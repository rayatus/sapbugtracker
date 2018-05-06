class ZCL_COMMENT_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_COMMENT_CONTROLLER
*"* do not include other source files here!!!
public section.

  class-methods CREATE
    importing
      !COMMENT type ref to ZCL_COMMENT
    raising
      ZCX_CREATE_EXCEPTION .
  class-methods DELETE
    importing
      !COMMENT type ref to ZCL_COMMENT
    raising
      ZCX_DELETE_EXCEPTION .
  class-methods ENTITY_TO_STRUCTURE
    importing
      !ENTITY type ref to ZCL_COMMENT
    returning
      value(STRUCTURE) type ZBT_BUGCOMMENT .
  class-methods EXIST
    importing
      !COMENTARIO type ref to ZCL_COMMENT
    returning
      value(RETURN) type FLAG .
  class-methods FIND_ALL_BUG_COMMENTS
    importing
      !BUG type ref to ZCL_BUG
      !NO_SECTION_COMMENTS type FLAG default 'X'
    returning
      value(RESULT) type ZBT_COMENTARIOS
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods FIND_BY_KEY
    importing
      !ID type ZBT_BUGCOMMENT-COMENTARIO
      !BUG type ref to ZCL_BUG
    returning
      value(ENTITY) type ref to ZCL_COMMENT
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods UPDATE
    importing
      !COMMENT type ref to ZCL_COMMENT
    raising
      ZCX_UPDATE_EXCEPTION .
protected section.
*"* protected components of class ZCL_COMMENT_CONTROLLER
*"* do not include other source files here!!!

  class-methods PERSIST_TO_ENTITY
    importing
      !PERSIST type ref to ZCL_BUGCOMMENT_PERSIST
      value(BUG) type ref to ZCL_BUG optional
    returning
      value(ENTITY) type ref to ZCL_COMMENT
    raising
      ZCX_VALIDATE_EXCEPTION .
private section.
*"* private components of class ZCL_COMMENT_CONTROLLER
*"* do not include other source files here!!!

  class-methods ENTITY_TO_PERSIST
    importing
      !ENTITY type ref to ZCL_COMMENT
    returning
      value(PERSIST) type ref to ZCL_BUGCOMMENT_PERSIST .
  class-methods NEXT_ID
    importing
      !BUG type ref to ZCL_BUG
    returning
      value(ID) type ZBT_BUGCOMMENT-COMENTARIO .
ENDCLASS.



CLASS ZCL_COMMENT_CONTROLLER IMPLEMENTATION.


