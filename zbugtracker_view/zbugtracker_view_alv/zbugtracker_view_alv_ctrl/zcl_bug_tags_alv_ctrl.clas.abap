class ZCL_BUG_TAGS_ALV_CTRL definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_TAGS_ALV_CTRL
*"* do not include other source files here!!!
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !BUG type ref to ZCL_BUG
      !TITLE type LVC_TITLE optional .
  methods DISPLAY .
  methods SET_TITLE
    importing
      !TITLE type LVC_TITLE .
  type-pools ABAP .
  methods SET_DISPLAY_MODE
    importing
      !DISPLAY type FLAG default ABAP_FALSE .
protected section.
*"* protected components of class ZCL_BUG_TAGS_ALV_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_TAGS_ALV_CTRL
*"* do not include other source files here!!!

  data O_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_GRID type ref to CL_GUI_ALV_GRID .
  data O_BUG type ref to ZCL_BUG .
  data ALV_TAGS type ZBT_BUG_TAG_ALV_TBL .
  data TITLE type LVC_TITLE .
  data EDIT_MODE type INT4 value 1. "#EC NOTEXT .

  methods ADD_TAG .
  methods DEL_TAG .
  methods BUILD_GRID .
  methods EXCLUDED_BUTTONS
    returning
      value(EXCLUDED_BUTTONS) type UI_FUNCTIONS .
  methods ON_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_DATA_CHANGED
    for event DATA_CHANGED of CL_GUI_ALV_GRID
    importing
      !ER_DATA_CHANGED
      !E_ONF4
      !E_ONF4_BEFORE
      !E_ONF4_AFTER
      !E_UCOMM .
  methods ON_TOOLBAR_CREATE
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
ENDCLASS.



CLASS ZCL_BUG_TAGS_ALV_CTRL IMPLEMENTATION.


METHOD add_tag.
  DATA:   lt_results  TYPE STANDARD TABLE OF ddshretval,
          l_result    TYPE ddshretval,
          lt_bug_tags TYPE zbt_bug_tag_tbl,
          l_bug_tag   TYPE LINE OF zbt_bug_tag_tbl,
          l_tag       TYPE LINE OF zbt_bug_tag_alv_tbl,
          lo_producto TYPE REF TO zcl_producto,
          l_cancel    TYPE flag.

* Display F4 for Tag selection
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname    = 'ZBT_PRODUCTO_TAG'
      fieldname  = 'TAG'
    IMPORTING
      user_reset = l_cancel
    TABLES
      return_tab = lt_results[].

  IF l_cancel IS INITIAL.

    lo_producto    = o_bug->get_producto( ).
    l_tag-producto = lo_producto->get_id( ).
    l_tag-bug      = o_bug->get_id( ).

    READ TABLE lt_results INTO l_result WITH KEY retfield = 'ZBT_PRODUCTO_TAG-TAG'.
    l_tag-tag = l_result-fieldval.

*   Check no TAG repeated
    READ TABLE alv_tags WITH KEY producto = l_tag-producto
                                 tag      = l_tag-tag
                                 TRANSPORTING NO FIELDS.
    IF NOT sy-subrc IS INITIAL.
      lt_bug_tags = o_bug->get_tags( ).

      l_bug_tag-producto = l_tag-producto.
      l_bug_tag-bug      = l_tag-bug.
      l_bug_tag-tag      = l_tag-tag.
      l_bug_tag-tagval   = l_tag-tagval.

      CREATE OBJECT l_bug_tag-oref
        EXPORTING
          bug       = o_bug
          tag_id    = l_bug_tag-tag
          tag_value = l_bug_tag-tagval.

*     Insert new tag into bug object
      INSERT l_bug_tag INTO TABLE lt_bug_tags[].
      o_bug->set_tags( lt_bug_tags ).

