CLASS zcl_tr_bug_ctrl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_TR_BUG_CTRL
*"* do not include other source files here!!!

    METHODS constructor
      IMPORTING
        !tr TYPE REF TO zcl_transport
        !container TYPE REF TO cl_gui_container .
    METHODS ask_4_bugid .
    METHODS save_data
      RAISING
        zcx_transport_alv_ctrl_exc .
  PROTECTED SECTION.
*"* protected components of class ZCL_TR_BUG_CTRL
*"* do not include other source files here!!!

    METHODS excluded_buttons
      RETURNING
        value(excluded_buttons) TYPE ui_functions .
  PRIVATE SECTION.
*"* private components of class ZCL_TR_BUG_CTRL
*"* do not include other source files here!!!

    DATA o_grid TYPE REF TO cl_gui_alv_grid .
    DATA o_container TYPE REF TO cl_gui_container .
    DATA o_tr TYPE REF TO zcl_transport .
    DATA gt_bugs TYPE zbt_ask4_bugid_alv_tbl .

    METHODS get_tr_bugs .
    METHODS validate_data
      RAISING
        zcx_transport_alv_ctrl_exc .
    METHODS set_tr_bugs .
ENDCLASS.



CLASS ZCL_TR_BUG_CTRL IMPLEMENTATION.


  METHOD ask_4_bugid.
    FIELD-SYMBOLS: <l_field>  TYPE LINE OF lvc_t_fcat.

    DATA: l_f4                TYPE lvc_s_f4,
          lt_excluded_buttons TYPE ui_functions,
          lt_f4               TYPE lvc_t_f4,
          lt_fieldcatalog     TYPE lvc_t_fcat,
          lo_grid_app         TYPE REF TO alv_grid_app,
          l_layout            TYPE lvc_s_layo.

    CREATE OBJECT o_grid
      EXPORTING
        i_parent = o_container.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZBT_ASK4_BUGID_ALV_STR'
      CHANGING
        ct_fieldcat      = lt_fieldcatalog[].

    LOOP AT lt_fieldcatalog ASSIGNING <l_field>.
      CASE <l_field>-fieldname.
        WHEN 'PRODUCTOID' OR 'BUGID'.
          <l_field>-edit       = 'X'.
          <l_field>-f4availabl = 'X'.

          l_f4-fieldname  = <l_field>-fieldname.
          l_f4-getbefore  = 'X'.
          l_f4-chngeafter = 'X'.
          INSERT l_f4 INTO TABLE lt_f4.

        WHEN OTHERS.
          <l_field>-edit = space.
      ENDCASE.
*      <l_field>-col_opt = 'X'.
    ENDLOOP.

    lt_excluded_buttons = excluded_buttons( ).

    CALL METHOD o_grid->set_table_for_first_display
      EXPORTING
        i_structure_name     = 'ZBT_ASK4_BUGID_ALV_STR'
        is_layout            = l_layout
        it_toolbar_excluding = lt_excluded_buttons
      CHANGING
        it_fieldcatalog      = lt_fieldcatalog[]
        it_outtab            = gt_bugs[].

    o_grid->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
    CREATE OBJECT lo_grid_app.
    SET HANDLER lo_grid_app->on_data_changed FOR o_grid.

    CALL METHOD o_grid->register_f4_for_fields
      EXPORTING
        it_f4 = lt_f4.
  ENDMETHOD.                    "ask_4_bugid


  METHOD constructor.

    me->o_tr = tr.
    me->o_container = container.

    get_tr_bugs( ).

  ENDMETHOD.                    "constructor


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




  ENDMETHOD.                    "excluded_buttons


  METHOD get_tr_bugs.
    DATA: lt_result   TYPE zbt_bugs,
          lo_producto TYPE REF TO zcl_producto,
          l_result    TYPE LINE OF zbt_bugs,
          l_bug       TYPE zbt_ask4_bugid_alv_str.

    CLEAR gt_bugs[].
    IF o_tr IS BOUND.
      lt_result = o_tr->get_bugs( ).

      LOOP AT lt_result INTO l_result.
        l_bug-productoid  = l_result-producto_id.
        lo_producto       = l_result-oref->get_producto( ).
        l_bug-producto    = lo_producto->get_descripcion( ).
        l_bug-bugid       = l_result-bug_id.
        l_bug-resumen     = l_result-oref->get_resumen( ).
        INSERT l_bug INTO TABLE gt_bugs[].
      ENDLOOP.
    ENDIF.
  ENDMETHOD.                    "get_tr_bugs


  METHOD save_data.
    DATA: lo_exception TYPE REF TO zcx_bugtracker_system.

    validate_data( ).

    TRY .
        set_tr_bugs( ).

        IF zcl_transport_controller=>exist( me->o_tr ) IS INITIAL.
          zcl_transport_controller=>create( me->o_tr ).
        ELSE.
          zcl_transport_controller=>update( me->o_tr ).
        ENDIF.
*       Update SAP TR attributes
        zcl_transport_controller=>update_tr_attributes( me->o_tr ).
      CATCH zcx_bugtracker_system INTO lo_exception.
        RAISE EXCEPTION TYPE zcx_transport_alv_ctrl_exc
          EXPORTING
            previous  = lo_exception
            transport = me->o_tr.
    ENDTRY.


  ENDMETHOD.                    "save_data


  METHOD set_tr_bugs.
    DATA: l_bug       TYPE LINE OF zbt_ask4_bugid_alv_tbl,
          lt_bugs     TYPE zbt_bugs,
          l_str_bug   TYPE LINE OF zbt_bugs,
          lo_bug      TYPE REF TO zcl_bug,
          lo_producto TYPE REF TO zcl_producto.

    lt_bugs[] = o_tr->get_bugs( ).

    LOOP AT me->gt_bugs INTO l_bug.
      TRY.
          lo_producto = zcl_producto_controller=>find_by_key( l_bug-productoid ).
          lo_bug      = zcl_bug_controller=>find_by_key( id       = l_bug-bugid
                                                         producto = lo_producto ).
          READ TABLE lt_bugs WITH KEY producto_id = l_bug-productoid
                                      bug_id      = l_bug-bugid
                                      TRANSPORTING NO FIELDS.
          IF NOT sy-subrc IS INITIAL.
            o_tr->add_bug( lo_bug ).
          ENDIF.
        CATCH zcx_not_found_exception.

      ENDTRY.
    ENDLOOP.

    LOOP AT lt_bugs INTO l_str_bug.
      READ TABLE gt_bugs WITH KEY productoid = l_str_bug-producto_id
                              bugid          = l_str_bug-bug_id
                              TRANSPORTING NO FIELDS.
      IF NOT sy-subrc IS INITIAL.
        o_tr->remove_bug( l_str_bug-oref ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.                    "set_tr_bugs


  METHOD validate_data.

    o_grid->check_changed_data( ).

    IF me->gt_bugs[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_transport_alv_ctrl_exc
        EXPORTING
          textid    = zcx_transport_alv_ctrl_exc=>bugs_are_mandatory
          transport = me->o_tr.
    ENDIF.

  ENDMETHOD.                    "validate_data
ENDCLASS.
