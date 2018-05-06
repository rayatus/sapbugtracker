class ZCL_BUGTRACKERWDA_CTRL definition
  public
  inheriting from CL_WD_COMPONENT_ASSISTANCE
  final
  create public .

public section.
*"* public components of class ZCL_BUGTRACKERWDA_CTRL
*"* do not include other source files here!!!

  data BUG_HEADER type ZBT_WDA_BUG_HEADER read-only .

  methods CONSTRUCTOR
    importing
      !BUG type ZBT_ID_BUG
      !PRODUCTO type ZBT_ID_PRODUCTO .
  methods SET_BUG_HEADER
    importing
      !BUG_HEADER type ZBT_WDA_BUG_HEADER .
  methods SAVE
    raising
      ZCX_BUGTRACKER_SYSTEM .
  methods DELETE .
protected section.
*"* protected components of class ZCL_BUGTRACKERWDA_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUGTRACKERWDA_CTRL
*"* do not include other source files here!!!

  data O_BUG type ref to ZCL_BUG .

  methods ENTITY_TO_WDA_STRUCTURE .
  methods SEARCH_BUG
    returning
      value(BUG) type ref to ZCL_BUG .
  class-methods WDA_STRUCTURE_TO_ENTITY .
ENDCLASS.



CLASS ZCL_BUGTRACKERWDA_CTRL IMPLEMENTATION.


METHOD constructor.

  super->constructor( ).

  me->bug_header-bug      = bug.
  me->bug_header-producto = producto.

  o_bug = search_bug( ).

  entity_to_wda_structure( ).

ENDMETHOD.


method DELETE.
endmethod.


METHOD entity_to_wda_structure.
  DATA: l_str        TYPE zbt_bug,
        lo_user      TYPE REF TO zcl_usuario,
        lo_component TYPE REF TO zcl_componente,
        lo_estado    TYPE REF TO zcl_estado,
        lo_btype     TYPE REF TO zcl_bugtype,
        lo_bstype    TYPE REF TO zcl_bugstype,
        lo_producto  TYPE REF TO zcl_producto.

  lo_producto = o_bug->get_producto( ).

  l_str = zcl_bug_controller=>entity_to_structure( o_bug ).
  MOVE-CORRESPONDING l_str TO me->bug_header.
  me->bug_header-product_txt     = lo_producto->get_descripcion( ).

  lo_user = o_bug->get_reporter( ).
  IF lo_user IS BOUND.
    me->bug_header-reporter_txt    = lo_user->get_name( ).
  ENDIF.
  lo_user = o_bug->get_developer( ).
  IF lo_user IS BOUND.
    me->bug_header-developer_txt   = lo_user->get_name( ).
  ENDIF.
  lo_user = o_bug->get_tester( ).
  IF lo_user IS BOUND.
    me->bug_header-tester_txt      = lo_user->get_name( ).
  ENDIF.

  lo_estado = o_bug->get_estado( ).
  IF lo_estado IS BOUND.
    me->bug_header-estado_txt      = lo_estado->get_descripcion( ).
    me->bug_header-estado_icon     = lo_estado->get_wdaicon( ).
  ENDIF.

  lo_component = o_bug->get_componente( ).
  IF lo_component IS BOUND.
    me->bug_header-componente_text = lo_component->get_descripcion( ).
  ENDIF.

  lo_btype = o_bug->get_bug_type( ) .
  IF lo_btype IS BOUND.
    me->bug_header-bugtype_txt     = lo_btype->get_descripcion( ).
  ENDIF.

  lo_bstype = o_bug->get_bug_subtype( ).
  IF lo_bstype IS BOUND.
    me->bug_header-bugstype_txt    = lo_bstype->get_descripcion( ).
  ENDIF.

  lo_user = o_bug->get_aenam( ).
  IF lo_user IS BOUND.
    me->bug_header-aenam_txt       = lo_user->get_name( ).
  ENDIF.

