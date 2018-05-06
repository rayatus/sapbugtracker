class ZCL_BTF_EDITOR definition
  public
  create public .

public section.
*"* public components of class ZCL_BTF_EDITOR
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !TITLE type VTEXT optional
      value(DISPLAY_MODE) type FLAG optional
      !SASH type I default 12
    raising
      CX_BTF_RUNTIME_ERROR
      CX_BTF_SYSTEM_ERROR .
  methods GET_TITLE
    returning
      value(TITLE) type VTEXT .
  methods SET_TITLE
    importing
      !TITLE type VTEXT .
  methods DISPLAY .
  methods FREE .
  methods GET_CONTENT
    exporting
      !LANGUAGE type TDSPRAS
      !ENCODING type STRING
      !TEXT type XSTRING .
  methods SET_CONTENT
    importing
      !TEXT type XSTRING
      !ENCODING type STRING default 'utf-8'
      !CLEAN type I default 0 .
  methods GET_CONTENT_AS_STRING
    returning
      value(STRING) type STRING .
  methods SET_DISPLAY_MODE
    importing
      !DISPLAY_MODE type FLAG default 'X' .
  methods SET_CONTENT_AS_STRING
    importing
      !STRING type STRING .
protected section.
*"* protected components of class ZCL_BTF_EDITOR
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BTF_EDITOR
*"* do not include other source files here!!!

  data EDITOR type ref to IF_BTF_EDITOR .
  data CONTAINER_TITLE type ref to CL_GUI_CONTAINER .
  data BTF type ref to IF_BTF .
  data BTF_DOC type ref to IF_BTF_DOCUMENT .
  data CONTAINER_EDITOR type ref to CL_GUI_CONTAINER .
  data SPLITTER type ref to CL_GUI_EASY_SPLITTER_CONTAINER .
  data TITLE type VTEXT value 'BTF Editor'. "#EC NOTEXT .
  data DISPLAY_MODE type FLAG value SPACE. "#EC NOTEXT .

  class-methods WRITE_HTML_TITLE
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !TITLE type VTEXT .
ENDCLASS.



CLASS ZCL_BTF_EDITOR IMPLEMENTATION.


METHOD constructor.

  DATA: l_exception         TYPE REF TO cx_btf_runtime_error,
        l_system_exception  TYPE REF TO cx_btf_system_error.


* Separates main container in to subContainers
  CREATE OBJECT me->splitter
    EXPORTING
      sash_position = 25
      parent        = container
      orientation   = cl_gui_easy_splitter_container=>orientation_vertical.

  me->splitter->set_sash_position( sash ).

  me->container_title = me->splitter->top_left_container.
  me->container_editor = me->splitter->bottom_right_container.

  me->btf     = cl_btf=>get_reference( ).
  me->btf_doc = me->btf->create_document( sy-langu ).
  me->editor  = me->btf->create_editor( me->btf_doc ).

  CALL METHOD me->editor->initialize
    EXPORTING
      ctrl_parent = me->container_editor.

  IF NOT title IS INITIAL.
    me->set_title( title ).
  ELSE.
    CLEAR me->title.
  ENDIF.

  set_display_mode( display_mode ).


ENDMETHOD.


METHOD display.

  IF NOT me->title IS INITIAL.
    write_html_title( container = me->container_title title = me->title ).
  ELSE.
    me->container_title->set_visible( cl_gui_control=>visible_false ) .
    me->splitter->set_sash_position( 0 ).
  ENDIF.


  set_display_mode( me->display_mode ).

ENDMETHOD.


METHOD free.
  DATA: l_valid TYPE i.
*  me->btf->free( ).

  me->container_editor->is_valid( IMPORTING result = l_valid ).
  IF NOT l_valid IS INITIAL.
    me->container_editor->free( ).
  ENDIF.
  me->container_title->is_valid( IMPORTING result = l_valid ).
  IF NOT l_valid IS INITIAL.
    me->container_title->free( ).
  ENDIF.
  me->splitter->is_valid( IMPORTING result = l_valid ).
  IF NOT l_valid IS INITIAL.
    me->splitter->free( ).
  ENDIF.


  CLEAR: me->btf,
         me->btf_doc,
         me->editor,
         me->container_editor,
         me->container_title,
         me->splitter.

  FREE:  me->btf,
         me->btf_doc,
         me->editor,
         me->container_editor,
         me->container_title,
         me->splitter.
ENDMETHOD.


METHOD get_content.
  editor->get_content( ).
  btf_doc->get_content(
    IMPORTING text     = text
              encoding = encoding
              language = language ).


ENDMETHOD.


METHOD get_content_as_string.
  DATA: l_xstring TYPE xstring.

  get_content( IMPORTING text = l_xstring ).
  CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
    EXPORTING
      im_xstring = l_xstring
    IMPORTING
      ex_string  = string.

ENDMETHOD.


METHOD get_title.
  title = me->title.
ENDMETHOD.


METHOD set_content.
  btf_doc->set_content(
    EXPORTING text     = text
              encoding = encoding
              clean    = clean ).
  editor->set_content( ).
ENDMETHOD.


METHOD set_content_as_string.
  DATA: l_xstring TYPE xstring,
        l_len     type i.

  CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
    EXPORTING
      im_string  = string
      im_encoding = 'UTF-8'
    IMPORTING
      ex_xstring = l_xstring
      ex_len     = l_len.

  set_content( EXPORTING text = l_xstring encoding = 'UTF-8' ).

ENDMETHOD.


METHOD set_display_mode.
  me->display_mode = display_mode.

  IF me->display_mode IS INITIAL .
    editor->set_design_mode( if_btf_editor_constants=>co_design_mode_on ).
  ELSE.
    editor->set_design_mode( if_btf_editor_constants=>co_design_mode_off ).
  ENDIF.

ENDMETHOD.


METHOD set_title.
  me->title = title.
ENDMETHOD.


METHOD write_html_title.

  DATA: lo_document  TYPE REF TO cl_dd_document,
        lo_col       TYPE REF TO cl_dd_area,
        lo_table     TYPE REF TO cl_dd_table_element.

  DATA: l_text      TYPE sdydo_text_element,
        l_color     TYPE sdydo_attribute.

  l_text = title.

  CREATE OBJECT lo_document.
  lo_document->add_text(
    text          = l_text
*    SAP_STYLE     = l_sap_style
*    SAP_COLOR     =
    sap_fontsize  = cl_dd_area=>large
*    SAP_FONTSTYLE =
    sap_emphasis = cl_dd_area=>strong
    ).

  lo_document->merge_document( ).
  lo_document->display_document( parent = container ).

ENDMETHOD.
ENDCLASS.
