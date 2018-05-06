class ZCL_COMMENT_GUI_CONTROLLER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_COMMENT_GUI_CONTROLLER
*"* do not include other source files here!!!
  type-pools ICON .

  events COMMENT_ADDED .

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER optional
      value(USER) type ref to ZCL_USUARIO optional
      !BUG type ref to ZCL_BUG
      !DISPLAY_MODE type FLAG default SPACE
    preferred parameter CONTAINER
    raising
      ZCX_COMMENT_ALV_CTRL_EXC .
  methods DISPLAY .
  methods GET_COMMENTS .
  methods REFRESH .
  type-pools ABAP .
  methods SET_DISPLAY_MODE
    importing
      !DISPLAY type FLAG default ABAP_TRUE .
protected section.
*"* protected components of class ZCL_COMMENT_GUI_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_COMMENT_GUI_CONTROLLER
*"* do not include other source files here!!!

  data CONTAINER type ref to CL_GUI_CONTAINER .
  data TOOLBAR_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_TOOLBAR type ref to CL_GUI_TOOLBAR .
  constants ACTION_REPLY type UI_FUNC value 'REPLY'. "#EC NOTEXT
  data BUG type ref to ZCL_BUG .
  data USER type ref to ZCL_USUARIO .
  constants ACTION_POPUP_OK type UI_FUNC value 'POPUP_OK'. "#EC NOTEXT
  constants ACTION_POPUP_KO type UI_FUNC value 'POPUP_KO'. "#EC NOTEXT
  data O_POPUP type ref to CL_GUI_DIALOGBOX_CONTAINER .
  data O_POPUP_SPLITTER type ref to CL_GUI_EASY_SPLITTER_CONTAINER .
  data O_POPUP_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_POPUP_TOOLBAR_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_POPUP_EDITOR type ref to ZCL_BTF_EDITOR .
  data O_POPUP_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data COMMENT type ZBT_COMENTARIOS_STR .
  data DISPLAY_MODE type FLAG value SPACE. "#EC NOTEXT .
  data MAIN_CONTAINER type ref to CL_GUI_CONTAINER .
  data SPLITTER_CONTAINER type ref to CL_GUI_EASY_SPLITTER_CONTAINER .
  class-data C_START_OF_TABLE type STRING value '<html><BODY><TABLE border="1" width = "100%" CELLPADDING=5 CELLSPACING=0>'. "#EC NOTEXT .
  class-data C_END_OF_TABLE type STRING value '</TABLE></BODY></html>'. "#EC NOTEXT .
  class-data C_BEGIN_COMMENT type STRING value '<TR><TD BGCOLOR="#AAAAAA">&</TD></TR>'. "#EC NOTEXT .
  class-data C_NEW_ROW type STRING value '<TR><TD>'. "#EC NOTEXT .
  class-data C_END_ROW type STRING value '</TD></TR>'. "#EC NOTEXT .

  methods ADD_COMMENT_TO_DD
    importing
      !TABLE_DD type ref to CL_DD_TABLE_AREA
      !COMMENT type ZBT_COMENTARIOS_STR .
  methods ADD_TOOLBAR_ACTION
    importing
      !ACTION type SY-UCOMM
      !ICON type ICON-ID optional .
  methods ASK_4NEW_COMMENT
    importing
      !BUG type ref to ZCL_BUG
      !USER type ref to ZCL_USUARIO
      !POPUP_TITLE type VTEXT default 'New Comment' .
  methods CLOSE_POPUP .
  methods GET_BUG
    returning
      value(BUG) type ref to ZCL_BUG .
  methods GET_USER
    returning
      value(USER) type ref to ZCL_USUARIO .
  type-pools SDYDO .
  methods HTML_TO_DD
    importing
      value(HTML) type STRING
    returning
      value(DDTEXT) type SDYDO_TEXT_TABLE .
  methods INIT_TOOLBAR .
  methods INIT_TOOLBAR_NEW_COMMENT
    importing
      !TOOLBAR type ref to CL_GUI_TOOLBAR .
  methods ON_TOOLBAR_ACTION_SELECTED
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE .
  methods SET_BUG
    importing
      !BUG type ref to ZCL_BUG .
  methods SET_USER
    importing
      !USER type ref to ZCL_USUARIO .
  methods CREATE_DYNAMIC_DOCUMENT
    importing
      !REFRESH type FLAG optional .
  methods INITIALIZE_CONTAINERS
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER .
ENDCLASS.



