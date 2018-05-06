* ----------------------------------------------------------------------
CLASS abap_unit_testclass DEFINITION FOR TESTING     "#AU Duration Medium
     "#AU Risk_Level Harmless
.
* ----------------------------------------------------------------------
* ===============
  PUBLIC SECTION.
* ===============

* ==================
  PROTECTED SECTION.
* ==================

* ================
  PRIVATE SECTION.
* ================
    DATA:
      m_ref TYPE REF TO zcl_bug_controller.                 "#EC NOTEXT

    METHODS: setup.
    METHODS: teardown.
    METHODS: create FOR TESTING.

    METHODS: update FOR TESTING.

    METHODS: delete FOR TESTING.
ENDCLASS.       "Abap_Unit_Testclass
* ----------------------------------------------------------------------
CLASS abap_unit_testclass IMPLEMENTATION.
* ----------------------------------------------------------------------

* ----------------------------------------------------------------------
  METHOD setup.
* ----------------------------------------------------------------------

    CREATE OBJECT m_ref.
  ENDMETHOD.       "Setup

* ----------------------------------------------------------------------
  METHOD teardown.
* ----------------------------------------------------------------------


  ENDMETHOD.       "Teardown

* ----------------------------------------------------------------------
  METHOD create.
* ----------------------------------------------------------------------
    DATA: lo_producto    TYPE REF TO zcl_producto,
          lo_bug         TYPE REF TO zcl_bug,
          lt_componentes TYPE zbt_componentes,
          lt_sections    TYPE zbt_bugsections,
          l_section      TYPE LINE OF zbt_bugsections,
          lo_componente  TYPE REF TO zcl_componente,
          lo_usuario     TYPE REF TO zcl_usuario,
          lo_bugtype     TYPE REF TO zcl_bugtype,
          lo_bugstype    TYPE REF TO zcl_bugstype,
          lo_estado      TYPE REF TO zcl_estado,
          lo_comment     TYPE REF TO zcl_comment,
          lt_comentarios TYPE zbt_comentarios,
          l_comentario_str TYPE LINE OF zbt_comentarios,
          l_comment_id   TYPE zbt_bugcomment-comentario,
          l_resumen      TYPE zbt_bug-resumen,
          l_date(10)     TYPE c,
          l_time(8)      TYPE c,
          l_timestamp    TYPE timestamp,
          l_creado       TYPE zbt_bug-creado,
          l_id_producto  TYPE zbt_producto-producto,
          l_id_bug       TYPE zbt_bug-bug,
          l_id_bug_i     TYPE zbt_bug-bug_i.

    l_id_producto = 1. "GEEC
    lo_producto   = zcl_producto_controller=>find_by_key( l_id_producto ).
    lo_bugtype = zcl_bugtype_controller=>find_by_key( zcl_bugtype_controller=>bugtype_issue ).

*   Assignamos el siguiente ID...
    l_id_bug = zcl_bug_controller=>next_id( producto = lo_producto
                                             bugtype = lo_bugtype ).
*   Un componente...
    lt_componentes[] = lo_producto->get_componentes( ).
    READ TABLE lt_componentes INDEX 1 INTO lo_componente.

*   Instanciamos el objeto
    CREATE OBJECT lo_bug
      EXPORTING
        producto   = lo_producto
        id         = l_id_bug
        componente = lo_componente.

*   A Reporter...
    lo_usuario = zcl_usuario_controller=>find_by_key( ).
    lo_bug->set_reporter( lo_usuario ).

* set internal bug ID
    lo_bug->set_id_i( l_id_bug_i ).

*   Un tipo..
    lo_bug->set_bug_type( lo_bugtype ).

*   Un tipo..
    lo_bug->set_bug_type( lo_bugtype ).

*   Una importancia...
    lo_bugstype = zcl_bug_subtype_controller=>find_by_key( bugtype = lo_bugtype id = 1 ).
    lo_bug->set_bug_subtype( lo_bugstype ).

*   Un estado...
    lo_estado = zcl_estado_controller=>find_by_key( '1' ).
    lo_bug->set_estado( lo_estado ).

*   una fecha de creación
    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.
    lo_bug->set_creado( l_creado ).

*   Un resumen...
    WRITE sy-datum TO l_date.
    WRITE sy-uzeit TO l_time.
    CONCATENATE 'ABAPUnit Create' l_date l_time INTO l_resumen SEPARATED BY space.
    lo_bug->set_resumen( l_resumen ).

*   Una sección - Qué ha pasado
    l_section-producto_id  = l_id_producto.
    l_section-bug_id       = l_id_bug.
*    l_section-bug_id_i     = l_id_bug_i.
    l_section-seccion_id   = zcl_bugsection_controller=>bugsection_problem.

    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.

    ADD 1 TO l_comment_id.
    CREATE OBJECT lo_comment
      EXPORTING
        bug     = lo_bug
        id      = l_comment_id
        usuario = lo_usuario
        erdat   = l_creado
        texto   = 'A problem'.

    CREATE OBJECT l_section-oref
      EXPORTING
        id      = l_section-seccion_id
        bug     = lo_bug
        comment = lo_comment.
    INSERT l_section INTO TABLE lt_sections.

