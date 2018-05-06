*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_ICON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ICON_SPACE  text
*      <--P_G_BUG_STATUS_ICON  text
*----------------------------------------------------------------------*
FORM set_icon  USING    p_icon_id
               CHANGING p_icon.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                        = p_icon_id
*   TEXT                        = ' '
*   INFO                        = ' '
*   ADD_STDINF                  = 'X'
   IMPORTING
     result                      = p_icon
* EXCEPTIONS
*   ICON_NOT_FOUND              = 1
*   OUTPUTFIELD_TOO_SHORT       = 2
*   OTHERS                      = 3
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " SET_ICON
*&---------------------------------------------------------------------*
*&      Form  SET_BUG_STATUS_ICON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_STATUS  text
*----------------------------------------------------------------------*
FORM set_bug_status_icon  USING    p_status.

  CASE p_status.
*    WHEN . TODO
    WHEN OTHERS.
      g_bug_status_icon = icon_space.
  ENDCASE.

ENDFORM.                    " SET_BUG_STATUS_ICON
*&---------------------------------------------------------------------*
*&      Form  SET_DISPLAY_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DISPLAY_MODE  text
*----------------------------------------------------------------------*
FORM set_display_mode  USING p_display_mode TYPE flag.

  g_display_mode    = p_display_mode.
  IF g_display_mode IS INITIAL.
    g_display_mode_txt = 'Modify'(001).
  ELSE.
    g_display_mode_txt = 'Display'(002).
  ENDIF.
ENDFORM.                    " SET_DISPLAY_MODE
*&---------------------------------------------------------------------*
*&      Form  FREE_GLOBAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM free_global_data .
  DATA lo_container TYPE REF TO cl_gui_container.

* Free InfoContainer
  lo_container ?= g_more_info_section_container.
  PERFORM free_container CHANGING lo_container.
  lo_container ?= g_steps_section_container.
  PERFORM free_container CHANGING lo_container.
  lo_container ?= g_problem_section_container.
  PERFORM free_container CHANGING lo_container.
  lo_container ?= g_tag_container.
  PERFORM free_container CHANGING lo_container.
  lo_container ?= g_bug_tree_container.
  PERFORM free_container CHANGING lo_container.

  lo_container ?= g_attachment_container.
  PERFORM free_container CHANGING lo_container.

* Free BTF Editor
  PERFORM free_btf_editor USING g_problem_btf.
  PERFORM free_btf_editor USING g_steps_btf.
  PERFORM free_btf_editor USING g_more_info_btf.

  FREE:  go_handler,
         go_tag_gui,
         go_comment_gui.
  CLEAR: gt_main_tc_ctr,
         gt_info_tc_ctr,
         go_handler,
         g_do_not_show_pfstatus,
         go_comment_gui,
         g_bug_tree_container,
         go_tag_gui.
ENDFORM.                    " FREE_GLOBAL_DATA
*&---------------------------------------------------------------------*
*&      Form  FREE_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CONTAINER  text
*----------------------------------------------------------------------*
FORM free_container  CHANGING p_container TYPE REF TO  cl_gui_container.
  DATA: l_is_valid   TYPE i.

  IF NOT p_container IS INITIAL.
    CALL METHOD p_container->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    CLEAR p_container.
    FREE p_container.
  ENDIF.
ENDFORM.                    " FREE_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  FREE_BTF_EDITOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_PROBLEM_BTF  text
*----------------------------------------------------------------------*
FORM free_btf_editor  USING p_btf TYPE REF TO zcl_btf_editor.
  IF NOT p_btf IS INITIAL.
    p_btf->free( ).
    CLEAR p_btf.
    FREE p_btf.
  ENDIF.
