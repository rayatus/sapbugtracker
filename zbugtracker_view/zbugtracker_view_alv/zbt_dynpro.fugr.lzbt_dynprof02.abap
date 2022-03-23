*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PBO_0100
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0100 .
  DATA: lt_combobox_values TYPE vrm_values.

* Set ComboBox values for Bug status
  IF NOT g_bug-estado IS INITIAL.
    PERFORM get_bug_estado_cb_values USING g_bug-estado
                                    CHANGING lt_combobox_values.
    PERFORM set_combobox_values USING 'G_BUG-ESTADO'
                                      lt_combobox_values[].
  ENDIF.
* Set ComboBox values for Products
  PERFORM get_producto_cb_values  CHANGING lt_combobox_values.
  PERFORM set_combobox_values USING 'G_PRODUCTO-PRODUCTO'
                                    lt_combobox_values[].
* Set ComboBox values for Product Components
  IF NOT g_producto-producto IS INITIAL.
    PERFORM get_component_cb_values USING    g_producto-producto
                                    CHANGING lt_combobox_values.
    PERFORM set_combobox_values USING 'G_COMPONENTE-COMPONENTE'
                                      lt_combobox_values[].
  ENDIF.
* Set ComboBox values for BugType
  PERFORM get_bugtype_cb_values CHANGING lt_combobox_values.
  PERFORM set_combobox_values USING 'G_BUG-BUGTYPE'
                                    lt_combobox_values[].
* Set ComboBox values for BugSubtype
  IF NOT g_bug-bugtype IS INITIAL.
    PERFORM get_bugsubtype_cb_values USING    g_bug-bugtype
                                     CHANGING lt_combobox_values
                                              g_bug-bugstype.
    PERFORM set_combobox_values USING 'G_BUG-BUGSTYPE'
                                      lt_combobox_values[].
  ENDIF.

  PERFORM set_icon_status     USING go_bug CHANGING g_bug_status_icon.
  PERFORM set_bugstype_status USING go_bug CHANGING g_bug_stype_icon.
ENDFORM.                                                    " PBO_0100
*&---------------------------------------------------------------------*
*&      Form  PBO_0200
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0200 .

ENDFORM.                                                    " PBO_0200
*&---------------------------------------------------------------------*
*&      Form  CREATE_INFO_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_info_container .
  IF g_info_container IS INITIAL.
    CREATE OBJECT g_info_container
      EXPORTING
        container_name = 'INFO_CONTAINER'.
  ENDIF.
  IF g_info_splitter_container IS INITIAL.
    CREATE OBJECT g_info_splitter_container
      EXPORTING
        parent  = g_info_container
        rows    = 3
        columns = 1.
  ENDIF.
  IF g_problem_section_container IS INITIAL.
    CALL METHOD g_info_splitter_container->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = g_problem_section_container.
  ENDIF.
  IF g_steps_section_container IS INITIAL.
    CALL METHOD g_info_splitter_container->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = g_steps_section_container.
  ENDIF.
  IF g_more_info_section_container IS INITIAL.
    CALL METHOD g_info_splitter_container->get_container
      EXPORTING
        row       = 3
        column    = 1
      RECEIVING
        container = g_more_info_section_container.
  ENDIF.
ENDFORM.                    " CREATE_INFO_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  CREATE_BTF_EDITOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CONTAINER  text
*      <--P_EDITOR  text
*----------------------------------------------------------------------*
FORM create_btf_editor  USING    p_container TYPE REF TO cl_gui_container
                                 p_title
                                 p_text      TYPE string
                                 p_display   TYPE flag
                        CHANGING p_editor    TYPE REF TO zcl_btf_editor.
  DATA: l_title             TYPE vtext,
        l_text              TYPE xstring,
        l_exception         TYPE REF TO cx_btf_runtime_error,
        l_system_exception  TYPE REF TO cx_btf_system_error.

  IF p_editor IS INITIAL.
    l_title = p_title.
    TRY.
        CREATE OBJECT p_editor
          EXPORTING
            container    = p_container
            title        = l_title
            display_mode = p_display.
      CATCH cx_btf_runtime_error .
      CATCH cx_btf_system_error .
    ENDTRY.
  ENDIF.

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text   = p_text
    IMPORTING
      buffer = l_text.

  p_editor->set_content( text = l_text ).
  p_editor->display( ).
ENDFORM.                    " CREATE_BTF_EDITOR
*&---------------------------------------------------------------------*
*&      Form  SET_COMBOBOX_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FIELDNAME  text
*      -->P_LT_COMBOBOX_VALUES  text
*      -->P_ENDFORM  text
*----------------------------------------------------------------------*
FORM set_combobox_values  USING    p_fieldname       TYPE vrm_id
                                   p_combobox_values TYPE vrm_values.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = p_fieldname
      values = p_combobox_values.
