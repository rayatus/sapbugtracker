class ZCL_ATTACHEMENT definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_ATTACHEMENT
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_ATTACHMENT-ATTATCHMENT
      !BUG type ref to ZCL_BUG
      !COMMENT type ref to ZCL_COMMENT optional
      !NAME type ZBT_ATTACHMENT-NAME optional .
  methods GET_BUG
    returning
      value(RETURN) type ref to ZCL_BUG .
  methods GET_ID
    returning
      value(RETURN) type ZBT_ATTACHMENT-ATTATCHMENT .
  methods GET_COMMENT
    returning
      value(RETURN) type ref to ZCL_COMMENT .
  methods SET_COMMENT
    importing
      !COMMENT type ref to ZCL_COMMENT .
  methods GET_NAME
    returning
      value(RETURN) type ZBT_ATTACHMENT-NAME .
  methods SET_NAME
    importing
      !NAME type ZBT_ATTACHMENT-NAME .
protected section.
*"* protected components of class ZCL_ATTACHEMENT
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_ATTACHEMENT
*"* do not include other source files here!!!

  data ID type ZBT_ATTACHMENT-ATTATCHMENT .
  data COMMENT type ref to ZCL_COMMENT .
  data BUG type ref to ZCL_BUG .
  data NAME type ZBT_ATTACHMENT-NAME .
ENDCLASS.



CLASS ZCL_ATTACHEMENT IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->id = id.
  me->bug = bug.
  set_comment( comment ).
  set_name( name ).
endmethod.


method GET_BUG.
  RETURN = bug.
endmethod.


method GET_COMMENT.
  RETURN = comment.
endmethod.


method GET_ID.
  RETURN = id.
endmethod.


method GET_NAME.
  RETURN = name.
endmethod.


METHOD prepare_hash_structure.
  DATA: value TYPE LINE OF zbt_objectvalue_hash_calcul,
        id    TYPE ZBT_ATTACHMENT-ATTATCHMENT.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_COMMENT.
  me->comment = comment.
endmethod.


method SET_NAME.
  me->name = name.
endmethod.
ENDCLASS.