METHOD create.
  DATA: lo_exception TYPE REF TO cx_root,
        lo_bug       TYPE REF TO zcl_bug,
        lo_transaccion TYPE REF TO zcl_transaction_service,
        l_str        TYPE zbt_bugcomment.

  TRY .
      l_str = entity_to_structure( comment ).

      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      zca_bugcomment_persist=>agent->create_persistent(
        i_bug        = l_str-bug
        i_comentario = l_str-comentario
        i_producto   = l_str-producto
        i_erdat      = l_str-erdat
        i_texto      = l_str-texto
        i_usuario    = l_str-usuario
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
  DATA: lo_exception TYPE REF TO cx_root,
        lo_transaccion TYPE REF TO zcl_transaction_service,
        l_str        TYPE zbt_bugcomment.

  TRY .
      l_str = entity_to_structure( comment ).
      lo_transaccion->start( ).
      zca_bugcomment_persist=>agent->delete_persistent(
        i_bug = l_str-bug
        i_comentario = l_str-comentario
        i_producto = l_str-producto
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
  DATA: l_str TYPE zbt_bugcomment.

  l_str = zcl_comment_controller=>entity_to_structure( entity ).

  persist = zca_bugcomment_persist=>agent->get_persistent(
              i_bug         = l_str-bug
              i_comentario  = l_str-comentario
              i_producto    = l_str-producto
            ).

  persist->set_erdat( l_str-erdat ).
  persist->set_texto( l_str-texto ).
  persist->set_usuario( l_str-usuario ).


endmethod.


method ENTITY_TO_STRUCTURE.
  DATA: lo_bug      TYPE REF TO zcl_bug,
        lo_producto TYPE REF TO zcl_producto,
        lo_user     TYPE REF TO zcl_usuario.

  lo_bug      = entity->get_bug( ).
  lo_producto = lo_bug->get_producto( ).
  lo_user     = entity->get_usuario( ).

  structure-producto   = lo_producto->get_id( ).
  structure-bug        = lo_bug->get_id( ).
  structure-comentario = entity->get_id( ).
  structure-usuario    = lo_user->get_id( ).
  structure-texto      = entity->get_texto( ).
  structure-erdat      = entity->get_erdat( ).

endmethod.


method EXIST.
  DATA: l_id   TYPE zbt_bugcomment-comentario,
        lo_bug TYPE REF TO zcl_bug.

  TRY .
      l_id   = comentario->get_id( ).
      lo_bug = comentario->get_bug( ).
      zcl_comment_controller=>find_by_key( id  = l_id
                                           bug = lo_bug ).
      return = 'X'.
    CATCH cx_root .
      return = space.
  ENDTRY.
endmethod.


method FIND_ALL_BUG_COMMENTS.

  TYPES: BEGIN OF ltype_section_comment,
          comment_id TYPE zbt_id_comentario,
         END   OF ltype_section_comment.

  TYPES: ltype_secion_comment_tbl TYPE HASHED TABLE OF ltype_section_comment WITH UNIQUE KEY comment_id.

  DATA:    lo_qm                  TYPE REF TO if_os_query_manager,
           lo_q                   TYPE REF TO if_os_query,
           lo_producto            TYPE REF TO zcl_producto,
           lo_comment             TYPE REF TO zcl_comment,
           lt_comment_persist     TYPE osreftab,
           lo_comment_persist     TYPE REF TO zcl_bugcomment_persist,
           lo_usuario             TYPE REF TO zcl_usuario,
           l_texto                TYPE zbt_texto_largo,
           l_erdat                TYPE zbt_erdat,
           l_id_usuario           TYPE xubname,
           lt_sections            TYPE zbt_bugsections,
           l_section              TYPE LINE OF zbt_bugsections,
           lt_section_comments    TYPE ltype_secion_comment_tbl,
           l_section_comment      TYPE LINE OF ltype_secion_comment_tbl,
           l_result               TYPE LINE OF zbt_comentarios.

  FIELD-SYMBOLS: <osref> TYPE osref.

  l_result-bug_id      = bug->get_id( ).
  lo_producto          = bug->get_producto( ).
  l_result-producto_id = lo_producto->get_id( ).

* Montamos una query para obtener las secciones de un bug
  lo_qm = cl_os_system=>get_query_manager( ).
  lo_q  = lo_qm->create_query( i_filter = 'PRODUCTO = PAR1 AND BUG = PAR2 ' ).

  lt_comment_persist[] = zca_bugcomment_persist=>agent->if_os_ca_persistency~get_persistent_by_query(
                 i_query   = lo_q
                 i_par1    = l_result-producto_id
                 i_par2    = l_result-bug_id ).

  LOOP AT lt_comment_persist ASSIGNING <osref>.
    AT FIRST.
      IF NOT no_section_comments IS INITIAL.
*       Buscamos las secciones del bug para "eliminar" los comentarios correspondientes a una sección
        lt_sections[] = zcl_bugsection_controller=>find_all_bug_sections( bug ).
        LOOP AT lt_sections INTO l_section.
          lo_comment = l_section-oref->get_comment( ).
          l_section_comment-comment_id = lo_comment->get_id( ).
*         Obtenemos los id's de comentarios utilizados por las secciones
          INSERT l_section_comment INTO TABLE lt_section_comments[].
        ENDLOOP.

      ENDIF.
    ENDAT.
    lo_comment_persist ?= <osref>.

    l_result-comentario_id = lo_comment_persist->get_comentario( ).

*   Es un comentario de una sección?
    READ TABLE lt_section_comments[] WITH TABLE KEY comment_id = l_result-comentario_id
      TRANSPORTING NO FIELDS.
    IF NOT sy-subrc IS INITIAL.
      l_texto                = lo_comment_persist->get_texto( ).
      l_erdat                = lo_comment_persist->get_erdat( ).
      l_id_usuario           = lo_comment_persist->get_usuario( ).

      lo_usuario   = zcl_usuario_controller=>find_by_key( l_id_usuario ).

      CREATE OBJECT lo_comment
        EXPORTING
          bug     = bug
          id      = l_result-comentario_id
          usuario = lo_usuario
          erdat   = l_erdat
          texto   = l_texto.

      l_result-oref = lo_comment.
      INSERT l_result INTO TABLE result[].
    ENDIF.
  ENDLOOP.

endmethod.


method FIND_BY_KEY.

  DATA: l_bug_id      TYPE zbt_id_bug,
        lo_persist    TYPE REF TO zcl_bugcomment_persist,
        lo_producto   TYPE REF TO zcl_producto,
        lo_exception  TYPE REF TO cx_root,
        l_producto_id TYPE zbt_id_producto.

  TRY .
      l_bug_id = bug->get_id( ).
      lo_producto = bug->get_producto( ).
      l_producto_id = lo_producto->get_id( ).

      lo_persist = zca_bugcomment_persist=>agent->get_persistent( i_bug        = l_bug_id
                                                                  i_comentario = id
                                                                  i_producto   = l_producto_id ).
      entity = persist_to_entity( persist = lo_persist
                                  bug     = bug ).

    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          previous = lo_exception.
  ENDTRY.

endmethod.


method NEXT_ID.
  TYPES: BEGIN OF ltype_comment_bug,
          bug_id      TYPE zbt_id_bug,
          comment_id  TYPE zbt_id_comentario,
         END   OF ltype_comment_bug.

  TYPES: ltype_table_comment_bug TYPE HASHED TABLE OF ltype_comment_bug WITH UNIQUE KEY bug_id.

  DATA: l_bug_id       TYPE zbt_id_bug,
        lt_comment_bug TYPE ltype_table_comment_bug ,
        lt_comments    TYPE zbt_comentarios.

  FIELD-SYMBOLS: <comment_bug> TYPE LINE OF ltype_table_comment_bug .

  l_bug_id = bug->get_id( ).
  READ TABLE lt_comment_bug WITH TABLE KEY bug_id = l_bug_id ASSIGNING <comment_bug>.
  IF NOT sy-subrc IS INITIAL.
    INSERT INITIAL LINE INTO TABLE lt_comment_bug ASSIGNING <comment_bug>.
    <comment_bug>-bug_id = l_bug_id.
    TRY.
        lt_comments[] = zcl_comment_controller=>find_all_bug_comments( bug ).
        DESCRIBE TABLE lt_comments LINES <comment_bug>-comment_id.
      CATCH zcx_not_found_exception .
    ENDTRY.
  ENDIF.

  ADD 1 TO <comment_bug>-bug_id.

  id = <comment_bug>-comment_id.

endmethod.


method PERSIST_TO_ENTITY.
  DATA: lo_producto TYPE REF TO zcl_producto,
        lo_usuario  TYPE REF TO zcl_usuario,
        l_producto  TYPE zbt_id_producto,
        l_usuario   TYPE xubname,
        l_erdat     TYPE zbt_erdat,
        l_texto     TYPE zbt_texto_largo,
        l_comment_id TYPE zbt_id_comentario,
        l_bug_id    TYPE zbt_id_bug,
        l_bug_id_i  type zbt_id_bug_i.

  l_comment_id  = persist->get_comentario( ).
  l_usuario     = persist->get_usuario( ).
  l_bug_id      = persist->get_bug( ).
*  l_bug_id_i    = persist->get_bug_i( ).
  l_producto    = persist->get_producto( ).
  l_erdat       = persist->get_erdat( ).
  l_texto       = persist->get_texto( ).

  IF NOT bug IS BOUND.
    lo_producto = zcl_producto_controller=>find_by_key( l_producto ).
    bug         = zcl_bug_controller=>find_by_key( id       = l_bug_id
*                                                   id_i     = l_bug_id_i
                                                   producto = lo_producto ).
  ELSEIF l_bug_id <> bug->get_id( ).
    RAISE EXCEPTION TYPE zcx_validate_exception.
  ELSE.
    lo_producto = bug->get_producto( ).
    IF lo_producto->get_id( ) <> l_producto.
      RAISE EXCEPTION TYPE zcx_validate_exception.
    ENDIF.
  ENDIF.
  lo_usuario = zcl_usuario_controller=>find_by_key( l_usuario ).

  CREATE OBJECT entity
    EXPORTING
      bug     = bug
      id      = l_comment_id
      usuario = lo_usuario
      erdat   = l_erdat
      texto   = l_texto.


endmethod.


METHOD update.
  DATA: lo_exception TYPE REF TO cx_root,
        lo_transaccion TYPE REF TO zcl_transaction_service,
        lo_persist   TYPE REF TO zcl_bugcomment_persist.

  TRY .
      CREATE OBJECT lo_transaccion.
      lo_transaccion->start( ).

      lo_persist = entity_to_persist( comment ).

      lo_transaccion->end( ).
    CATCH cx_root INTO lo_exception.
      RAISE EXCEPTION TYPE zcx_update_exception
        EXPORTING
          textid   = zcx_update_exception=>zcx_update_exception
          previous = lo_exception.
  ENDTRY.

ENDMETHOD.
ENDCLASS.