CLASS ZCL_COMMENT_GUI_CONTROLLER IMPLEMENTATION.


METHOD add_comment_to_dd.
  DATA: l_erdat     TYPE zbt_bugcomment-erdat,
        l_erdat_str TYPE string,
        l_user_name TYPE string,
        l_string    TYPE string,
        l_string2   TYPE string,
        lt_html     TYPE sdydo_html_table,
        lt_text     TYPE sdydo_text_table,
        l_text      TYPE LINE OF sdydo_text_table,
        l_color     TYPE sdydo_attribute,
        lo_user     TYPE REF TO zcl_usuario.

  l_erdat  = comment-oref->get_erdat( ).

  CALL FUNCTION 'CONVERSION_EXIT_TSTMP_OUTPUT'
    EXPORTING
      input  = l_erdat
    IMPORTING
      output = l_erdat_str.

  lo_user  = comment-oref->get_usuario( ).

  l_user_name = lo_user->get_id( ).
  CONCATENATE l_erdat_str l_user_name INTO l_text SEPARATED BY '-'.
  l_string = c_begin_comment.
  REPLACE '&' INTO l_string WITH l_text.
  table_dd->add_static_html( string_with_html = l_string ).

*  table_dd->new_row( sap_style = cl_dd_area=>table_heading ).
*  table_dd->add_text( text = l_text ).

*  l_color = cl_dd_area=>list_normal.
*  table_dd->new_row( sap_color = l_color ).
  l_string2 = comment-oref->get_texto( ).
  l_string = c_begin_comment.
  REPLACE '&' INTO l_string WITH l_string2.
  table_dd->add_static_html( string_with_html = l_string ).

* Converts HTML texto to Dinamyc Document Text
  lt_text[] = html_to_dd( l_string ).
  lt_html[] = lt_text[].
  table_dd->add_static_html( table_with_html = lt_html ).
*  table_dd->add_text( text_table = lt_text ).

*  table_dd->new_row( ).
ENDMETHOD.


method ADD_TOOLBAR_ACTION.
endmethod.


METHOD ask_4new_comment.

  DATA: lo_producto  TYPE REF TO zcl_producto,
        lt_comments  TYPE zbt_comentarios.

* Creates POPUP
  CREATE OBJECT o_popup
    EXPORTING
      width  = 680
      height = 200.

* Splits container in 2
  CREATE OBJECT o_popup_splitter
    EXPORTING
      parent        = o_popup
      orientation   = cl_gui_easy_splitter_container=>orientation_vertical
      sash_position = 93.

  o_popup_container            = o_popup_splitter->top_left_container.
  o_popup_toolbar_container    = o_popup_splitter->bottom_right_container.

  CREATE OBJECT o_popup_toolbar
    EXPORTING
      parent = o_popup_toolbar_container.
  init_toolbar_new_comment( o_popup_toolbar ).

  comment-bug_id      = bug->get_id( ).
  lo_producto         = bug->get_producto( ).
  comment-producto_id = lo_producto->get_id( ).

  CREATE OBJECT comment-oref
    EXPORTING
      bug     = bug
      id      = comment-comentario_id
      usuario = user.

* Creates BTF Editor into POPUP
  CREATE OBJECT o_popup_editor
    EXPORTING
      container = o_popup_container.

* lo_editor->set_title( popup_title ).
  o_popup_editor->display( ).

ENDMETHOD.


METHOD close_popup.

  o_popup_editor->free( ).
  o_popup_toolbar->free( ).
  o_popup_toolbar_container->free( ).
  o_popup_container->free( ).
  o_popup_splitter->free( ).
  o_popup->free( ).

ENDMETHOD.


METHOD constructor.
  DATA: lo_dialogbox TYPE REF TO cl_gui_dialogbox_container.

  me->main_container = container.
  IF NOT me->main_container IS BOUND.
    CREATE OBJECT lo_dialogbox
      EXPORTING
        width  = 430
        height = 130.

    me->main_container ?= lo_dialogbox.
  ENDIF.
  initialize_containers( me->main_container ).

