class ZCL_WRKLOG_CONCEPT_CONTROLLER definition
  public
  create private .

public section.
*"* public components of class ZCL_WRKLOG_CONCEPT_CONTROLLER
*"* do not include other source files here!!!

  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_WORKCONCEPT-WKCONCEPTID
    returning
      value(WRKLOG_CONCEPT) type ref to ZCL_WRKLOG_CONCEPT
    raising
      ZCX_NOT_FOUND_EXCEPTION .
protected section.
*"* protected components of class ZCL_WRKLOG_CONCEPT_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_WRKLOG_CONCEPT_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_WRKLOG_CONCEPT_CONTROLLER IMPLEMENTATION.


METHOD find_by_key.
  DATA: l_wkconceptid TYPE zbt_workconcept-wkconceptid.

  SELECT SINGLE wkconceptid INTO l_wkconceptid
    FROM       zbt_workconcept
    WHERE wkconceptid = id.

  IF NOT sy-subrc IS INITIAL.
    RAISE EXCEPTION TYPE zcx_not_found_exception
      EXPORTING
        textid = zcx_not_found_exception=>zcx_not_found_exception.
  ENDIF.

  CREATE OBJECT wrklog_concept
    EXPORTING
      id = l_wkconceptid.

ENDMETHOD.
ENDCLASS.