ENDMETHOD.


METHOD save.
  DATA: lo_exception TYPE REF TO zcx_bugtracker_system.

  IF zcl_bug_controller=>exist( o_bug ) = abap_true.
    zcl_bug_controller=>update( o_bug  ).
  ELSE.
    zcl_bug_controller=>create( o_bug  ).
  ENDIF.

*  COMMIT WORK AND WAIT.

ENDMETHOD.


METHOD SEARCH_BUG.
  DATA: lt_bugs    TYPE zbt_bugs,
        l_bugs     TYPE LINE OF zbt_bugs,
        r_bug      TYPE zbt_bug_range,
        lr_bug     TYPE LINE OF zbt_bug_range,
        r_product  TYPE zbt_producto_range,
        lr_product TYPE LINE OF zbt_producto_range.


  lr_product-sign   = lr_bug-sign    = 'I'.
  lr_product-option = lr_bug-option  = 'EQ'.
  lr_bug-low        = bug_header-bug.
  lr_product-low    = bug_header-producto.

  lt_bugs = zcl_bug_controller=>search( bug             = r_bug[]
                                        producto        = r_product[] ).

  READ TABLE lt_bugs INDEX 1 INTO l_bugs.
  bug = l_bugs-oref.

ENDMETHOD.


METHOD set_bug_header.
  me->bug_header = bug_header.

  wda_structure_to_entity( ).
ENDMETHOD.


METHOD wda_structure_to_entity.
*
*  DATA:   l_str        TYPE zbt_bug,
*          lo_user      TYPE REF TO zcl_usuario,
*          lo_component TYPE REF TO zcl_componente,
*          lo_estado    TYPE REF TO zcl_estado,
*          lo_btype     TYPE REF TO zcl_bugtype,
*          lo_bstype    TYPE REF TO zcl_bugstype,
*          lo_producto  TYPE REF TO zcl_producto.
*
*  lo_producto = o_bug->get_producto( ).
*
*  l_str = zcl_bug_controller=>entity_to_structure( o_bug ).
*  MOVE-CORRESPONDING l_str TO me->bug_header.
*  me->bug_header-product_txt     = lo_producto->get_descripcion( ).
*
*  lo_user = o_bug->get_reporter( ).
*  IF lo_user IS BOUND.
*    me->bug_header-reporter_txt    = lo_user->get_name( ).
*  ENDIF.
*  lo_user = o_bug->get_developer( ).
*  IF lo_user IS BOUND.
*    me->bug_header-developer_txt   = lo_user->get_name( ).
*  ENDIF.
*  lo_user = o_bug->get_tester( ).
*  IF lo_user IS BOUND.
*    me->bug_header-tester_txt      = lo_user->get_name( ).
*  ENDIF.
*
*  lo_estado = o_bug->get_estado( ).
*  IF lo_estado IS BOUND.
*    me->bug_header-estado_txt      = lo_estado->get_descripcion( ).
*    me->bug_header-estado_icon     = lo_estado->get_wdaicon( ).
*  ENDIF.
*
*  lo_component = o_bug->get_componente( ).
*  IF lo_component IS BOUND.
*    me->bug_header-componente_text = lo_component->get_descripcion( ).
*  ENDIF.
*
*  lo_btype = o_bug->get_bug_type( ) .
*  IF lo_btype IS BOUND.
*    me->bug_header-bugtype_txt     = lo_btype->get_descripcion( ).
*  ENDIF.
*
*  lo_bstype = o_bug->get_bug_subtype( ).
*  IF lo_bstype IS BOUND.
*    me->bug_header-bugstype_txt    = lo_bstype->get_descripcion( ).
*  ENDIF.
*
*  lo_user = o_bug->get_aenam( ).
*  IF lo_user IS BOUND.
*    me->bug_header-aenam_txt       = lo_user->get_name( ).
*  ENDIF.

ENDMETHOD.
ENDCLASS.