ENDFORM.                    " SET_COMBOBOX_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_BUG_ESTADO_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_BUG_ESTADO  text
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_bug_estado_cb_values  USING    value(p_estado) TYPE zbt_bug-estado
                               CHANGING p_combobox_values TYPE vrm_values.

  DATA: l_combobox_value   TYPE vrm_value,
        lt_estados         TYPE zbt_estados,
        lo_estado          TYPE REF TO zcl_estado,
        l_estado           TYPE LINE OF zbt_estados.

  CHECK p_estado IS NOT INITIAL.

  CLEAR p_combobox_values[].
  lo_estado  = zcl_estado_controller=>find_by_key( p_estado ).

  l_combobox_value-key  = p_estado.
  l_combobox_value-text = lo_estado->get_descripcion( ).
  APPEND l_combobox_value TO p_combobox_values.

  lt_estados = lo_estado->get_next_estados( ).
  LOOP AT lt_estados INTO l_estado.
    p_estado = l_estado-oref->get_id( ).
    l_combobox_value-key  = p_estado.
    l_combobox_value-text = l_estado-oref->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.
  ENDLOOP.

  lt_estados = lo_estado->get_prev_estados( ).
  LOOP AT lt_estados INTO l_estado.
    p_estado = l_estado-oref->get_id( ).
    l_combobox_value-key  = p_estado.
    l_combobox_value-text = l_estado-oref->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.
  ENDLOOP.

  SORT p_combobox_values.
  DELETE ADJACENT DUPLICATES FROM p_combobox_values.
ENDFORM.                    " GET_BUG_ESTADO_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_PRODUCTO_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_PRODUCTO_PRODUCTO  text
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_producto_cb_values  CHANGING p_combobox_values TYPE vrm_values.

  DATA: l_combobox_value   TYPE vrm_value,
        lt_products        TYPE zbt_productos,
        lo_product         TYPE REF TO zcl_producto.

  CLEAR p_combobox_values.
  lt_products = zcl_producto_controller=>find_all_products( ).
  LOOP AT lt_products INTO lo_product.
    l_combobox_value-key  = lo_product->get_id( ).
    l_combobox_value-text = lo_product->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.
  ENDLOOP.

ENDFORM.                    " GET_PRODUCTO_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_COMPONENT_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_PRODUCTO_PRODUCTO  text
*      -->P_G_COMPONENT_COMPONENT  text
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_component_cb_values  USING    p_producto  TYPE zbt_bug-producto
                              CHANGING p_combobox_values TYPE vrm_values.

  DATA: l_combobox_value   TYPE vrm_value,
        lo_product         TYPE REF TO zcl_producto,
        lo_component       TYPE REF TO zcl_componente,
        lt_components      TYPE zbt_componentes.

  CHECK p_producto IS NOT INITIAL.

  CLEAR p_combobox_values.
  lo_product = zcl_producto_controller=>find_by_key( p_producto ).

  lt_components = lo_product->get_componentes( ).
  LOOP AT lt_components INTO lo_component.
    l_combobox_value-key  = lo_component->get_id( ).
    l_combobox_value-text = lo_component->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.
  ENDLOOP.

ENDFORM.                    " GET_COMPONENT_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_BUGTYPE_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_bugtype_cb_values  CHANGING p_combobox_values TYPE vrm_values.
  DATA: lt_bugtype TYPE zbt_bugtypes,
        l_combobox_value   TYPE vrm_value,
        lo_bugtype TYPE REF TO zcl_bugtype.

  CLEAR p_combobox_values[].
  lt_bugtype = zcl_bugtype_controller=>find_all_bugtypes( ).
  LOOP AT lt_bugtype INTO lo_bugtype.
    l_combobox_value-key  = lo_bugtype->get_id( ).
    l_combobox_value-text = lo_bugtype->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.
  ENDLOOP.


ENDFORM.                    " GET_BUGTYPE_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_BUGSUBTYPE_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_BUG_BUGTYPE  text
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_bugsubtype_cb_values  USING    value(p_bugtype)  TYPE zbt_bug-bugtype
                               CHANGING p_combobox_values TYPE vrm_values
                                        p_bugstype        LIKE g_bug-bugstype.

  STATICS: s_bugtype          TYPE zbt_bug-bugtype,
           st_combobox_values TYPE vrm_values.

  DATA: lt_bugstype        TYPE zbt_bugstypes,
        lo_bugtype         TYPE REF TO zcl_bugtype,
        l_combobox_value   TYPE vrm_value,
        lo_bugstype        TYPE REF TO zcl_bugstype.

  CHECK p_bugtype IS NOT INITIAL.

  CLEAR p_combobox_values[].
  IF s_bugtype <> p_bugtype.
    IF NOT s_bugtype IS INITIAL.
      CLEAR p_bugstype.
    ENDIF.

    lo_bugtype  = zcl_bugtype_controller=>find_by_key( p_bugtype ).
    lt_bugstype = zcl_bugtype_controller=>find_all_bug_subtypes( bugtype = lo_bugtype ).

    LOOP AT lt_bugstype INTO lo_bugstype.
      l_combobox_value-key  = lo_bugstype->get_id( ).
      l_combobox_value-text = lo_bugstype->get_descripcion( ).
      APPEND l_combobox_value TO p_combobox_values.
    ENDLOOP.
    st_combobox_values[] = p_combobox_values[].
    s_bugtype = p_bugtype.
  ELSE.
    p_bugtype = s_bugtype.
    p_combobox_values[] = st_combobox_values[].
  ENDIF.
