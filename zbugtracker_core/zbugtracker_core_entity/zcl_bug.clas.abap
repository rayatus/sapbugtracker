class ZCL_BUG definition
  public
  inheriting from ZCL_ENTITY
  final
  create public

  global friends ZCL_BUG_CONTROLLER .

public section.
*"* public components of class ZCL_BUG
*"* do not include other source files here!!!

  methods ADD_COMMENT
    importing
      !COMMENT type ref to ZCL_COMMENT .
  methods CONSTRUCTOR
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO
      !ID type ZBT_BUG-BUG
      !COMPONENTE type ref to ZCL_COMPONENTE .
  methods GET_AEDAT
    returning
      value(RETURN) type ZBT_AEDAT .
  methods GET_AENAM
    returning
      value(RETURN) type ref to ZCL_USUARIO .
  methods GET_ATTACHEMENTS
    returning
      value(RETURN) type ZBT_ATTACHEMENTS .
  methods GET_BUG_SUBTYPE
    returning
      value(RETURN) type ref to ZCL_BUGSTYPE .
  methods GET_BUG_TYPE
    returning
      value(RETURN) type ref to ZCL_BUGTYPE .
  methods GET_COMENTARIOS
    importing
      !NO_SECTION_COMMENTS type FLAG default 'X'
    returning
      value(RETURN) type ZBT_COMENTARIOS .
  methods GET_COMPONENTE
    returning
      value(RETURN) type ref to ZCL_COMPONENTE .
  methods GET_CREADO
    returning
      value(RETURN) type ZBT_BUG-CREADO .
  methods GET_DEADLINE
    returning
      value(RETURN) type ZBT_BUG-DEADLINE .
  methods GET_ASSIGNED
    returning
      value(ASSIGNED) type ref to ZCL_USUARIO .
  methods GET_DEVELOPER
    returning
      value(DEVELOPER) type ref to ZCL_USUARIO .
  methods GET_ESTADO
    returning
      value(RETURN) type ref to ZCL_ESTADO .
  methods GET_FINALIZADO
    returning
      value(RETURN) type ZBT_BUG-FINALIZADO .
  methods GET_HORAS_ESTIMADAS
    returning
      value(RETURN) type ZBT_BUG-HORAS_EST .
  methods GET_HORAS_REALES
    returning
      value(RETURN) type ZBT_BUG-HORAS_REA .
  methods GET_ID
    returning
      value(RETURN) type ZBT_BUG-BUG .
  methods GET_ID_I
    returning
      value(RETURN) type ZBT_BUG-BUG_I .
  methods GET_NEXT_BUGS
    returning
      value(RETURN) type ZBT_BUGS .
  methods GET_PREV_BUGS
    returning
      value(RETURN) type ZBT_BUGS .
  methods GET_PRODUCTO
    returning
      value(RETURN) type ref to ZCL_PRODUCTO .
  methods GET_REPORTER
    returning
      value(REPORTER) type ref to ZCL_USUARIO .
  methods GET_RESUMEN
    returning
      value(RESUMEN) type ZBT_BUG-RESUMEN .
  methods GET_SECTIONS
    returning
      value(RETURN) type ZBT_BUGSECTIONS .
  methods GET_TAGS
    returning
      value(TAGS) type ZBT_BUG_TAG_TBL .
  methods GET_TESTER
    returning
      value(TESTER) type ref to ZCL_USUARIO .
  methods GET_TRANSPORTS
    returning
      value(RETURN) type ZBT_TRANSPORT_TBL .
  methods SET_AEDAT
    importing
      !AEDAT type ZBT_AEDAT .
  methods SET_AENAM
    importing
      !AENAM type ref to ZCL_USUARIO .
  methods SET_ATTACHEMENTS
    importing
      !ATTACHEMENTS type ZBT_ATTACHEMENTS .
  methods SET_BUG_SUBTYPE
    importing
      !SUBTYPE type ref to ZCL_BUGSTYPE .
  methods SET_BUG_TYPE
    importing
      !BUGTYPE type ref to ZCL_BUGTYPE .
  methods SET_COMENTARIOS
    importing
      !COMENTARIOS type ZBT_COMENTARIOS .
  methods SET_COMPONENTE
    importing
      !COMPONENTE type ref to ZCL_COMPONENTE .
  methods SET_CREADO
    importing
      !CREADO type ZBT_BUG-CREADO .
  methods SET_DEADLINE
    importing
      !DEADLINE type ZBT_BUG-DEADLINE .
  methods SET_DEVELOPER
    importing
      !DEVELOPER type ref to ZCL_USUARIO .
  methods SET_ESTADO
    importing
      !ESTADO type ref to ZCL_ESTADO .
  methods SET_FINALIZADO
    importing
      !FINALIZADO type ZBT_BUG-FINALIZADO .
  methods SET_HORAS_ESTIMADAS
    importing
      !HORAS type ZBT_BUG-HORAS_EST .
  methods SET_HORAS_REALES
    importing
      !HORAS type ZBT_BUG-HORAS_REA .
  methods SET_ID
    importing
      !ID type ZBT_BUG-BUG .
  methods SET_ID_I
    importing
      !ID_I type ZBT_BUG-BUG_I .
  methods SET_NEXT_BUGS
    importing
      !NEXT_BUGS type ZBT_BUGS .
  methods SET_PREV_BUGS
    importing
      !PREV_BUGS type ZBT_BUGS .
  methods SET_PRODUCTO
    importing
      !PRODUCTO type ref to ZCL_PRODUCTO .
  methods SET_REPORTER
    importing
      !REPORTER type ref to ZCL_USUARIO .
  methods SET_RESUMEN
    importing
      !RESUMEN type ZBT_BUG-RESUMEN .
  methods SET_SECTIONS
    importing
      !SECCIONES type ZBT_BUGSECTIONS .
  methods SET_TAGS
    importing
      !TAGS type ZBT_BUG_TAG_TBL .
  methods SET_TESTER
    importing
      !TESTER type ref to ZCL_USUARIO .
  methods SET_ASSIGNED
    importing
      !ASSIGNED type ref to ZCL_USUARIO .
  methods SET_TRANSPORTS
    importing
      !TRANSPORTS type ZBT_TRANSPORT_TBL .
  methods GET_WRKLOGS
    returning
      value(WRKLOGS) type ZBT_BUGWRKLOGS .
  methods SET_WRKLOGS
    importing
      !WRKLOGS type ZBT_BUGWRKLOGS .
