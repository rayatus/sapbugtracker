*&---------------------------------------------------------------------*
*& Report  ZBUGTRACKER02
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbugtracker02.

DATA: display_mode TYPE flag,
      o_bug        TYPE REF TO zcl_bug,
      o_prod       TYPE REF TO zcl_producto.


INITIALIZATION.
  CASE sy-tcode.
    WHEN 'ZBUGTRACKER02'.
      SET TITLEBAR 'T001' WITH text-001.
      display_mode = space.
    WHEN OTHERS.
      SET TITLEBAR 'T001' WITH text-002.
      display_mode = 'X'.
  ENDCASE.

  SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME.
  PARAMETERS: p_prod TYPE zbt_bug-producto OBLIGATORY MEMORY ID zbt_product_id,
              p_bug  TYPE zbt_bug-bug OBLIGATORY MEMORY ID zbt_bug_id.
  SELECTION-SCREEN END OF BLOCK a.


AT SELECTION-SCREEN ON p_prod.
  TRY .
      o_prod = zcl_producto_controller=>find_by_key( p_prod ).

    CATCH zcx_not_found_exception.
      MESSAGE e001(zbugtracker_msg) WITH p_prod.
  ENDTRY.

AT SELECTION-SCREEN ON BLOCK a.


  TRY .
      o_bug = zcl_bug_controller=>find_by_key(
          id       = p_bug
          producto = o_prod
        ).
    CATCH zcx_not_found_exception.
      MESSAGE e002(zbugtracker_msg) WITH p_bug.
  ENDTRY.

START-OF-SELECTION.



END-OF-SELECTION.

  CALL FUNCTION 'ZBT_DISPLAY_BUG'
    EXPORTING
      bug          = o_bug
      display_mode = display_mode.
