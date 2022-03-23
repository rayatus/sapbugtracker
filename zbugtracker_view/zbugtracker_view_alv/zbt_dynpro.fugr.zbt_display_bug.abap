FUNCTION zbt_display_bug.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(BUG) TYPE REF TO  ZCL_BUG
*"     REFERENCE(DISPLAY_MODE) TYPE  FLAG OPTIONAL
*"----------------------------------------------------------------------

  PERFORM progress USING 0 'Rendering data...'(007).

  CREATE OBJECT go_handler.
  PERFORM set_display_mode USING display_mode.

  PERFORM object_to_structures USING bug.
  go_old_bug = bug.

  zcl_bug_controller=>lock( bug ).

  CALL SCREEN '0001'.

  zcl_bug_controller=>unlock( bug ).

* Free global data
  PERFORM free_global_data.

ENDFUNCTION.
