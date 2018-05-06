class ZCL_BUG_ESTHOURS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_ESTHOURS
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !WRKLOG_CONCEPT type ref to ZCL_WRKLOG_CONCEPT
      !ESTHOURS type ZBT_HORAS_ESTIMADAS .
  methods GET_BUG
    returning
      value(BUG) type ref to ZCL_BUG .
  methods GET_WORKLOG_CONCEPT
    returning
      value(WRKLOG_CONCEPT) type ref to ZCL_WRKLOG_CONCEPT .
  methods GET_ESTHOURS
    returning
      value(ESTHOURS) type ZBT_HORAS_ESTIMADAS .
  methods SET_ESTHOURS
    importing
      !ESTHOURS type ZBT_HORAS_ESTIMADAS .
protected section.
*"* protected components of class ZCL_BUG_ESTHOURS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_ESTHOURS
*"* do not include other source files here!!!

  data BUG type ref to ZCL_BUG .
  data ESTHOURS type ZBT_HORAS_ESTIMADAS .
  data WRKLOG_CONCEPT type ref to ZCL_WRKLOG_CONCEPT .
ENDCLASS.



CLASS ZCL_BUG_ESTHOURS IMPLEMENTATION.


METHOD constructor.

  me->bug             = bug.
  me->wrklog_concept  = wrklog_concept.
  me->esthours        = esthours.

ENDMETHOD.


METHOD get_bug.
  bug = me->bug.
ENDMETHOD.


method GET_ESTHOURS.
  esthours = me->esthours.
endmethod.


method GET_WORKLOG_CONCEPT.
  wrklog_concept = me->wrklog_concept.
endmethod.


METHOD set_esthours.
  me->esthours = esthours.
ENDMETHOD.
ENDCLASS.
