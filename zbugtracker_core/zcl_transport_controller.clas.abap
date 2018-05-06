CLASS zcl_transport_controller DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_TRANSPORT_CONTROLLER
*"* do not include other source files here!!!

    CONSTANTS c_tr_attribute_id TYPE trattr VALUE 'ZBT_BUG'. "#EC NOTEXT

    CLASS-METHODS create
      IMPORTING
        !transport TYPE REF TO zcl_transport
      RAISING
        zcx_create_exception .
    CLASS-METHODS exist
      IMPORTING
        !transport TYPE REF TO zcl_transport
      RETURNING
        value(return) TYPE flag .
    CLASS-METHODS find_by_key
      IMPORTING
        value(id) TYPE zbt_transporter-transportreq
      RETURNING
        value(return) TYPE REF TO zcl_transport
      RAISING
        zcx_not_found_exception .
    CLASS-METHODS find_all_bug_transports
      IMPORTING
        !bug TYPE REF TO zcl_bug
      RETURNING
        value(result) TYPE zbt_transport_tbl .
    CLASS-METHODS update
      IMPORTING
        !transport TYPE REF TO zcl_transport
      RAISING
        zcx_update_exception .
    CLASS-METHODS delete
      IMPORTING
        !transport TYPE REF TO zcl_transport
      RAISING
        zcx_delete_exception .
    CLASS-METHODS read_tr_attributes
      IMPORTING
        !trkorr TYPE trkorr
      RETURNING
        value(bugs) TYPE zbt_producto_bug_id_tbl .
    CLASS-METHODS update_tr_attributes
      IMPORTING
        !transport TYPE REF TO zcl_transport .
  PROTECTED SECTION.
private section.
*"* private components of class ZCL_TRANSPORT_CONTROLLER
*"* do not include other source files here!!!

  class-data TRANSPORT_BUFFER type ZBT_TRANSPORT_TBL .

  class-methods RETRIEVE_BUGS_FROM_PERSISTENCE
    importing
      !TRANSPORT type ref to ZCL_TRANSPORT
    returning
      value(BUGS) type ZBT_BUGS
    raising
      ZCX_NOT_FOUND_EXCEPTION .
ENDCLASS.



CLASS ZCL_TRANSPORT_CONTROLLER IMPLEMENTATION.


  METHOD create.
    DATA: l_str          TYPE zbt_transporter,
          lt_bugs        TYPE zbt_bugs,
          l_bug          TYPE LINE OF zbt_bugs,
          lo_producto    TYPE REF TO zcl_producto,
          lo_transaccion TYPE REF TO zcl_transaction_service,
          lo_exception   TYPE REF TO cx_root.

    TRY .

        lt_bugs = transport->get_bugs( ).
        LOOP AT lt_bugs INTO l_bug.
          AT FIRST.
            CREATE OBJECT lo_transaccion.
            lo_transaccion->start( ).
            l_str-transportreq = transport->get_id( ).
          ENDAT.

          l_str-bug          = l_bug-oref->get_id( ).
          lo_producto        = l_bug-oref->get_producto( ).
          l_str-producto     = lo_producto->get_id( ).

          zca_transport_persist=>agent->create_persistent(
            i_bug           = l_str-bug
            i_producto      = l_str-producto
            i_transportreq  = l_str-transportreq
              ).

          AT LAST.
            lo_transaccion->end( ).
          ENDAT.
        ENDLOOP.

      CATCH cx_root INTO lo_exception.
        RAISE EXCEPTION TYPE zcx_create_exception
          EXPORTING
            textid   = zcx_create_exception=>zcx_create_exception
            previous = lo_exception.
    ENDTRY.

  ENDMETHOD.                    "create


  METHOD delete.
    DATA: l_str          TYPE zbt_transporter,
            lt_bugs        TYPE zbt_bugs,
            l_bug          TYPE LINE OF zbt_bugs,
            lo_producto    TYPE REF TO zcl_producto,
            lo_transaccion TYPE REF TO zcl_transaction_service,
            lo_exception   TYPE REF TO cx_root.
    TRY .
        lt_bugs = transport->get_bugs( ).
        LOOP AT lt_bugs INTO l_bug.
          AT FIRST.
            CREATE OBJECT lo_transaccion.
            lo_transaccion->start( ).
            l_str-transportreq = transport->get_id( ).
          ENDAT.

          l_str-bug          = l_bug-oref->get_id( ).
          l_str-producto     = lo_producto->get_id( ).

          zca_transport_persist=>agent->delete_persistent(
            i_bug           = l_str-bug
            i_producto      = l_str-producto
            i_transportreq  = l_str-transportreq
          ).
          AT LAST.
            lo_transaccion->end( ).
          ENDAT.
        ENDLOOP.
      CATCH cx_root INTO lo_exception.
        RAISE EXCEPTION TYPE zcx_delete_exception
          EXPORTING
            textid   = zcx_delete_exception=>zcx_delete_exception
            previous = lo_exception.
    ENDTRY.

  ENDMETHOD.                    "delete


  METHOD exist.
    DATA: l_id TYPE zbt_transporter-transportreq.
    TRY .
        l_id = transport->get_id( ).
        zcl_transport_controller=>find_by_key( l_id ).
        return = 'X'.
      CATCH cx_root.
        return = space.
    ENDTRY.
  ENDMETHOD.                    "EXIST


  METHOD find_all_bug_transports.

    DATA:    lo_qm                  TYPE REF TO if_os_query_manager,
             lo_q                   TYPE REF TO if_os_query,
             lo_producto            TYPE REF TO zcl_producto,
             lo_transporte          TYPE REF TO zcl_transport,
             l_id_producto          TYPE zbt_producto-producto,
             l_id_bug               TYPE zbt_id_bug,
             l_id_transporte        TYPE zbt_transportreq,
             l_str                  TYPE zbt_transport_str,
             lt_transporte_persist  TYPE osreftab,
             lo_transporte_persist  TYPE REF TO zcl_transport_persist.

    FIELD-SYMBOLS: <osref> TYPE osref.

    l_id_bug      = bug->get_id( ).
    lo_producto   = bug->get_producto( ).
    l_id_producto = lo_producto->get_id( ).