ENDFORM.                    " FREE_BTF_EDITOR
*&---------------------------------------------------------------------*
*&      Form  SET_SUBSCREENS_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_subscreens_0001 .

  IF g_top_screen IS INITIAL.
    g_top_screen = 101.
  ENDIF.

  main_tc-activetab = gt_main_tc_ctr-pressed_tab.
  CASE gt_main_tc_ctr-pressed_tab.
    WHEN c_main_tc_def-tab0.
      gt_main_tc_ctr-subscreen = '0100'.
    WHEN c_main_tc_def-tab1.
      gt_main_tc_ctr-subscreen = '0200'.
    WHEN c_main_tc_def-tab2.
      gt_main_tc_ctr-subscreen = '0300'.
    WHEN c_main_tc_def-tab3.
      gt_main_tc_ctr-subscreen = '0400'.
    WHEN c_main_tc_def-tab4.
      gt_main_tc_ctr-subscreen = '0500'.
    WHEN c_main_tc_def-tab5.
      gt_main_tc_ctr-subscreen = '0600'.
    WHEN c_main_tc_def-tab6.
      gt_main_tc_ctr-subscreen = '0700'.
    WHEN OTHERS.
      gt_main_tc_ctr-subscreen = '0100'.
  ENDCASE.

  IF gt_main_tc_ctr-prog IS INITIAL.
    gt_main_tc_ctr-prog = sy-repid.
  ENDIF.

ENDFORM.                    " SET_SUBSCREENS_0001
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command_0001 .
  DATA: l_ucomm TYPE sy-ucomm.

  cl_gui_cfw=>flush( ).

  l_ucomm = sy-ucomm.
  CLEAR sy-ucomm.

  CASE l_ucomm.
    WHEN 'CHGMODE'.
      PERFORM chgmode_0001.
    WHEN 'BACK'.
      PERFORM exit_0001.
    WHEN 'SAVE'.
      PERFORM save_bug_0001.
    WHEN 'BUGTREE'.
      PERFORM bugtree_0001.
    WHEN OTHERS.
      IF l_ucomm(3) = 'TAB'.
        PERFORM set_main_tc_screen USING l_ucomm.
      ENDIF.
  ENDCASE.
ENDFORM.                    " USER_COMMAND_0001
*&---------------------------------------------------------------------*
*&      Form  SET_MAIN_TC_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_main_tc_screen USING p_ucomm TYPE sy-ucomm .
  FIELD-SYMBOLS: <tab> TYPE any.

  ASSIGN COMPONENT p_ucomm OF STRUCTURE c_main_tc_def TO <tab>.
  IF sy-subrc IS INITIAL.
    gt_main_tc_ctr-pressed_tab = <tab>.
  ELSE.
    gt_main_tc_ctr-pressed_tab = c_main_tc_def-tab0.
  ENDIF.

ENDFORM.                    " SET_MAIN_TC_SCREEN
*&---------------------------------------------------------------------*
*&      Form  PBO_0300
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0300 .

  DATA: lt_comentarios TYPE zbt_comentarios,
        l_id_producto  TYPE zbt_producto-producto,
        l_id_bug       TYPE zbt_id_bug.

  IF NOT g_comments_container IS BOUND.
    TRY.
        CREATE OBJECT g_comments_container
          EXPORTING
            container_name = 'COMMENTS'.

        CREATE OBJECT go_comment_gui
          EXPORTING
            bug          = go_bug
            container    = g_comments_container
            display_mode = g_display_mode.

        SET HANDLER go_handler->on_comment_added FOR go_comment_gui.
        go_comment_gui->display( ).

      CATCH zcx_not_found_exception .
    ENDTRY.
  ENDIF.


ENDFORM.                                                    " PBO_0300
*&---------------------------------------------------------------------*
*&      Form  SAVE_BUG_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_bug_0001 .
  DATA: l_bug_id    TYPE zbt_id_bug,
        l_bug_id_i  type zbt_id_bug_i,
        l_string    TYPE string,
        o_exception TYPE REF TO zcx_bugtracker_system.
