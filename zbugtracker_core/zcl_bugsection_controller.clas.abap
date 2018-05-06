class ZCL_BUGSECTION_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_BUGSECTION_CONTROLLER
*"* do not include other source files here!!!
public section.

  constants BUGSECTION_PROBLEM type ZBT_BUGSECCION-SECCION value 1. "#EC NOTEXT
  constants BUGSECTION_STEPS_REPRODUCE type ZBT_BUGSECCION-SECCION value 2. "#EC NOTEXT
  constants BUGSECTION_MORE_INFO type ZBT_BUGSECCION-SECCION value 3. "#EC NOTEXT

  class-methods CREATE
    importing
      !SECTION type ref to ZCL_BUG_SECTION
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_BUG_SECTION
    returning
      value(STRUCTURE) type ZBT_BUGSECCION .
  class-methods EXIST
    importing
      !BUGSECTION type ref to ZCL_BUG_SECTION
    returning
      value(RETURN) type FLAG .
  class-methods FIND_ALL_BUG_SECTIONS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_BUGSECTIONS .
  class-methods FIND_BY_KEY
    importing
      !BUG type ref to ZCL_BUG
      !ID type ZBT_ID_SECCION
    returning
      value(RETURN) type ref to ZCL_BUG_SECTION
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods UPDATE
    importing
      !SECTION type ref to ZCL_BUG_SECTION
    raising
      ZCX_UPDATE_EXCEPTION .
  class-methods DELETE
    importing
      !BUG_SECTION type ref to ZCL_BUG_SECTION
    raising
      ZCX_DELETE_EXCEPTION .
protected section.
*"* protected components of class ZCL_BUGSECTION_CONTROLLER
*"* do not include other source files here!!!

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUGSECCION_PERSIST
      value(BUG) type ref to ZCL_BUG optional
    returning
      value(ENTITY) type ref to ZCL_BUG_SECTION
    raising
      ZCX_VALIDATE_EXCEPTION
      ZCX_NOT_FOUND_EXCEPTION .
private section.
*"* private components of class ZCL_BUGSECTION_CONTROLLER
*"* do not include other source files here!!!

  class-methods ENTITY_TO_PERSIST
    importing
      !ENTITY type ref to ZCL_BUG_SECTION
    returning
      value(PERSIST) type ref to ZCL_BUGSECCION_PERSIST .
ENDCLASS.



CLASS ZCL_BUGSECTION_CONTROLLER IMPLEMENTATION.


