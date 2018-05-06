class ZCL_WRKLOG_CONCEPT definition
  public
  inheriting from ZCL_ENTITY
  create public .

public section.
*"* public components of class ZCL_WRKLOG_CONCEPT
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_WORKCONCEPT-WKCONCEPTID .
  methods GET_TEXT
    returning
      value(TEXT) type ZBT_WORKLOG_CONCEPT_TEXT .
  methods GET_ID
    returning
      value(ID) type ZBT_WORKCONCEPT-WKCONCEPTID .
protected section.
*"* protected components of class ZCL_WRKLOG_CONCEPT
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_WRKLOG_CONCEPT
*"* do not include other source files here!!!

  data ID type ZBT_WORKCONCEPT-WKCONCEPTID .
ENDCLASS.



CLASS ZCL_WRKLOG_CONCEPT IMPLEMENTATION.


METHOD constructor.
  super->constructor( ).
  me->id = id.
ENDMETHOD.


method GET_ID.
  id = me->id.
endmethod.


METHOD get_text.

  SELECT SINGLE wkconceptidtxt INTO text
      FROM  ZBT_WORKCONCEPTt
      WHERE wkconceptid = me->id
        AND spras = sy-langu.

ENDMETHOD.


method PREPARE_HASH_STRUCTURE.

* ToDo

endmethod.
ENDCLASS.