*BREAK-POINT.
  TRY .
      IF zcl_bug_controller=>exist( go_bug ) = abap_true.
        zcl_bug_controller=>update( go_bug  ).
      ELSE.
        zcl_bug_controller=>create( go_bug  ).
        PERFORM set_display_mode USING g_display_mode.
      ENDIF.
      COMMIT WORK AND WAIT.

      PERFORM object_to_structures USING go_bug.

      l_bug_id = go_bug->get_id( ).
      l_bug_id_i = go_bug->get_id_i( ).

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = l_bug_id
        IMPORTING
          output = l_bug_id.
      MESSAGE s000(zbugtracker_msg) WITH l_bug_id.

    CATCH zcx_bugtracker_system INTO o_exception.
      l_string = o_exception->get_text( ).
      MESSAGE l_string TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.
  clear g_hash_after_save.
  g_hash_after_save = go_bug->get_hash( ).

ENDFORM.                    " SAVE_BUG_0001
*&---------------------------------------------------------------------*
*&      Form  STRUCTURES_TO_OBJECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM structures_to_object .
  DATA: lo_producto   TYPE REF TO zcl_producto,
        lo_user       TYPE REF TO zcl_usuario,
        lo_componente TYPE REF TO zcl_componente.

  lo_producto   = zcl_producto_controller=>find_by_key( g_producto-producto ).
  lo_componente = zcl_componente_controller=>find_by_key( id       = g_componente-componente
                                                          producto = lo_producto ).

  zcl_bug_controller=>structure_to_entity(
      EXPORTING structure = g_bug
      CHANGING  entity    = go_bug ).

  go_bug->set_producto( lo_producto ).
  go_bug->set_componente( lo_componente ).

* Update Bug Sections
  PERFORM update_bugsection USING go_bug g_problem_btf   1.
  PERFORM update_bugsection USING go_bug g_steps_btf     2.
  PERFORM update_bugsection USING go_bug g_more_info_btf 3.

  TRY .
      lo_user = zcl_usuario_controller=>find_by_key( g_bug-tester ).
      IF lo_user IS BOUND.
        g_users_txt-tester = lo_user->get_name( ).
      ENDIF.
    CATCH zcx_not_found_exception.
      CLEAR g_users_txt-tester.
  ENDTRY.

  TRY .
      lo_user = zcl_usuario_controller=>find_by_key( g_bug-assigned ).
      IF lo_user IS BOUND.
        g_users_txt-assigned = lo_user->get_name( ).
      ENDIF.
    CATCH zcx_not_found_exception.
      CLEAR g_users_txt-assigned.
  ENDTRY.

  TRY .
      lo_user = zcl_usuario_controller=>find_by_key( g_bug-developer ).
      IF lo_user IS BOUND.
        g_users_txt-developer = lo_user->get_name( ).
      ENDIF.
    CATCH zcx_not_found_exception.
      CLEAR g_users_txt-developer.
  ENDTRY.


ENDFORM.                    " STRUCTURES_TO_OBJECT
*&---------------------------------------------------------------------*
*&      Form  OBJECT_TO_STRUCTURES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM object_to_structures USING p_bug TYPE REF TO zcl_bug.
  DATA: lo_producto    TYPE REF TO zcl_producto,
        lo_componente  TYPE REF TO zcl_componente,
        lo_comment     TYPE REF TO zcl_comment,
        lo_user        TYPE REF TO zcl_usuario,
        lt_sections    TYPE zbt_bugsections,
        l_section      TYPE LINE OF zbt_bugsections,
        l_field(30)    TYPE c,
        l_section_txt1 TYPE string,
        l_section_txt2 TYPE string,
        l_section_txt3 TYPE string,
        lo_container   TYPE REF TO cl_gui_container.

  FIELD-SYMBOLS <symbol> TYPE any.

  lo_producto   = p_bug->get_producto( ).
  lo_componente = p_bug->get_componente( ).

  g_bug        = zcl_bug_controller=>entity_to_structure( p_bug ).
  go_bug       = p_bug.
  g_producto   = zcl_producto_controller=>entity_to_structure( lo_producto ).
  g_componente = zcl_componente_controller=>entity_to_structure( lo_componente ).

  PERFORM set_bug_status_icon USING g_bug-estado.

  lt_sections = go_bug->get_sections( ).
  LOOP AT lt_sections INTO l_section.
    lo_comment = l_section-oref->get_comment( ).

    CONCATENATE 'L_SECTION_TXT' l_section-seccion_id INTO l_field.
    ASSIGN (l_field) TO <symbol>.

    <symbol> = lo_comment->get_texto( ).
  ENDLOOP.

