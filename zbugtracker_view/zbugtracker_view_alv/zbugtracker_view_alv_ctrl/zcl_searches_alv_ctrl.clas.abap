class ZCL_SEARCHES_ALV_CTRL definition
  public
  create public .

public section.
*"* public components of class ZCL_SEARCHES_ALV_CTRL
*"* do not include other source files here!!!

  interfaces ZINF_RESULTS_ALV_CTRL .

  aliases DISPLAY_RESULTS
    for ZINF_RESULTS_ALV_CTRL~DISPLAY_RESULTS .
  aliases DO_SEARCH
    for ZINF_RESULTS_ALV_CTRL~DO_SEARCH .
  aliases ON_RESULTS_SELECTED
    for ZINF_RESULTS_ALV_CTRL~ON_RESULTS_SELECTED .

  events BUG_SELECTED
    exporting
      value(BUG) type ref to ZCL_BUG .
  events PRODUCT_SELECTED
    exporting
      value(PRODUCT) type ref to ZCL_PRODUCTO .

  methods SEARCH
    importing
      !SCREEN_ATTRIBUTES type ZBT_SCREEN_ATTRIBUTES optional .
protected section.
*"* protected components of class ZCL_SEARCHES_ALV_CTRL
*"* do not include other source files here!!!

  methods DISPLAY_SETTINGS
    importing
      !GRID type ref to CL_SALV_TABLE .
  methods SET_ALV_ROW_ATTR
    changing
      !ROW type ZBT_SEARCH_RESULTS_GRID_STR .
  methods ON_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN .
  methods CREATE_ICON
    importing
      !ICON type ICONNAME
      !TEXT type TEXT20
    returning
      value(RESULT) type CHAR80 .
private section.
*"* private components of class ZCL_SEARCHES_ALV_CTRL
*"* do not include other source files here!!!

  data BUG type ZBT_BUG_RANGE .
  data BUGSTYPE type ZBT_BUGSTYPE_RANGE .
  data BUGTYPE type ZBT_BUGTYPE_RANGE .
  data COMPONENTE type ZBT_COMPONENTE_RANGE .
  data DEADLINE type ZBT_DATS_RANGE .
  data ESTADO type ZBT_ESTADO_RANGE .
  data HORAS_ESTIMADAS type ZBT_HORAS_RANGE .
  data HORAS_REALES type ZBT_HORAS_RANGE .
  data PRODUCTO type ZBT_PRODUCTO_RANGE .
  data RESUMEN type ZBT_TEXT_RANGE .
  data CREADO type ZBT_TIMESTAMP_RANGE .
  data REPORTER type ZBT_USER_RANGE .
  data DEVELOPER type ZBT_USER_RANGE .
  data assigned type zbt_user_range .
  data TESTER type ZBT_USER_RANGE .
  data FINALIZADO type ZBT_TIMESTAMP_RANGE .
  data O_RESULT_GRID type ref to CL_SALV_TABLE .
  data GT_GRID_TABLE type ZBT_SEARCH_RESULTS_GRID_TBL .
ENDCLASS.



CLASS ZCL_SEARCHES_ALV_CTRL IMPLEMENTATION.


METHOD create_icon.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name       = icon
      text       = text
      info       = text
      add_stdinf = space
    IMPORTING
      result     = result.

ENDMETHOD.


