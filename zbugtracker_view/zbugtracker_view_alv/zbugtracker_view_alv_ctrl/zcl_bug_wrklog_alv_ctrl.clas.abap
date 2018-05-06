class ZCL_BUG_WRKLOG_ALV_CTRL definition
  public
  final
  create public .

public section.
  type-pools ABAP .

*"* public components of class ZCL_BUG_WRKLOG_ALV_CTRL
*"* do not include other source files here!!!
  methods REFRESH .
  methods SET_DISPLAY_MODE
    importing
      !DISPLAY type FLAG default ABAP_TRUE .
  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !CONTAINER type ref to CL_GUI_CONTAINER .
protected section.
*"* protected components of class ZCL_BUG_WRKLOG_ALV_CTRL
*"* do not include other source files here!!!
PRIVATE SECTION.
*"* private components of class ZCL_BUG_WRKLOG_ALV_CTRL
*"* do not include other source files here!!!

  TYPES:
    BEGIN OF mtype_alv_wrklog,
          wrklog_id       TYPE zbt_bug_wrklog-wrklog_id,
          wrklog_concept  TYPE zbt_bug_wrklog-wrklog_concept,
          wkconceptidtxt  TYPE zbt_workconceptt-wkconceptidtxt,
          usuario         TYPE zbt_bug_wrklog-usuario,
          fullname        TYPE ad_namtext,
          texto           TYPE zbt_bug_wrklog-texto,
          erdat           TYPE zbt_bug_wrklog-erdat,
          hours           TYPE zbt_bug_wrklog-wrkhours,
         END   OF mtype_alv_wrklog .
  TYPES mtype_alv_wrklog_tbl TYPE STANDARD TABLE OF mtype_alv_wrklog.

  TYPE-POOLS abap .
  DATA display_mode TYPE flag VALUE abap_false.           "#EC NOTEXT .
  DATA edit_mode TYPE int4 VALUE 1.                       "#EC NOTEXT .
  DATA o_bug TYPE REF TO zcl_bug .
  DATA o_container TYPE REF TO cl_gui_container .
  DATA o_grid TYPE REF TO cl_gui_alv_grid .
  DATA alv_wrklogs TYPE c .
ENDCLASS.



CLASS ZCL_BUG_WRKLOG_ALV_CTRL IMPLEMENTATION.


METHOD constructor.
  o_bug       = bug.
  o_container = container.
ENDMETHOD.


method REFRESH.

endmethod.


METHOD set_display_mode.
  DATA: l_edit_mode TYPE int4.

  IF display IS INITIAL.
    l_edit_mode = 1.
  ELSE.
    l_edit_mode = 0.
  ENDIF.

  IF l_edit_mode <> me->edit_mode.
    me->edit_mode = l_edit_mode.
    IF o_grid IS BOUND.
      o_grid->set_ready_for_input( me->edit_mode ).
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
