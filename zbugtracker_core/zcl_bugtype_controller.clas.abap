class ZCL_BUGTYPE_CONTROLLER definition
  public
  create public .

public section.
*"* public components of class ZCL_BUGTYPE_CONTROLLER
*"* do not include other source files here!!!

  constants BUGTYPE_ENHANCEMENT type ZBT_BUG_TYPE-BUGTYPE value 2. "#EC NOTEXT
  constants BUGTYPE_ISSUE type ZBT_BUG_TYPE-BUGTYPE value 1. "#EC NOTEXT
  constants BUGTYPE_NOTE type ZBT_BUG_TYPE-BUGTYPE value 3. "#EC NOTEXT

  class-methods EXIST
    importing
      !BUGTYPE type ref to ZCL_BUGTYPE
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_ID_BUGTYPE
    returning
      value(BUGTYPE) type ref to ZCL_BUGTYPE
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_ALL_BUGTYPES
    returning
      value(RETURN) type ZBT_BUGTYPES .
  class-methods FIND_ALL_BUG_SUBTYPES
    importing
      !BUGTYPE type ref to ZCL_BUGTYPE
    returning
      value(RETURN) type ZBT_BUGSTYPES .
protected section.
*"* protected components of class ZCL_BUGTYPE_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUGTYPE_CONTROLLER
*"* do not include other source files here!!!

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUGTYPE_PERSIST
    returning
      value(ENTITY) type ref to ZCL_BUGTYPE .
ENDCLASS.



CLASS ZCL_BUGTYPE_CONTROLLER IMPLEMENTATION.


method EXIST.
  DATA: l_id TYPE zbt_bug_type-bugtype.


  TRY .
      l_id = bugtype->get_id( ).
      zcl_bugtype_controller=>find_by_key( l_id ).
      return = 'X'.
    CATCH cx_root.
      return = space.

  ENDTRY.
endmethod.


METHOD find_all_bugtypes.
  DATA: lo_qm                  TYPE REF TO if_os_query_manager,
        lo_q                   TYPE REF TO if_os_query,
        l_id_bugtype           TYPE zbt_id_bugtype,
        lo_bugtype             TYPE REF TO zcl_bugtype,
        lt_bugtypes_persist    TYPE osreftab,
        lo_bugtype_persist     TYPE REF TO zcl_bugtype_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( ).

  lt_bugtypes_persist[] = zca_bugtype_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q ).
  LOOP AT lt_bugtypes_persist ASSIGNING <osref>.
    lo_bugtype_persist ?= <osref>.
    l_id_bugtype = lo_bugtype_persist->GET_BUGTYPE( ).
    CREATE OBJECT lo_bugtype
      EXPORTING
        id = l_id_bugtype.
    INSERT lo_bugtype INTO TABLE return[].
  ENDLOOP.

ENDMETHOD.


METHOD find_all_bug_subtypes.
  DATA: lo_qm                     TYPE REF TO if_os_query_manager,
        lo_q                      TYPE REF TO if_os_query,
        l_id_subtype              TYPE zbt_bugstype,
        l_id_type                 TYPE zbt_id_bugtype,
        lo_bug_subtype            TYPE REF TO zcl_bugstype,
        lt_subtipos_persist       TYPE osreftab,
        lo_exception              TYPE REF TO cx_root,
        lo_bug_subtype_persist    TYPE REF TO zcl_bug_subtype_persist,
        lt_subtypes               TYPE zbt_bugstypes,
        l_subtype                 TYPE LINE OF zbt_bugstypes,
        lo_bugtype                TYPE REF TO zcl_bugtype.

  FIELD-SYMBOLS: <osref> TYPE osref.

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'TYPE = PAR1 ' ).

  l_id_type = bugtype->get_id( ).

  TRY .
*      lt_subtipos_persist[] = zca_bug_subtype_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
*                     i_query   = lo_q
*                     i_par1    = l_id_type ).
*      LOOP AT lt_subtipos_persist ASSIGNING <osref>.
*        lo_bug_subtype_persist  ?= <osref>.
*
*        lo_bug_subtype = zcl_bug_subtype_controller=>persist_to_entity( persistent = lo_bug_subtype_persist ).
*
*        INSERT lo_bug_subtype INTO TABLE return[].
*      ENDLOOP.

      lt_subtypes = zcl_bug_subtype_controller=>find_all_subtypes( ).
      LOOP AT lt_subtypes INTO l_subtype.
        lo_bugtype = l_subtype->get_bugtype( ).
        IF lo_bugtype->get_id( ) = l_id_type.
          INSERT l_subtype INTO TABLE return[].
        ENDIF.
      ENDLOOP.
    CATCH cx_root INTO lo_exception.

  ENDTRY.




ENDMETHOD.


method FIND_BY_KEY.
  DATA: lo_exception       TYPE REF TO cx_root,
        lo_bugtype_persist TYPE REF TO zcl_bugtype_persist.
  CASE id.
    WHEN bugtype_enhancement OR bugtype_issue or bugtype_note.
      TRY .
          lo_bugtype_persist = zca_bugtype_persist=>agent->get_persistent( id ).

          bugtype = persist_to_entity( lo_bugtype_persist ).

        CATCH cx_root INTO lo_exception.
*         Si da error es que no hay nada parametrizado, esto no es ningún problema
          CREATE OBJECT bugtype
            EXPORTING
              id = id.
      ENDTRY.
    WHEN OTHERS.
      RAISE EXCEPTION TYPE zcx_not_found_exception.
  ENDCASE.

endmethod.


method PERSIST_TO_ENTITY.
  DATA: l_id    TYPE zbt_bug_type-bugtype,
        l_nrobj TYPE nrobj.

  l_id    = persist->get_bugtype( ).
  l_nrobj = persist->get_nrobj( ).

  CREATE OBJECT entity
    EXPORTING
      id = l_id.

  entity->set_nrobj( l_nrobj ).

endmethod.
ENDCLASS.