METHOD display_settings.
  DATA: o_settings  TYPE REF TO cl_salv_display_settings,
        o_cols      TYPE REF TO cl_salv_columns_table,
        o_col_table TYPE REF TO cl_salv_column_table,
        lt_cols     TYPE salv_t_column_ref,
        l_col       TYPE LINE OF salv_t_column_ref.

  o_settings = grid->get_display_settings( ).
  o_settings->set_striped_pattern( 'X' ).

  o_cols = grid->get_columns( ).
  o_cols->set_optimize( 'X' ).
  o_cols->set_color_column( 'COLOR' ).

  lt_cols = o_cols->get( ).
  LOOP AT lt_cols INTO l_col.
    o_col_table ?= l_col-r_column.
    CASE l_col-columnname.
      WHEN 'BUG_ID'.
      WHEN 'RESUMEN'.
      WHEN 'PRODUCTO_ID'.
        o_col_table->set_visible( if_salv_c_bool_sap=>false ).
      WHEN 'PRODUCTO'.
      WHEN 'COMPONENTE_ID'.
        o_col_table->set_visible( if_salv_c_bool_sap=>false ).
      WHEN 'COMPONENTE'.
      WHEN 'CREADO'.
      WHEN 'FINALIZADO'.
      WHEN 'DEADLINE'.
      WHEN 'REPORTER'.
      WHEN 'DEVELOPER'.
      WHEN 'ASSIGNED'.
      WHEN 'TESTER'.
      WHEN 'ESTADO'.
      WHEN 'ESTADO_ID'.
        o_col_table->set_visible( if_salv_c_bool_sap=>false ).
      WHEN 'ESTADO_ICON'.
        o_col_table->set_icon( if_salv_c_bool_sap=>true ).
      WHEN 'HORAS_EST'.
      WHEN 'HORAS_REA'.
      WHEN 'BUGTYPE_ID'.
        o_col_table->set_visible( if_salv_c_bool_sap=>false ).
      WHEN 'BUGTYPE'.
      WHEN 'BUGSTYPE_ICON'.
        o_col_table->set_icon( if_salv_c_bool_sap=>true ).
      WHEN 'BUGSTYPE_ID'.
        o_col_table->set_visible( if_salv_c_bool_sap=>false ).
      WHEN 'BUGSTYPE'.
    ENDCASE.
  ENDLOOP.

ENDMETHOD.


METHOD on_double_click.
  DATA: l_result    TYPE LINE OF zbt_bugs,
        lo_producto TYPE REF TO zcl_producto.

  READ TABLE me->zinf_results_alv_ctrl~results INDEX row INTO l_result.
  IF sy-subrc IS INITIAL.
    CASE column.
      WHEN 'PRODUCTO'.
        lo_producto = l_result-oref->get_producto( ).

      WHEN OTHERS.
        CALL FUNCTION 'ZBT_DISPLAY_BUG'
          EXPORTING
            bug          = l_result-oref
            display_mode = 'X'.
    ENDCASE.
  ENDIF.


ENDMETHOD.


METHOD SEARCH.

  CALL FUNCTION 'ZBT_SEARCH_BUG'
    EXPORTING
      screen_attributes = screen_attributes
      results_alv_ctrl  = me.

ENDMETHOD.


METHOD set_alv_row_attr.
  DATA: l_color TYPE LINE OF lvc_t_scol.

  l_color-fname = 'BUG_ID'.
  l_color-color-col = col_key.
  l_color-color-int = 1.
  l_color-color-inv = 0.
  INSERT l_color INTO TABLE row-color[].

  l_color-fname = 'PRODUCTO_ID'.
  l_color-color-col = col_group.
  l_color-color-int = 0.
  l_color-color-inv = 0.
  INSERT l_color INTO TABLE row-color[].
  l_color-fname = 'PRODUCTO'.
  INSERT l_color INTO TABLE row-color[].


  IF NOT row-estado_icon IS INITIAL.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name       = row-estado_icon
        text       = space
        info       = row-estado
        add_stdinf = space
      IMPORTING
        result     = row-estado_icon.
  ENDIF.

  IF NOT row-bugstype_icon IS INITIAL.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name       = row-bugstype_icon
        text       = space
        info       = row-bugstype
        add_stdinf = space
      IMPORTING
        result     = row-bugstype_icon.
  ENDIF.
ENDMETHOD.