* Montamos una query para obtener las secciones de un bug
    lo_qm = cl_os_system=>get_query_manager( ).
    lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

    lt_transporte_persist[] = zca_transport_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                   i_query   = lo_q
                   i_par1    = l_id_producto
                   i_par2    = l_id_bug ).
    LOOP AT lt_transporte_persist ASSIGNING <osref>.

      lo_transporte_persist ?= <osref>.
      l_id_transporte = lo_transporte_persist->get_transportreq( ).

      READ TABLE result WITH KEY transport_id = l_id_transporte TRANSPORTING NO FIELDS.
      IF NOT sy-subrc IS INITIAL.
        TRY .
            lo_transporte = find_by_key( l_id_transporte ).
            l_str-transport_id = l_id_transporte.
            l_str-oref = lo_transporte.
            INSERT l_str INTO TABLE result[].
          CATCH zcx_not_found_exception.

        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.                    "find_all_bug_transports


  METHOD find_by_key.

    DATA: lt_bugs                TYPE zbt_bugs,
          l_bug                  TYPE LINE OF zbt_bugs,
          l_transport_buffer     TYPE LINE OF zbt_transport_tbl.

    READ TABLE transport_buffer WITH KEY transport_id = id INTO l_transport_buffer.

    IF NOT sy-subrc IS INITIAL.
      l_transport_buffer-transport_id = id.
      CREATE OBJECT l_transport_buffer-oref
        EXPORTING
          id = l_transport_buffer-transport_id.
      INSERT l_transport_buffer INTO TABLE transport_buffer.

      return = l_transport_buffer-oref.
*     Retrieve bugs related to this transport request from within persistence layer
      lt_bugs = retrieve_bugs_from_persistence( return ).
      LOOP AT lt_bugs INTO l_bug.
        return->add_bug( l_bug-oref ).
      ENDLOOP.
    ELSE.
      return = l_transport_buffer-oref.
    ENDIF.


    IF NOT return IS BOUND.
*   If nothing is found...
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid = zcx_not_found_exception=>zcx_not_found_exception.
    ENDIF.

  ENDMETHOD.                    "find_by_key


  METHOD read_tr_attributes.
*    types: TRWBO.
    DATA: lt_attr TYPE TRATTRIBUTES, "trwbo_t_e070a,
          l_attr  TYPE LINE OF TRATTRIBUTES, "trwbo_t_e070a,
          l_bug   TYPE LINE OF zbt_producto_bug_id_tbl.

    CALL FUNCTION 'TR_READ_ATTRIBUTES'
      EXPORTING
        iv_request       = trkorr
      IMPORTING
        et_attributes    = lt_attr
      EXCEPTIONS
        invalid_request  = 1
        no_authorization = 2
        OTHERS           = 3.

    LOOP AT lt_attr INTO l_attr
        WHERE attribute = c_tr_attribute_id.
      l_bug = l_attr-reference.
      INSERT l_bug INTO TABLE bugs[].
    ENDLOOP.

  ENDMETHOD.                    "read_tr_attributes


  METHOD retrieve_bugs_from_persistence.
    DATA: lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          lo_producto            TYPE REF TO zcl_producto,
          lo_bug                 TYPE REF TO zcl_bug,
          lt_bug_id              TYPE zbt_producto_bug_id_tbl,
          l_bug_str              TYPE LINE OF zbt_bugs,
          l_bug_id               TYPE LINE OF zbt_producto_bug_id_tbl,
          l_id_producto          TYPE zbt_producto-producto,
          l_id_bug               TYPE zbt_id_bug,
          lo_exception           TYPE REF TO cx_root,
          lt_transporte_persist  TYPE osreftab,
          l_transport_id         TYPE zbt_transporter-transportreq,
          lo_transporte_persist  TYPE REF TO zcl_transport_persist.

    FIELD-SYMBOLS: <osref> TYPE osref.

    l_transport_id = transport->get_id( ).

