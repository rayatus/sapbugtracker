class ZCL_PROGRAM definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_PROGRAM
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !ID type ZBT_PROGRAMS-PROGRAMA .
  methods GET_BUG
    returning
      value(RETURN) type ref to ZCL_BUG .
  methods GET_ID
    returning
      value(RETURN) type ZBT_PROGRAMS-PROGRAMA .
protected section.
*"* protected components of class ZCL_PROGRAM
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_PROGRAM
*"* do not include other source files here!!!

  data ID type ZBT_PROGRAMS-PROGRAMA .
  data BUG type ref to ZCL_BUG .
ENDCLASS.



CLASS ZCL_PROGRAM IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->bug = bug.
  me->id = id.
endmethod.


method GET_BUG.
  RETURN = bug.
endmethod.


method GET_ID.
  RETURN = id.
endmethod.


method PREPARE_HASH_STRUCTURE.
  DATA: value TYPE LINE OF zbt_objectvalue_hash_calcul,
        id    TYPE ZBT_PROGRAMS-PROGRAMA.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].
endmethod.
ENDCLASS.
