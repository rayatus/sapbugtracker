class ZCL_IM_BUGTRACKER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_IM_BUGTRACKER
*"* do not include other source files here!!!

  interfaces IF_EX_CTS_REQUEST_CHECK .
protected section.
*"* protected components of class ZCL_IM_BUGTRACKER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_IM_BUGTRACKER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_IM_BUGTRACKER IMPLEMENTATION.


method IF_EX_CTS_REQUEST_CHECK~CHECK_BEFORE_ADD_OBJECTS.
endmethod.


method IF_EX_CTS_REQUEST_CHECK~CHECK_BEFORE_CHANGING_OWNER.
endmethod.


method IF_EX_CTS_REQUEST_CHECK~CHECK_BEFORE_CREATION.
endmethod.


METHOD if_ex_cts_request_check~check_before_release.
  DATA: l_is_mandatory      TYPE zbt_trreleased_bugid,
        l_screen_attributes TYPE zbt_screen_attributes,
        l_cancel            TYPE flag,
        o_popup             TYPE REF TO zcl_tr_bug_ctrl,
        o_tr                TYPE REF TO zcl_transport,
        o_container         TYPE REF TO cl_gui_dialogbox_container.


  l_is_mandatory = zcl_system_config=>is_bugid_mandatory_tr_released( ).

  IF l_is_mandatory = '1' or l_is_mandatory = '2'.

    l_screen_attributes-top    = 1.
    l_screen_attributes-left   = 1.
    l_screen_attributes-bottom = 13.
    l_screen_attributes-rigth  = 100.
    l_screen_attributes-title  = 'SAPBugTracker: Link Bug to Transport Request.'(t10).

    IF type = 'K' OR type = 'W'. "For customizing and WB Requests
      IF NOT dialog IS INITIAL.
        TRY.
            CALL FUNCTION 'ZBT_ASK4_BUGID'
              EXPORTING
                trkorr            = request
                screen_attributes = l_screen_attributes
              IMPORTING
                canceled_by_user  = l_cancel.
            IF NOT l_cancel IS INITIAL AND l_is_mandatory = '1'.
              MESSAGE 'Action canceled by user.'(002) TYPE 'E' RAISING cancel.
            ENDIF.
          CATCH zcx_not_found_exception .
            MESSAGE 'Transport Request does not exist.'(003) TYPE 'E' RAISING cancel.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


  method IF_EX_CTS_REQUEST_CHECK~CHECK_BEFORE_RELEASE_SLIN.
  endmethod.
ENDCLASS.