* Montamos una query para obtener las secciones de un bug
    lo_qm = cl_os_system=>get_query_manager( ).
    lo_q  = lo_qm->create_query( i_filter = 'TRANSPORTREQ = PAR1' ).

    lt_transporte_persist[] = zca_transport_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
      i_query   = lo_q
      i_par1    = l_transport_id ).

* We read attributes from the transport order (all bugs must be in DB, but...)

    lt_bug_id[] = zcl_transport_controller=>read_tr_attributes( l_transport_id ).
    LOOP AT lt_bug_id INTO l_bug_id.
      TRY.
          lo_producto = zcl_producto_controller=>find_by_key( l_bug_id-producto ).
          lo_bug = zcl_bug_controller=>find_by_key( id       = l_bug_id-bug
                                                    producto = lo_producto ).

          l_bug_str-producto_id = l_bug_id-producto.
          l_bug_str-bug_id      = l_bug_id-bug.
          l_bug_str-oref        = lo_bug.
          READ TABLE bugs WITH KEY producto_id = l_id_producto
                           bug_id      = l_id_bug
                           TRANSPORTING NO FIELDS.
          IF NOT sy-subrc IS INITIAL.
            INSERT l_bug_str INTO TABLE bugs.
          ENDIF.
        CATCH zcx_not_found_exception.

      ENDTRY.
    ENDLOOP.

    LOOP AT lt_transporte_persist ASSIGNING <osref>.
*   Now we add bugs from BugTracker Tables
      TRY .
          lo_transporte_persist ?= <osref>.

          l_id_bug      = lo_transporte_persist->get_bug( ).
          l_id_producto = lo_transporte_persist->get_producto( ).

          lo_producto = zcl_producto_controller=>find_by_key( id = l_id_producto ).

          lo_bug = zcl_bug_controller=>find_by_key( id       = l_id_bug
                                                    producto = lo_producto ).

          l_bug_str-producto_id = l_id_producto.
          l_bug_str-bug_id      = l_id_bug.
          l_bug_str-oref        = lo_bug.
          READ TABLE bugs WITH KEY producto_id = l_id_producto
                                   bug_id      = l_id_bug
                                   TRANSPORTING NO FIELDS.
          IF NOT sy-subrc IS INITIAL.
            INSERT l_bug_str INTO TABLE bugs.
          ENDIF.

        CATCH cx_root INTO lo_exception.
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              textid   = zcx_not_found_exception=>zcx_not_found_exception
              previous = lo_exception.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.                    "retrieve_bugs_from_persistence


  METHOD update.
    DATA: lo_persist       TYPE REF TO zcl_transport_persist,
          l_tr_str         TYPE zbt_transporter,
          lt_new_bugs      TYPE zbt_bugs,
          lt_old_bugs      TYPE zbt_bugs,
          l_bug_str        TYPE LINE OF zbt_bugs,
          lo_producto      TYPE REF TO zcl_producto,
          lo_transaccion   TYPE REF TO zcl_transaction_service,
          lo_exception     TYPE REF TO cx_root.

    TRY .
*     Firstly, it's necessary to retrieve to which bugs is this TR related before de modification
        lt_old_bugs[] = retrieve_bugs_from_persistence( transport ).
        lt_new_bugs[] = transport->get_bugs( ).

        CREATE OBJECT lo_transaccion.
        lo_transaccion->start( ).

        l_tr_str-transportreq = transport->get_id( ).

*     Compare current bugs with those that exist in DB
        LOOP AT lt_new_bugs INTO l_bug_str.

          l_tr_str-bug          = l_bug_str-bug_id.
          l_tr_str-producto     = l_bug_str-producto_id.

          READ TABLE lt_old_bugs WITH KEY producto_id = l_bug_str-producto_id
                                          bug_id      = l_bug_str-bug_id
                                          TRANSPORTING NO FIELDS.

          IF sy-subrc IS INITIAL.
            lo_persist = zca_transport_persist=>agent->get_persistent(
                                i_bug          = l_tr_str-bug
                                i_producto     = l_tr_str-producto
                                i_transportreq = l_tr_str-transportreq
                              ).
            DELETE lt_old_bugs WHERE producto_id = l_bug_str-producto_id
                                 AND bug_id      = l_bug_str-bug_id.
          ELSE.
            lo_persist = zca_transport_persist=>agent->create_persistent(
                        i_bug           = l_tr_str-bug
                        i_producto      = l_tr_str-producto
                        i_transportreq  = l_tr_str-transportreq
                      ).
          ENDIF.


        ENDLOOP.