* Creates Main Container
  PERFORM create_info_container.
* Creates corresponding editors in separated containers
  PERFORM create_btf_editor USING    g_problem_section_container
                                     'Description'(003)
                                     l_section_txt1
                                     g_display_mode
                            CHANGING g_problem_btf.
  PERFORM create_btf_editor USING    g_steps_section_container
                                     'How to Reproduce'(004)
                                     l_section_txt2
                                     g_display_mode
                            CHANGING g_steps_btf.
  PERFORM create_btf_editor USING    g_more_info_section_container
                                     'More Info'(005)
                                     l_section_txt3
                                     g_display_mode
                            CHANGING g_more_info_btf.
* Gets Users Name
  lo_user = go_bug->get_reporter( ).
  IF lo_user IS BOUND.
    g_users_txt-reporter = lo_user->get_name( ).
  ENDIF.

  lo_user = go_bug->get_assigned( ).
  IF lo_user IS BOUND.
    g_users_txt-assigned = lo_user->get_name( ).
  ENDIF.

  lo_user = go_bug->get_developer( ).
  IF lo_user IS BOUND.
    g_users_txt-developer = lo_user->get_name( ).
  ENDIF.

  lo_user = go_bug->get_tester( ).
  IF lo_user IS BOUND.
    g_users_txt-tester = lo_user->get_name( ).
  ENDIF.

  lo_user = go_bug->get_aenam( ).
  IF lo_user IS BOUND.
    g_users_txt-aenam = lo_user->get_name( ).
  ENDIF.
ENDFORM.                    " OBJECT_TO_STRUCTURES
*&---------------------------------------------------------------------*
*&      Form  UPDATE_BUGSECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BUG  text
*      -->P_BTF_EDITOR  text
*      <--P_LT_SECTIONS  text
*----------------------------------------------------------------------*
FORM update_bugsection  USING    p_bug         TYPE REF TO zcl_bug
                                 p_btf_editor  TYPE REF TO zcl_btf_editor
                                 p_section_id  TYPE zbt_id_seccion.

  DATA: lt_sections   TYPE zbt_bugsections,
        l_producto_id TYPE zbt_producto-producto,
        lo_producto   TYPE REF TO zcl_producto,
        lo_usuario    TYPE REF TO zcl_usuario,
        lo_comment    TYPE REF TO zcl_comment,
        l_string      TYPE string,
        l_aux_str     TYPE string,
        l_section     TYPE LINE OF zbt_bugsections.


  lo_usuario = zcl_usuario_controller=>find_by_key( ).
  lt_sections = p_bug->get_sections( ).

  l_string = p_btf_editor->get_content_as_string( ).

  READ TABLE lt_sections WITH KEY seccion_id = p_section_id INTO l_section.
  IF sy-subrc IS INITIAL.
    lo_comment = l_section-oref->get_comment( ).
    l_aux_str = lo_comment->get_texto( ).

    PERFORM html_text_equal USING    l_aux_str
                                     l_string
                            CHANGING sy-subrc.
    IF NOT sy-subrc IS INITIAL.
      lo_comment->set_texto( l_string ).
      lo_comment->set_erdat( ).
      lo_comment->set_usuario( lo_usuario ).
    ENDIF.
  ELSE.
    CREATE OBJECT lo_comment
      EXPORTING
        bug     = p_bug
        usuario = lo_usuario
        texto   = l_string.

    lo_producto   = p_bug->get_producto( ).
    l_producto_id = lo_producto->get_id( ).

    l_section-producto_id = g_producto-producto.
    l_section-bug_id      = g_bug-bug.
    l_section-seccion_id  = p_section_id.
    CREATE OBJECT l_section-oref
      EXPORTING
        id      = l_section-seccion_id
        bug     = go_bug
        comment = lo_comment.
    INSERT l_section INTO TABLE lt_sections.
  ENDIF.

  p_bug->set_sections( lt_sections ).
