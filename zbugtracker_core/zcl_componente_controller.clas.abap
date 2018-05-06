class ZCL_COMPONENTE_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_COMPONENTE_CONTROLLER
*"* do not include other source files here!!!
public section.

  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_COMPONENTE
    returning
      value(STRUCTURE) type ZBT_COMPONT_TXT .
  class-methods EXIST
    importing
      !COMPONENTE type ref to ZCL_COMPONENTE
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_ID_COMPONENTE
      !PRODUCTO type ref to ZCL_PRODUCTO
    returning
      value(RESULT) type ref to ZCL_COMPONENTE
    raising
      ZCX_NOT_FOUND_EXCEPTION .
protected section.
*"* protected components of class ZCL_COMPONENTE_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_COMPONENTE_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_COMPONENTE_CONTROLLER IMPLEMENTATION.


METHOD entity_to_structure.

  structure-componente  = entity->get_id( ).
  structure-descripcion = entity->get_descripcion( ).

ENDMETHOD.


method EXIST.
  DATA: l_id        TYPE zbt_compont-componente,
        lo_producto TYPE REF TO zcl_producto.

  TRY .
      l_id        = componente->get_id( ).
      lo_producto = componente->get_producto( ).
      zcl_componente_controller=>find_by_key( id = l_id
                                              producto = lo_producto ).
      return = 'X'.
    CATCH cx_root .
      return = space.
  ENDTRY.
endmethod.


method FIND_BY_KEY.

  DATA: lo_agent        TYPE REF TO zca_componente_persist,
        lo_persist      TYPE REF TO zcl_componente_persist,
        lo_exception    TYPE REF TO cx_root,
        l_id_producto   TYPE zbt_producto-producto.

  l_id_producto = producto->get_id( ).
  lo_agent      = zca_componente_persist=>agent.
  TRY.
      CALL METHOD lo_agent->get_persistent
        EXPORTING
          i_producto   = l_id_producto
          i_componente = id
        RECEIVING
          result       = lo_persist.

*     Mapeamos contra un entity
      CREATE OBJECT result
        EXPORTING
          producto   = producto
          componente = id.

    CATCH cx_os_object_not_found INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.




endmethod.
ENDCLASS.
