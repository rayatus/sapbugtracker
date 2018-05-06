class ZCL_BUG_SUBTYPE_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_BUG_SUBTYPE_CONTROLLER
*"* do not include other source files here!!!
public section.

  constants BUGSUBTYPE_UNDEFINED type ZBT_BUGSTYPE value 0. "#EC NOTEXT
  constants BUGSUBTYPE_MINOR type ZBT_BUGSTYPE value 1. "#EC NOTEXT
  constants BUGSUBTYPE_NORMAL type ZBT_BUGSTYPE value 2. "#EC NOTEXT
  constants BUGSUBTYPE_HIGH type ZBT_BUGSTYPE value 3. "#EC NOTEXT
  constants BUGSUBTYPE_VERYHIGH type ZBT_BUGSTYPE value 4. "#EC NOTEXT
  constants BUGSUBTYPE_DUMP type ZBT_BUGSTYPE value 5. "#EC NOTEXT

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSISTENT type ref to ZCL_BUG_SUBTYPE_PERSIST
    returning
      value(ENTITY) type ref to ZCL_BUGSTYPE .
  class-methods EXIST
    importing
      !BUGSTYPE type ref to ZCL_BUGSTYPE
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !BUGTYPE type ref to ZCL_BUGTYPE
      !ID type ZBT_BUGSTYPE optional
    returning
      value(RETURN) type ref to ZCL_BUGSTYPE
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_ALL_SUBTYPES
    returning
      value(RETURN) type ZBT_BUGSTYPES .
protected section.
*"* protected components of class ZCL_BUGTYPE_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_SUBTYPE_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BUG_SUBTYPE_CONTROLLER IMPLEMENTATION.


METHOD exist.
  DATA: l_id       TYPE zbt_bug_stype-subtype,
        lo_bugtype TYPE REF TO zcl_bugtype.

  TRY .
      l_id       = bugstype->get_id( ).
      lo_bugtype = bugstype->get_bugtype( ).
      zcl_bug_subtype_controller=>find_by_key( bugtype = lo_bugtype
                                               id      = l_id ).
      return = 'X'.
    CATCH cx_root.
      return = space.
  ENDTRY.

ENDMETHOD.


METHOD find_all_subtypes.
  DATA: lo_qm                     TYPE REF TO if_os_query_manager,
        lo_q                      TYPE REF TO if_os_query,
        l_id_subtype              TYPE zbt_bugstype,
        l_id_type                 TYPE zbt_id_bugtype,
        lo_bug_subtype            TYPE REF TO zcl_bugstype,
        lt_subtipos_persist       TYPE osreftab,
        lo_bug_subtype_persist    TYPE REF TO zcl_bug_subtype_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

* Montamos una query para obtener todos los componentes
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( ).

  lt_subtipos_persist[] = zca_bug_subtype_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q ).
  LOOP AT lt_subtipos_persist ASSIGNING <osref>.
    lo_bug_subtype_persist  ?= <osref>.

    lo_bug_subtype = zcl_bug_subtype_controller=>persist_to_entity( persistent = lo_bug_subtype_persist ).

    INSERT lo_bug_subtype INTO TABLE return[].
  ENDLOOP.


ENDMETHOD.


METHOD find_by_key.

  DATA: lo_exception           TYPE REF TO cx_root,
        l_type                 TYPE zbt_bug_type-bugtype,
        lo_bug_subtype_persist TYPE REF TO zcl_bug_subtype_persist.

  TRY .
      l_type = bugtype->get_id( ).

      lo_bug_subtype_persist =
        zca_bug_subtype_persist=>agent->get_persistent( i_type    = l_type
                                                        i_subtype = id ).

      return = persist_to_entity( lo_bug_subtype_persist ).

    CATCH cx_root INTO lo_exception.

  ENDTRY.



ENDMETHOD.


METHOD persist_to_entity.
  DATA: l_type     TYPE zbt_id_bugtype,
        l_icon     TYPE zbt_bugstype_icon,
        lo_bugtype TYPE REF TO zcl_bugtype,
        l_subtype  TYPE zbt_bugstype.

  l_type    = persistent->get_type( ).
  l_subtype = persistent->get_subtype( ).
  l_icon    = persistent->get_icon( ).

  lo_bugtype = zcl_bugtype_controller=>find_by_key( l_type ).

  CREATE OBJECT entity
    EXPORTING
      id      = l_subtype
      bugtype = lo_bugtype
      spras   = sy-langu
      icon    = l_icon.


ENDMETHOD.
ENDCLASS.
