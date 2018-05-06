class ZCL_BUG_CONTROLLER definition
  public
  create public

  global friends ZCL_PRODUCTO_CONTROLLER .

public section.
*"* public components of class ZCL_BUG_CONTROLLER
*"* do not include other source files here!!!

  class-methods CREATE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_CREATE_EXCEPTION
      ZCX_VALIDATE_EXCEPTION .
  class-methods DELETE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_DELETE_EXCEPTION .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_BUG
    returning
      value(STRUCTURE) type ZBT_BUG .
  class-methods EXIST
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RETURN) type FLAG .
  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_ID_BUG
      !PRODUCTO type ref to ZCL_PRODUCTO
    returning
      value(BUG) type ref to ZCL_BUG
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods NEXT_ID
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
      !BUGTYPE type ref to ZCL_BUGTYPE optional
    returning
      value(RETURN) type ZBT_BUG-BUG .
  class-methods UPDATE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_UPDATE_EXCEPTION
      ZCX_VALIDATE_EXCEPTION .
  class-methods VALIDATE_ON_CREATE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_VALIDATE_EXCEPTION .
  class-methods VALIDATE_ON_DELETE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_VALIDATE_EXCEPTION .
  class-methods VALIDATE_ON_UPDATE
    importing
      !BUG type ref to ZCL_BUG
    raising
      ZCX_VALIDATE_EXCEPTION .
  class-methods STRUCTURE_TO_ENTITY
    importing
      !STRUCTURE type ZBT_BUG
    changing
      value(ENTITY) type ref to ZCL_BUG .
  class-methods LOCK
    importing
      !BUG type ref to ZCL_BUG .
  class-methods UNLOCK
    importing
      !BUG type ref to ZCL_BUG .
  class-methods EQUAL
    importing
      !BUG1 type ref to ZCL_BUG
      !BUG2 type ref to ZCL_BUG
    returning
      value(EQUAL) type FLAG .
  class-methods SEARCH
    importing
      !BUG type ZBT_BUG_RANGE optional
      !BUG_I type ZBT_BUG_I_RANGE optional
      !BUGSTYPE type ZBT_BUGSTYPE_RANGE optional
      !BUGTYPE type ZBT_BUGTYPE_RANGE optional
      !COMPONENTE type ZBT_COMPONENTE_RANGE optional
      !DEADLINE type ZBT_DATS_RANGE optional
      !ESTADO type ZBT_ESTADO_RANGE optional
      !HORAS_ESTIMADAS type ZBT_HORAS_RANGE optional
      !HORAS_REALES type ZBT_HORAS_RANGE optional
      !PRODUCTO type ZBT_PRODUCTO_RANGE optional
      !RESUMEN type ZBT_TEXT_RANGE optional
      !CREADO type ZBT_TIMESTAMP_RANGE optional
      !REPORTER type ZBT_USER_RANGE optional
      !DEVELOPER type ZBT_USER_RANGE optional
      !ASSIGNED type ZBT_USER_RANGE optional
      !TESTER type ZBT_USER_RANGE optional
      !FINALIZADO type ZBT_TIMESTAMP_RANGE optional
      !AEDAT type ZBT_TIMESTAMP_RANGE optional
      !AENAM type ZBT_USER_RANGE optional
      value(MAX_ROWS) type I optional
    returning
      value(RETURN) type ZBT_BUGS .
protected section.
*"* protected components of class ZCL_BUG_CONTROLLER
*"* do not include other source files here!!!

  class-methods ENTITY_TO_PERSIST
    importing
      !ENTITY type ref to ZCL_BUG
    changing
      value(PERSIST) type ref to ZCL_BUG_PERSIST .
  class-methods FIND_NEXT_BUGS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_BUGS .
  class-methods FIND_PREV_BUGS
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(RESULT) type ZBT_BUGS .
  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUG_PERSIST
    returning
      value(ENTITY) type ref to ZCL_BUG .
private section.
*"* private components of class ZCL_BUG_CONTROLLER
*"* do not include other source files here!!!

  class-data BUGS_BUFFER type ZBT_BUGS .

  class-methods EQUAL_TAGS
    importing
      !BUG1 type ref to ZCL_BUG
      !BUG2 type ref to ZCL_BUG
    returning
      value(EQUAL) type FLAG .
ENDCLASS.



CLASS ZCL_BUG_CONTROLLER IMPLEMENTATION.


METHOD create.

  DATA: lo_bug_persist        TYPE REF TO zcl_bug_persist,
        l_timestamp           TYPE timestamp,
        l_creado              TYPE zbt_bug-creado,
        l_aedat               TYPE zbt_bug-aedat,
        lo_producto           TYPE REF TO zcl_producto,
        lo_bugtype            TYPE REF TO zcl_bugtype,
        l_str_bug             TYPE zbt_bug,
        lt_attachements       TYPE zbt_attachements,
        lt_comentarios        TYPE zbt_comentarios,
        lt_sections           TYPE zbt_bugsections,
        lo_usuario            TYPE REF TO zcl_usuario,
        lt_transportes        TYPE zbt_transport_tbl,
        lo_transaccion        TYPE REF TO zcl_transaction_service,
        lo_validate_exception TYPE REF TO zcx_validate_exception,
        lt_tags               TYPE zbt_bug_tag_tbl,
        lt_wrklogs            TYPE zbt_bugwrklogs,
        lo_exception          TYPE REF TO cx_root.

  FIELD-SYMBOLS: <attachement> TYPE LINE OF zbt_attachements,
                 <comentario>  TYPE LINE OF zbt_comentarios,
                 <section>     TYPE LINE OF zbt_bugsections,
                 <transporte>  TYPE LINE OF zbt_transport_tbl,
                 <tag>         TYPE LINE OF zbt_bug_tag_tbl,
                 <wrklog>      LIKE LINE OF lt_wrklogs.

* On create, get next Id
  l_str_bug-bug = bug->get_id( ).  l_str_bug-bug_i = bug->get_id_i( ).

  IF l_str_bug-bug IS INITIAL.
    lo_producto   = bug->get_producto( ).
    lo_bugtype    = bug->get_bug_type( ).
    l_str_bug-bug = zcl_bug_controller=>next_id( producto = lo_producto
                                                 bugtype  = lo_bugtype ).
    bug->set_id( l_str_bug-bug ).
    bug->set_id_i( l_str_bug-bug_i ).
  ENDIF.

