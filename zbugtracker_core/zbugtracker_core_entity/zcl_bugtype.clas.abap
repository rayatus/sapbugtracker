class ZCL_BUGTYPE definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_BUGTYPE
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_BUG_TYPE-BUGTYPE
      !SPRAS type SPRAS default SY-LANGU .
  methods GET_ID
    returning
      value(RETURN) type ZBT_BUG_TYPE-BUGTYPE .
  methods GET_NROBJ
    returning
      value(RETURN) type ZBT_BUG_TYPE-NROBJ .
  methods GET_DESCRIPCION
    importing
      !SPRAS type SY-LANGU default SY-LANGU
    returning
      value(RETURN) type VAL_TEXT .
  methods SET_NROBJ
    importing
      !NROBJ type NROBJ .
  methods SET_DESCRIPCION
    importing
      !DESCRIPCION type VAL_TEXT .
protected section.
*"* protected components of class ZCL_BUGTYPE
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_BUGTYPE
*"* do not include other source files here!!!

  data ID type ZBT_BUG_TYPE-BUGTYPE .
  data NROBJ type ZBT_BUG_TYPE-NROBJ .
  data DESCRIPCION type ZBT_TYPE_TXT-DESCRIPCION .
ENDCLASS.



CLASS ZCL_BUGTYPE IMPLEMENTATION.


METHOD constructor.
  super->constructor( ).
  me->id = id.

  SELECT SINGLE descripcion INTO me->descripcion FROM zbt_type_txt
    WHERE bugtype = me->id
      AND spras   = spras.

ENDMETHOD.


METHOD get_descripcion.
  return = descripcion.
ENDMETHOD.


method GET_ID.
  RETURN = id.
endmethod.


method GET_NROBJ.
  return = nrobj.
endmethod.


METHOD prepare_hash_structure.
  DATA:  value TYPE LINE OF zbt_objectvalue_hash_calcul,
         id    TYPE zbt_bug_type-bugtype.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_DESCRIPCION.
  me->descripcion = descripcion.
endmethod.


method SET_NROBJ.
  me->nrobj = nrobj.
endmethod.
ENDCLASS.
