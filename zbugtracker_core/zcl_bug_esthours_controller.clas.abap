class ZCL_BUG_ESTHOURS_CONTROLLER definition
  public
  create private .

public section.
*"* public components of class ZCL_BUG_ESTHOURS_CONTROLLER
*"* do not include other source files here!!!
  type-pools ABAP .

  class-methods ENTITY_TO_PERSIST
    importing
      !ENTITY type ref to ZCL_BUG_ESTHOURS
    exporting
      !PERSIST type ref to ZCL_BUG_ESTHOURS_PERSIST .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_BUG_ESTHOURS
    returning
      value(STRUCTURE) type ZBT_BUG_ESTHOURS .
  class-methods EXISTS
    importing
      !ESTHOURS type ref to ZCL_BUG_ESTHOURS
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !BUG type ref to ZCL_BUG
      !WRKLOG_CONCEPT type ref to ZCL_WRKLOG_CONCEPT
    returning
      value(RETURN) type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUG_ESTHOURS_PERSIST
    preferred parameter PERSIST
    returning
      value(ENTITY) type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods STRUCTURE_TO_ENTITY
    importing
      !STRUCTURE type ZBT_BUG_ESTHOURS
    preferred parameter STRUCTURE
    returning
      value(ENTITY) type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_ALL_BUG_ESTHOURS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_BUGESTHOURS .
  class-methods CREATE
    importing
      !ESTHOURS type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods UPDATE
    importing
      !ESTHOURS type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_UPDATE_EXCEPTION .
  class-methods DELETE
    importing
      !ESTHOURS type ref to ZCL_BUG_ESTHOURS
    raising
      ZCX_DELETE_EXCEPTION .
  class-methods PERSIST_TO_STRUCTURE
    importing
      !PERSIST type ref to ZCL_BUG_ESTHOURS_PERSIST
    returning
      value(STRUCTURE) type ZBT_BUG_ESTHOURS .
protected section.
*"* protected components of class ZCL_BUG_ESTHOURS_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_ESTHOURS_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BUG_ESTHOURS_CONTROLLER IMPLEMENTATION.


