FUNCTION-POOL zbt_tr_bug_group.             "MESSAGE-ID ..

* INCLUDE LZBT_TR_BUG_GROUPD...              " Local class definition

DATA: gv_screen_attributes TYPE zbt_screen_attributes,
      gv_continue          TYPE flag,
      go_trbug_ctrl        TYPE REF TO zcl_tr_bug_ctrl,
      go_tr                TYPE REF TO zcl_transport,
      gv_tr_str            TYPE ZBT_TRANSPORT_STR,
      go_custom_container  TYPE REF TO cl_gui_custom_container.