METHOD zinf_results_alv_ctrl~display_results.

  DATA: l_bug_str     TYPE zbt_bug,
        lo_producto   TYPE REF TO zcl_producto,
        lo_componente TYPE REF TO zcl_componente,
        lo_type       TYPE REF TO zcl_bugtype,
        lo_stype      TYPE REF TO zcl_bugstype,
        lo_estado     TYPE REF TO zcl_estado,
        l_data        TYPE LINE OF zbt_bugs,
        l_grid        TYPE LINE OF zbt_search_results_grid_tbl,
        o_alv_events  TYPE REF TO cl_salv_events_table,
        o_fcodes      TYPE REF TO cl_salv_functions_list,
        l_percentage  TYPE i,
        l_total       TYPE i.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 0
      text       = 'Rendering data...'(001).

  CALL METHOD cl_salv_table=>factory
    EXPORTING
      r_container  = container
    IMPORTING
      r_salv_table = o_result_grid
    CHANGING
      t_table      = gt_grid_table[].

  o_alv_events = o_result_grid->get_event( ).
  SET HANDLER me->on_double_click FOR o_alv_events.


  CLEAR gt_grid_table.
  LOOP AT me->zinf_results_alv_ctrl~results INTO l_data.
    AT FIRST.
      DESCRIBE TABLE me->zinf_results_alv_ctrl~results LINES l_total.
    ENDAT.
    l_percentage = sy-tabix * l_total / 100.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = l_percentage
        text       = 'Rendering data...'(001).

    CLEAR l_grid.

    lo_producto   = l_data-oref->get_producto( ).
    lo_type       = l_data-oref->get_bug_type( ).
    lo_stype      = l_data-oref->get_bug_subtype( ).
    lo_componente = l_data-oref->get_componente( ).
    lo_estado     = l_data-oref->get_estado( ).

    l_bug_str = zcl_bug_controller=>entity_to_structure( l_data-oref ).
    MOVE-CORRESPONDING l_bug_str TO l_grid.

    l_grid-producto_id   = lo_producto->get_id( ).
    l_grid-producto      = lo_producto->get_descripcion( ).
    l_grid-bug_id        = l_data-oref->get_id( ).
    l_grid-componente_id = lo_componente->get_id( ).
    l_grid-componente    = lo_componente->get_descripcion( ).
    l_grid-estado_id     = lo_estado->get_id( ).
    l_grid-estado        = lo_estado->get_descripcion( ).
    l_grid-estado_icon   = lo_estado->get_icon( ).
    l_grid-bugtype_id    = lo_type->get_id( ).
    l_grid-bugtype       = lo_type->get_descripcion( ).
    l_grid-bugstype_id   = lo_stype->get_id( ).
    l_grid-bugstype      = lo_stype->get_descripcion( ).
    l_grid-bugstype_icon = lo_stype->get_icon( ).
    l_grid-bugstype_icon = create_icon( icon = l_grid-bugstype_icon
text = l_grid-bugstype ).

*   Prepare display settings for each row
    set_alv_row_attr( CHANGING row = l_grid ).

    INSERT l_grid INTO TABLE gt_grid_table[].
  ENDLOOP.

  o_result_grid->set_data( CHANGING t_table = gt_grid_table[] ).

  display_settings( o_result_grid ).

*--------------------------------------------------------------------*
* Sets ALVGrid OK_CODES
*--------------------------------------------------------------------*
  o_fcodes = o_result_grid->get_functions( ).
  o_fcodes->set_default( 'X' ).

  o_result_grid->display( ).

ENDMETHOD.


METHOD zinf_results_alv_ctrl~do_search.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 0
      text       = 'Searching ...'(002).

  me->zinf_results_alv_ctrl~results = zcl_bug_controller=>search(
              bug             = bug[]
              bugstype        = bugstype[]
              bugtype         = bugtype[]
              componente      = componente[]
              deadline        = deadline[]
              estado          = estado[]
              horas_estimadas = horas_estimadas[]
              horas_reales    = horas_reales[]
              producto        = producto[]
              resumen         = resumen[]
              creado          = creado[]
              reporter        = reporter[]
              developer       = developer[]
              assigned        = assigned[]
              tester          = tester[]
              finalizado      = finalizado[]
              aedat           = aedat[]
              aenam           = aenam[]
              max_rows        = max_rows ).

ENDMETHOD.
ENDCLASS.
