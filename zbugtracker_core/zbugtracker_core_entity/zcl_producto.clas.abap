class ZCL_PRODUCTO definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_PRODUCTO
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_PRODUCTO-PRODUCTO .
  methods GET_ID
    returning
      value(RETURN) type ZBT_PRODUCTO-PRODUCTO .
  methods GET_DESCRIPCION
    importing
      !SPRAS type ZBT_PRODUCTO_TXT-SPRAS default SY-LANGU
    returning
      value(RETURN) type ZBT_PRODUCTO_TXT-DESCRIPCION .
  methods GET_COMPONENTES
    returning
      value(RETURN) type ZBT_COMPONENTES .
  methods SET_COMPONENTES
    importing
      !COMPONENTES type ZBT_COMPONENTES .
  methods GET_BUG_NUMBER_RANGE
    returning
      value(RETURN) type TNRO-OBJECT .
protected section.
*"* protected components of class ZCL_PRODUCTO
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_PRODUCTO
*"* do not include other source files here!!!

  data ID type ZBT_PRODUCTO-PRODUCTO .
  data COMPONENTES type ZBT_COMPONENTES .
  data BUG_NUMBER_RANGE type TNRO-OBJECT .
ENDCLASS.



CLASS ZCL_PRODUCTO IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->id = id.
endmethod.


method GET_BUG_NUMBER_RANGE.
  return = BUG_NUMBER_RANGE.
endmethod.


method GET_COMPONENTES.
  RETURN = componentes.
endmethod.


METHOD get_descripcion.

  SELECT SINGLE descripcion INTO return FROM zbt_producto_txt
    WHERE spras = spras
      AND producto = me->id.

ENDMETHOD.


method GET_ID.
  return = me->id.
endmethod.


METHOD prepare_hash_structure.

  DATA: str   TYPE zbt_bug,
        value TYPE LINE OF zbt_objectvalue_hash_calcul,
        i     TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.

  CALL METHOD zcl_producto_controller=>entity_to_structure
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
ENDMETHOD.


method SET_COMPONENTES.
  me->componentes = componentes.
endmethod.
ENDCLASS.