protected section.
*"* protected components of class ZCL_BUG
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_BUG
*"* do not include other source files here!!!

  data TESTER type ref to ZCL_USUARIO .
  data RESUMEN type ZBT_RESUMEN .
  data REPORTER type ref to ZCL_USUARIO .
  data PRODUCTO type ref to ZCL_PRODUCTO .
  data HORAS_REA type ZBT_HORAS_REALES .
  data HORAS_EST type ZBT_HORAS_ESTIMADAS .
  data FINALIZADO type ZBT_ENDDAT .
  data ESTADO type ref to ZCL_ESTADO .
  data DEVELOPER type ref to ZCL_USUARIO .
  data ASSIGNED type ref to ZCL_USUARIO .
  data DEADLINE type ZBT_DEADLINE .
  data CREADO type ZBT_ERDAT .
  data COMPONENTE type ref to ZCL_COMPONENTE .
  data BUGTYPE type ref to ZCL_BUGTYPE .
  data BUGSTYPE type ref to ZCL_BUGSTYPE .
  data ID type ZBT_ID_BUG .
  data ID_I type ZBT_ID_BUG_I .
  data COMENTARIOS type ZBT_COMENTARIOS .
  data PREV_BUGS type ZBT_BUGS .
  data NEXT_BUGS type ZBT_BUGS .
  data SECCIONES type ZBT_BUGSECTIONS .
  data ATTACHEMENTS type ZBT_ATTACHEMENTS .
  data TRANSPORTS type ZBT_TRANSPORT_TBL .
  data AEDAT type ZBT_AEDAT .
  data AENAM type ref to ZCL_USUARIO .
  data TAGS type ZBT_BUG_TAG_TBL .
  data DELETED_TAGS type ZBT_BUG_TAG_TBL .
  data WRKLOGS type ZBT_BUGWRKLOGS .

  methods GET_DELETED_TAGS
    returning
      value(TAGS) type ZBT_BUG_TAG_TBL .
ENDCLASS.



CLASS ZCL_BUG IMPLEMENTATION.


METHOD add_comment.
  DATA: l_comentario   TYPE LINE OF zbt_comentarios,
        lo_producto    TYPE REF TO zcl_producto,
        l_max_comment  TYPE zbt_id_comentario,
        lt_comentarios TYPE zbt_comentarios.


  lt_comentarios = get_comentarios( no_section_comments = space ).
  SORT lt_comentarios BY comentario_id DESCENDING.
  READ TABLE lt_comentarios INDEX 1 INTO l_comentario.
  l_max_comment = l_comentario-comentario_id + 1.

  CLEAR l_comentario.
  IF comment->get_id( ) IS INITIAL.
    comment->set_id( l_max_comment ).
    ADD 1 TO l_max_comment.
  ENDIF.
  l_comentario-comentario_id = comment->get_id( ).
  lo_producto = get_producto( ).
  l_comentario-producto_id   = lo_producto->get_id( ).
  l_comentario-bug_id        = get_id( ).
  l_comentario-oref          = comment.
  READ TABLE lt_comentarios WITH KEY comentario_id =