*     Update ALV data
      l_tag-tagtext = l_bug_tag-oref->get_description( ).
      INSERT l_tag     INTO TABLE alv_tags.
      o_grid->refresh_table_display(  ).
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD build_grid.
  FIELD-SYMBOLS: <l_field>  TYPE LINE OF lvc_t_fcat.

  DATA: lt_excluded_buttons TYPE ui_functions,
        lt_fieldcatalog     TYPE lvc_t_fcat,
        l_layout            TYPE lvc_s_layo.

  CREATE OBJECT o_grid
    EXPORTING
      i_parent = o_container.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZBT_BUG_TAG_ALV_STR'
    CHANGING
      ct_fieldcat      = lt_fieldcatalog[].

  LOOP AT lt_fieldcatalog ASSIGNING <l_field>.
    CASE <l_field>-fieldname.
      WHEN  'TAGVAL'.
        <l_field>-outputlen   = '000070'.
        <l_field>-intlen   = '000070'.
        <l_field>-edit   = 'X'.

      WHEN 'PRODUCTO' OR 'BUG' OR 'TAG'.
        <l_field>-no_out = 'X'.
        <l_field>-tech   = 'X'.
      WHEN OTHERS.
        <l_field>-edit = space.
    ENDCASE.
  ENDLOOP.

  lt_excluded_buttons = excluded_buttons( ).

  CALL METHOD o_grid->set_table_for_first_display
    EXPORTING
      i_structure_name     = 'ZBT_BUG_TAG_ALV_STR'
      is_layout            = l_layout
      it_toolbar_excluding = lt_excluded_buttons
    CHANGING
      it_fieldcatalog      = lt_fieldcatalog[]
      it_outtab            = alv_tags[].

* Push enter in order to update TAG data
  o_grid->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).

  SET HANDLER me->on_data_changed     FOR o_grid.
  SET HANDLER me->on_user_command     FOR o_grid.
  SET HANDLER me->on_toolbar_create   FOR o_grid.

  o_grid->set_toolbar_interactive( ).
  o_grid->set_ready_for_input( me->edit_mode ).

  set_title( title ).

ENDMETHOD.


METHOD constructor.
  DATA: lt_tags       TYPE zbt_bug_tag_tbl,
        l_alv_tag     TYPE LINE OF zbt_bug_tag_alv_tbl,
        l_tag         TYPE LINE OF zbt_bug_tag_tbl,
        lo_producto   type REF TO zcl_producto,
        l_id_bug      type ZBT_ID_BUG,
        l_id_producto type zbt_id_producto.


  me->o_container = container.
  me->o_bug       = bug.
  lo_producto     = me->o_bug->get_producto( ).

  l_id_bug        = me->o_bug->get_id( ).
  l_id_producto   = lo_producto->get_id( ).

  me->title       = title.

  lt_tags = o_bug->get_tags( ).
  LOOP AT lt_tags INTO l_tag.
    l_alv_tag-producto = l_id_producto.
    l_alv_tag-bug      = l_id_bug.
    l_alv_tag-tag      = l_tag-tag.
    l_alv_tag-tagval   = l_tag-tagval.
    l_alv_tag-TAGTEXT  = l_tag-oref->get_description( ).

    INSERT l_alv_tag INTO TABLE alv_tags[].
  ENDLOOP.


ENDMETHOD.


METHOD del_tag.
  DATA: lt_index  TYPE lvc_t_row,
        lt_tags   TYPE zbt_bug_tag_tbl,
        l_alv_tag TYPE LINE OF zbt_bug_tag_alv_tbl,
        l_idx     TYPE LINE OF lvc_t_row.

  o_grid->get_selected_rows( IMPORTING et_index_rows = lt_index ).
  LOOP AT lt_index INTO l_idx.
    READ TABLE alv_tags INDEX l_idx INTO l_alv_tag.
    IF sy-subrc IS INITIAL.

      lt_tags[] = o_bug->get_tags( ).
      DELETE lt_tags WHERE tag = l_alv_tag-tag.
      o_bug->set_tags( lt_tags[] ).

      DELETE alv_tags INDEX l_idx.
    ENDIF.
    AT LAST.
      o_grid->refresh_table_display(  ).
    ENDAT.
  ENDLOOP.
ENDMETHOD.


METHOD display.

  build_grid( ).

ENDMETHOD.