METHOD create.

  DATA: l_str        TYPE zbt_bugseccion,
        lo_comment   TYPE REF TO zcl_comment,
        lo_exception TYPE REF TO cx_root.

  DATA: lo_transaccion TYPE REF TO zcl_transaction_service.

  TRY .
      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_comment = section->get_comment( ).
      zcl_comment_controller=>create( lo_comment ).

      l_str = entity_to_structure( section ).

      zca_bugseccion_persist=>agent->create_persistent(
            i_bug        = l_str-bug
            i_comentario = l_str-comentario
            i_producto   = l_str-producto
            i_seccion    = l_str-seccion
          ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_create_exception=>zcx_create_exception
          previous = lo_exception.
  ENDTRY.


ENDMETHOD.


METHOD delete.
  DATA: lo_exception   TYPE REF TO cx_root,
        lo_comment     TYPE REF TO zcl_comment,
        lo_transaccion TYPE REF TO zcl_transaction_service,
        l_str          TYPE zbt_bugseccion.

  TRY .
      l_str = entity_to_structure( bug_section ).

      lo_transaccion->start( ).

      lo_comment = bug_section->get_comment( ).
      IF lo_comment IS BOUND.
        CALL METHOD zcl_comment_controller=>delete
          EXPORTING
            comment = lo_comment.
      ENDIF.

      zca_bugseccion_persist=>agent->delete_persistent(
        i_bug      = l_str-bug
        i_producto = l_str-producto
        i_seccion  = l_str-seccion
       ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_delete_exception
        EXPORTING
          textid   = zcx_delete_exception=>zcx_delete_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.


method ENTITY_TO_PERSIST.
  DATA: l_str TYPE zbt_bugseccion.

  l_str = entity_to_structure( entity ).
  persist = zca_bugseccion_persist=>agent->get_persistent(
      i_bug       = l_str-bug
      i_producto  = l_str-producto
      i_seccion   = l_str-seccion
  ).

  persist->set_comentario( l_str-comentario ).

endmethod.


method ENTITY_TO_STRUCTURE.
  DATA: lo_bug        TYPE REF TO zcl_bug,
        lo_producto   TYPE REF TO zcl_producto,
        lo_comentario TYPE REF TO zcl_comment.

  lo_bug        = entity->get_bug( ).
  lo_producto   = lo_bug->get_producto( ).
  lo_comentario = entity->get_comment( ).

  structure-bug         = lo_bug->get_id( ).
  structure-producto    = lo_producto->get_id( ).
  structure-seccion     = entity->get_id( ).
  structure-comentario  = lo_comentario->get_id( ).

endmethod.


method EXIST.
  DATA: l_id   TYPE zbt_bugseccion-seccion,
        lo_bug TYPE REF TO zcl_bug.

  TRY .
      l_id    = bugsection->get_id( ).
      lo_bug  = bugsection->get_bug( ).
      zcl_bugsection_controller=>find_by_key( id  = l_id
                                              bug = lo_bug ).
      return = 'X'.
    CATCH cx_root.
      return = space.

  ENDTRY.
endmethod.


method FIND_ALL_BUG_SECTIONS.

  DATA:    lo_qm                  TYPE REF TO if_os_query_manager,
           lo_q                   TYPE REF TO if_os_query,
           lo_producto            TYPE REF TO zcl_producto,
           lo_bugseccion          TYPE REF TO zcl_bug_section,
           lo_comment             TYPE REF TO zcl_comment,
           l_id_comment           TYPE zbt_bugcomment-comentario,
           l_result               TYPE LINE OF zbt_bugsections,
           lt_bugseccion_persist  TYPE osreftab,
           lo_bugseccion_persist  TYPE REF TO zcl_bugseccion_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_result-bug_id      = bug->get_id( ).
  lo_producto          = bug->get_producto( ).
  l_result-producto_id = lo_producto->get_id( ).

* Montamos una query para obtener las secciones de un bug
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_bugseccion_persist[] = zca_bugseccion_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_result-producto_id
                 i_par2    = l_result-bug_id ).
  LOOP AT lt_bugseccion_persist ASSIGNING <osref>.
    lo_bugseccion_persist ?= <osref>.
    l_result-seccion_id = lo_bugseccion_persist->get_seccion( ).

    CREATE OBJECT lo_bugseccion
      EXPORTING
        bug = bug
        id  = l_result-seccion_id.

    l_id_comment = lo_bugseccion_persist->get_comentario( ).
    IF NOT l_id_comment IS INITIAL.
      lo_comment = zcl_comment_controller=>find_by_key( id = l_id_comment
                                                        bug = bug ).
      lo_bugseccion->set_comment( lo_comment ).
    ENDIF.

    l_result-oref = lo_bugseccion.
    INSERT l_result INTO TABLE result[].
  ENDLOOP.

endmethod.


method FIND_BY_KEY.
  DATA: l_id_bug      TYPE zbt_id_bug,
        l_id_producto TYPE zbt_id_producto,
        lo_producto   TYPE REF TO zcl_producto,
        lo_persist    TYPE REF TO zcl_bugseccion_persist,
        lo_exception  TYPE REF TO cx_root.

  TRY .
      l_id_bug      = bug->get_id( ).

      lo_producto   = bug->get_producto( ).
      l_id_producto = lo_producto->get_id( ).

      lo_persist = zca_bugseccion_persist=>agent->get_persistent( i_bug      = l_id_bug
                                                                  i_producto = l_id_producto
                                                                  i_seccion  = id ).
      return = persist_to_entity( persist = lo_persist
                                  bug     = bug ).

    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.

endmethod.


method PERSIST_TO_ENTITY.
  DATA: l_id          TYPE zbt_id_seccion,
        l_id_producto TYPE zbt_id_producto,
        l_id_bug      TYPE zbt_id_bug,
        l_id_bug_i    type zbt_id_bug_i,
        l_id_comentario  TYPE zbt_id_comentario,
        lo_comentario TYPE REF TO zcl_comment,
        lo_producto   TYPE REF TO zcl_producto.

  l_id             = persist->get_seccion( ).
  l_id_producto    = persist->get_producto( ).
  l_id_bug         = persist->get_bug( ).
*  l_id_bug_i       = persist->get_bug_i( ).
  l_id_comentario  = persist->get_comentario( ).

  IF NOT bug IS BOUND.
    lo_producto = zcl_producto_controller=>find_by_key( l_id_producto ).

    bug = zcl_bug_controller=>find_by_key( id       = l_id_bug
*                                           id_i     = l_id_bug_i
                                           producto = lo_producto  ).
  ELSEIF l_id_bug <> bug->get_id( ).
    RAISE EXCEPTION TYPE zcx_validate_exception.
*  elseif l_id_bug_i <> bug->get_id_i( ).
*    RAISE EXCEPTION TYPE zcx_validate_exception.
  ELSE.
    lo_producto = bug->get_producto( ).
    IF lo_producto->get_id( ) <> l_id_producto.
      RAISE EXCEPTION TYPE zcx_validate_exception.
    ENDIF.
  ENDIF.

  lo_comentario = zcl_comment_controller=>find_by_key( id  = l_id_comentario
                                                       bug = bug ).

  CREATE OBJECT entity
    EXPORTING
      id      = l_id
      bug     = bug
      comment = lo_comentario.


endmethod.


METHOD update.

  DATA: lo_comment   TYPE REF TO zcl_comment,
        lo_exception TYPE REF TO cx_root,
        lo_transaccion TYPE REF TO zcl_transaction_service.

  TRY .
      lo_comment = section->get_comment( ).
      zcl_comment_controller=>update( lo_comment ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      entity_to_persist( section ).
      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE ZCX_UPDATE_EXCEPTION
        EXPORTING
          textid   = ZCX_UPDATE_EXCEPTION=>ZCX_UPDATE_EXCEPTION
          previous = lo_exception.
  ENDTRY.


ENDMETHOD.
ENDCLASS.
