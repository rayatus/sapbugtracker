*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROF03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_INITIAL_BUG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LO_BUG  text
*----------------------------------------------------------------------*
FORM create_initial_bug  CHANGING p_bug TYPE REF TO zcl_bug.

  DATA:   lo_estado TYPE REF TO zcl_estado,
          lt_prods  TYPE zbt_productos,
          lo_prod   TYPE REF TO zcl_producto,
          lt_comps  TYPE zbt_componentes,
          lo_comp   TYPE REF TO zcl_componente,
          lo_user   TYPE REF TO zcl_usuario,
          lt_types  TYPE zbt_bugtypes,
          lt_stypes TYPE zbt_bugstypes,
          lo_stype  TYPE REF TO zcl_bugstype,
          lo_type   TYPE REF TO zcl_bugtype.

  lt_prods[] = zcl_producto_controller=>find_all_products( ).
  READ TABLE lt_prods[] INDEX 1 INTO lo_prod.

  lt_comps[] = lo_prod->get_componentes( ).
  READ TABLE lt_comps INDEX 1 INTO lo_comp.

  CREATE OBJECT p_bug
    EXPORTING
      producto   = lo_prod
      id         = c_initial_bug_id
      componente = lo_comp.

  lo_user = zcl_usuario_controller=>find_by_key( ).
  p_bug->set_reporter( lo_user ).

  lo_estado  = zcl_estado_controller=>find_by_key( c_initial_bug_status ).
  p_bug->set_estado( lo_estado ).

  lt_types[] = zcl_bugtype_controller=>find_all_bugtypes( ).
  READ TABLE lt_types INDEX 1 INTO lo_type.
  p_bug->set_bug_type( lo_type ).

  lt_stypes[] = zcl_bugtype_controller=>find_all_bug_subtypes( lo_type ).
  READ TABLE lt_stypes INDEX 1 INTO lo_stype.
  p_bug->set_bug_subtype( lo_stype ).

ENDFORM.                    " CREATE_INITIAL_BUG