METHOD excluded_buttons.

  DATA: l_button TYPE LINE OF ui_functions.

  l_button = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_detail.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_graph.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_copy.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_cut.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_paste.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_append_row.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_sum.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_subtot.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_views.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_auf.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_variant_admin.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_loc_undo.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_maximum.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_minimum.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_pc_file.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_print.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_print_back.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_print_prev.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_mb_variant.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_mb_subtot.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_mb_sum.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_load_variant.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_data_save.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_average.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_abc.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_chain.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_crbatch.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_crweb.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_lineitems.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_master_data.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_more.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_report.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_xint.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_call_xxl.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_data_save.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_delete_filter.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_expcrdata.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_expcrdesig.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_expcrtempl.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_expmdb.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_extend.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_info.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_html.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_to_office.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_to_rep_tree.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_send.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>mc_fc_word_processor.
  INSERT l_button INTO TABLE excluded_buttons.

  l_button = cl_gui_alv_grid=>MC_FC_LOC_INSERT_ROW.
  INSERT l_button INTO TABLE excluded_buttons.
  l_button = cl_gui_alv_grid=>MC_FC_LOC_DELETE_ROW.
  INSERT l_button INTO TABLE excluded_buttons.


ENDMETHOD.


METHOD on_data_changed.
  DATA:    ls_good       TYPE lvc_s_modi,
           lt_tags       TYPE zbt_bug_tag_tbl,
           lo_tag        TYPE REF TO zcl_bug_tag,
           lo_producto   TYPE REF TO zcl_producto,
           l_rowdata     TYPE zbt_bug_tag_alv_str.

  FIELD-SYMBOLS: <tag>   TYPE LINE OF zbt_bug_tag_tbl.

  LOOP AT er_data_changed->mt_good_cells INTO ls_good.

    l_rowdata-bug      = o_bug->get_id( ).
    lo_producto        = o_bug->get_producto( ).
    l_rowdata-producto = lo_producto->get_id( ).

    CASE ls_good-fieldname.
      WHEN 'TAGVAL'.
        CALL METHOD er_data_changed->get_cell_value
          EXPORTING
            i_row_id    = ls_good-row_id
            i_fieldname = ls_good-fieldname
          IMPORTING
            e_value     = l_rowdata-tagval.

        CALL METHOD er_data_changed->get_cell_value
          EXPORTING
            i_row_id    = ls_good-row_id
            i_fieldname = 'TAG'
          IMPORTING
            e_value     = l_rowdata-tag.

        lt_tags[] = o_bug->get_tags( ).
        READ TABLE lt_tags WITH KEY tag = l_rowdata-tag ASSIGNING <tag>.
        IF sy-subrc IS INITIAL.
          <tag>-tagval = l_rowdata-tagval.
          <tag>-oref->set_value( <tag>-tagval ).
          o_bug->set_tags( lt_tags[] ).
        ENDIF.

    ENDCASE.

  ENDLOOP.
ENDMETHOD.


METHOD on_toolbar_create.
  DATA: ls_toolbar TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 'ADDTAG' TO ls_toolbar-function.
  MOVE 0 TO ls_toolbar-butn_type.
  MOVE icon_insert_row TO ls_toolbar-icon.
  MOVE 'Add Tag'(001) TO ls_toolbar-quickinfo.
  MOVE ' ' TO ls_toolbar-text.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  MOVE 'DELTAG' TO ls_toolbar-function.
  MOVE 0 TO ls_toolbar-butn_type.
  MOVE icon_delete_row TO ls_toolbar-icon.
  MOVE 'Del Tag'(002) TO ls_toolbar-quickinfo.
  MOVE ' ' TO ls_toolbar-text.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.
ENDMETHOD.


METHOD on_user_command.

  IF edit_mode = 1.
    CASE e_ucomm.
      WHEN 'ADDTAG'.
        add_tag( ).
      WHEN 'DELTAG'.
        del_tag( ).
      WHEN OTHERS.

    ENDCASE.
  ENDIF.

ENDMETHOD.


METHOD set_display_mode.
  DATA: l_edit_mode TYPE int4.

  IF display IS INITIAL.
    l_edit_mode = 1.
  ELSE.
    l_edit_mode = 0.
  ENDIF.

  IF l_edit_mode <> me->edit_mode.
    me->edit_mode = l_edit_mode.
    IF o_grid IS BOUND.
      o_grid->set_ready_for_input( me->edit_mode ).
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD set_title.

  o_grid->set_gridtitle( title ).

ENDMETHOD.
ENDCLASS.
