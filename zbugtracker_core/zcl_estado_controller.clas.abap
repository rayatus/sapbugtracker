class ZCL_ESTADO_CONTROLLER definition
  public
  create public .

public section.
*"* public components of class ZCL_ESTADO_CONTROLLER
*"* do not include other source files here!!!

  constants STATUS_FINISHED type ZBT_TYPESTATUS value 2. "#EC NOTEXT
  constants STATUS_STARTED type ZBT_TYPESTATUS value 1. "#EC NOTEXT
  constants STATUS_WORKING type ZBT_TYPESTATUS value 0. "#EC NOTEXT
  class-data STATUS_HIER_ID type ZBT_ESTADOS_HIER .

  class-methods CLASS_CONSTRUCTOR .
  class-methods EXIST
    importing
      !ESTADO type ref to ZCL_ESTADO
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_ID_ESTADO
    returning
      value(RETURN) type ref to ZCL_ESTADO
    raising
      ZCX_NOT_FOUND_EXCEPTION .
protected section.
*"* protected components of class ZCL_ESTADO_CONTROLLER
*"* do not include other source files here!!!

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_ESTADO_PERSIST
    returning
      value(ENTITY) type ref to ZCL_ESTADO .
private section.
*"* private components of class ZCL_ESTADO_CONTROLLER
*"* do not include other source files here!!!

  class-methods FIND_STATUS_TEXT
    importing
      !ESTADO type ref to ZCL_ESTADO
      !SPRAS type SPRAS default SY-LANGU
    returning
      value(TEXT) type ZBT_ESTADO_TXT-DESCRIPCION .
  class-methods RETRIEVE_HIER_STATUS .
ENDCLASS.



CLASS ZCL_ESTADO_CONTROLLER IMPLEMENTATION.


METHOD class_constructor.

  retrieve_hier_status( ).
ENDMETHOD.


method EXIST.
  DATA: l_id TYPE zbt_estado-estado.

  TRY .
      l_id = estado->get_id( ).
      zcl_estado_controller=>find_by_key( l_id ).
      return = 'X'.
    CATCH cx_root.
      return = space.
  ENDTRY.

endmethod.


METHOD find_by_key.
  DATA: l_status_hier_id TYPE LINE OF zbt_estados_hier.

  READ TABLE status_hier_id WITH KEY estado = id INTO l_status_hier_id.
  IF NOT sy-subrc IS INITIAL.
    READ TABLE status_hier_id WITH KEY next_estado = id INTO l_status_hier_id.
    IF NOT sy-subrc IS INITIAL.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid = zcx_not_found_exception=>zcx_not_found_exception.
    ELSE.
      return = l_status_hier_id-next_estado_oref.
    ENDIF.
  ELSE.
    return = l_status_hier_id-estado_oref.
  ENDIF.

ENDMETHOD.


METHOD find_status_text.
  DATA: l_id TYPE zbt_estado-estado.

  l_id = estado->get_id( ).

  SELECT SINGLE descripcion INTO text
  FROM zbt_estado_txt
  WHERE spras  = spras
    AND estado = l_id.

ENDMETHOD.


METHOD persist_to_entity.
  DATA: l_id          TYPE zbt_id_estado,
        l_icon        TYPE ZBT_ESTADO-ICON,
        l_descripcion TYPE zbt_estado_txt-descripcion,
        lt_estados    TYPE zbt_estados,
        l_wdaicon     TYPE ZBT_ESTADO_ICON_WDA,
        l_type        TYPE zbt_typestatus.

  l_id = persist->get_estado( ).

  CREATE OBJECT entity
    EXPORTING
      id = l_id.

* Buscamos la descripción del estado
  l_descripcion = find_status_text( entity ).
  entity->set_descripcion( l_descripcion ).

  l_type = persist->get_type( ).
  entity->set_type( l_type ).

  l_icon = persist->get_icon( ).
  entity->set_icon( l_icon ).

  l_wdaicon = persist->get_wdaicon( ).
  entity->set_wdaicon( l_wdaicon ).

* Buscamos los siguientes estados al estado actual
*  lt_estados = find_next_status( entity ).
*  entity->set_next_estados( lt_estados ).
** Buscamos los anteriores estados al actual
*  lt_estados = find_prev_status( entity ).
*  entity->set_prev_estados( lt_estados ).
ENDMETHOD.


METHOD retrieve_hier_status.
  DATA:   lo_qm                       TYPE REF TO if_os_query_manager,
          lo_q                        TYPE REF TO if_os_query,
          lt_estados                  TYPE zbt_estados,
          lt_estados_aux              TYPE zbt_estados,
          l_estado                    TYPE LINE OF zbt_estados,
          lo_estado_hier_persist      TYPE REF TO zcl_estadohier_persist,
          lo_estado_persist           TYPE REF TO zcl_estado_persist,
          l_status_hier_id            TYPE LINE OF zbt_estados_hier,
          lt_estados_hier_persist     TYPE osreftab,
          l_return                    TYPE LINE OF zbt_estados.

  FIELD-SYMBOLS: <osref> TYPE osref.

  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( ).

  lt_estados_hier_persist[] = zca_estadohier_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q ).
  LOOP AT lt_estados_hier_persist ASSIGNING <osref>.
    lo_estado_hier_persist ?= <osref>.

    l_status_hier_id-estado      = lo_estado_hier_persist->get_estado( ).
    l_status_hier_id-next_estado = lo_estado_hier_persist->get_next_estado( ).

    READ TABLE lt_estados WITH TABLE KEY id = l_status_hier_id-estado INTO l_estado.
    IF NOT sy-subrc IS INITIAL.
      l_estado-id   = l_status_hier_id-estado.

      lo_estado_persist = zca_estado_persist=>agent->get_persistent( l_status_hier_id-estado ).
      l_estado-oref = persist_to_entity( lo_estado_persist ).

      INSERT l_estado INTO TABLE lt_estados[].
    ENDIF.
    l_status_hier_id-estado_oref = l_estado-oref.

    READ TABLE lt_estados WITH TABLE KEY id = l_status_hier_id-next_estado INTO l_estado.
    IF NOT sy-subrc IS INITIAL.
      l_estado-id   = l_status_hier_id-next_estado.

      lo_estado_persist = zca_estado_persist=>agent->get_persistent( l_status_hier_id-next_estado ).
      l_estado-oref = persist_to_entity( lo_estado_persist ).

      INSERT l_estado INTO TABLE lt_estados[].
    ENDIF.
    l_status_hier_id-next_estado_oref = l_estado-oref.

    lt_estados_aux[] = l_status_hier_id-estado_oref->get_next_estados( ).
    l_estado-id   = l_status_hier_id-next_estado.
    l_estado-oref = l_status_hier_id-next_estado_oref.
    INSERT l_estado INTO TABLE lt_estados_aux[].
    l_status_hier_id-estado_oref->set_next_estados( lt_estados_aux[] ).

    lt_estados_aux[] = l_status_hier_id-next_estado_oref->get_prev_estados( ).
    l_estado-id   = l_status_hier_id-estado.
    l_estado-oref = l_status_hier_id-estado_oref.
    INSERT l_estado INTO TABLE lt_estados_aux[].
    l_status_hier_id-next_estado_oref->set_prev_estados( lt_estados_aux[] ).

    INSERT l_status_hier_id INTO TABLE status_hier_id.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
