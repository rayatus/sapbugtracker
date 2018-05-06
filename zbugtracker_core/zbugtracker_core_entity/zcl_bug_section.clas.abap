class ZCL_BUG_SECTION definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_BUGSECCION-SECCION
      !BUG type ref to ZCL_BUG
      !COMMENT type ref to ZCL_COMMENT optional .
  methods GET_BUG
    returning
      value(RETURN) type ref to ZCL_BUG .
  methods GET_ID
    returning
      value(RETURN) type ZBT_BUGSECCION-SECCION .
  methods GET_COMMENT
    returning
      value(RETURN) type ref to ZCL_COMMENT .
  methods SET_COMMENT
    importing
      !COMMENT type ref to ZCL_COMMENT .
protected section.
*"* protected components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

  data BUG type ref to ZCL_BUG .
  data ID type ZBT_BUGSECCION-SECCION .
  data COMMENT type ref to ZCL_COMMENT .
ENDCLASS.



CLASS ZCL_BUG_SECTION IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->id      = id.
  me->bug     = bug.
  me->comment = comment.
endmethod.


method GET_BUG.
  RETURN = me->bug.

endmethod.


method GET_COMMENT.
  return = comment.
endmethod.


method GET_ID.
  return = id.
endmethod.


METHOD prepare_hash_structure.
  DATA: str       TYPE zbt_bugseccion,
        hash      TYPE hash160,
        o_comment TYPE REF TO zcl_comment,
        value     TYPE LINE OF zbt_objectvalue_hash_calcul,
        i         TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.

  CALL METHOD zcl_bugsection_controller=>entity_to_structure
    EXPORTING
      entity    = me
    RECEIVING
      structure = str.

  DO.
    ADD 1 TO i.
    ASSIGN COMPONENT i OF STRUCTURE str TO <field>.
    IF sy-subrc IS INITIAL.
      value = <field>.
      SHIFT value LEFT DELETING LEADING space.
      INSERT value INTO TABLE values[].
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.

  o_comment = get_comment( ).
  hash = o_comment->get_hash( ).
  value = hash.
  SHIFT  value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_COMMENT.
  me->comment = comment.
endmethod.
ENDCLASS.
