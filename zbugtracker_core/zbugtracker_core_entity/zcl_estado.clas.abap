class ZCL_ESTADO definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_ESTADO
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_ESTADO-ESTADO .
  methods GET_DESCRIPCION
    returning
      value(RETURN) type ZBT_ESTADO_TXT-DESCRIPCION .
  methods GET_ID
    returning
      value(RETURN) type ZBT_ESTADO-ESTADO .
  methods GET_NEXT_ESTADOS
    returning
      value(RETURN) type ZBT_ESTADOS .
  methods GET_TYPE
    returning
      value(RETURN) type ZBT_TYPESTATUS .
  methods SET_DESCRIPCION
    importing
      !DESCRIPCION type ZBT_ESTADO_TXT-DESCRIPCION .
  methods SET_NEXT_ESTADOS
    importing
      !NEXT_ESTADOS type ZBT_ESTADOS .
  methods SET_TYPE
    importing
      !TYPE type ZBT_TYPESTATUS .
  methods SET_PREV_ESTADOS
    importing
      !PREV_ESTADOS type ZBT_ESTADOS .
  methods GET_PREV_ESTADOS
    returning
      value(RETURN) type ZBT_ESTADOS .
  methods GET_ICON
    returning
      value(ICON_ID) type ZBT_ESTADO-ICON .
  methods SET_ICON
    importing
      !ICON_ID type ZBT_ESTADO-ICON .
  methods GET_WDAICON
    returning
      value(WDAICON) type ZBT_ESTADO-WDAICON .
  methods SET_WDAICON
    importing
      !WDAICON type ZBT_ESTADO-WDAICON .
protected section.
*"* protected components of class ZCL_ESTADO
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_ESTADO
*"* do not include other source files here!!!

  data ID type ZBT_ESTADO-ESTADO .
  data NEXT_ESTADOS type ZBT_ESTADOS .
  data DESCRIPCION type ZBT_ESTADO_TXT-DESCRIPCION .
  data TYPE type ZBT_TYPESTATUS .
  data PREV_ESTADOS type ZBT_ESTADOS .
  data ICON_ID type ZBT_ESTADO-ICON .
  data WDAICON_ID type ZBT_ESTADO-WDAICON .
ENDCLASS.



CLASS ZCL_ESTADO IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->id = id.
endmethod.


method GET_DESCRIPCION.

  return = descripcion.

endmethod.


METHOD get_icon.
  icon_id = me->icon_id.
ENDMETHOD.


method GET_ID.
  return = id.
endmethod.


method GET_NEXT_ESTADOS.
  return = next_estados.
endmethod.


method GET_PREV_ESTADOS.
  return = prev_estados.
endmethod.


method GET_TYPE.
  return = type.
endmethod.


METHOD get_wdaicon.
  wdaicon = me->wdaicon_id.
ENDMETHOD.


METHOD prepare_hash_structure.
  DATA: value TYPE LINE OF zbt_objectvalue_hash_calcul,
        id    TYPE zbt_estado-estado.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_DESCRIPCION.
  me->descripcion = descripcion.
endmethod.


METHOD set_icon.
  me->icon_id = icon_id.
ENDMETHOD.


method SET_NEXT_ESTADOS.
  me->next_estados = next_estados.
endmethod.


method SET_PREV_ESTADOS.
  me->prev_estados = prev_estados.
endmethod.


method SET_TYPE.
  me->type = type.
endmethod.


METHOD set_wdaicon.
  me->wdaicon_id = wdaicon.
ENDMETHOD.
ENDCLASS.
