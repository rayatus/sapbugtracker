class ZCL_BUG_ATTACHMENT_ALV_CTRL definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_ATTACHMENT_ALV_CTRL
*"* do not include other source files here!!!
  type-pools TRWBO .

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !BUG type ref to ZCL_BUG
      !TITLE type LVC_TITLE optional .
  methods GET_ATTACHMENTS
    returning
      value(CONTENT) type ZBT_BUG_ATTACHMENT_ALV_TBL .
  methods DISPLAY_ATTACHMENTS .
  methods HANDLE_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID .
  methods USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods DISPLAY .
  methods SET_TITLE
    importing
      !TITLE type LVC_TITLE .
protected section.
*"* protected components of class ZCL_BUG_ATTACHMENT_ALV_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_ATTACHMENT_ALV_CTRL
*"* do not include other source files here!!!

  data O_GRID type ref to CL_GUI_ALV_GRID .
  data O_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_BUG type ref to ZCL_BUG .
  data ATTACHMENTS type ZBT_BUG_ATTACHMENT_ALV_TBL .
  data TITLE type LVC_TITLE .

  methods RETRIEVE_ATTACHMENTS .
  methods BUILD_GRID .
  methods EXCLUDED_BUTTONS
    returning
      value(EXCLUDED_BUTTONS) type UI_FUNCTIONS .
  methods HANDLE_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
ENDCLASS.



CLASS ZCL_BUG_ATTACHMENT_ALV_CTRL IMPLEMENTATION.


method BUILD_GRID.

  FIELD-SYMBOLS: <l_field>  TYPE LINE OF lvc_t_fcat.

  DATA: lt_excluded_buttons TYPE ui_functions,
        lt_fieldcatalog     TYPE lvc_t_fcat,
        l_layout            TYPE lvc_s_layo,
        l_variant           TYPE disvariant.

  CREATE OBJECT o_grid
    EXPORTING
      i_parent = o_container.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZBT_BUG_ATTACHMENT_ALV_STR'
    CHANGING
      ct_fieldcat      = lt_fieldcatalog[].

  LOOP AT lt_fieldcatalog ASSIGNING <l_field>.
    CASE <l_field>-fieldname.
      WHEN  'DOC_SIZE'.
        <l_field>-SELTEXT = 'Doc. Size'.
        <l_field>-SCRTEXT_L = 'Document Size'.
        <l_field>-SCRTEXT_M = 'Doc. Size'.
        <l_field>-SCRTEXT_S = 'Size'.
      WHEN 'DOC_ID' OR 'OBJECT_ID' OR 'COUNTER'.
        <l_field>-no_out = 'X'.
        <l_field>-tech   = 'X'.
      when 'OBJ_DESCR'.
        <l_field>-hotspot = 'X'.
      WHEN OTHERS.
*        <l_field>-edit   = 'X'.
    ENDCASE.
  ENDLOOP.

  lt_excluded_buttons = excluded_buttons( ).
  l_variant-report = sy-repid.


  CALL METHOD o_grid->set_table_for_first_display
    EXPORTING
      i_structure_name     = 'ZBT_BUG_ATTACHMENT_ALV_STR'
      is_variant           = l_variant
      i_save               = 'A'
      is_layout            = l_layout
      it_toolbar_excluding = lt_excluded_buttons
    CHANGING
      it_fieldcatalog      = lt_fieldcatalog[]
      it_outtab            = ATTACHMENTS[].

* Push enter in order to update attachment data
  o_grid->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).

*  SET HANDLER me->on_data_changed     FOR o_grid.
  SET HANDLER me->user_command     FOR o_grid.
  set HANDLER me->handle_toolbar for o_grid.

  call method o_grid->set_TOOLBAR_interactive.
  set_title( title ).



endmethod.


METHOD CONSTRUCTOR.

  o_container = container.
  o_bug       = bug.
  me->title       = title.
  retrieve_attachments( ).

ENDMETHOD.


method DISPLAY.

  build_grid( ).

endmethod.