l_comentario-comentario_id TRANSPORTING NO FIELDS.
  IF sy-subrc IS INITIAL.
    MODIFY TABLE lt_comentarios FROM l_comentario.
  ELSE.
    INSERT l_comentario INTO TABLE lt_comentarios.
  ENDIF.


  set_comentarios( lt_comentarios ).


ENDMETHOD.


METHOD constructor.
  super->constructor( ).

  me->id       = id.
  me->producto = producto.
  set_componente( componente ).

ENDMETHOD.


METHOD GET_AEDAT.
  return = aedat.
ENDMETHOD.


method GET_AENAM.
  return = aenam.
endmethod.


method GET_ASSIGNED.
  assigned = me->assigned.
endmethod.


method GET_ATTACHEMENTS.
  RETURN = attachements.
endmethod.


METHOD get_bug_subtype.
  return = bugstype.
ENDMETHOD.


method GET_BUG_TYPE.
  return = me->bugtype.
endmethod.


METHOD get_comentarios.
  DATA: lt_sections TYPE         zbt_bugsections,
        l_section   TYPE LINE OF zbt_bugsections,
        l_id        TYPE zbt_bugcomment-comentario,
        lo_comment  TYPE REF TO  zcl_comment,
        lo_section  TYPE REF TO  zcl_bug_section.

  return = comentarios.

* No mostramos los comentarios de las secciones
  IF NOT no_section_comments IS INITIAL.
    lt_sections = get_sections( ).
    LOOP AT lt_sections INTO l_section.
      lo_comment = l_section-oref->get_comment( ).
      l_id = lo_comment->get_id( ).
      DELETE return WHERE comentario_id = l_id.
    ENDLOOP.
  ENDIF.
ENDMETHOD.


method GET_COMPONENTE.
  RETURN = me->componente.
endmethod.


method GET_CREADO.
  RETURN = me->creado.
endmethod.


method GET_DEADLINE.
  return = me->deadline.
endmethod.


method GET_DELETED_TAGS.
  tags = deleted_tags.
endmethod.


method GET_DEVELOPER.
  developer = me->developer.
endmethod.


method GET_ESTADO.

  return = me->estado.

endmethod.


method GET_FINALIZADO.
  return = me->finalizado.
endmethod.


method GET_HORAS_ESTIMADAS.
  return = me->horas_est.
endmethod.


method GET_HORAS_REALES.
  return = me->horas_rea.
endmethod.


method GET_ID.
  return = id.
endmethod.


method GET_ID_I.
  return = me->id_i.
endmethod.


method GET_NEXT_BUGS.
  return = next_bugs.
endmethod.


method GET_PREV_BUGS.
  return = prev_bugs.
endmethod.


method GET_PRODUCTO.
  return = me->producto.
endmethod.


method GET_REPORTER.
  reporter = me->reporter.
endmethod.


method GET_RESUMEN.
  resumen = me->resumen.
endmethod.


method GET_SECTIONS.
  return = secciones.
endmethod.


METHOD get_tags.
  tags[] = me->tags[].
ENDMETHOD.


method GET_TESTER.
  tester = me->tester.
endmethod.


method GET_TRANSPORTS.
  RETURN = transports.
endmethod.


METHOD GET_WRKLOGS.
  wrklogs = me->wrklogs.
ENDMETHOD.


METHOD prepare_hash_structure.
  DATA: str         TYPE zbt_bug,
        lt_comments TYPE zbt_comentarios,
        lt_bugs     TYPE zbt_bugs,
        lt_sections TYPE zbt_bugsections,
        lt_tags     TYPE zbt_bug_tag_tbl,
        lt_transport TYPE zbt_transport_tbl,
        l_transport  TYPE LINE OF zbt_transport_tbl,
        l_tag       TYPE LINE OF zbt_bug_tag_tbl,
        l_section   TYPE LINE OF zbt_bugsections,
        l_bug       TYPE LINE OF zbt_bugs,
        l_hash      TYPE hash160,
        l_comment   TYPE LINE OF zbt_comentarios,
        value       TYPE LINE OF zbt_objectvalue_hash_calcul,
        i           TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.

  CALL METHOD zcl_bug_controller=>entity_to_structure
    EXPORTING
      entity    = me
    RECEIVING
      structure = str.

  DO.
    ADD 1 TO i.
    ASSIGN COMPONENT i OF STRUCTURE str TO <field>.
    IF sy-subrc IS INITIAL.
      value = <field>.
      SHIFT value LEFT DELETING LEADING space.
      INSERT value INTO TABLE values[].
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.

  lt_comments[] = get_comentarios( ).
  LOOP AT lt_comments INTO l_comment.
    l_hash = l_comment-oref->get_hash( ).
    value = l_hash.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.