*     Know we proced to delete old bugs that are no more related to this TR
        LOOP AT lt_old_bugs INTO l_bug_str.
          READ TABLE lt_new_bugs WITH KEY producto_id = l_bug_str-producto_id
                                          bug_id      = l_bug_str-bug_id
                                          TRANSPORTING NO FIELDS.
          IF NOT sy-subrc IS INITIAL.
            l_tr_str-bug          = l_bug_str-bug_id.
            l_tr_str-producto     = l_bug_str-producto_id.

            zca_transport_persist=>agent->delete_persistent(
              i_bug           = l_tr_str-bug
              i_producto      = l_tr_str-producto
              i_transportreq  = l_tr_str-transportreq
            ).
          ENDIF.
        ENDLOOP.

        lo_transaccion->end( ).

      CATCH cx_root INTO lo_exception.
        RAISE EXCEPTION TYPE zcx_update_exception
          EXPORTING
            textid   = zcx_update_exception=>zcx_update_exception
            previous = lo_exception.
    ENDTRY.

  ENDMETHOD.                    "update


  METHOD update_tr_attributes.

    DATA:   lt_attributes     TYPE trwbo_t_e070a,
            lt_attributes_aux TYPE trwbo_t_e070a,
            l_trkorr          TYPE trkorr,
            lo_producto       TYPE REF TO zcl_producto,
            l_bug_id          TYPE LINE OF zbt_producto_bug_id_tbl,
            l_attribute       TYPE LINE OF trwbo_t_e070a,
            lt_bugs           TYPE zbt_bugs,
            l_bug             TYPE LINE OF zbt_bugs.

    l_trkorr = transport->get_id( ).
    CALL FUNCTION 'TR_READ_ATTRIBUTES'
      EXPORTING
        iv_request       = l_trkorr
      IMPORTING
        et_attributes    = lt_attributes
      EXCEPTIONS
        invalid_request  = 1
        no_authorization = 2
        OTHERS           = 3.

    lt_bugs = transport->get_bugs( ).
    LOOP AT lt_bugs INTO l_bug.

      l_trkorr          = transport->get_id( ).
      lo_producto       = l_bug-oref->get_producto( ).
      l_bug_id-producto = lo_producto->get_id( ).
      l_bug_id-bug      = l_bug-oref->get_id( ).

      READ TABLE lt_attributes WITH KEY trkorr    = l_trkorr
                                        attribute = c_tr_attribute_id
                                        reference = l_bug_id
                                        INTO l_attribute.
      IF NOT sy-subrc IS INITIAL.
        DESCRIBE TABLE lt_attributes LINES l_attribute-pos.

        ADD 1 TO l_attribute-pos.
        l_attribute-trkorr    = l_trkorr.
        l_attribute-attribute = c_tr_attribute_id.
        l_attribute-reference = l_bug_id.
        INSERT l_attribute INTO TABLE lt_attributes[].

        CLEAR lt_attributes_aux[].
        INSERT l_attribute INTO TABLE lt_attributes_aux[].

        CALL FUNCTION 'TR_APPEND_ATTRIBUTES'
          EXPORTING
            iv_request        = l_trkorr
            it_attributes     = lt_attributes_aux[]
          EXCEPTIONS
            invalid_request   = 1
            invalid_attribute = 2
            no_authorization  = 3
            enqueue_failed    = 4
            db_access_error   = 5
            OTHERS            = 6.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_attributes INTO l_attribute.
      l_bug_id = l_attribute-reference.
      READ TABLE lt_bugs WITH KEY producto_id = l_bug_id-producto
                                  bug_id     = l_bug_id-bug
                                  TRANSPORTING NO FIELDS.
      IF NOT sy-subrc IS INITIAL.
        CLEAR lt_attributes_aux[].
        INSERT l_attribute INTO TABLE lt_attributes_aux[].

        CALL FUNCTION 'TR_DELETE_ATTRIBUTES'
          EXPORTING
            iv_request        = l_trkorr
            it_attributes     = lt_attributes_aux[]
          EXCEPTIONS
            invalid_request   = 1
            invalid_attribute = 2
            no_authorization  = 3
            enqueue_failed    = 4
            db_access_error   = 5
            OTHERS            = 6.
      ENDIF.


    ENDLOOP.
    COMMIT WORK AND WAIT.

  ENDMETHOD.                    "update_tr_attributes
ENDCLASS.