method DISPLAY_ATTACHMENTS.
*  DATA: lo_cols_tab     TYPE REF TO cl_salv_columns_table,
*        lo_col_tab type REF TO cl_salv_column_table,
*       lo_col      TYPE REF TO cl_salv_column,
*       lo_fcodes   TYPE REF TO cl_salv_functions_list,
*       lo_events  TYPE REF TO cl_salv_events_table,
*       l_title     TYPE lvc_title,
*       lo_settings TYPE REF TO cl_salv_display_settings.
*
*  FIELD-SYMBOLS: <l_field>  TYPE LINE OF lvc_t_fcat.
*
*  DATA: lt_excluded_buttons TYPE ui_functions,
*        lt_fieldcatalog     TYPE lvc_t_fcat,
*        l_layout            TYPE lvc_s_layo.
*
*  TRY.
*
**create OBJECT o_grid
**EXPORTING
**  i_parent = o_container.
*
**  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
**    EXPORTING
**      i_structure_name = 'ZBT_BUG_TAG_ALV_STR'
**    CHANGING
**      ct_fieldcat      = lt_fieldcatalog[].
*
**      CALL METHOD cl_salv_table=>factory
**        EXPORTING
**          list_display = if_salv_c_bool_sap=>false
**          r_container  = o_container
**        IMPORTING
**          r_salv_table = o_grid
**        CHANGING
**          t_table      = attachments[].
*
*
*
*
*      lo_cols_tab = o_grid->get_columns( ).
*      lo_cols_tab->set_optimize( ).
**   Get OBJ_DESCR column
*      TRY.
*          lo_col_tab ?= lo_cols_tab->get_column( 'OBJ_DESCR' ).
*        CATCH cx_salv_not_found.
*      ENDTRY.
*
**   Set the HotSpot for OBJ_DESCR Column
*      TRY.
*          CALL METHOD lo_col_tab->set_cell_type
*            EXPORTING
*              value = if_salv_c_cell_type=>hotspot.
*          .
*        CATCH cx_salv_data_error .
*      ENDTRY.
*
*
*      lo_col = lo_cols_tab->get_column( 'COUNTER' ).
*      lo_col->set_technical( 'X' ).
*
*      lo_col = lo_cols_tab->get_column( 'OBJECT_ID' ).
*      lo_col->set_technical( 'X' ).
*
*      lo_col = lo_cols_tab->get_column( 'DOC_ID' ).
*      lo_col->set_technical( 'X' ).
*
*      lo_col = lo_cols_tab->get_column( 'DOC_SIZE' ).
*      lo_col->SET_SHORT_TEXT( 'Size').
*      lo_col->SET_medium_TEXT( 'Doc. Size').
*      lo_col->SET_long_TEXT( 'Document Size').
*
*      lo_settings = o_grid->get_display_settings( ).
*      lo_settings->set_striped_pattern( 'X' ).
*      l_title = 'Attachment List'(001).
*      lo_settings->set_list_header( l_title ).
*
*      lo_fcodes = o_grid->get_functions( ).
** Add the refresh function
*    TRY.
*      data: l_text type string,
*            l_icon type string.
*        l_text = text-b01.
*        l_icon = icon_refresh.
*        lo_fcodes->add_function(
*          name     = 'REFRESH'
*          icon     = l_icon
*          text     = l_text
*          tooltip  = l_text
*          position = if_salv_c_function_position=>right_of_salv_functions ).
*      CATCH cx_salv_wrong_call cx_salv_existing.
*    ENDTRY.
*      lo_fcodes->set_all( 'X' ).
*
*      o_grid->display( ).
*    CATCH cx_salv_msg .
*
*  ENDTRY.
*
endmethod.


method EXCLUDED_BUTTONS.

 DATA: l_button TYPE LINE OF ui_functions.

*  l_button = cl_gui_alv_grid=>mc_fc_loc_copy_row.
*  INSERT l_button INTO TABLE excluded_buttons.
**  l_button = cl_gui_alv_grid=>mc_fc_detail.
**  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_graph.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_copy.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_cut.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_paste.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_append_row.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_sum.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_subtot.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_views.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_auf.
*  INSERT l_button INTO TABLE excluded_buttons.
**  l_button = cl_gui_alv_grid=>mc_fc_variant_admin.
**  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_loc_undo.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_maximum.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_minimum.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_pc_file.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_print.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_print_back.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_print_prev.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_mb_variant.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_mb_subtot.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_mb_sum.
*  INSERT l_button INTO TABLE excluded_buttons.
**  l_button = cl_gui_alv_grid=>mc_fc_load_variant.
**  INSERT l_button INTO TABLE excluded_buttons.
**  l_button = cl_gui_alv_grid=>mc_fc_data_save.
**  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_average.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_abc.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_chain.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_crbatch.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_crweb.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_lineitems.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_master_data.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_more.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_report.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_xint.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_call_xxl.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_data_save.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_delete_filter.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_expcrdata.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_expcrdesig.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_expcrtempl.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_expmdb.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_extend.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_info.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_html.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_to_office.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_to_rep_tree.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_send.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>mc_fc_word_processor.
*  INSERT l_button INTO TABLE excluded_buttons.
*
*  l_button = cl_gui_alv_grid=>MC_FC_LOC_INSERT_ROW.
*  INSERT l_button INTO TABLE excluded_buttons.
*  l_button = cl_gui_alv_grid=>MC_FC_LOC_DELETE_ROW.
*  INSERT l_button INTO TABLE excluded_buttons.