* Only is necessary to check relations, not the whole previous/next_bug
  lt_bugs = get_next_bugs( ).
  LOOP AT lt_bugs INTO l_bug.
    CONCATENATE l_bug-producto_id l_bug-bug_id INTO value.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.
  lt_bugs = get_prev_bugs( ).
  LOOP AT lt_bugs INTO l_bug.
    CONCATENATE l_bug-producto_id l_bug-bug_id INTO value.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.

  lt_sections[] = get_sections( ).
  LOOP AT lt_sections INTO l_section.
    l_hash = l_section-oref->get_hash( ).
    value = l_hash.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.

  lt_tags[] = get_tags( ).
  LOOP AT lt_tags INTO l_tag.
    l_hash = l_tag-oref->get_hash( ).
    value = l_hash.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.

  lt_transport = get_transports( ).
  LOOP AT lt_transport INTO l_transport.
    l_hash = l_transport-oref->get_hash( ).
    value = l_hash.
    SHIFT value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].
  ENDLOOP.

ENDMETHOD.


method SET_AEDAT.
  me->aedat = aedat.
endmethod.


method SET_AENAM.
  me->aenam = aenam.
endmethod.


method SET_ASSIGNED.
  me->assigned = assigned.
endmethod.


method SET_ATTACHEMENTS.
  me->attachements = attachements.
endmethod.


METHOD set_bug_subtype.
  me->bugstype = subtype.
ENDMETHOD.


METHOD set_bug_type.
  me->bugtype = bugtype.
ENDMETHOD.


method SET_COMENTARIOS.
  me->comentarios = comentarios.
endmethod.


method SET_COMPONENTE.
  me->componente = componente.
endmethod.


method SET_CREADO.
  me->creado = creado.
endmethod.


method SET_DEADLINE.
  me->deadLine = deadline.
endmethod.


method SET_DEVELOPER.
  me->developer = developer.
endmethod.


METHOD set_estado.
  me->estado = estado.
ENDMETHOD.


method SET_FINALIZADO.
  me->finalizado = finalizado.
endmethod.


method SET_HORAS_ESTIMADAS.
  me->horas_est = horas.
endmethod.


method SET_HORAS_REALES.
  me->horas_rea = horas.
endmethod.


method SET_ID.
  me->id = id.
endmethod.


method SET_ID_I.
  me->id_i = id_i.
endmethod.


method SET_NEXT_BUGS.
  me->next_bugs = next_bugs.
endmethod.


method SET_PREV_BUGS.
  me->prev_bugs = prev_bugs.
endmethod.


METHOD set_producto.
  me->producto = producto.
ENDMETHOD.


method SET_REPORTER.
  me->reporter = reporter.
endmethod.


method SET_RESUMEN.
  me->resumen = resumen.
endmethod.


METHOD set_sections.
  DATA: l_seccion      TYPE LINE OF zbt_bugsections,
        lo_comment     TYPE REF TO zcl_comment.


  IF secciones[] <> me->secciones[].
    LOOP AT secciones INTO l_seccion.
      lo_comment = l_seccion-oref->get_comment( ).
      add_comment( lo_comment ).
    ENDLOOP.
  ENDIF.

  me->secciones = secciones.
ENDMETHOD.


METHOD set_tags.
  DATA: l_tag TYPE LINE OF zbt_bug_tag_tbl.

  LOOP AT me->tags INTO l_tag.
    READ TABLE tags WITH KEY tag = l_tag-tag TRANSPORTING NO FIELDS.
    IF NOT sy-subrc IS INITIAL.
      INSERT l_tag INTO TABLE deleted_tags.
    ENDIF.
  ENDLOOP.

  LOOP AT tags[] INTO l_tag.
    DELETE deleted_tags WHERE tag = l_tag-tag.
  ENDLOOP.

  me->tags[] = tags[].
ENDMETHOD.


method SET_TESTER.
  me->tester = tester.
endmethod.


method SET_TRANSPORTS.
  me->transports = transports.
endmethod.


METHOD set_wrklogs.
  me->wrklogs = wrklogs.
ENDMETHOD.
ENDCLASS.
