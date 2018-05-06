class ZCL_TRANSPORT definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_TRANSPORT
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !ID type ZBT_TRANSPORTER-TRANSPORTREQ .
  methods GET_ID
    returning
      value(RETURN) type ZBT_TRANSPORTER-TRANSPORTREQ .
  methods GET_BUGS
    returning
      value(RETURN) type ZBT_BUGS .
  methods GET_PROGRAMAS
    returning
      value(RETURN) type ZBT_PROGRAMAS .
  methods ADD_BUG
    importing
      !BUG type ref to ZCL_BUG optional .
  methods REMOVE_BUG
    importing
      !BUG type ref to ZCL_BUG .
protected section.
*"* protected components of class ZCL_TRANSPORT
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_TRANSPORT
*"* do not include other source files here!!!

  data ID type ZBT_TRANSPORTER-TRANSPORTREQ .
  data PROGRAMAS type ZBT_PROGRAMAS .
  data BUGS type ZBT_BUGS .
ENDCLASS.



CLASS ZCL_TRANSPORT IMPLEMENTATION.


METHOD add_bug.
  DATA: lv_str      TYPE zbt_bugs_str,
        lo_producto TYPE REF TO zcl_producto.

  lo_producto = bug->get_producto( ).
  lv_str-producto_id = lo_producto->get_id( ).
  lv_str-bug_id = bug->get_id( ).
  lv_str-oref = bug.

  READ TABLE bugs WITH KEY producto_id = lv_str-producto_id
                           bug_id      = lv_str-bug_id
                           TRANSPORTING NO FIELDS.
  IF NOT sy-subrc IS INITIAL.
    INSERT lv_str INTO TABLE bugs.
  ENDIF.

ENDMETHOD.


method CONSTRUCTOR.
  super->constructor( ).
  me->id = id.
endmethod.


method GET_BUGS.
  RETURN = bugs.
endmethod.


method GET_ID.
  RETURN = id.
endmethod.


method GET_PROGRAMAS.
  RETURN = programas.
endmethod.


METHOD prepare_hash_structure.
  DATA: value TYPE LINE OF zbt_objectvalue_hash_calcul,
        id    TYPE zbt_transporter-transportreq.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].
ENDMETHOD.


METHOD remove_bug.
  DATA: lv_str      TYPE zbt_bugs_str,
        lo_producto TYPE REF TO zcl_producto.

  lo_producto = bug->get_producto( ).
  lv_str-producto_id = lo_producto->get_id( ).
  lv_str-bug_id = bug->get_id( ).

  DELETE bugs WHERE producto_id = lv_str-producto_id
                AND bug_id      = lv_str-bug_id.

ENDMETHOD.
ENDCLASS.
