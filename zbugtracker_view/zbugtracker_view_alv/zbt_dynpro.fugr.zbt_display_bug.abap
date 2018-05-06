FUNCTION zbt_display_bug.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(BUG) TYPE REF TO  ZCL_BUG
*"     REFERENCE(DISPLAY_MODE) TYPE  FLAG OPTIONAL
*"     REFERENCE(SCREEN_ATTRIBUTES) TYPE  ZBT_SCREEN_POPUP OPTIONAL
*"----------------------------------------------------------------------

  PERFORM progress USING 0 'Rendering data...'(007).

  IF NOT screen_attributes IS INITIAL.
    g_do_not_show_pfstatus = abap_true.
  ENDIF.

  CREATE OBJECT go_handler.
  PERFORM set_display_mode USING display_mode.

  PERFORM object_to_structures USING bug.
  g_oldhash = bug->get_hash( ).

  zcl_bug_controller=>lock( bug ).

  CALL SCREEN 0001 STARTING AT screen_attributes-top
                             screen_attributes-left
                 ENDING AT   screen_attributes-bottom
                             screen_attributes-rigth.


  zcl_bug_controller=>unlock( bug ).

* Free global data
  PERFORM free_global_data.

ENDFUNCTION.