* Incluimos una ToolBar para poder realizar acciones sobre los comentarios
  init_toolbar( ).

  set_bug( bug ).

* Initializes user
  IF user IS INITIAL.
    user = zcl_usuario_controller=>find_by_key( ).
  ENDIF.
  set_user( user ).

  set_display_mode( display_mode ).

ENDMETHOD.


METHOD create_dynamic_document.

  DATA: lo_document  TYPE REF TO cl_dd_document,
      lo_bug       TYPE REF TO zcl_bug,
      lo_table     TYPE REF TO cl_dd_table_area,
      lt_comments  TYPE zbt_comentarios,
      l_comment    TYPE LINE OF zbt_comentarios.

  CREATE OBJECT lo_document.

  lo_bug = get_bug( ).
  lt_comments[] = lo_bug->get_comentarios( ).
  SORT lt_comments BY comentario_id DESCENDING.

  LOOP AT lt_comments INTO l_comment.
    AT FIRST.
*      lo_document->add_table(
*       EXPORTING
*         no_of_columns = 1
*         width         = '100%'
*       IMPORTING
*         tablearea     = lo_table
*      ).
      lo_document->add_static_html( string_with_html = c_start_of_table ).
    ENDAT.

*    add_comment_to_dd( table_dd = lo_table
*                       comment  = l_comment ).
*--------------------------------------------------------------------*
    DATA:  l_erdat     TYPE zbt_bugcomment-erdat,
           l_erdat_str TYPE string,
           l_user_name TYPE string,
           l_string    TYPE string,
           l_string2   TYPE string,
           lt_html     TYPE sdydo_html_table,
           lt_text     TYPE sdydo_text_table,
           l_text      TYPE LINE OF sdydo_text_table,
           l_color     TYPE sdydo_attribute,
           lo_user     TYPE REF TO zcl_usuario.

    l_erdat  = l_comment-oref->get_erdat( ).

    CALL FUNCTION 'CONVERSION_EXIT_TSTMP_OUTPUT'
      EXPORTING
        input  = l_erdat
      IMPORTING
        output = l_erdat_str.

    lo_user  = l_comment-oref->get_usuario( ).

    l_user_name = lo_user->get_id( ).
    CONCATENATE l_erdat_str l_user_name INTO l_text SEPARATED BY '-'.
    l_string = c_begin_comment.
    REPLACE '&' INTO l_string WITH l_text.
    lo_document->add_static_html( string_with_html = l_string ).

*  table_dd->new_row( sap_style = cl_dd_area=>table_heading ).
*  table_dd->add_text( text = l_text ).

*  l_color = cl_dd_area=>list_normal.
*  table_dd->new_row( sap_color = l_color ).

    l_string = c_new_row.
    lo_document->add_static_html( string_with_html = l_string ).

    l_string2 = l_comment-oref->get_texto( ).
* Converts HTML texto to Dinamyc Document Text
    lt_text[] = html_to_dd( l_string2 ).
    lt_html[] = lt_text[].
    lo_document->add_static_html( table_with_html = lt_html ).

    l_string = c_end_row.
    lo_document->add_static_html( string_with_html = l_string ).
*  table_dd->add_text( text_table = lt_text ).

*  table_dd->new_row( ).
*--------------------------------------------------------------------*
    AT LAST.
      lo_document->add_static_html( string_with_html = c_end_of_table ).
    ENDAT.
  ENDLOOP.

  lo_document->merge_document( ).
  IF refresh IS INITIAL.
    lo_document->display_document( parent = container ).
  ELSE.
    lo_document->display_document( reuse_control = 'X' reuse_registration = 'X' ).
  ENDIF.
ENDMETHOD.


METHOD display.
  create_dynamic_document( space ).
ENDMETHOD.


METHOD get_bug.
  bug = me->bug.
ENDMETHOD.


method GET_COMMENTS.
endmethod.


METHOD GET_USER.
  user = me->user.
ENDMETHOD.


METHOD html_to_dd.
  DATA: l_find_result TYPE match_result,
        l_length      TYPE i,
        l_text        TYPE LINE OF sdydo_text_table.

  FIND '<BODY>' IN html RESULTS l_find_result.
  l_find_result-offset = l_find_result-offset + l_find_result-length.
  html = html+l_find_result-offset.

  FIND '</BODY>' IN html RESULTS l_find_result.
  html = html(l_find_result-offset).

  DO.
    l_length = strlen( html ).
    l_text = html.
    INSERT l_text INTO TABLE ddtext[].
    IF l_length > 255.
      html = html+255.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.

