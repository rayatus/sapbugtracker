FUNCTION zbt_ask4_bugid .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TRKORR) TYPE  TRKORR
*"     REFERENCE(SCREEN_ATTRIBUTES) TYPE  ZBT_SCREEN_ATTRIBUTES
*"       OPTIONAL
*"  EXPORTING
*"     VALUE(CANCELED_BY_USER) TYPE  FLAG
*"  RAISING
*"      ZCX_NOT_FOUND_EXCEPTION
*"----------------------------------------------------------------------

  PERFORM initialize.

  gv_screen_attributes = screen_attributes.
  IF gv_screen_attributes-title IS INITIAL.
    gv_screen_attributes-title = 'SAPBugTracker: Select a Bug Id at least'(001).
  ENDIF.

  TRY .
      go_tr = zcl_transport_controller=>find_by_key( trkorr ).
    CATCH zcx_not_found_exception.
*     If nothing is found in SAPBugTracker DataBase...
      SELECT SINGLE trkorr INTO trkorr FROM e070 WHERE trkorr = trkorr.
      IF sy-subrc IS INITIAL.
*       Create temporal Transport request
        CREATE OBJECT go_tr
          EXPORTING
            id = trkorr.
      ELSE.
*       Transport request doesn't exist
        RAISE EXCEPTION TYPE zcx_not_found_exception
          EXPORTING
            textid = zcx_not_found_exception=>zcx_not_found_exception.
      ENDIF.
  ENDTRY.

  gv_tr_str-transport_id = go_tr->get_id( ).
  gv_tr_str-oref         = go_tr.

  CALL SCREEN 0001 STARTING AT gv_screen_attributes-left
                               gv_screen_attributes-top
                   ENDING AT   gv_screen_attributes-rigth
                               gv_screen_attributes-bottom.
  IF gv_continue IS INITIAL.
    canceled_by_user = 'X'.
  ENDIF.

ENDFUNCTION.
