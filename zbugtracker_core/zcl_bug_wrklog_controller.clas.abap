class ZCL_BUG_WRKLOG_CONTROLLER definition
  public
  create private .

public section.
*"* public components of class ZCL_BUG_WRKLOG_CONTROLLER
*"* do not include other source files here!!!
  type-pools ABAP .

  class-methods ENTITY_TO_PERSIST
    importing
      !ENTITY type ref to ZCL_WRKLOG
    exporting
      !PERSIST type ref to ZCL_BUG_WRKLOG_PERSIST .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_WRKLOG
    returning
      value(STRUCTURE) type ZBT_BUG_WRKLOG .
  class-methods EXISTS
    importing
      !WRKLOG type ref to ZCL_WRKLOG
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !BUG type ref to ZCL_BUG
      !ID type ZBT_BUG_WRKLOG-WRKLOG_ID
    returning
      value(RETURN) type ref to ZCL_WRKLOG
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUG_WRKLOG_PERSIST
    preferred parameter PERSIST
    returning
      value(ENTITY) type ref to ZCL_WRKLOG .
  class-methods STRUCTURE_TO_ENTITY
    importing
      !STRUCTURE type ZBT_BUG_WRKLOG
    exporting
      !ENTITY type ref to ZCL_WRKLOG .
  class-methods FIND_ALL_BUG_WRKLOG
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_BUGWRKLOGS .
  class-methods CREATE
    importing
      !WRKLOG type ref to ZCL_WRKLOG
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods UPDATE
    importing
      !WRKLOG type ref to ZCL_WRKLOG
    raising
      ZCX_UPDATE_EXCEPTION .
  class-methods DELETE
    importing
      !WRKLOG type ref to ZCL_WRKLOG
    raising
      ZCX_DELETE_EXCEPTION .
protected section.
*"* protected components of class ZCL_BUG_WRKLOG_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_WRKLOG_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BUG_WRKLOG_CONTROLLER IMPLEMENTATION.


