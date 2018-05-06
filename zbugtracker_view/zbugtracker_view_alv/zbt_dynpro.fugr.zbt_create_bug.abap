FUNCTION zbt_create_bug.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(SCREEN_ATTRIBUTES) TYPE  ZBT_SCREEN_POPUP OPTIONAL
*"  EXPORTING
*"     REFERENCE(BUG) TYPE REF TO  ZCL_BUG
*"----------------------------------------------------------------------
  DATA: lo_bug    TYPE REF TO zcl_bug.

  PERFORM progress USING 0 'Rendering data...'(007).

  CREATE OBJECT go_handler.

  PERFORM create_initial_bug CHANGING lo_bug.
  g_oldhash = lo_bug->get_hash( ).
  PERFORM set_create_mode.

  PERFORM object_to_structures USING lo_bug.

  CALL SCREEN 0001 STARTING AT screen_attributes-top
                             screen_attributes-left
                 ENDING AT   screen_attributes-bottom
                             screen_attributes-rigth.

  zcl_bug_controller=>unlock( lo_bug ).

* Free global data
  PERFORM free_global_data.

ENDFUNCTION.
