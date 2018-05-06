class ZCL_BUG_TAG_CONTROLLER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_TAG_CONTROLLER
*"* do not include other source files here!!!

  class-methods EXIST
    importing
      !ENTITY type ref to ZCL_BUG_TAG
    returning
      value(EXISTS) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !BUG type ref to ZCL_BUG
      !TAG type ZBT_ID_TAG
    returning
      value(ENTITY) type ref to ZCL_BUG_TAG
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_BUG_TAGS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(TAGS) type ZBT_BUG_TAG_TBL .
  class-methods CREATE
    importing
      !TAG type ref to ZCL_BUG_TAG
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods DELETE
    importing
      !BUG_TAG type ref to ZCL_BUG_TAG
    raising
      ZCX_DELETE_EXCEPTION .
  class-methods UPDATE
    importing
      !TAG type ref to ZCL_BUG_TAG
    raising
      ZCX_UPDATE_EXCEPTION .
  class-methods EQUAL
    importing
      !TAG1 type ref to ZCL_BUG_TAG
      !TAG2 type ref to ZCL_BUG_TAG
    returning
      value(EQUAL) type FLAG .
protected section.
*"* protected components of class ZCL_BUG_TAG_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_TAG_CONTROLLER
*"* do not include other source files here!!!

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUG_TAG_PERSIST
    returning
      value(ENTITY) type ref to ZCL_BUG_TAG .
  class-methods ENTITY_TO_PERSIST
    importing
      value(ENTITY) type ref to ZCL_BUG_TAG
    changing
      value(PERSIST) type ref to ZCL_BUG_TAG_PERSIST .
ENDCLASS.



CLASS ZCL_BUG_TAG_CONTROLLER IMPLEMENTATION.


METHOD create.
  DATA: lo_bug                TYPE REF TO zcl_bug,
        lo_producto           TYPE REF TO zcl_producto,
        l_id_bug              TYPE zbt_id_bug,
        l_id_producto         TYPE zbt_producto-producto,
        l_id_tag              TYPE zbt_id_tag,
        l_tagval              TYPE zbt_tag_value,
        lo_persist            TYPE REF TO zcl_bug_tag_persist,
        lo_transaccion        TYPE REF TO zcl_transaction_service,
        lo_exception          TYPE REF TO cx_root.

  TRY .
      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_bug        = tag->get_bug( ).
      lo_producto   = lo_bug->get_producto( ).
      l_id_producto = lo_producto->get_id( ).
      l_id_bug      = lo_bug->get_id( ).
      l_id_tag      = tag->get_id( ).
      l_tagval      = tag->get_value( ).

      zca_bug_tag_persist=>agent->create_persistent(
      EXPORTING
        i_producto = l_id_producto
        i_bug      = l_id_bug
        i_tag      = l_id_tag
      RECEIVING
        result = lo_persist  ).

      lo_persist->set_tagval( l_tagval ).

      lo_transaccion->end( ).

    CATCH cx_os_object_existing INTO lo_exception.

      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_create_exception=>zcx_create_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.


METHOD delete.
  DATA: lo_bug                TYPE REF TO zcl_bug,
        lo_producto           TYPE REF TO zcl_producto,
        l_id_bug              TYPE zbt_id_bug,
        l_id_producto         TYPE zbt_producto-producto,
        l_id_tag              TYPE zbt_id_tag,
        l_tagval              TYPE zbt_tag_value,
        lo_persist            TYPE REF TO zcl_bug_tag_persist,
        lo_transaccion        TYPE REF TO zcl_transaction_service,
        lo_exception          TYPE REF TO cx_root.

  TRY .
      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_bug        = bug_tag->get_bug( ).
      lo_producto   = lo_bug->get_producto( ).

      l_id_producto = lo_producto->get_id( ).
      l_id_bug      = lo_bug->get_id( ).
      l_id_tag      = bug_tag->get_id( ).


      zca_bug_tag_persist=>agent->delete_persistent(
      EXPORTING
        i_producto = l_id_producto
        i_bug      = l_id_bug
        i_tag      = l_id_tag ).

      lo_transaccion->end( ).

    CATCH cx_os_object_not_existing INTO lo_exception.

      RAISE EXCEPTION TYPE zcx_delete_exception
        EXPORTING
          textid   = zcx_delete_exception=>zcx_delete_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.


METHOD entity_to_persist.
  DATA: l_tagval      TYPE zbt_tag_value.

  l_tagval = entity->get_value( ).

  persist->set_tagval( l_tagval ).

ENDMETHOD.


METHOD equal.

  DATA: lo_bug1  TYPE REF TO zcl_bug,
        lo_bug2  TYPE REF TO zcl_bug,
        lo_prod1 TYPE REF TO zcl_producto,
        lo_prod2 TYPE REF TO zcl_producto.

  lo_bug1  = tag1->get_bug( ).
  lo_prod1 = lo_bug1->get_producto( ).

  lo_bug2  = tag1->get_bug( ).
  lo_prod2 = lo_bug1->get_producto( ).

  IF  tag1->get_id( )     = tag2->get_id( )
  AND tag1->get_value( )  = tag2->get_value( )
  AND lo_prod1->get_id( ) = lo_prod2->get_id( )
  AND lo_bug1->get_id( )  = lo_bug2->get_id( ).
    equal = abap_true.
  ELSE.
    equal = abap_false.
  ENDIF.

ENDMETHOD.


