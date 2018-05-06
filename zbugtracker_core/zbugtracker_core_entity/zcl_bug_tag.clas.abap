class ZCL_BUG_TAG definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_BUG_TAG
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !TAG_ID type ZBT_ID_TAG
      !TAG_VALUE type ZBT_TAG_VALUE optional .
  methods GET_BUG
    returning
      value(BUG) type ref to ZCL_BUG .
  methods GET_ID
    returning
      value(TAG_ID) type ZBT_ID_TAG .
  methods GET_VALUE
    returning
      value(TAG_VALUE) type ZBT_TAG_VALUE .
  methods SET_VALUE
    importing
      !TAG_VALUE type ZBT_TAG_VALUE .
  methods GET_DESCRIPTION
    returning
      value(DESCRIPTION) type ZBT_TAG_TEXT .
protected section.
*"* protected components of class ZCL_BUG_TAG
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_BUG_TAG
*"* do not include other source files here!!!

  data BUG type ref to ZCL_BUG .
  data TAG type ZBT_ID_TAG .
  data TAGVAL type ZBT_TAG_VALUE .
  data TAGTEXT type ZBT_TAG_TEXT .
ENDCLASS.



CLASS ZCL_BUG_TAG IMPLEMENTATION.


METHOD constructor.
  DATA: o_producto    TYPE REF TO zcl_producto,
        l_producto_id TYPE zbt_id_producto.

  super->constructor( ).
  me->bug = bug.
  me->tag = tag_id.
  set_value( tag_value ).

  o_producto = bug->get_producto( ).
  l_producto_id = o_producto->get_id( ).

  SELECT SINGLE vtext FROM zbt_productotagt
  INTO tagtext
  WHERE spras    = sy-langu
    AND producto = l_producto_id
    AND tag      = tag_id.


ENDMETHOD.


method GET_BUG.
  bug = me->bug.
endmethod.


method GET_DESCRIPTION.
  description = tagtext.
endmethod.


method GET_ID.
  tag_id = tag.
endmethod.


METHOD get_value.
  tag_value = tagval.
ENDMETHOD.


METHOD prepare_hash_structure.
  DATA: value   TYPE LINE OF zbt_objectvalue_hash_calcul,
        bug_id  TYPE zbt_bug-bug.

  bug_id = bug->get_id( ).
  CONCATENATE bug_id tag tagval INTO value.
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_VALUE.
  tagval = tag_value.
endmethod.
ENDCLASS.