ENDFORM.                    " UPDATE_BUGSECTION
*&---------------------------------------------------------------------*
*&      Form  STATUS_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM status_0001 .
  DATA: l_bug     LIKE g_bug-bug,
        l_fcode   TYPE sy-ucomm,
        lt_fcodes TYPE STANDARD TABLE OF sy-ucomm.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = g_bug-bug
    IMPORTING
      output = l_bug.

  CASE g_display_mode .
    WHEN 'X'.
      l_fcode = 'SAVE'.
      INSERT l_fcode INTO TABLE lt_fcodes.
    WHEN OTHERS.
  ENDCASE.

  IF g_do_not_show_pfstatus <> abap_true.
    SET PF-STATUS 'S0001' EXCLUDING lt_fcodes.
  ELSE.
    SET PF-STATUS 'EMPTY' EXCLUDING lt_fcodes.
  ENDIF.

  SET TITLEBAR  'T0001' WITH l_bug g_display_mode_txt.

ENDFORM.                    " STATUS_0001
*&---------------------------------------------------------------------*
*&      Form  SET_DYNPRO_DISPLAY_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_DISPLAY_MODE  text
*----------------------------------------------------------------------*
FORM set_dynpro_display_mode  USING value(p_display_mode) TYPE flag.

  IF NOT p_display_mode IS INITIAL.
    LOOP AT SCREEN.
*     No cambiamos los atributos de los siguientes campos
      IF screen-name CS 'AUTOTEXT'.
      ELSE.
        CASE screen-group1.
          WHEN 'BTN'. "Button
          WHEN OTHERS.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ENDIF.

    ENDLOOP.
  ENDIF.


ENDFORM.                    " SET_DYNPRO_DISPLAY_MODE
*&---------------------------------------------------------------------*
*&      Form  set_create_mode
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_create_mode.
  g_display_mode_txt = 'Create'(006).
  CLEAR g_display_mode.
ENDFORM.                    "set_create_mode
*&---------------------------------------------------------------------*
*&      Form  PAI_0100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pai_0100 .
  DATA: lo_producto    TYPE REF TO zcl_producto,
        l_string       TYPE string,
        lo_exception   TYPE REF TO zcx_bugtracker_system,
        lo_estado      TYPE REF TO zcl_estado,
        lo_usuario     TYPE REF TO zcl_usuario,
        l_estado_type  TYPE zbt_typestatus,
        l_timestamp    TYPE timestamp,
        lt_componentes TYPE zbt_componentes.

* If product has components then is mandatory to select one
  IF g_componente-componente IS INITIAL.
    lo_producto = zcl_producto_controller=>find_by_key( g_bug-producto ).
    lt_componentes[] = lo_producto->get_componentes( ).
    IF NOT lt_componentes[] IS INITIAL.
      MESSAGE e003(zbugtracker_msg).
    ENDIF.

  ENDIF.

* If status is "ended" then EndDate must be fulfilled
  lo_estado = zcl_estado_controller=>find_by_key( g_bug-estado ).
  l_estado_type = lo_estado->get_type( ) .
  IF g_bug-finalizado IS INITIAL AND l_estado_type = zcl_estado_controller=>status_finished.
    GET TIME STAMP FIELD l_timestamp.
    g_bug-finalizado = l_timestamp.
  ELSEIF l_estado_type <> zcl_estado_controller=>status_finished.
    CLEAR g_bug-finalizado.
  ENDIF.

  TRY .
      IF NOT g_bug-tester IS INITIAL.
        lo_usuario = zcl_usuario_controller=>find_by_key( g_bug-tester ).
      ENDIF.
      IF NOT g_bug-developer IS INITIAL.
        lo_usuario = zcl_usuario_controller=>find_by_key( g_bug-developer ).
      ENDIF.
      IF NOT g_bug-assigned IS INITIAL.
        lo_usuario = zcl_usuario_controller=>find_by_key( g_bug-assigned ).
      ENDIF.
    CATCH zcx_not_found_exception INTO lo_exception.
      l_string = lo_exception->get_text( ).
      MESSAGE l_string TYPE 'E'.
  ENDTRY.