* Set CreateTime
  IF l_str_bug-creado IS INITIAL.
    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.
    bug->set_creado( l_creado ).
  ENDIF.

* Antes de crear procedemos a validar
  validate_on_create( bug ).

  l_str_bug = entity_to_structure( bug ).

  TRY.
      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      CALL METHOD zca_bug_persist=>agent->create_persistent
        EXPORTING
          i_bug        = l_str_bug-bug
          i_bug_i      = l_str_bug-bug_i
          i_bugstype   = l_str_bug-bugstype
          i_bugtype    = l_str_bug-bugtype
          i_componente = l_str_bug-componente
          i_creado     = l_str_bug-creado
          i_deadline   = l_str_bug-deadline
          i_developer  = l_str_bug-developer
          i_estado     = l_str_bug-estado
          i_finalizado = l_str_bug-finalizado
          i_horas_est  = l_str_bug-horas_est
          i_horas_rea  = l_str_bug-horas_rea
          i_producto   = l_str_bug-producto
          i_reporter   = l_str_bug-reporter
          i_resumen    = l_str_bug-resumen
          i_tester     = l_str_bug-tester
          i_assigned   = l_str_bug-assigned
        RECEIVING
          result       = lo_bug_persist.
*     Creamos los attachements
      lt_attachements[] = bug->get_attachements( ).
      LOOP AT lt_attachements ASSIGNING <attachement>.
        zcl_attachement_controller=>create( <attachement> ).
      ENDLOOP.
*     Creamos los comentarios
      lt_comentarios[] = bug->get_comentarios( no_section_comments = 'X' ).
      LOOP AT lt_comentarios ASSIGNING <comentario>.
        zcl_comment_controller=>create( <comentario>-oref ).
      ENDLOOP.
*     Creamos las secciones
      lt_sections[] = bug->get_sections( ) .
      LOOP AT lt_sections ASSIGNING <section>.
        zcl_bugsection_controller=>create( <section>-oref ).
      ENDLOOP.
*     Creamos los transportes
      lt_transportes[] = bug->get_transports( ).
      LOOP AT lt_transportes ASSIGNING <transporte>.
        zcl_transport_controller=>create( <transporte>-oref ).
      ENDLOOP.
*     Creamos los Tags
      lt_tags[] = bug->get_tags( ).
      LOOP AT lt_tags ASSIGNING <tag>.
        zcl_bug_tag_controller=>create( <tag>-oref ).
      ENDLOOP.
*     Creates WorkLog
      lt_wrklogs = bug->get_wrklogs( ).
      LOOP AT lt_wrklogs ASSIGNING <wrklog>.
        zcl_bug_wrklog_controller=>create( <wrklog>-oref ).
      ENDLOOP.

*     Set ModifyDate
      GET TIME STAMP FIELD l_timestamp.
      l_aedat = l_aedat.
      bug->set_aedat( l_aedat ).
*     Set ModifyUser
      lo_usuario = zcl_usuario_controller=>find_by_key( ).
      bug->set_aenam( lo_usuario ).

      lo_transaccion->end( ).

    CATCH cx_os_object_existing INTO lo_exception.

      RAISE EXCEPTION TYPE zcx_create_exception
        EXPORTING
          textid   = zcx_create_exception=>zcx_create_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.


METHOD delete.

  DATA: lo_bug_persist TYPE REF TO zcl_bug_persist,
        lo_producto    TYPE REF TO zcl_producto,
        l_id_bug       TYPE zbt_bug-bug,
        l_id_bug_i     TYPE zbt_bug-bug_i,
        l_id_producto  TYPE zbt_producto-producto,
        lt_attachements TYPE zbt_attachements,
        lt_comentarios  TYPE zbt_comentarios,
        lt_sections     TYPE zbt_bugsections,
        lt_transportes  TYPE ZBT_TRANSPORT_TBL,
        lo_transaccion  TYPE REF TO zcl_transaction_service,
        lt_tags               TYPE zbt_bug_tag_tbl,
        lo_exception   TYPE REF TO cx_root.

  FIELD-SYMBOLS:   <attachement> TYPE LINE OF zbt_attachements,
                   <comentario>  TYPE LINE OF zbt_comentarios,
                   <section>     TYPE LINE OF zbt_bugsections,
                   <tag>         TYPE LINE OF zbt_bug_tag_tbl,
                   <transporte>  TYPE LINE OF ZBT_TRANSPORT_TBL.

  validate_on_delete( bug ).

  l_id_bug      = bug->get_id( ).
  l_id_bug_i    = bug->get_id_i( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).


  CREATE OBJECT lo_transaccion.
  lo_transaccion->start( ).

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Borramos el resto de objetos
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Borramos los attachements
  lt_attachements[] = bug->get_attachements( ).
  LOOP AT lt_attachements ASSIGNING <attachement>.
    zcl_attachement_controller=>delete( <attachement> ).
  ENDLOOP.
* Borramos los comentarios
  lt_comentarios[] = bug->get_comentarios( NO_SECTION_COMMENTS = space ).
  LOOP AT lt_comentarios ASSIGNING <comentario>.
    zcl_comment_controller=>delete( <comentario>-oref ).
  ENDLOOP.
* Borramos las secciones
  lt_sections[] = bug->get_sections( ) .
  LOOP AT lt_sections ASSIGNING <section>.
    zcl_bugsection_controller=>delete( <section>-oref ).
  ENDLOOP.
* Borramos los transportes
  lt_transportes[] = bug->get_transports( ).
  LOOP AT lt_transportes ASSIGNING <transporte>.
    zcl_transport_controller=>delete( <transporte>-oref ).
  ENDLOOP.
* Borramos los tags
  lt_tags[] = bug->get_tags( ).
  LOOP AT lt_tags ASSIGNING <tag>.
    zcl_bug_tag_controller=>delete( <tag>-oref ).
  ENDLOOP.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Borramos de la persistencia
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  zca_bug_persist=>agent->delete_persistent(
    i_bug           = l_id_bug
*    i_bug_i           = l_id_bug_i
    i_producto      = l_id_producto
  ).

  lo_transaccion->end( ).

ENDMETHOD.