ENDMETHOD.


METHOD initialize_containers.
* Splits container in 2
  CREATE OBJECT me->splitter_container
    EXPORTING
      parent        = container
      orientation   = cl_gui_easy_splitter_container=>orientation_vertical
      sash_position = 5.

  me->container     = me->splitter_container->bottom_right_container.
  toolbar_container = me->splitter_container->top_left_container.

ENDMETHOD.


METHOD init_toolbar.
  DATA: l_event   TYPE cntl_simple_event,
        lt_events TYPE cntl_simple_events.


  CREATE OBJECT o_toolbar
    EXPORTING
      parent             = toolbar_container.

  l_event-eventid = cl_gui_toolbar=>m_id_function_selected.
  APPEND l_event TO lt_events[].


  CALL METHOD o_toolbar->set_registered_events
    EXPORTING
      events = lt_events[].

  SET HANDLER me->on_toolbar_action_selected
            FOR o_toolbar.

  CALL METHOD o_toolbar->add_button
    EXPORTING
      fcode            = action_reply
      icon             = icon_create_note
*      IS_DISABLED      = me->display_mode
      butn_type        = 0
      text             = 'Reply'(001)
      quickinfo        = 'Reply'(002)
    EXCEPTIONS
      cntb_error_fcode = 1.

ENDMETHOD.


METHOD init_toolbar_new_comment.
  DATA: l_event   TYPE cntl_simple_event,
        lt_events TYPE cntl_simple_events.


  l_event-eventid = cl_gui_toolbar=>m_id_function_selected.
  APPEND l_event TO lt_events[].


  CALL METHOD toolbar->set_registered_events
    EXPORTING
      events = lt_events[].

  SET HANDLER me->on_toolbar_action_selected
            FOR toolbar.

  CALL METHOD toolbar->add_button
    EXPORTING
      fcode            = action_popup_ok
      icon             = icon_okay
      butn_type        = 0
      text             = 'Ok'(003)
      quickinfo        = 'Ok'(004)
    EXCEPTIONS
      cntb_error_fcode = 1.

  CALL METHOD toolbar->add_button
    EXPORTING
      fcode            = action_popup_ko
      icon             = icon_cancel
      butn_type        = 0
      text             = 'Cancel'(003)
      quickinfo        = 'Cancel'(004)
    EXCEPTIONS
      cntb_error_fcode = 1.

ENDMETHOD.


METHOD on_toolbar_action_selected.
  DATA: lo_bug      TYPE REF TO zcl_bug,
        l_string    TYPE string,
        lt_comments TYPE zbt_comentarios,
        lo_user     TYPE REF TO zcl_usuario.

  CASE fcode.
    WHEN action_reply.

      lo_bug  = get_bug( ).
      lo_user = get_user( ).

      ask_4new_comment(
        EXPORTING bug      = lo_bug
                  user     = lo_user ).

    WHEN action_popup_ok.
      l_string = o_popup_editor->get_content_as_string( ).
      comment-oref->set_texto( l_string ).
      comment-oref->set_erdat( ).

      lo_bug = get_bug( ).
      lo_bug->add_comment( comment-oref ).

      close_popup( ).
      RAISE EVENT comment_added.

    WHEN action_popup_ko.
      close_popup( ).

    WHEN OTHERS.

  ENDCASE.
ENDMETHOD.


METHOD refresh.

  me->splitter_container->free( ).
  CLEAR me->splitter_container.

  initialize_containers( me->main_container ).
  init_toolbar( ).

  create_dynamic_document( ).
ENDMETHOD.


METHOD set_bug.
  me->bug = bug.
ENDMETHOD.


METHOD set_display_mode.

  display_mode  = display.

* Refresh ToolBar Buttons
  IF display_mode IS INITIAL.
    o_toolbar->set_enable( 'X' ).
  ELSE.
    o_toolbar->set_enable( space ).
  ENDIF.

ENDMETHOD.


METHOD SET_USER.
  me->user = user.
ENDMETHOD.
ENDCLASS.
