*----------------------------------------------------------------------*
***INCLUDE LZBT_TR_BUG_GROUPF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  STATUS_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM status_0001 .

  SET PF-STATUS 'S0001'.
  SET TITLEBAR 'T0001' WITH gv_screen_attributes-title.

  PERFORM create_controls.

ENDFORM.                    " STATUS_0001
*&---------------------------------------------------------------------*
*&      Form  CREATE_CONTROLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_controls .

  IF go_custom_container IS INITIAL.

    CREATE OBJECT go_custom_container
      EXPORTING
        container_name = 'CONTAINER'.

    CREATE OBJECT go_trbug_ctrl
      EXPORTING
        tr        = go_tr
        container = go_custom_container.

    go_trbug_ctrl->ask_4_bugid( ).
  ENDIF.
ENDFORM.                    " CREATE_CONTROLS
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialize .
  FREE: go_custom_container,
        go_tr.

  CLEAR: go_custom_container,
         go_tr,
         go_trbug_ctrl,
         gv_continue,
         gv_tr_str.
ENDFORM.                    " INITIALIZE