*   Otra sección - Cómo reproducirlo
    l_section-producto_id  = l_id_producto.
    l_section-bug_id       = l_id_bug.
    l_section-seccion_id   = zcl_bugsection_controller=>bugsection_steps_reproduce.

    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.

    ADD 1 TO l_comment_id.
    CREATE OBJECT lo_comment
      EXPORTING
        bug     = lo_bug
        id      = l_comment_id
        usuario = lo_usuario
        erdat   = l_creado
        texto   = 'about steps'.

    CREATE OBJECT l_section-oref
      EXPORTING
        id      = l_section-seccion_id
        bug     = lo_bug
        comment = lo_comment.
    INSERT l_section INTO TABLE lt_sections.
    lo_bug->set_sections( lt_sections ).

*   Creamos un par de comenarios
    ADD 1 TO l_comment_id.
    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.

    CREATE OBJECT lo_comment
      EXPORTING
        bug     = lo_bug
        id      = l_comment_id
        usuario = lo_usuario
        erdat   = l_creado
        texto   = 'Comment No. 1'.
    l_comentario_str-producto_id  = l_id_producto.
    l_comentario_str-bug_id       = l_id_bug.
    l_comentario_str-oref         = lo_comment.
    INSERT l_comentario_str INTO TABLE lt_comentarios[].

    ADD 1 TO l_comment_id.
    GET TIME STAMP FIELD l_timestamp.
    l_creado = l_timestamp.

    CREATE OBJECT lo_comment
      EXPORTING
        bug     = lo_bug
        id      = l_comment_id
        usuario = lo_usuario
        erdat   = l_creado
        texto   = 'Comment 2'.
    l_comentario_str-producto_id  = l_id_producto.
    l_comentario_str-bug_id       = l_id_bug.
    l_comentario_str-oref         = lo_comment.
    INSERT l_comentario_str INTO TABLE lt_comentarios[].
    lo_bug->set_comentarios( lt_comentarios[] ).

*   Creamos el bug en la BBDD
    zcl_bug_controller=>create( lo_bug ).

    COMMIT WORK.
  ENDMETHOD.       "Create



* ----------------------------------------------------------------------
  METHOD update.
* ----------------------------------------------------------------------
    DATA: lo_producto   TYPE REF TO zcl_producto,
          lo_bug        TYPE REF TO zcl_bug,
          l_id_producto TYPE zbt_producto-producto,
          l_id_bug      TYPE zbt_bug-bug,
          l_id_bug_i    type zbt_bug-bug_i,
          l_old_str     TYPE zbt_bug,
          l_new_str     TYPE zbt_bug.

    l_id_producto = 1. "GEEC
    lo_producto   = zcl_producto_controller=>find_by_key( l_id_producto ).

    l_id_bug = 52.
    lo_bug = zcl_bug_controller=>find_by_key( producto = lo_producto
    id = l_id_bug  ).


    l_old_str = zcl_bug_controller=>entity_to_structure( lo_bug ).

    l_old_str-resumen = 'old resumen 1'.
    lo_bug->set_resumen( l_old_str-resumen ).

    zcl_bug_controller=>update( lo_bug ).
    COMMIT WORK AND WAIT.
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Volvemos a consultar la BBDD a ver qé tiene guardado?
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CLEAR lo_bug.
    lo_bug = zcl_bug_controller=>find_by_key( producto = lo_producto
    id = l_id_bug  ).

    l_new_str = zcl_bug_controller=>entity_to_structure( lo_bug ).

    cl_aunit_assert=>assert_equals( act = l_new_str-resumen exp = l_old_str-resumen ).

  ENDMETHOD.       "Update

* ----------------------------------------------------------------------
  METHOD delete.
* ----------------------------------------------------------------------
    DATA: lo_producto   TYPE REF TO zcl_producto,
          l_id_producto TYPE zbt_producto-producto,
          l_exist       TYPE flag,
          l_bug         TYPE LINE OF zbt_bugs,
          lt_bugs       TYPE zbt_bugs.

    l_id_producto = 1. "GEEC
    lo_producto   = zcl_producto_controller=>find_by_key( l_id_producto ).

    lt_bugs = zcl_producto_controller=>find_all_bugs( lo_producto ).
    READ TABLE lt_bugs INDEX 1 INTO l_bug.

    zcl_bug_controller=>delete( l_bug-oref ).
    COMMIT WORK AND WAIT.

*   Ahora no tendría que existir.
    l_exist = zcl_bug_controller=>exist( l_bug-oref ).
    cl_aunit_assert=>assert_equals( act = l_exist exp = space ).

  ENDMETHOD.       "Delete
ENDCLASS.       "Abap_Unit_Testclass