METHOD create.

  DATA:   lo_exception   TYPE REF TO cx_root,
          lo_transaccion TYPE REF TO zcl_transaction_service,
          lo_persist     TYPE REF TO zcl_bug_wrklog_persist,
          l_str          TYPE zbt_bug_wrklog.

  TRY .
      l_str = entity_to_structure( wrklog ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_persist = zca_bug_wrklog_persist=>agent->create_persistent( i_bug        = l_str-bug
                                                                     i_producto   = l_str-producto
                                                                     i_wrklog_id  = l_str-wrklog_id  ).
      lo_persist->set_erdat( l_str-erdat ).
      lo_persist->set_texto( l_str-texto ).
      lo_persist->set_usuario( l_str-usuario ).
      lo_persist->set_wrklog_concept( l_str-wrklog_concept ).

      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_create_exception=>zcx_create_exception
          previous = lo_exception.
  ENDTRY.
ENDMETHOD.


METHOD delete.

  DATA:   lo_exception   TYPE REF TO cx_root,
          lo_transaccion TYPE REF TO zcl_transaction_service,
          l_str          TYPE zbt_bug_wrklog.

  TRY .
      l_str = entity_to_structure( wrklog ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      zca_bug_wrklog_persist=>agent->delete_persistent( i_bug        = l_str-bug
                                                        i_producto   = l_str-producto
                                                        i_wrklog_id  = l_str-wrklog_id  ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_delete_exception
        EXPORTING
          textid   = zcx_delete_exception=>zcx_delete_exception
          previous = lo_exception.
  ENDTRY.
ENDMETHOD.


METHOD entity_to_persist.
  DATA: l_str TYPE zbt_bug_wrklog.

  l_str = entity_to_structure( entity ).
  persist = zca_bug_wrklog_persist=>agent->get_persistent(  i_bug        = l_str-bug
                                                            i_producto   = l_str-producto
                                                            i_wrklog_id  = l_str-wrklog_id  ).

  persist->set_erdat( l_str-erdat ).
  persist->set_texto( l_str-texto ).
  persist->set_usuario( l_str-usuario ).
  persist->set_wrklog_concept( l_str-wrklog_concept ).

ENDMETHOD.


METHOD entity_to_structure.

  DATA: lo_bug            TYPE REF TO zcl_bug,
        lo_user           TYPE REF TO zcl_usuario,
        lo_producto       TYPE REF TO zcl_producto,
        lo_wrklog_concept TYPE REF TO zcl_wrklog_concept.


  lo_bug            = entity->get_bug( ).
  lo_producto       = lo_bug->get_producto( ).
  lo_user           = entity->get_usuario( ).
  lo_wrklog_concept = entity->get_wrklog_concept( ).

  structure-producto       = lo_producto->get_id( ).
  structure-bug            = lo_bug->get_id( ).
  structure-usuario        = lo_user->get_id( ).
  structure-WRKLOG_ID      = entity->get_id( ).
  structure-WRKLOG_CONCEPT = lo_wrklog_concept->get_id( ).
  structure-texto          = entity->get_texto(  ).
  structure-erdat          = entity->get_erdat(  ).


ENDMETHOD.


METHOD exists.
  DATA: lo_producto TYPE REF TO zcl_producto,
        lo_bug      TYPE REF TO zcl_bug,
        l_id        TYPE zbt_bug_wrklog-wrklog_id.

  TRY.
      lo_bug      = wrklog->get_bug( ).
      l_id        = wrklog->get_id( ).

      zcl_bug_wrklog_controller=>find_by_key(
          bug      = lo_bug
          id       = l_id
             ).
      return = abap_true.
    CATCH zcx_not_found_exception .
      return = abap_false.
  ENDTRY.


ENDMETHOD.


METHOD find_all_bug_wrklog.
  DATA:  lo_qm                  TYPE REF TO if_os_query_manager,
         lo_q                   TYPE REF TO if_os_query,
         lo_producto            TYPE REF TO zcl_producto,
         lt_queryresult         TYPE osreftab,
         l_erdat                TYPE zbt_erdat,
         l_texto                TYPE zbt_texto_largo,
         l_user                 TYPE xubname,
         lo_persist             TYPE REF TO zcl_bug_wrklog_persist,
         lo_user                TYPE REF TO zcl_usuario,
         l_result               LIKE LINE OF result.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_result-bug_id      = bug->get_id( ).
  lo_producto          = bug->get_producto( ).
  l_result-producto_id = lo_producto->get_id( ).

* Prepare Query
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_queryresult[] = zca_bug_wrklog_persist=>agent->if_os_ca_persistency~get_persistent_by_query( i_query   = lo_q
                                                                                                  i_par1    = l_result-producto_id
                                                                                                  i_par2    = l_result-bug_id ).
  LOOP AT lt_queryresult ASSIGNING <osref>.
    lo_persist         ?= <osref>.
    l_result-wrklog_id = lo_persist->get_wrklog_id( ).
    l_erdat            = lo_persist->get_erdat( ).
    l_texto            = lo_persist->get_texto( ).
    l_user             = lo_persist->get_usuario( ).

    CREATE OBJECT l_result-oref
      EXPORTING
        bug   = bug
        id    = l_result-wrklog_id
        erdat = l_erdat.

    IF NOT l_user IS INITIAL.
      TRY.
          lo_user = zcl_usuario_controller=>find_by_key( id = l_user  ).
          l_result-oref->set_usuario( lo_user ).
        CATCH zcx_not_found_exception .
      ENDTRY.
    ENDIF.

    l_result-oref->set_texto( l_texto ).

    INSERT l_result INTO TABLE result[].
  ENDLOOP.

ENDMETHOD.


METHOD find_by_key.

  DATA:   lo_wrklog_agent    TYPE REF TO zca_bug_wrklog_persist,
          lo_wrklog_persist  TYPE REF TO zcl_bug_wrklog_persist,
          lo_exception       TYPE REF TO cx_root,
          lo_producto        TYPE REF TO zcl_producto,
          l_id_producto      TYPE zbt_producto-producto,
          l_id_bug           TYPE zbt_bug-bug.


  l_id_bug      = bug->get_id( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

  TRY.
      lo_wrklog_agent = zca_bug_wrklog_persist=>agent.
      CALL METHOD lo_wrklog_agent->get_persistent
        EXPORTING
          i_producto  = l_id_producto
          i_bug       = l_id_bug
          i_wrklog_id = id
        RECEIVING
          result      = lo_wrklog_persist.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Persist to Entity
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      return = persist_to_entity( lo_wrklog_persist ).

    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.


ENDMETHOD.


METHOD persist_to_entity.
  DATA: l_id                TYPE zbt_bug_wrklog-wrklog_id,
        l_id_bug            TYPE zbt_id_bug,
        l_id_producto       TYPE zbt_id_producto,
        l_id_user           TYPE xubname,
        l_id_wrklog_concept TYPE ZBT_WORKLOG_CONCEPT_ID,
        l_texto             TYPE ZBT_TEXTO_LARGO,
        l_erdat             TYPE zbt_bug_wrklog-erdat,
        lo_user             TYPE REF TO zcl_usuario,
        lo_bug              TYPE REF TO zcl_bug,
        lo_producto         TYPE REF TO zcl_producto,
        lo_wrklog_concept   TYPE REF TO zcl_wrklog_concept.

  l_id                = persist->get_wrklog_id( ).
  l_id_bug            = persist->get_bug( ).
  l_id_producto       = persist->get_producto( ).
  l_erdat             = persist->get_erdat( ).
  l_id_user           = persist->get_usuario( ).
  l_id_wrklog_concept = persist->get_wrklog_concept( ).
  l_texto             = persist->get_texto( ).

  lo_producto = zcl_producto_controller=>find_by_key( id  = l_id_producto ).

  lo_bug      = zcl_bug_controller=>find_by_key( id       = l_id_bug
                                                 producto = lo_producto  ).

  lo_user     = zcl_usuario_controller=>find_by_key( id = l_id_user ).

  lo_wrklog_concept = zcl_wrklog_concept_controller=>find_by_key( id = l_id_wrklog_concept ).

  CREATE OBJECT entity
    EXPORTING
      bug   = lo_bug
      id    = l_id
      erdat = l_erdat.

  entity->set_usuario( lo_user ).
  entity->set_texto( l_texto ).
  entity->set_wrklog_concept( lo_wrklog_concept ).

ENDMETHOD.


METHOD structure_to_entity.

  DATA: lo_bug            TYPE REF TO zcl_bug,
        lo_user           TYPE REF TO zcl_usuario,
        lo_producto       TYPE REF TO zcl_producto,
        lo_wrklog_concept TYPE REF TO zcl_wrklog_concept.


  lo_producto = zcl_producto_controller=>find_by_key( id = structure-producto ).

  lo_bug      = zcl_bug_controller=>find_by_key( id       = structure-bug
                                                 producto = lo_producto ).

  lo_user     = zcl_usuario_controller=>find_by_key( id = structure-usuario ).

  lo_wrklog_concept = zcl_wrklog_concept_controller=>find_by_key( id = structure-wrklog_concept ).

  CREATE OBJECT entity
    EXPORTING
      bug   = lo_bug
      id    = structure-wrklog_id
      erdat = structure-erdat.

  entity->set_texto( structure-texto ).
  entity->set_usuario( lo_user ).
  entity->set_wrklog_concept( lo_wrklog_concept ).

ENDMETHOD.


METHOD update.
  DATA: lo_exception   TYPE REF TO cx_root,
        lo_transaccion TYPE REF TO zcl_transaction_service.

  TRY .

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      entity_to_persist( wrklog ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_update_exception=>zcx_update_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.
ENDCLASS.
