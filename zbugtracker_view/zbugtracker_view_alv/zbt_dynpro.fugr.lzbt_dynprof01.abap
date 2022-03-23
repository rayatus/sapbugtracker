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
    g_display_mode_txt = 'Modificar'(001).
  ELSE.
    g_display_mode_txt = 'Visualizar'(002).
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
  PERFORM free_container CHANGING g_more_info_section_container.
  PERFORM free_container CHANGING g_steps_section_container.
  PERFORM free_container CHANGING g_problem_section_container.
  lo_container ?= g_info_splitter_container.
  PERFORM free_container CHANGING lo_container.
  lo_container ?= g_info_container.
  PERFORM free_container CHANGING lo_container.
  CLEAR: g_info_splitter_container, g_info_container.

* Free BTF Editor
  PERFORM free_btf_editor USING g_problem_btf.
  PERFORM free_btf_editor USING g_steps_btf.
  PERFORM free_btf_editor USING g_more_info_btf.

  FREE go_handler.
  CLEAR: gt_main_tc_ctr, go_handler.
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
    p_container->free( ).
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
    g_top_screen = 100.
  ENDIF.

  main_tc-activetab = gt_main_tc_ctr-pressed_tab.
  CASE gt_main_tc_ctr-pressed_tab.
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
    WHEN OTHERS.
      gt_main_tc_ctr-subscreen = '0200'.
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

  l_ucomm = sy-ucomm.
  CLEAR sy-ucomm.

  CASE l_ucomm.
    WHEN 'CHGMODE'.
      PERFORM chgmode_0001.
    WHEN 'BACK'.
      PERFORM exit_0001.
    WHEN 'SAVE'.
      PERFORM save_bug_0001.
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
    gt_main_tc_ctr-pressed_tab = c_main_tc_def-tab1.
  ENDIF.

ENDFORM.                    " SET_MAIN_TC_SCREEN
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command_0100 .
  CASE sy-ucomm.
    WHEN 'HIDETOP'.
      g_top_screen = 101.
    WHEN 'SHOWTOP'.
      g_top_screen = 100.
  ENDCASE.
ENDFORM.                    " USER_COMMAND_0100
*&---------------------------------------------------------------------*
*&      Form  PBO_0300
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0300 .

  DATA: lo_comment_gui TYPE REF TO zcl_comment_gui_controller,
        lt_comentarios TYPE zbt_comentarios,
        l_id_producto  TYPE zbt_producto-producto,
        l_id_bug       TYPE zbt_id_bug.

  IF NOT g_comments_container IS BOUND.
    TRY.
        CREATE OBJECT g_comments_container
          EXPORTING
            container_name = 'COMMENTS'.

        CREATE OBJECT lo_comment_gui
          EXPORTING
            bug          = go_bug
            container    = g_comments_container
            display_mode = g_display_mode.

        SET HANDLER go_handler->on_comment_added FOR lo_comment_gui.
        lo_comment_gui->display( ).

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
        l_string    TYPE string,
        o_exception TYPE REF TO zcx_bugtracker_system.

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
        l_section_txt3 TYPE string.

  FIELD-SYMBOLS <symbol> TYPE any.

  lo_producto   = p_bug->get_producto( ).
  lo_componente = p_bug->get_componente( ).

  g_bug        = zcl_bug_controller=>entity_to_structure( p_bug ).
  go_bug       = p_bug.
  g_producto   = zcl_producto_controller=>entity_to_structure( lo_producto ).
  g_componente = zcl_componente_controller=>entity_to_structure( lo_componente ).

  PERFORM set_bug_status_icon USING g_bug-estado.

* Creates Main Container separated into 3 containers
  PERFORM create_info_container.

  lt_sections = go_bug->get_sections( ).
  LOOP AT lt_sections INTO l_section.
    lo_comment = l_section-oref->get_comment( ).

    CONCATENATE 'L_SECTION_TXT' l_section-seccion_id INTO l_field.
    ASSIGN (l_field) TO <symbol>.

    <symbol> = lo_comment->get_texto( ).
  ENDLOOP.

* Creates corresponding editors in separated containers
  PERFORM create_btf_editor USING    g_problem_section_container
                                     'Description'(003)
                                     l_section_txt1
                                     g_display_mode
                            CHANGING g_problem_btf.
  PERFORM create_btf_editor USING    g_steps_section_container
                                     'Steps to Reproduce'(004)
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

  lo_user = go_bug->get_developer( ).
  IF lo_user IS BOUND.
    g_users_txt-developer = lo_user->get_name( ).
  ENDIF.

  lo_user = go_bug->get_tester( ).
  IF lo_user IS BOUND.
    g_users_txt-tester = lo_user->get_name( ).
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
    IF l_aux_str <> l_string.
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

  SET PF-STATUS 'S0001' EXCLUDING lt_fcodes.
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
        lt_componentes TYPE zbt_componentes.

* If product has components then is mandatory to select one
  IF g_componente-componente IS INITIAL.
    lo_producto = go_bug->get_producto( ).
    lt_componentes[] = lo_producto->get_componentes( ).
    IF NOT lt_componentes[] IS INITIAL.
      MESSAGE e003(zbugtracker_msg).
    ENDIF.

  ENDIF.

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
                           p_old_bug     TYPE REF TO zcl_bug
                  CHANGING p_is_modified TYPE flag.
  DATA: l_equal TYPE flag.

  CALL METHOD zcl_bug_controller=>equal
    EXPORTING
      bug1  = p_bug
      bug2  = p_old_bug
    RECEIVING
      equal = l_equal.

  IF l_equal IS INITIAL.
    p_is_modified = 'X'.
  ELSE.
    p_is_modified = space.
  ENDIF.

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
                            go_old_bug
                      CHANGING l_is_modified.
  IF NOT l_is_modified IS INITIAL.
    PERFORM ask_4continue USING
          'Data has been modified'(009)
          'Not saved data will be lost. Continue?'(010)
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
    PERFORM object_to_structures USING go_old_bug.

    IF g_display_mode IS INITIAL.
      l_new_mode = 'X'.
    ELSE.
      CLEAR l_new_mode.
    ENDIF.

    PERFORM set_display_mode USING l_new_mode.

  ENDIF.

ENDFORM.                    " CHGMODE_0001