ENDFORM.                                                    " PAI_0100
*&---------------------------------------------------------------------*
*&      Form  EXIT_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exit_0001 .
  DATA: l_continue    TYPE flag VALUE 'X'.

  PERFORM ask_4data_lose CHANGING l_continue.

  IF NOT l_continue IS INITIAL.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.                                                    " EXIT_0001
*&---------------------------------------------------------------------*
*&      Form  ASK_4CONTINUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0948   text
*      -->P_0949   text
*      -->P_0950   text
*      <--P_L_CONTINUE  text
*----------------------------------------------------------------------*
FORM ask_4continue  USING    value(p_title)
                             value(p_question)
                    CHANGING p_continue TYPE flag.

  DATA: l_answer TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = p_title
      text_question         = p_question
      icon_button_1         = 'ICON_OKAY'
      icon_button_2         = 'ICON_CANCEL'
      display_cancel_button = space
      popup_type            = 'ICON_MESSAGE_WARNING'
    IMPORTING
      answer                = l_answer.
  CASE l_answer.
    WHEN '1'.
      p_continue = 'X'.
    WHEN OTHERS.
      CLEAR p_continue.
  ENDCASE.
ENDFORM.                    " ASK_4CONTINUE
*&---------------------------------------------------------------------*
*&      Form  IS_MODIFIED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_BUG  text
*      -->P_GO_OLD_BUG  text
*      <--P_L_IS_MODIFIED  text
*----------------------------------------------------------------------*
FORM is_modified  USING    p_bug         TYPE REF TO zcl_bug
                           p_oldhash     TYPE hash160
                  CHANGING p_is_modified TYPE flag.

  DATA: newhash TYPE hash160.

  newhash = p_bug->get_hash( ).

* check the new hash against the hash from last save
  if g_hash_after_save is not initial
     and p_oldhash <> g_hash_after_save.

    IF newhash <> g_hash_after_save.
      p_is_modified = 'X'.
    ELSE.
      p_is_modified = space.
    ENDIF.

  else.
    IF newhash <> p_oldhash.
      p_is_modified = 'X'.
    ELSE.
      p_is_modified = space.
    ENDIF.
  endif.
ENDFORM.                    " IS_MODIFIED
*&---------------------------------------------------------------------*
*&      Form  ASK_4data_lose
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_CONTINUE  text
*----------------------------------------------------------------------*
FORM ask_4data_lose  CHANGING p_continue TYPE flag.
  DATA:  l_is_modified TYPE flag VALUE space,
         l_continue    TYPE flag VALUE 'X',
         l_answer      TYPE c.

  p_continue = 'X'.

  PERFORM is_modified USING go_bug
                            g_oldhash
                      CHANGING l_is_modified.
  IF NOT l_is_modified IS INITIAL.
    PERFORM ask_4continue USING
          'Data has been modified'(009)
          'Unsaved data will be lost. Continue?'(010)
          CHANGING p_continue.
  ENDIF.

ENDFORM.                    " ASK_4data_lose
*&---------------------------------------------------------------------*
*&      Form  CHGMODE_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chgmode_0001 .
  DATA: l_continue TYPE flag,
        l_new_mode LIKE g_display_mode.

  PERFORM ask_4data_lose CHANGING l_continue.
  IF NOT l_continue IS INITIAL.
*   Reset to original data
* TODO
**    PERFORM object_to_structures USING go_old_bug.

    IF g_display_mode IS INITIAL.
      l_new_mode = 'X'.
    ELSE.
      CLEAR l_new_mode.
    ENDIF.

    PERFORM set_display_mode USING l_new_mode.

    IF go_comment_gui IS BOUND.
      go_comment_gui->set_display_mode( g_display_mode ).
    ENDIF.
    IF g_more_info_btf IS BOUND.
      g_more_info_btf->set_display_mode( g_display_mode ).
    ENDIF.
    IF g_steps_btf IS BOUND.
      g_steps_btf->set_display_mode( g_display_mode ).
    ENDIF.
    IF g_problem_btf IS BOUND.
      g_problem_btf->set_display_mode( g_display_mode ).
    ENDIF.

    IF go_tag_gui IS BOUND.
      go_tag_gui->set_display_mode( g_display_mode ).
    ENDIF.

  ENDIF.