METHOD exist.
  DATA: lo_bug TYPE REF TO zcl_bug,
        l_id_tag TYPE zbt_id_tag.

  TRY.
      lo_bug   = entity->get_bug( ).
      l_id_tag = entity->get_id( ).

      find_by_key(
        EXPORTING
          bug    =  lo_bug
          tag    =  l_id_tag ).

      exists = 'X'.
    CATCH zcx_not_found_exception .
      CLEAR exists.
  ENDTRY.


ENDMETHOD.


METHOD find_bug_tags.
  DATA:   lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          lo_producto            TYPE REF TO zcl_producto,
          l_id_producto          TYPE zbt_producto-producto,
          l_id_bug               TYPE zbt_id_bug,
          l_result               TYPE LINE OF zbt_bug_tag_tbl,
          lt_tags_persist        TYPE osreftab,
          lo_bug_tag_persist     TYPE REF TO zcl_bug_tag_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_id_bug      = bug->get_id( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

* Montamos una query para obtener los bugs anteriores al indicado
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  TRY .

      lt_tags_persist[] = zca_bug_tag_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                     i_query   = lo_q
                     i_par1    = l_id_producto
                     i_par2    = l_id_bug ).
      LOOP AT lt_tags_persist ASSIGNING <osref>.
        CLEAR l_result.

        lo_bug_tag_persist ?= <osref>.
        l_result-producto = lo_bug_tag_persist->get_bug( ).
        l_result-bug      = lo_bug_tag_persist->get_producto( ).
        l_result-tag      = lo_bug_tag_persist->get_tag( ).
        l_result-tagval   = lo_bug_tag_persist->get_tagval( ).

        CREATE OBJECT l_result-oref
          EXPORTING
            bug       = bug
            tag_id    = l_result-tag
            tag_value = l_result-tagval.

        INSERT l_result INTO TABLE tags[].
      ENDLOOP.
    CATCH cx_os_object_not_found.

  ENDTRY.
ENDMETHOD.


METHOD find_by_key.

  DATA: lo_agent        TYPE REF TO zca_bug_tag_persist,
        lo_persist      TYPE REF TO zcl_bug_tag_persist,
        lo_exception    TYPE REF TO cx_root,
        lo_producto     TYPE REF TO zcl_producto,
        l_id_producto   TYPE zbt_id_producto,
        l_id_bug        TYPE zbt_id_bug.

  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).
  l_id_bug      = bug->get_id( ).

  TRY.
*     Buscamos el objeto en la capa de persistencia
      lo_agent = zca_bug_tag_persist=>agent.
      CALL METHOD lo_agent->get_persistent
        EXPORTING
          i_producto = l_id_producto
          i_bug      = l_id_bug
          i_tag      = tag
        RECEIVING
          result     = lo_persist.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Mapeamos contra un Entity
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      entity = persist_to_entity( lo_persist ).

    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.
ENDMETHOD.


METHOD persist_to_entity.
  DATA: l_id_bug      TYPE zbt_id_bug,
        l_id_producto TYPE zbt_id_producto,
        l_id_tag      TYPE zbt_id_tag,
        l_tagval      TYPE zbt_tag_value,
        lo_producto   TYPE REF TO zcl_producto,
        lo_bug        TYPE REF TO zcl_bug.

  l_id_bug      = persist->get_bug( ).
  l_id_producto = persist->get_producto( ).
  l_id_tag      = persist->get_tag( ).
  l_tagval      = persist->get_tagval( ).

  lo_producto = zcl_producto_controller=>find_by_key( l_id_producto ).
  lo_bug      = zcl_bug_controller=>find_by_key( id = l_id_bug
                                                 producto = lo_producto ).

  CREATE OBJECT entity
    EXPORTING
      bug       = lo_bug
      tag_id    = l_id_tag
      tag_value = l_tagval.

ENDMETHOD.


METHOD update.
  DATA: lo_persist      TYPE REF TO zcl_bug_tag_persist,
        lo_transaccion  TYPE REF TO zcl_transaction_service,
        lo_exception    TYPE REF TO cx_root,
        l_id_producto   TYPE zbt_producto-producto,
        l_id_bug        TYPE zbt_bug-bug,
        l_id_tag        TYPE zbt_id_tag,
        lo_producto     TYPE REF TO zcl_producto,
        lo_bug          TYPE REF TO zcl_bug.


  l_id_tag = tag->get_id( ).
  lo_bug   = tag->get_bug( ).
  l_id_bug = lo_bug->get_id( ).
  lo_producto = lo_bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

  TRY .
*     Buscamos primero lo que hay ahora en la capa de persistencia
      lo_persist = zca_bug_tag_persist=>agent->get_persistent( i_bug      = l_id_bug
                                                               i_producto = l_id_producto
                                                               i_tag      = l_id_tag ).

    CATCH cx_os_object_not_found INTO lo_exception.
*     Para poder actualizarlo ha de existir
      RAISE EXCEPTION TYPE zcx_update_exception
        EXPORTING
          textid   = zcx_update_exception=>zcx_update_exception
          previous = lo_exception.
  ENDTRY.


  TRY.

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Mapeamos contra el objeto de persistencia
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      entity_to_persist(
        EXPORTING
          entity  = tag
        CHANGING
          persist = lo_persist ).

      lo_transaccion->end( ).
    CATCH zcx_create_exception INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_update_exception
        EXPORTING
          previous = lo_exception.

  ENDTRY.

ENDMETHOD.
ENDCLASS.