endmethod.


method GET_ATTACHMENTS.
    content[] = attachments[].
endmethod.


  METHOD handle_hotspot_click.

    data: l_alv_attachment  TYPE LINE OF zbt_bug_attachment_alv_tbl
          .
    DATA: lt_sood4 type TABLE OF SOOD4 INITIAL SIZE 0.
    DATA: ls_sood4 type SOOD4.

    READ TABLE attachments into l_alv_attachment INDEX e_row_id .
    if sy-subrc is initial.
      move l_alv_attachment-doc_id+0(3) to ls_sood4-FOLTP.
      move l_alv_attachment-doc_id+3(2) to ls_sood4-FOLYR.
      move l_alv_attachment-doc_id+5(12) to ls_sood4-FOLNO.
      move l_alv_attachment-doc_id+17(3) to ls_sood4-OBJTP.
      move l_alv_attachment-doc_id+20(2) to ls_sood4-OBJYR.
      move l_alv_attachment-doc_id+22(12) to ls_sood4-OBJNO.

      append ls_sood4 to lt_sood4.

      CALL FUNCTION 'SO_DOCUMENTS_MANAGER'
        EXPORTING
          activity  = 'DISP'
        TABLES
          documents = lt_sood4.

      clear: lt_sood4, ls_sood4,l_alv_attachment .
      REFRESH: lt_sood4.
    endif.




  ENDMETHOD.


method HANDLE_TOOLBAR.

  DATA: ls_toolbar TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 3 TO ls_toolbar-butn_type.
  APPEND ls_toolbar TO e_object->mt_toolbar.
  clear ls_toolbar.
  MOVE 'REFRESH' TO ls_toolbar-function.
  MOVE 0 TO ls_toolbar-butn_type.
  MOVE icon_refresh TO ls_toolbar-icon.
  MOVE 'Refresh'(B01) TO ls_toolbar-quickinfo.
  MOVE 'Refresh'(B01) TO ls_toolbar-text.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.


endmethod.


method RETRIEVE_ATTACHMENTS.


  data: lt_SRGBTBREL type TABLE OF SRGBTBREL,
        l_SRGBTBREL like line of lt_SRGBTBREL,
        lt_alv_attachment type TABLE OF zbt_bug_attachment_alv_tbl,
        l_alv_attachment  TYPE LINE OF zbt_bug_attachment_alv_tbl ,
        lv_bug_i type ZBT_ID_BUG_I,
        wa_DOCUMENT_DATA  type SOFOLENTI1,
        l_DOCUMENT_ID type  sofolenti1-doc_id.

  CONSTANTS: c_TYPEID_A  type SIBFTYPEID VALUE 'ZBUG_TRACK'.
  clear attachments.

  lv_bug_i = o_bug->get_id_i( ).

  select * from SRGBTBREL into CORRESPONDING FIELDS OF TABLE lt_SRGBTBREL
    where instid_a =   lv_bug_i and  TYPEID_A = c_TYPEID_A.

  loop at   lt_SRGBTBREL into l_SRGBTBREL.

    move l_SRGBTBREL-instid_b to l_DOCUMENT_ID.


    CALL FUNCTION 'SO_DOCUMENT_READ_API1'
      EXPORTING
        DOCUMENT_ID   = l_DOCUMENT_ID
*       FILTER        = 'X'
      IMPORTING
        DOCUMENT_DATA = wa_document_data.


    MOVE-CORRESPONDING  wa_document_data to l_alv_attachment.
    move l_DOCUMENT_ID to l_alv_attachment-doc_id.
    append l_alv_attachment to attachments.

    clear: l_alv_attachment, l_DOCUMENT_ID .

  endloop.




endmethod.


method SET_TITLE.
  o_grid->set_gridtitle( title ).
endmethod.


method USER_COMMAND.

  if e_ucomm = 'REFRESH' .

    retrieve_attachments( ).
    CALL METHOD o_grid->REFRESH_TABLE_DISPLAY( ).

  endif.

endmethod.
ENDCLASS.
