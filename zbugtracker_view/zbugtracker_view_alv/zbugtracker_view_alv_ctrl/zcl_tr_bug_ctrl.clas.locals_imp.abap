*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


*----------------------------------------------------------------------*
*       CLASS alv_grid_app DEFINITION
*----------------------------------------------------------------------*
* Catches ALV Events
*----------------------------------------------------------------------*
CLASS alv_grid_app DEFINITION.
  PUBLIC SECTION.
    METHODS   : on_data_changed FOR EVENT data_changed
                  OF cl_gui_alv_grid IMPORTING er_data_changed.
ENDCLASS.                    "alv_grid_app DEFINITION
*----------------------------------------------------------------------*
*       CLASS alv_grid_app IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS alv_grid_app IMPLEMENTATION.

  METHOD on_data_changed.
    DATA: ls_good       TYPE lvc_s_modi,
          lo_producto   TYPE REF TO zcl_producto,
          lo_bug        TYPE REF TO zcl_bug,
          l_rowdata     TYPE zbt_ask4_bugid_alv_str.

    LOOP AT er_data_changed->mt_good_cells INTO ls_good.

      CALL METHOD er_data_changed->get_cell_value
        EXPORTING
          i_row_id    = ls_good-row_id
          i_fieldname = 'PRODUCTOID'
        IMPORTING
          e_value     = l_rowdata-productoid.

      CASE ls_good-fieldname.
        WHEN 'PRODUCTOID'.
          IF NOT l_rowdata-productoid IS INITIAL.
            lo_producto = zcl_producto_controller=>find_by_key( l_rowdata-productoid ).
            l_rowdata-producto = lo_producto->get_descripcion( ).

            CALL METHOD er_data_changed->modify_cell
              EXPORTING
                i_row_id    = ls_good-row_id
                i_fieldname = 'PRODUCTO'
                i_value     = l_rowdata-producto.
          ENDIF.

        WHEN 'BUGID'.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = l_rowdata-bugid.

          IF NOT l_rowdata-bugid IS INITIAL.

            lo_producto = zcl_producto_controller=>find_by_key( l_rowdata-productoid ).
            lo_bug = zcl_bug_controller=>find_by_key( producto = lo_producto
                                                      id       = l_rowdata-bugid ).

            l_rowdata-resumen = lo_bug->get_resumen( ).

            CALL METHOD er_data_changed->modify_cell
              EXPORTING
                i_row_id    = ls_good-row_id
                i_fieldname = 'RESUMEN'
                i_value     = l_rowdata-resumen.

          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                    "on_data_changed
ENDCLASS.                    "alv_grid_app IMPLEMENTATION
