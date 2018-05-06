class ZCL_BUGSTYPE definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_BUGSTYPE
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUGTYPE type ref to ZCL_BUGTYPE
      !ID type ZBT_BUG_STYPE-SUBTYPE
      !SPRAS type SPRAS default SY-LANGU
      !ICON type ZBT_BUGSTYPE_ICON .
  methods GET_ID
    returning
      value(RETURN) type ZBT_BUG_STYPE-SUBTYPE .
  methods GET_DESCRIPCION
    returning
      value(RETURN) type ZBT_STYPE_TXT-DESCRIPCION .
  methods GET_BUGTYPE
    returning
      value(RETURN) type ref to ZCL_BUGTYPE .
  methods GET_ICON
    returning
      value(RETURN) type ZBT_BUGSTYPE_ICON .
protected section.
*"* protected components of class ZCL_BUGSTYPE
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_BUGSTYPE
*"* do not include other source files here!!!

  data ID type ZBT_BUG_STYPE-SUBTYPE .
  data DESCRIPCION type ZBT_STYPE_TXT-DESCRIPCION .
  data BUGTYPE type ref to ZCL_BUGTYPE .
  data ICON type ZBT_BUGSTYPE_ICON .
ENDCLASS.



CLASS ZCL_BUGSTYPE IMPLEMENTATION.


METHOD constructor.
  DATA: l_id TYPE zbt_bug_type-bugtype.

  super->constructor( ).
  me->id = id.
  me->bugtype = bugtype.
  me->icon = icon.
  l_id = bugtype->get_id( ).

  SELECT SINGLE descripcion INTO descripcion FROM zbt_stype_txt
  WHERE spras = spras
    AND bugtype  = l_id
    AND bugstype = id.
ENDMETHOD.


METHOD get_bugtype.
  return = bugtype.
ENDMETHOD.


METHOD get_descripcion.
return = descripcion.
ENDMETHOD.


METHOD get_icon.
  return = icon.
ENDMETHOD.


method GET_ID.
  return = id.
endmethod.


method PREPARE_HASH_STRUCTURE.
data: value TYPE LINE OF zbt_objectvalue_hash_calcul,
      id    TYPE ZBT_BUG_STYPE-SUBTYPE.

      value = id = get_id( ).
      SHIFT value LEFT DELETING LEADING space.
      INSERT value INTO TABLE values[].
endmethod.
ENDCLASS.