METHOD entity_to_persist.

  DATA: l_structure TYPE zbt_bug.

  l_structure = entity_to_structure( entity ).
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Las clave de un objeto de persistencia NO se pueden cambiar
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*  persist->set_bug( l_structure-bug ).
*  persist->set_producto( l_structure-producto ).

  persist->set_bugstype( l_structure-bugstype ).
  persist->set_bugtype( l_structure-bugtype ).
  persist->set_componente( l_structure-componente ).
  persist->set_creado( l_structure-creado ).
  persist->set_deadline( l_structure-deadline ).
  persist->set_developer( l_structure-developer ).
  persist->set_assigned( l_structure-assigned ).
  persist->set_estado( l_structure-estado ).
  persist->set_finalizado( l_structure-finalizado ).
  persist->set_horas_est( l_structure-horas_est ).
  persist->set_horas_rea( l_structure-horas_rea ).
  persist->set_reporter( l_structure-reporter ).
  persist->set_resumen( l_structure-resumen ).
  persist->set_tester( l_structure-tester ).
  persist->set_aedat( l_structure-aedat ).
  persist->set_aenam( l_structure-aenam ).
  persist->set_bug_i( l_structure-bug_i ).

ENDMETHOD.


METHOD entity_to_structure.
  DATA: lo_producto   TYPE REF TO zcl_producto,
        lo_usuario    TYPE REF TO zcl_usuario,
        lo_componente TYPE REF TO zcl_componente,
        lo_bugtype    TYPE REF TO zcl_bugtype,
        lo_bugstype   TYPE REF TO zcl_bugstype,
        lo_estado     TYPE REF TO zcl_estado.

  structure-bug   = entity->get_id( ).
  structure-bug_i = entity->get_id_i( ).

  lo_producto = entity->get_producto( ).
  structure-producto = lo_producto->get_id( ).

  structure-creado = entity->get_creado( ).

  structure-finalizado = entity->get_finalizado( ).

  structure-deadline = entity->get_deadline( ).

  structure-aedat = entity->get_aedat( ).
  lo_usuario = entity->get_aenam( ).
  IF lo_usuario IS BOUND.
    structure-aenam = lo_usuario->get_id( ).
  ENDIF.
  CLEAR lo_usuario.

  lo_usuario = entity->get_reporter( ).
  IF lo_usuario IS BOUND.
    structure-reporter = lo_usuario->get_id( ).
  ENDIF.
  CLEAR lo_usuario.

  lo_usuario = entity->get_developer( ).
  IF lo_usuario IS BOUND.
    structure-developer = lo_usuario->get_id( ).
  ENDIF.
  CLEAR lo_usuario.

  lo_usuario = entity->get_assigned( ).
  IF lo_usuario IS BOUND.
    structure-assigned = lo_usuario->get_id( ).
  ENDIF.
  CLEAR lo_usuario.

  lo_usuario = entity->get_tester( ).
  IF lo_usuario IS BOUND.
    structure-tester = lo_usuario->get_id( ).
  ENDIF.
  CLEAR lo_usuario.

  structure-resumen = entity->get_resumen( ).

  lo_estado = entity->get_estado( ).
  IF lo_estado IS BOUND.
    structure-estado = lo_estado->get_id( ).
  ENDIF.

  structure-horas_est = entity->get_horas_estimadas( ).
  structure-horas_rea = entity->get_horas_reales( ).

  lo_componente = entity->get_componente( ).
  IF lo_componente IS BOUND.
    structure-componente = lo_componente->get_id( ).
  ENDIF.

  lo_bugtype = entity->get_bug_type( ).
  IF lo_bugtype IS BOUND.
    structure-bugtype = lo_bugtype->get_id( ).
  ENDIF.

  lo_bugstype = entity->get_bug_subtype( ).
  IF lo_bugstype IS BOUND.
    structure-bugstype = lo_bugstype->get_id( ).
  ENDIF.

ENDMETHOD.


METHOD equal.

  IF bug1->get_hash( ) = bug2->get_hash( ).
    equal = abap_true.
  ELSE.
    equal = abap_false.
  ENDIF.


ENDMETHOD.


METHOD equal_tags.
  DATA: l_counter1 TYPE i,
        l_counter2 TYPE i,
        lt_tags1   TYPE zbt_bug_tag_tbl,
        lt_tags2   TYPE zbt_bug_tag_tbl,
        l_tag1     TYPE LINE OF zbt_bug_tag_tbl,
        l_tag2     TYPE LINE OF zbt_bug_tag_tbl.


  lt_tags1 = bug1->get_tags( ).
  lt_tags2 = bug2->get_tags( ).
  SORT: lt_tags1, lt_tags2.
  DESCRIBE TABLE lt_tags1 LINES l_counter1.
  DESCRIBE TABLE lt_tags2 LINES l_counter2.
  IF l_counter1 <> l_counter2.
    equal = abap_false.
  ELSE.
    CLEAR l_counter2.
    DO l_counter1 TIMES.
      ADD 1 TO l_counter2.
      READ TABLE lt_tags1 INDEX l_counter2 INTO l_tag1.
      READ TABLE lt_tags2 INDEX l_counter2 INTO l_tag2.
      IF zcl_bug_tag_controller=>equal( tag1 = l_tag1-oref
                                        tag2 = l_tag2-oref ) = abap_false.
        equal = abap_false.
        EXIT.
      ENDIF.
    ENDDO.
  ENDIF.

ENDMETHOD.


method EXIST.
  DATA: l_id        TYPE zbt_bug-bug,
        l_id_i      TYPE zbt_bug-bug_i,
        lo_producto TYPE REF TO zcl_producto.

  TRY .
      l_id        = bug->get_id( ).
      l_id_i      = bug->get_id_i( ).
      lo_producto = bug->get_producto( ).
      zcl_bug_controller=>find_by_key( id       = l_id
*                                       id_i     = l_id_i
                                       producto = lo_producto ).
      return = 'X'.
    CATCH cx_root.
      return = space.

  ENDTRY.
endmethod.


method FIND_BY_KEY.

  DATA: lo_bug_agent    TYPE REF TO zca_bug_persist,
        lo_bug_persist  TYPE REF TO zcl_bug_persist,
        lo_exception    TYPE REF TO cx_root,
        l_id_producto   TYPE zbt_producto-producto.

  l_id_producto = producto->get_id( ).


  TRY.