ENDFORM.                    " GET_BUGSUBTYPE_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_NEXT_BUGSTATUS_CB_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_BUG_ESTADO  text
*      <--P_LT_COMBOBOX_VALUES  text
*----------------------------------------------------------------------*
FORM get_next_bugstatus_cb_values  USING    p_estado          TYPE zbt_bug-estado
                                   CHANGING p_combobox_values TYPE vrm_values.

  STATICS: s_estado        TYPE zbt_bug-estado.

  DATA: lt_estados         TYPE zbt_estados,
        l_estado           TYPE LINE OF zbt_estados,
        lo_estado          TYPE REF TO zcl_estado,
        l_combobox_value   TYPE vrm_value.

  CLEAR p_combobox_values[].
  IF s_estado <> p_estado.
    IF NOT s_estado IS INITIAL.
      CLEAR p_estado.
    ENDIF.

    lo_estado   = zcl_estado_controller=>find_by_key( p_estado ).
*   Add current status to ComboBox
    l_combobox_value-key  = lo_estado->get_id( ).
    l_combobox_value-text = lo_estado->get_descripcion( ).
    APPEND l_combobox_value TO p_combobox_values.

    lt_estados  = lo_estado->get_next_estados( ).

    LOOP AT lt_estados INTO l_estado.
*     Add next allowed status to ComboBox
      l_combobox_value-key  = l_estado-id.
      l_combobox_value-text = l_estado-oref->get_descripcion( ).
      APPEND l_combobox_value TO p_combobox_values.
    ENDLOOP.
    s_estado = p_estado.
  ENDIF.


ENDFORM.                    " GET_NEXT_BUGSTATUS_CB_VALUES
*&---------------------------------------------------------------------*
*&      Form  SET_ICON_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_BUG_ESTADO  text
*----------------------------------------------------------------------*
FORM set_icon_status  USING    value(p_bug) TYPE REF TO zcl_bug
                      CHANGING p_icon LIKE g_bug_status_icon.
  DATA: l_icon_id TYPE zbt_estado-icon,
        l_text    TYPE char30,
        l_info    TYPE zbt_estado_txt-descripcion,
        lo_estado TYPE REF TO zcl_estado.

  lo_estado = p_bug->get_estado( ).
  l_icon_id = lo_estado->get_icon( ).

  IF l_icon_id IS INITIAL.
    l_icon_id = icon_space.
  ELSE.
    l_info = lo_estado->get_descripcion( ).
  ENDIF.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name       = l_icon_id
      text       = l_text
      info       = l_info
      add_stdinf = space
    IMPORTING
      result     = p_icon.

ENDFORM.                    " SET_ICON_STATUS
*&---------------------------------------------------------------------*
*&      Form  PROGRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERCENTAGE  text
*      -->P_TEXT  text
*----------------------------------------------------------------------*
FORM progress  USING    p_percentage
                        p_text.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = p_percentage
      text       = p_text.

ENDFORM.                    " PROGRESS
*&---------------------------------------------------------------------*
*&      Form  SET_BUGSTYPE_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_BUG  text
*      <--P_G_BUG_STYPE_ICON  text
*----------------------------------------------------------------------*
FORM set_bugstype_status USING    value(p_bug) TYPE REF TO zcl_bug
                         CHANGING p_icon LIKE g_bug_status_icon.

  DATA: l_icon_id TYPE zbt_estado-icon,
        l_text    TYPE char30,
        l_info    TYPE zbt_stype_txt-descripcion,
        lo_stype  TYPE REF TO zcl_bugstype.

  lo_stype = p_bug->get_bug_subtype( ).
  l_icon_id = lo_stype->get_icon( ).

  IF l_icon_id IS INITIAL.
    l_icon_id = icon_space.
  ELSE.
    l_info = lo_stype->get_descripcion( ).
  ENDIF.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name       = l_icon_id
      text       = l_text
      info       = l_info
      add_stdinf = space
    IMPORTING
      result     = p_icon.

ENDFORM.                    " SET_BUGSTYPE_STATUS
