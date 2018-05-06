class ZCL_ATTACHEMENT_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_ATTACHEMENT_CONTROLLER
*"* do not include other source files here!!!
public section.

  class-methods CREATE
    importing
      !ATTACHEMENT type ref to ZCL_ATTACHEMENT
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods FIND_ALL_BUG_ATTACHEMENTS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_ATTACHEMENTS .
  class-methods UPDATE
    importing
      !ATTACHEMENT type ref to ZCL_ATTACHEMENT
    raising
      ZCX_UPDATE_EXCEPTION .
  class-methods DELETE
    importing
      !ATTACHEMENT type ref to ZCL_ATTACHEMENT
    raising
      ZCX_DELETE_EXCEPTION .
protected section.
*"* protected components of class ZCL_ATTACHEMENT_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ATTACHEMENT_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ATTACHEMENT_CONTROLLER IMPLEMENTATION.


METHOD create.
* TODO
  DATA: lo_transaccion TYPE REF TO zcl_transaction_service.

  CREATE OBJECT lo_transaccion.
  lo_transaccion->start( ).

  lo_transaccion->end( ).

ENDMETHOD.


method DELETE.
endmethod.


method FIND_ALL_BUG_ATTACHEMENTS.

  DATA:    lo_qm                   TYPE REF TO if_os_query_manager,
           lo_q                    TYPE REF TO if_os_query,
           lo_producto             TYPE REF TO zcl_producto,
           lo_attachement          TYPE REF TO zcl_attachement,
           l_id_producto           TYPE zbt_producto-producto,
           l_id_bug                TYPE zbt_id_bug,
           l_id_attachement        TYPE zbt_attatchment,
           lt_attachement_persist  TYPE osreftab,
           lo_attachement_persist  TYPE REF TO zcl_attachement_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_id_bug      = bug->get_id( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

* Montamos una query para obtener las secciones de un bug
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_attachement_persist[] = zca_attachement_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_id_producto
                 i_par2    = l_id_bug ).
  LOOP AT lt_attachement_persist ASSIGNING <osref>.
    lo_attachement_persist ?= <osref>.
    l_id_attachement = lo_attachement_persist->get_attatchment( ).
    CREATE OBJECT lo_attachement
      EXPORTING
        bug = bug
        id  = l_id_attachement.
    INSERT lo_attachement INTO TABLE result[].
  ENDLOOP.

endmethod.


METHOD update.
* TODO
  DATA: lo_transaccion TYPE REF TO zcl_transaction_service.

  CREATE OBJECT lo_transaccion.
  lo_transaccion->start( ).

  lo_transaccion->end( ).
ENDMETHOD.
ENDCLASS.