METHOD CREATE.

  DATA:   lo_exception   TYPE REF TO cx_root,
          lo_transaccion TYPE REF TO zcl_transaction_service,
          lo_persist     TYPE REF TO zcl_bug_esthours_persist,
          l_str          TYPE zbt_bug_esthours.

  TRY .
      l_str = entity_to_structure( esthours ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_persist = zca_bug_esthours_persist=>agent->create_persistent( i_bug            = l_str-bug
                                                                      i_producto        = l_str-producto
                                                                      i_wrklog_concept  = l_str-wrklog_concept  ).
      lo_persist->set_esthours( l_str-esthours ).

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
          l_str          TYPE zbt_bug_esthours.

  TRY .
      l_str = entity_to_structure( esthours ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      zca_bug_esthours_persist=>agent->delete_persistent( i_bug             = l_str-bug
                                                          i_producto        = l_str-producto
                                                          i_wrklog_concept  = l_str-wrklog_concept  ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_delete_exception
        EXPORTING
          textid   = zcx_delete_exception=>zcx_delete_exception
          previous = lo_exception.
  ENDTRY.
ENDMETHOD.


METHOD ENTITY_TO_PERSIST.
  DATA: l_str TYPE zbt_bug_esthours.

  l_str   = entity_to_structure( entity ).
  persist = zca_bug_esthours_persist=>agent->get_persistent(  i_bug             = l_str-bug
                                                              i_producto        = l_str-producto
                                                              i_wrklog_concept  = l_str-WRKLOG_CONCEPT ).
  persist->set_esthours( l_str-esthours ).

ENDMETHOD.


METHOD ENTITY_TO_STRUCTURE.

  DATA: lo_bug            TYPE REF TO zcl_bug,
        lo_user           TYPE REF TO zcl_usuario,
        lo_producto       TYPE REF TO zcl_producto,
        lo_wrklog_concept TYPE REF TO zcl_wrklog_concept.


  lo_bug            = entity->get_bug( ).
  lo_producto       = lo_bug->get_producto( ).
  lo_wrklog_concept = entity->get_worklog_concept( ).

  structure-producto       = lo_producto->get_id( ).
  structure-bug            = lo_bug->get_id( ).
  structure-WRKLOG_CONCEPT = lo_wrklog_concept->get_id( ).
  structure-esthours       = entity->get_esthours( ).


ENDMETHOD.


METHOD EXISTS.
  DATA: lo_bug            TYPE REF TO zcl_bug,
        lo_wrklog_concept type REF TO zcl_wrklog_concept.
  TRY.
      lo_bug             = esthours->get_bug( ).
      lo_wrklog_concept  = esthours->get_worklog_concept( ).

      zcl_bug_esthours_controller=>find_by_key(
          bug             = lo_bug
          wrklog_concept = lo_wrklog_concept
             ).
      return = abap_true.
    CATCH zcx_not_found_exception .
      return = abap_false.
  ENDTRY.


ENDMETHOD.


METHOD find_all_bug_esthours.
  DATA:  lo_qm                  TYPE REF TO if_os_query_manager,
         lo_q                   TYPE REF TO if_os_query,
         lo_producto            TYPE REF TO zcl_producto,
         lt_queryresult         TYPE osreftab,
         lo_persist             TYPE REF TO zcl_bug_esthours_persist,
         l_result               LIKE LINE OF result.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_result-bug_id      = bug->get_id( ).
  lo_producto          = bug->get_producto( ).
  l_result-producto_id = lo_producto->get_id( ).

* Prepare Query
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_queryresult[] = zca_bug_esthours_persist=>agent->if_os_ca_persistency~get_persistent_by_query( i_query   = lo_q
                                                                                                    i_par1    = l_result-producto_id
                                                                                                    i_par2    = l_result-bug_id ).
  LOOP AT lt_queryresult ASSIGNING <osref>.
    lo_persist ?= <osref>.

    l_result-wrklog_concept_id = lo_persist->get_wrklog_concept( ).
    l_result-oref = persist_to_entity( persist = lo_persist ).

    INSERT l_result INTO TABLE result[].
  ENDLOOP.

ENDMETHOD.


METHOD find_by_key.

  DATA:   lo_esthours_agent    TYPE REF TO zca_bug_esthours_persist,
          lo_esthours_persist  TYPE REF TO zcl_bug_esthours_persist,
          lo_exception         TYPE REF TO cx_root,
          lo_producto          TYPE REF TO zcl_producto,
          l_id_producto        TYPE zbt_producto-producto,
          l_id_bug             TYPE zbt_bug-bug,
          l_id_wrklog_concept  TYPE zbt_bug_esthours-wrklog_concept.


  l_id_bug            = bug->get_id( ).
  lo_producto         = bug->get_producto( ).
  l_id_producto       = lo_producto->get_id( ).
  l_id_wrklog_concept = wrklog_concept->get_id( ).

  TRY.
      lo_esthours_agent = zca_bug_esthours_persist=>agent.
      CALL METHOD lo_esthours_agent->get_persistent
        EXPORTING
          i_producto       = l_id_producto
          i_bug            = l_id_bug
          i_wrklog_concept = l_id_wrklog_concept
        RECEIVING
          result           = lo_esthours_persist.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Persist to Entity
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      return = persist_to_entity( lo_esthours_persist ).

    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.


ENDMETHOD.


METHOD PERSIST_TO_ENTITY.
  DATA: l_str TYPE zbt_bug_esthours.

  l_str  = persist_to_structure( persist ).
  entity = structure_to_entity( l_str ).

ENDMETHOD.


METHOD PERSIST_TO_STRUCTURE.

  structure-bug            = persist->get_bug( ).
  structure-producto       = persist->get_producto( ).
  structure-wrklog_concept = persist->get_wrklog_concept( ).
  structure-esthours       = persist->get_esthours( ).

ENDMETHOD.


METHOD structure_to_entity.

  DATA: lo_bug            TYPE REF TO zcl_bug,
        lo_user           TYPE REF TO zcl_usuario,
        lo_producto       TYPE REF TO zcl_producto,
        lo_wrklog_concept TYPE REF TO zcl_wrklog_concept.


  lo_producto = zcl_producto_controller=>find_by_key( id = structure-producto ).

  lo_bug      = zcl_bug_controller=>find_by_key( id       = structure-bug
                                                 producto = lo_producto ).

  lo_wrklog_concept = zcl_wrklog_concept_controller=>find_by_key( id = structure-wrklog_concept ).

  CREATE OBJECT entity
    EXPORTING
      bug            = lo_bug
      wrklog_concept = lo_wrklog_concept
      esthours       = structure-esthours.

ENDMETHOD.


METHOD UPDATE.
  DATA: lo_exception   TYPE REF TO cx_root,
        lo_transaccion TYPE REF TO zcl_transaction_service.

  TRY .

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      entity_to_persist( esthours ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_update_exception=>zcx_update_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.
ENDCLASS.