*     Buscamos el objeto en la capa de persistencia
      lo_bug_agent = zca_bug_persist=>agent.
      CALL METHOD lo_bug_agent->get_persistent
        EXPORTING
          i_bug      = id
          i_producto = l_id_producto
        RECEIVING
          result     = lo_bug_persist.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Mapeamos contra un Entity
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      bug = persist_to_entity( lo_bug_persist ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.

endmethod.


METHOD find_next_bugs.
  DATA:   lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          lo_producto            TYPE REF TO zcl_producto,
          lo_bug                 TYPE REF TO zcl_bug,
          l_id_producto          TYPE zbt_producto-producto,
          l_id_bug               TYPE zbt_id_bug,
          l_id_bug_i             TYPE zbt_id_bug_i,
          l_result               TYPE LINE OF zbt_bugs,
          lt_bughier_persist     TYPE osreftab,
          l_bug_buffer           TYPE LINE OF zbt_bugs,
          lo_bughier_persist     TYPE REF TO zcl_bughier_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_id_bug      = bug->get_id( ).
  l_id_bug_i    = bug->get_id_i( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

  READ TABLE bugs_buffer WITH TABLE KEY producto_id = l_id_producto
                                        bug_id      = l_id_bug

                                        INTO l_bug_buffer.
  IF NOT sy-subrc IS INITIAL.
    l_bug_buffer-oref        = bug.
    l_bug_buffer-producto_id = l_id_producto.
    l_bug_buffer-bug_id      = l_id_bug.

    INSERT l_bug_buffer INTO TABLE bugs_buffer.
  ENDIF.

* Montamos una query para obtener los siguientes bugs al indicado
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_bughier_persist[] = zca_bughier_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_id_producto
                 i_par2    = l_id_bug ).

  LOOP AT lt_bughier_persist ASSIGNING <osref>.
    lo_bughier_persist ?= <osref>.
    l_bug_buffer-bug_id      = l_result-bug_id      = lo_bughier_persist->get_next_bug( ).
    l_bug_buffer-producto_id = l_result-producto_id = l_id_producto.

    READ TABLE bugs_buffer WITH TABLE KEY producto_id = l_result-producto_id
                                          bug_id      = l_result-bug_id

                                          INTO l_bug_buffer.
    IF sy-subrc IS INITIAL.
      l_result-oref = l_bug_buffer-oref.
    ELSE.

      l_bug_buffer-oref = l_result-oref =
      zcl_bug_controller=>find_by_key( id       = l_result-bug_id
                                       producto = lo_producto ).
      INSERT l_bug_buffer INTO TABLE bugs_buffer[].
    ENDIF.


    INSERT l_result INTO TABLE result[].
  ENDLOOP.

ENDMETHOD.


METHOD find_prev_bugs.
  DATA:   lo_qm                  TYPE REF TO if_os_query_manager,
          lo_q                   TYPE REF TO if_os_query,
          lo_producto            TYPE REF TO zcl_producto,
          lo_bug                 TYPE REF TO zcl_bug,
          l_id_producto          TYPE zbt_producto-producto,
          l_id_bug               TYPE zbt_id_bug,
          l_id_bug_i             TYPE zbt_id_bug_i,
          l_result               TYPE LINE OF zbt_bugs,
          lt_bughier_persist     TYPE osreftab,
          l_bug_buffer           TYPE LINE OF zbt_bugs,
          lo_bughier_persist     TYPE REF TO zcl_bughier_persist.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_id_bug      = bug->get_id( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

  READ TABLE bugs_buffer WITH TABLE KEY producto_id = l_id_producto
                                        bug_id      = l_id_bug
                                        INTO l_bug_buffer.
  IF NOT sy-subrc IS INITIAL.
    l_bug_buffer-oref        = bug.
    l_bug_buffer-producto_id = l_id_producto.
    l_bug_buffer-bug_id      = l_id_bug.
   INSERT l_bug_buffer INTO TABLE bugs_buffer.
  ENDIF.

* Montamos una query para obtener los bugs anteriores al indicado
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND NEXT_BUG = PAR2 ' ).

  lt_bughier_persist[] = zca_bughier_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_id_producto
                 i_par2    = l_id_bug ).
  LOOP AT lt_bughier_persist ASSIGNING <osref>.
    lo_bughier_persist ?= <osref>.
    l_bug_buffer-bug_id      = l_result-bug_id      = lo_bughier_persist->get_bug( ).
    l_bug_buffer-producto_id = l_result-producto_id = l_id_producto.

    READ TABLE bugs_buffer WITH TABLE KEY producto_id = l_result-producto_id
                                          bug_id      = l_result-bug_id
                                          INTO l_bug_buffer.
    IF sy-subrc IS INITIAL.
      l_result-oref = l_bug_buffer-oref.
    ELSE.

      l_bug_buffer-oref = l_result-oref =
      zcl_bug_controller=>find_by_key( id       = l_result-bug_id
                                       producto = lo_producto ).
      INSERT l_bug_buffer INTO TABLE bugs_buffer[].
    ENDIF.
    INSERT l_result INTO TABLE result[].
  ENDLOOP.
ENDMETHOD.


method LOCK.
endmethod.


method NEXT_ID.
  DATA: l_number_range TYPE tnro-object.

  l_number_range = producto->get_bug_number_range( ).
  IF l_number_range IS INITIAL.
    l_number_range = 'ZBT_BUGID'. "Default Number Range
  ENDIF.

  IF bugtype IS SUPPLIED AND bugtype->get_nrobj( ) IS NOT INITIAL.
    l_number_range = bugtype->get_nrobj( ).
  ENDIF.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '1'
      object                        = l_number_range
      quantity                      = '1'
*     TOYEAR                        = '0000'
   IMPORTING
     number                        = return
*     QUANTITY                      =
*     RETURNCODE                    =
*   EXCEPTIONS
*     INTERVAL_NOT_FOUND            = 1
*     NUMBER_RANGE_NOT_INTERN       = 2
*     OBJECT_NOT_FOUND              = 3
*     QUANTITY_IS_0                 = 4
*     QUANTITY_IS_NOT_1             = 5
*     INTERVAL_OVERFLOW             = 6
*     BUFFER_OVERFLOW               = 7
*     OTHERS                        = 8
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


endmethod.


METHOD persist_to_entity.

  DATA: l_usuario       TYPE xubname,
        l_id_estado     TYPE zbt_id_estado,
        l_id_bugtype    TYPE zbt_id_bugtype,
        l_id_bugstype   TYPE zbt_bugstype,
        l_id_bug        TYPE zbt_bug-bug,
        l_id_bug_i      TYPE zbt_bug-bug_i,
        l_id_producto   TYPE zbt_producto-producto,
        l_id_componente TYPE zbt_id_componente,
        l_resumen       TYPE zbt_resumen,
        lo_bugstype     TYPE REF TO zcl_bugstype,
        lo_bugtype      TYPE REF TO zcl_bugtype,
        lo_producto     TYPE REF TO zcl_producto,
        lo_usuario      TYPE REF TO zcl_usuario,
        lo_componente   TYPE REF TO zcl_componente,
        lo_estado       TYPE REF TO zcl_estado,
        l_timestamp     TYPE zbt_erdat,
        l_dats          TYPE sy-datum,
        l_horas         TYPE zbt_horas_reales,
        lt_bugs         TYPE zbt_bugs,
        lt_sections     TYPE zbt_bugsections,
        lt_transportes  TYPE zbt_transport_tbl,
        lt_attachements TYPE zbt_attachements,
        lt_comments     TYPE zbt_comentarios,
        lt_tags         TYPE zbt_bug_tag_tbl.

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Mapeamos contra un entity
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  l_id_bug        = persist->get_bug( ).

  l_id_producto   = persist->get_producto( ).
  l_id_componente = persist->get_componente( ).

  lo_producto   = zcl_producto_controller=>find_by_key( l_id_producto ).
  lo_componente = zcl_componente_controller=>find_by_key( producto   = lo_producto
                                                          id         = l_id_componente ).
  CREATE OBJECT entity
    EXPORTING
      id         = l_id_bug
      producto   = lo_producto
      componente = lo_componente.

  l_usuario = persist->get_developer( ).
  IF NOT l_usuario IS INITIAL.
    lo_usuario =  zcl_usuario_controller=>find_by_key( l_usuario ).
    entity->set_developer( lo_usuario ).
  ENDIF.



 l_usuario = persist->get_assigned( ).
  IF NOT l_usuario IS INITIAL.
    lo_usuario =  zcl_usuario_controller=>find_by_key( l_usuario ).
    entity->set_assigned( lo_usuario ).
  ENDIF.

  l_usuario = persist->get_tester( ).
  IF NOT l_usuario IS INITIAL.
    lo_usuario =  zcl_usuario_controller=>find_by_key( l_usuario ).
    entity->set_tester( lo_usuario ).
  ENDIF.

  l_usuario = persist->get_reporter( ).
  IF NOT l_usuario IS INITIAL.
    lo_usuario =  zcl_usuario_controller=>find_by_key( l_usuario ).
    entity->set_reporter( lo_usuario ).
  ENDIF.

  l_usuario = persist->get_aenam( ).
  IF NOT l_usuario IS INITIAL.
    lo_usuario =  zcl_usuario_controller=>find_by_key( l_usuario ).
    entity->set_aenam( lo_usuario ).
  ENDIF.

  l_id_componente = persist->get_componente( ).
  IF NOT l_id_componente IS INITIAL.
    lo_componente = zcl_componente_controller=>find_by_key(
                        id       = l_id_componente
                        producto = lo_producto ).
    entity->set_componente( lo_componente ).
  ENDIF.

  l_id_estado = persist->get_estado( ).
  IF NOT l_id_estado IS INITIAL.
    lo_estado = zcl_estado_controller=>find_by_key( l_id_estado ).
    entity->set_estado( lo_estado ).
  ENDIF.

  l_id_bugtype = persist->get_bugtype( ).
  IF NOT l_id_bugtype IS INITIAL.
    lo_bugtype = zcl_bugtype_controller=>find_by_key( l_id_bugtype ).
    entity->set_bug_type( lo_bugtype ).
  ENDIF.

  l_id_bugstype = persist->get_bugstype( ).
  IF NOT l_id_bugstype IS INITIAL.
    lo_bugstype = zcl_bug_subtype_controller=>find_by_key( bugtype = lo_bugtype
                                                           id = l_id_bugstype ).
    entity->set_bug_subtype( lo_bugstype ).
  ENDIF.

  l_resumen = persist->get_resumen( ).
  entity->set_resumen( l_resumen ).

  l_timestamp = persist->get_creado( ).
  entity->set_creado( l_timestamp ).

  l_id_bug_i      = persist->get_bug_i( ).
  entity->SET_ID_I( l_id_bug_i ).

  l_timestamp = persist->get_aedat( ).
  entity->set_aedat( l_timestamp ).

  l_dats = persist->get_deadline( ).
  entity->set_deadline( l_dats ).

  l_timestamp = persist->get_finalizado( ).
  entity->set_finalizado( l_timestamp ).

  l_horas = persist->get_horas_est( ).
  entity->set_horas_estimadas( l_horas ).

  l_horas = persist->get_horas_rea( ).
  entity->set_horas_reales( l_horas ).

  lt_bugs[] = find_next_bugs( entity ).
  entity->set_next_bugs( lt_bugs ).

  lt_bugs[] = find_prev_bugs( entity ).
  entity->set_prev_bugs( lt_bugs ).

  lt_attachements[] = zcl_attachement_controller=>find_all_bug_attachements( entity ).
  entity->set_attachements( lt_attachements[] ).

  lt_comments[] = zcl_comment_controller=>find_all_bug_comments( bug                 = entity
                                                                 no_section_comments = 'X' ).
  entity->set_comentarios( lt_comments[] ).

  lt_sections[] = zcl_bugsection_controller=>find_all_bug_sections( entity ).
  entity->set_sections( lt_sections[] ).

  lt_transportes[] = zcl_transport_controller=>find_all_bug_transports( entity ).
  entity->set_transports( lt_transportes[] ).

  lt_tags[] = zcl_bug_tag_controller=>find_bug_tags( entity ).
  entity->set_tags( lt_tags[] ).

ENDMETHOD.


METHOD search.
  DATA: lt_bugs     TYPE STANDARD TABLE OF zbt_bug,
        l_bug       TYPE zbt_bug,
        lo_producto TYPE REF TO zcl_producto,
        l_return    TYPE LINE OF zbt_bugs.

  SELECT * FROM zbt_bug INTO TABLE lt_bugs
    up to max_rows ROWS
    WHERE bug         IN bug[]
      and bug_i       IN bug_i[]
      AND producto    IN producto[]
      AND componente  IN componente[]
      AND developer   IN developer[]
      AND assigned    IN assigned[]
      AND tester      IN tester[]
      AND reporter    IN reporter[]
      AND creado      IN creado[]
      AND estado      IN estado[]
      AND bugtype     IN bugtype[]
      AND bugstype    IN bugstype[]
      AND finalizado  IN finalizado[]
      AND deadline    IN deadline[]
      and aedat       in aedat[]
      and aenam       in aenam[].

  LOOP AT lt_bugs INTO l_bug.
    l_return-bug_id      = l_bug-bug.
    l_return-producto_id = l_bug-producto.

    lo_producto = zcl_producto_controller=>find_by_key( l_return-producto_id  ).
    l_return-oref = zcl_bug_controller=>find_by_key( id       = l_return-bug_id
                                                     producto = lo_producto ).

    INSERT l_return INTO TABLE return.
  ENDLOOP.

ENDMETHOD.


METHOD structure_to_entity.

  DATA: lo_producto   TYPE REF TO zcl_producto,
        lo_usuario    TYPE REF TO zcl_usuario,
        lo_componente TYPE REF TO zcl_componente,
        lo_bugtype    TYPE REF TO zcl_bugtype,
        lo_bugstype   TYPE REF TO zcl_bugstype,
        lo_estado     TYPE REF TO zcl_estado.

*  entity->set_id( structure-bug ).

  lo_producto   = zcl_producto_controller=>find_by_key( structure-producto ).
  lo_componente = zcl_componente_controller=>find_by_key( id = structure-componente
                                                          producto = lo_producto ).

  entity->set_producto( lo_producto ).
  entity->set_componente( lo_componente ).
  entity->set_creado( structure-creado ).
  entity->set_finalizado( structure-finalizado ).
  entity->set_deadline( structure-deadline ).

  TRY.
      lo_usuario = zcl_usuario_controller=>find_by_key( structure-reporter ).
      entity->set_reporter( lo_usuario ).
    CATCH zcx_not_found_exception.

  ENDTRY.
  CLEAR lo_usuario.

  TRY .
      lo_usuario = zcl_usuario_controller=>find_by_key( structure-developer ).
      entity->set_developer( lo_usuario ).
    CATCH zcx_not_found_exception.

  ENDTRY.
  CLEAR lo_usuario.

TRY .
      lo_usuario = zcl_usuario_controller=>find_by_key( structure-assigned ).
      entity->set_assigned( lo_usuario ).
    CATCH zcx_not_found_exception.

  ENDTRY.
  CLEAR lo_usuario.

  TRY.
      lo_usuario = zcl_usuario_controller=>find_by_key( structure-tester ).
      entity->set_tester( lo_usuario ).
    CATCH zcx_not_found_exception.

  ENDTRY.
  CLEAR lo_usuario.

  entity->set_resumen( structure-resumen ).

  lo_estado = zcl_estado_controller=>find_by_key( structure-estado ).
  IF lo_estado IS BOUND.
    entity->set_estado( lo_estado ).
  ENDIF.

  entity->set_horas_estimadas( structure-horas_est ).
  entity->set_horas_reales( structure-horas_rea ).

  entity->set_componente( lo_componente ).

  lo_bugtype = zcl_bugtype_controller=>find_by_key( structure-bugtype ).
  entity->set_bug_type( lo_bugtype ).

  lo_bugstype = zcl_bug_subtype_controller=>find_by_key( id = structure-bugstype
                                                         bugtype = lo_bugtype ).
  IF NOT lo_bugstype IS BOUND.
*   If after having changed BugType we found that there's no subtype with same subtype id
*   for the newly selected bugType, we try to obtain default subtype value
    lo_bugstype = zcl_bug_subtype_controller=>find_by_key( id = 0
                                                           bugtype = lo_bugtype ).
  ENDIF.
  entity->set_bug_subtype( lo_bugstype ).

ENDMETHOD.


method UNLOCK.
endmethod.


METHOD update.

  DATA: lo_bug_persist  TYPE REF TO zcl_bug_persist,
        lo_producto     TYPE REF TO zcl_producto,
        l_timestamp     TYPE timestamp,
        l_aedat         TYPE zbt_bug-aedat,
        l_id_bug        TYPE zbt_bug-bug,
        l_id_bug_i      TYPE zbt_bug-bug_i,
        l_id_producto   TYPE zbt_producto-producto,
        lt_attachements TYPE zbt_attachements,
        lt_comentarios  TYPE zbt_comentarios,
        lt_sections     TYPE zbt_bugsections,
        lt_transportes  TYPE zbt_transport_tbl,
        lo_usuario      TYPE REF TO zcl_usuario,
        lo_transaccion  TYPE REF TO zcl_transaction_service,
        lt_tags         TYPE zbt_bug_tag_tbl,
        lt_wrklogs      TYPE ZBT_BUGWRKLOGS,
        lo_exception    TYPE REF TO cx_root.

  FIELD-SYMBOLS:   <attachement> TYPE LINE OF zbt_attachements,
                   <comentario>  TYPE LINE OF zbt_comentarios,
                   <section>     TYPE LINE OF zbt_bugsections,
                   <tag>         TYPE LINE OF zbt_bug_tag_tbl,
                   <transporte>  TYPE LINE OF zbt_transport_tbl,
                   <wrklog>      like LINE OF lt_wrklogs.

  validate_on_update( bug ).

  l_id_bug      = bug->get_id( ).
*  l_id_bug_i    = bug->get_id_i( ).
  lo_producto   = bug->get_producto( ).
  l_id_producto = lo_producto->get_id( ).

  TRY .
*     We look first at what is now the persistence layer
      lo_bug_persist = zca_bug_persist=>agent->get_persistent( i_bug      = l_id_bug
                                                               i_producto = l_id_producto ).

    CATCH cx_os_object_not_found INTO lo_exception.
*     In order to update it must exist
      RAISE EXCEPTION TYPE zcx_update_exception
        EXPORTING
          textid   = zcx_update_exception=>zcx_update_exception
          previous = lo_exception.
  ENDTRY.

  CREATE OBJECT lo_transaccion.
  lo_transaccion->start( ).


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* We proceed to update the rest of the objects
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  TRY .
*     Update Attachments
      lt_attachements[] = bug->get_attachements( ).
      LOOP AT lt_attachements ASSIGNING <attachement>.
*       IF zcl_attachement_controller=>exist( <attachement>-oref ) = abap_true.
        zcl_attachement_controller=>update( <attachement> ).
*       ELSE.
        zcl_attachement_controller=>update( <attachement> ).
*       ENDIF.

      ENDLOOP.
*     Update comments
      lt_comentarios[] = bug->get_comentarios( no_section_comments = space ).
      LOOP AT lt_comentarios ASSIGNING <comentario>.
        IF zcl_comment_controller=>exist( <comentario>-oref ) = abap_true.
          zcl_comment_controller=>update( <comentario>-oref ).
        ELSE.
          zcl_comment_controller=>create( <comentario>-oref ).
        ENDIF.

      ENDLOOP.
*     Update Sections
      lt_sections[] = bug->get_sections( ) .
      LOOP AT lt_sections ASSIGNING <section>.
        IF zcl_bugsection_controller=>exist( <section>-oref ) = abap_true.
          zcl_bugsection_controller=>update( <section>-oref ).
        ELSE.
          zcl_bugsection_controller=>create( <section>-oref ).
        ENDIF.
      ENDLOOP.
*     Update Transports
      lt_transportes[] = bug->get_transports( ).
      LOOP AT lt_transportes ASSIGNING <transporte>.
        IF zcl_transport_controller=>exist( <transporte>-oref ) = abap_true.
          zcl_transport_controller=>update( <transporte>-oref ).
        ELSE.
          zcl_transport_controller=>create( <transporte>-oref ).
        ENDIF.
      ENDLOOP.
*     Update Tags
      lt_tags[] = bug->get_tags( ).
      LOOP AT lt_tags ASSIGNING <tag>.
        IF zcl_bug_tag_controller=>exist( <tag>-oref ) = abap_true.
          zcl_bug_tag_controller=>update( <tag>-oref ).
        ELSE.
          zcl_bug_tag_controller=>create( <tag>-oref ).
        ENDIF.
      ENDLOOP.
      lt_tags[] = bug->get_deleted_tags( ).
      LOOP AT lt_tags ASSIGNING <tag>.
        zcl_bug_tag_controller=>delete( <tag>-oref ).
      ENDLOOP.

*     Update WorkLog
      lt_wrklogs = bug->get_wrklogs( ).
      LOOP AT lt_wrklogs ASSIGNING <wrklog>.
        IF zcl_bug_wrklog_controller=>exists( <wrklog>-oref ) = abap_true.
          zcl_bug_wrklog_controller=>update( <wrklog>-oref ).
        ELSE.
          zcl_bug_wrklog_controller=>create( <wrklog>-oref ).
        ENDIF.
      ENDLOOP.

*     Set ModifyDate
      GET TIME STAMP FIELD l_timestamp.
      l_aedat = l_timestamp.
      bug->set_aedat( l_aedat ).
*     Set ModifyUser
      lo_usuario = zcl_usuario_controller=>find_by_key( ).
      bug->set_aenam( lo_usuario ).

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Mapeamos contra el objeto de persistencia
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      entity_to_persist(
        EXPORTING
          entity  = bug
        CHANGING
          persist = lo_bug_persist ).

      lo_transaccion->end( ).
    CATCH zcx_create_exception INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_update_exception
        EXPORTING
          previous = lo_exception.

  ENDTRY.
ENDMETHOD.


METHOD validate_on_create.
  DATA: l_str_bug      TYPE zbt_bug,
        lt_sections    TYPE zbt_bugsections,
        l_section      TYPE LINE OF zbt_bugsections,
        l_section_ok   TYPE i,
        l_comment_id   TYPE zbt_bugcomment-comentario,
        l_seccion_id   TYPE zbt_bugseccion-seccion,
        lo_estado      TYPE REF TO zcl_estado,
        lo_producto    TYPE REF TO zcl_producto,
        lo_usuario     TYPE REF TO zcl_usuario,
        lo_bugtype     TYPE REF TO zcl_bugtype,
        lo_subtype     TYPE REF TO zcl_bugstype,
        lo_componente  TYPE REF TO zcl_componente,
        l_field        TYPE string,
        lo_not_found   TYPE REF TO zcx_not_found_exception.

  l_str_bug = entity_to_structure( bug ).
  TRY .
*     Campos clave obligatorios!
      IF l_str_bug-bug IS INITIAL.
        l_field = 'Bug Id'(001).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.

      ENDIF.
      IF l_str_bug-bug_i IS INITIAL.
        l_field = 'internal Bug Id'(018).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.

      ENDIF.
      IF l_str_bug-producto IS INITIAL.
        l_field = 'Product Id'(002).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.
      ENDIF.
*     Producto debe existir
      lo_producto = bug->get_producto( ).
      IF zcl_producto_controller=>exist( lo_producto ) IS INITIAL.
        l_field = 'Product'(003).
        RAISE EXCEPTION TYPE zcx_not_found_exception
          EXPORTING
            object = l_field.
      ENDIF.


*     Si se indica un componente éste debe existir
      IF NOT l_str_bug-componente IS INITIAL.
        lo_componente = bug->get_componente( ).
        IF zcl_componente_controller=>exist( lo_componente ) IS INITIAL.
          l_field = 'Component'(004).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     Necesario la persona que da de alta el Bug!
      IF l_str_bug-reporter IS INITIAL.
        l_field = 'Reporter'(005).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.
      ELSE.
*       Reporter debe existir
        lo_usuario = bug->get_reporter( ).
        IF zcl_usuario_controller=>exist( lo_usuario ) IS INITIAL.
          l_field = 'Reporter'(005).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     Si se indica un desarrollador éste debe existir
      IF NOT l_str_bug-developer IS INITIAL.
*       Developer debe existir
        lo_usuario = bug->get_developer( ).
        IF zcl_usuario_controller=>exist( lo_usuario ) IS INITIAL.
          l_field = 'Developer'(006).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     does the assigned user exist?
      IF NOT l_str_bug-assigned IS INITIAL.
*       does the assigned user exist
        lo_usuario = bug->get_assigned( ).
        IF zcl_usuario_controller=>exist( lo_usuario ) IS INITIAL.
          l_field = 'Assigned'(017).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     Si se indica un tester éste debe existir
      IF NOT l_str_bug-tester IS INITIAL.
*       Tester debe existir
        lo_usuario = bug->get_tester( ).
        IF zcl_usuario_controller=>exist( lo_usuario ) IS INITIAL.
          l_field = 'Tester'(007).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     Necesario un estado
      IF l_str_bug-estado IS INITIAL.
        RAISE EXCEPTION TYPE zcx_validate_exception.

      ELSE.
*       Estado debe existir
        lo_estado = bug->get_estado( ).
        IF zcl_estado_controller=>exist( lo_estado ) IS INITIAL.
          l_field = 'Status'(008).
          RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
            EXPORTING
              field = l_field.
        ENDIF.
      ENDIF.

*     Necesario un resumen
      IF l_str_bug-resumen IS INITIAL.
        l_field = 'Short Text'(009).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.
      ENDIF.

*     Necesario un tipo
      IF l_str_bug-bugtype IS INITIAL.
        l_field = 'Bug Type'(010).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.
      ELSE.
*       Tipo debe existir
        lo_bugtype = bug->get_bug_type( ).
        IF zcl_bugtype_controller=>exist( lo_bugtype ) IS INITIAL.
          l_field = 'Bug Type'(010).
          RAISE EXCEPTION TYPE zcx_not_found_exception
            EXPORTING
              object = l_field.
        ENDIF.
      ENDIF.

*     Necesaria una fecha de creación
      IF l_str_bug-creado IS INITIAL.
        l_field = 'Create Time'(011).
        RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
          EXPORTING
            field = l_field.
      ENDIF.

      lt_sections = bug->get_sections( ).
      CASE l_str_bug-bugtype.
        WHEN zcl_bugtype_controller=>bugtype_issue.
*         Si se trata de una incidencia, necesaria una estimación de la importancia
          IF l_str_bug-bugstype IS INITIAL.
            l_field = 'Bug SubType'(012).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
          ELSE.
*           Subtype Debe existir
            lo_subtype = bug->get_bug_subtype( ).
            IF zcl_bug_subtype_controller=>exist( lo_subtype ) IS INITIAL.
              l_field = 'Bug SubType'(012).
              RAISE EXCEPTION TYPE zcx_not_found_exception
                EXPORTING
                  object = l_field.
            ENDIF.
          ENDIF.
*         Necesario haber rellenado las secciones de "Problema detectado" y "Pasos para reproducirlo"
          LOOP AT lt_sections INTO l_section.
            l_seccion_id = l_section-oref->get_id( ).
            IF l_seccion_id = zcl_bugsection_controller=>bugsection_problem
            OR l_seccion_id = zcl_bugsection_controller=>bugsection_steps_reproduce.
              ADD 1 TO l_section_ok.
            ENDIF.
          ENDLOOP.
          IF l_section_ok <> 2.
            l_field = 'Description and Steps to reproduce'(013).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
          ENDIF.
        WHEN zcl_bugtype_controller=>bugtype_enhancement.
*         Wenn dies ein Verbesserung ist, eine Eingabe des Verbesserungtypes is nötig
*         Verhinderung des 0er Statuses
          IF l_str_bug-bugstype IS INITIAL.
            l_field = 'Bug SubType'(012).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
          ELSE.
*           Subtype Debe existir, existiert der Subtype?
            lo_subtype = bug->get_bug_subtype( ).
            IF zcl_bug_subtype_controller=>exist( lo_subtype ) IS INITIAL.
              l_field = 'Bug SubType'(012).
              RAISE EXCEPTION TYPE zcx_not_found_exception
                EXPORTING
                  object = l_field.
            ENDIF.
          ENDIF.
*         Si se trata de una mejora, necesaria una estimación inicial de horas
*         Wenn es eine Verbesserung ist, ist eine erste Einschätzung der erforderlichen Stunden
          IF l_str_bug-horas_est IS INITIAL.
            l_field = 'Estimated Time'(014).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
          ENDIF.
*         Necesario la sección InfoAdicional
*         Erforderliche InfoAdicional Abschnitt
          LOOP AT lt_sections INTO l_section.
            l_seccion_id = l_section-oref->get_id( ).
            IF l_seccion_id = zcl_bugsection_controller=>bugsection_more_info.
              ADD 1 TO l_section_ok.
            ENDIF.
          ENDLOOP.
          IF l_section_ok <> 1.
            l_field = 'Additional Info'(015).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
                      ENDIF.
        WHEN zcl_bugtype_controller=>bugtype_note.
*         Wenn dies ein Hinweis ist, eine Eingabe zur Schwere ist erforderlich
*         Verhinderung des 0er Statuses
          IF l_str_bug-bugstype IS INITIAL.
            l_field = 'Bug SubType'(012).
            RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
              EXPORTING
                field = l_field.
          ELSE.
*           Subtype Debe existir, existiert der Subtype?
            lo_subtype = bug->get_bug_subtype( ).
            IF zcl_bug_subtype_controller=>exist( lo_subtype ) IS INITIAL.
              l_field = 'Bug SubType'(012).
              RAISE EXCEPTION TYPE zcx_not_found_exception
                EXPORTING
                  object = l_field.
            ENDIF.
          ENDIF.
      ENDCASE.

    CATCH zcx_not_found_exception INTO lo_not_found.
      RAISE EXCEPTION TYPE zcx_validate_exception
        EXPORTING
          textid   = zcx_validate_exception=>zcx_validate_exception
          previous = lo_not_found.
  ENDTRY.
ENDMETHOD.


METHOD validate_on_delete.

* Debe existir
  IF exist( bug ) = space.
    RAISE EXCEPTION TYPE zcx_validate_exception.
  ENDIF.

ENDMETHOD.


METHOD validate_on_update.
  DATA: l_str_bug      TYPE zbt_bug,
        l_field        TYPE string,
        lo_estado      TYPE REF TO zcl_estado.

  validate_on_create( bug ).
  l_str_bug = entity_to_structure( bug ).

  lo_estado = bug->get_estado( ).

* Si estado = cerrado -> tiene que tener fecha de cierre
  IF  lo_estado->get_type( ) = zcl_estado_controller=>status_finished
  AND l_str_bug-finalizado IS INITIAL.
    l_field = 'End Date'(016).
    RAISE EXCEPTION TYPE zcx_mandatory_emptyfield
      EXPORTING
        field = l_field.
* A la inversa también
  ELSEIF l_str_bug-finalizado IS NOT INITIAL
     AND lo_estado->get_type( ) <> zcl_estado_controller=>status_finished.
    RAISE EXCEPTION TYPE zcx_validate_exception.
  ENDIF.

* Si estado = cerrado Y bug = mejora -> tiene que tener horas REALES
  IF  lo_estado->get_type( ) = zcl_estado_controller=>status_finished
  AND l_str_bug-bugtype      = zcl_bugtype_controller=>bugtype_enhancement
  AND l_str_bug-horas_rea IS INITIAL.
    RAISE EXCEPTION TYPE zcx_validate_exception.
  ENDIF.

ENDMETHOD.
ENDCLASS.
