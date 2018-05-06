class ZCL_PRODUCTO_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_PRODUCTO_CONTROLLER
*"* do not include other source files here!!!
public section.

  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_ID_PRODUCTO
    returning
      value(RESULT) type ref to ZCL_PRODUCTO
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_ALL_COMPONENTES
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
    returning
      value(RESULT) type ZBT_COMPONENTES .
  class-methods EXIST
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
    returning
      value(RETURN) type FLAG .
  class-methods FIND_ALL_BUGS
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
    returning
      value(RESULT) type ZBT_BUGS .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_PRODUCTO
    returning
      value(STRUCTURE) type ZBT_PRODUCTO_STRUCTURE .
  class-methods FIND_ALL_PRODUCTS
    returning
      value(RETURN) type ZBT_PRODUCTOS .
protected section.
*"* protected components of class ZCL_PRODUCTO_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_PRODUCTO_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_PRODUCTO_CONTROLLER IMPLEMENTATION.


METHOD entity_to_structure.

  structure-producto    = entity->get_id( ).
  structure-descripcion = entity->get_descripcion( ).

ENDMETHOD.


method EXIST.
  DATA: l_id TYPE zbt_id_producto.

  TRY .
      l_id = producto->get_id( ).
      zcl_producto_controller=>find_by_key( l_id ).
      return = 'X'.
    CATCH cx_root.
      return = space.
  ENDTRY.

endmethod.


METHOD find_all_bugs.
  DATA:   lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          lt_bugs_persist        TYPE osreftab,
          lo_bug_persist         TYPE REF TO zcl_bug_persist,
          l_result               TYPE LINE OF zbt_bugs.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_result-producto_id = producto->get_id( ).

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 ' ).

  lt_bugs_persist[] = zca_bug_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_result-producto_id ).
  LOOP AT lt_bugs_persist ASSIGNING <osref>.
    lo_bug_persist ?= <osref>.
    l_result-oref = zcl_bug_controller=>persist_to_entity( lo_bug_persist ).
    l_result-bug_id = l_result-oref->get_id( ).
    INSERT l_result INTO TABLE result[].
  ENDLOOP.

ENDMETHOD.


METHOD find_all_componentes.
  DATA:   lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          l_id_producto          TYPE zbt_producto-producto,
          lo_componente          TYPE REF TO zcl_componente,
          lt_componentes         TYPE zbt_componentes,
          lt_componentes_persist TYPE osreftab,
          lo_componente_persist  TYPE REF TO zcl_componente_persist,
          l_id_componente        TYPE zbt_id_componente.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_id_producto = producto->get_id( ).

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 ' ).

  TRY .
      lt_componentes_persist[] = zca_componente_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                     i_query   = lo_q
                     i_par1    = l_id_producto ).
      LOOP AT lt_componentes_persist ASSIGNING <osref>.
        lo_componente_persist ?= <osref>.
        l_id_componente = lo_componente_persist->get_componente( ).
        CREATE OBJECT lo_componente
          EXPORTING
            producto   = producto
            componente = l_id_componente.
        INSERT lo_componente INTO TABLE result[].
      ENDLOOP.
    CATCH cx_root.

  ENDTRY.
ENDMETHOD.


METHOD find_all_products.
  DATA: lo_qm                  TYPE REF TO if_os_query_manager,
        lo_q                   TYPE REF TO if_os_query,
        l_id_producto          TYPE zbt_id_producto,
        lo_producto            TYPE REF TO zcl_producto,
        lt_productos_persist   TYPE osreftab,
        lo_producto_persist    TYPE REF TO zcl_producto_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( ).

  lt_productos_persist[] = zca_producto_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q ).
  LOOP AT lt_productos_persist ASSIGNING <osref>.
    lo_producto_persist ?= <osref>.
    l_id_producto = lo_producto_persist->get_producto( ).
    lo_producto = zcl_producto_controller=>find_by_key( l_id_producto ).

    INSERT lo_producto INTO TABLE return[].
  ENDLOOP.

ENDMETHOD.


method FIND_BY_KEY.

  DATA: lo_agent               TYPE REF TO zca_producto_persist,
        lo_persist             TYPE REF TO zcl_producto_persist,
        l_usuario              TYPE xubname,
        lo_exception           TYPE REF TO cx_root,
        lt_componentes         TYPE ZBT_COMPONENTES.

  lo_agent = zca_producto_persist=>agent.
  TRY.
*     Buscamos el objeto
      lo_agent->get_persistent( i_producto = id ).

*     Mapeamos contra un entity
      CREATE OBJECT result
        EXPORTING
          id = id.

*     Buscamos todos los componentes del producto
      lt_componentes[] = find_all_componentes( result ).
      result->set_componentes( lt_componentes[] ).

    CATCH cx_os_object_not_found INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.

endmethod.
ENDCLASS.
