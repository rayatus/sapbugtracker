class ZCL_COMPONENTE definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_COMPONENTE
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
      !COMPONENTE type ZBT_COMPONT-COMPONENTE .
  methods GET_PRODUCTO
    returning
      value(RETURN) type ref to ZCL_PRODUCTO .
  methods GET_ID
    returning
      value(RETURN) type ZBT_COMPONT-COMPONENTE .
  methods GET_DESCRIPCION
    importing
      !SPRAS type ZBT_COMPONT_TXT-SPRAS default SY-LANGU
    preferred parameter SPRAS
    returning
      value(RETURN) type ZBT_COMPONT_TXT-DESCRIPCION .
protected section.
*"* protected components of class ZCL_COMPONENTE
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_COMPONENTE
*"* do not include other source files here!!!

  data PRODUCTO type ref to ZCL_PRODUCTO .
  data ID type ZBT_COMPONT-COMPONENTE .
ENDCLASS.



CLASS ZCL_COMPONENTE IMPLEMENTATION.


method CONSTRUCTOR.
  super->constructor( ).
  me->producto = producto.
  me->id       = componente.
endmethod.


METHOD get_descripcion.
  DATA: l_producto_id TYPE zbt_producto-producto.

  l_producto_id = producto->get_id( ).
  SELECT SINGLE descripcion INTO return FROM zbt_compont_txt
    WHERE spras = spras
      AND producto = l_producto_id
      AND componente = id.

ENDMETHOD.


method GET_ID.
  return = id.
endmethod.


method GET_PRODUCTO.
  return = me->producto.
endmethod.


METHOD prepare_hash_structure.

  DATA:  str   TYPE zbt_compont_txt,
         value TYPE LINE OF zbt_objectvalue_hash_calcul,
         i     TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.

  CALL METHOD zcl_componente_controller=>entity_to_structure
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
ENDCLASS.