ENDFORM.                    " CHGMODE_0001
*&---------------------------------------------------------------------*
*&      Form  PBO_0500
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0500 .
  DATA: lo_objects_gui TYPE REF TO zcl_bug_objects_alv_ctrl.

  IF NOT g_objects_container IS BOUND.
    CREATE OBJECT g_objects_container
      EXPORTING
        container_name = 'OBJECT_CONTAINER'.

    CREATE OBJECT lo_objects_gui
      EXPORTING
        bug       = go_bug
        container = g_objects_container.

    lo_objects_gui->display( ).
  ENDIF.
ENDFORM.                                                    " PBO_0500
*&---------------------------------------------------------------------*
*&      Form  BUGTREE_001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bugtree_0001 .
  DATA: lo_bugtree TYPE REF TO zcl_bug_alvtree_ctrl.

  IF NOT g_bug_tree_container IS BOUND.
    CREATE OBJECT g_bug_tree_container
      EXPORTING
        extension = 250.
  ENDIF.

  CREATE OBJECT lo_bugtree
    EXPORTING
      container = g_bug_tree_container
      bug       = go_bug.

  lo_bugtree->display( ).

ENDFORM.                    " BUGTREE_001
*&---------------------------------------------------------------------*
*&      Form  PBO_0101
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0101 .
  PERFORM  create_tag_grid.
ENDFORM.                                                    " PBO_0101
*&---------------------------------------------------------------------*
*&      Form  CREATE_TAG_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_tag_grid .
  DATA: l_title    TYPE lvc_title.


  free: g_tag_container, go_tag_gui.

  IF NOT g_tag_container IS BOUND.

    CREATE OBJECT g_tag_container
      EXPORTING
        container_name = 'TAG_CONTAINER'.

    l_title = 'TAGs'(008).

    CREATE OBJECT go_tag_gui
      EXPORTING
        bug       = go_bug
        container = g_tag_container
        title     = l_title.

    go_tag_gui->display( ).
  else.

    CREATE OBJECT g_tag_container
      EXPORTING
        container_name = 'TAG_CONTAINER'.

    l_title = 'TAGs'(008).
    CREATE OBJECT go_tag_gui
      EXPORTING
        bug       = go_bug
        container = g_tag_container
        title     = l_title.

    go_tag_gui->display( ).


  ENDIF.
  go_tag_gui->set_display_mode( g_display_mode ).

ENDFORM.                    " CREATE_TAG_GRID
*&---------------------------------------------------------------------*
*&      Form  PBO_0700
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0700 .

ENDFORM.                                                    " PBO_0700
*&---------------------------------------------------------------------*
*&      Form  HTML_TEXT_EQUAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OLD  text
*      -->P_NEW  text
*      <--P_SY_SUBRC  text
*----------------------------------------------------------------------*
FORM html_text_equal  USING    value(p_old) TYPE string
                               value(p_new) TYPE string
                      CHANGING value(p_subrc) TYPE sy-subrc.

  PERFORM clean_html CHANGING p_old.
  PERFORM clean_html CHANGING p_new.

  IF p_old <> p_new.
    p_subrc = 9999.
  ELSE.
    CLEAR p_subrc.
  ENDIF.

ENDFORM.                    " HTML_TEXT_EQUAL
*&---------------------------------------------------------------------*
*&      Form  CLEAN_HTML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_STRING  text
*----------------------------------------------------------------------*
FORM clean_html  CHANGING p_html TYPE string.
  DATA: find_result TYPE match_result.

  FIND '<BODY>' IN p_html RESULTS find_result.
  find_result-offset = find_result-offset + find_result-length.
  p_html = p_html+find_result-offset.

  FIND '</BODY>' IN p_html RESULTS find_result.
  p_html = p_html(find_result-offset).
ENDFORM.                    " CLEAN_HTML
