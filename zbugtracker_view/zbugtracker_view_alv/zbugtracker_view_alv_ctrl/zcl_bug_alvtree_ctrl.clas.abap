class ZCL_BUG_ALVTREE_CTRL definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_ALVTREE_CTRL
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !BUG type ref to ZCL_BUG .
  methods DISPLAY .
protected section.
*"* protected components of class ZCL_BUG_ALVTREE_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_ALVTREE_CTRL
*"* do not include other source files here!!!

  data ALV_TREE type ref to CL_SALV_TREE .
  data BUG_HIERARCHY type ZBT_BUGHIEARCHY_TREE_TBL .
  data O_BUG type ref to ZCL_BUG .
  data ALV_TREE_EVENTS type ref to CL_SALV_EVENTS_TREE .

  class CL_GUI_COLUMN_TREE definition load .
  methods ADD_NODE
    importing
      value(DATA) type ZBT_BUGHIEARCHY_TREE_STR
      !RELATIONSHIP type SALV_DE_NODE_RELATION default CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD
      !RELATNODE type SALV_DE_NODE_KEY
    returning
      value(NODE) type ref to CL_SALV_NODE .
  methods BUILD_TREE
    importing
      !BUG type ref to ZCL_BUG
      value(NODE_KEY) type SALV_DE_NODE_KEY optional .
  methods BUILD_HEADER .
  methods BUILD_COLS .
  methods DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TREE
    importing
      !NODE_KEY
      !COLUMNNAME .
ENDCLASS.



CLASS ZCL_BUG_ALVTREE_CTRL IMPLEMENTATION.


METHOD add_node.
  DATA: lo_nodes       TYPE REF TO cl_salv_nodes,
        l_icon         TYPE salv_de_tree_image,
        l_text         TYPE lvc_value.

  lo_nodes = alv_tree->get_nodes( ).

  CALL METHOD lo_nodes->add_node
    EXPORTING
      related_node = relatnode
      relationship = relationship
      data_row     = data
    RECEIVING
      node         = node.

  l_text = data-bug_id.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = l_text
    IMPORTING
      output = l_text.

  node->set_text( l_text ).

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name   = data-estado_icon
      info   = data-estado
    IMPORTING
      result = l_icon.

  node->set_collapsed_icon( l_icon ).
  node->set_expanded_icon( l_icon ).

ENDMETHOD.


METHOD build_cols.
  DATA: lo_cols        TYPE REF TO cl_salv_columns_tree,
        lo_col         TYPE REF TO cl_salv_column.

  lo_cols = alv_tree->get_columns( ).
  lo_cols->set_optimize( abap_true ).

  TRY.
      lo_col = lo_cols->get_column( 'BUG_ID' ).
      lo_col->set_technical( if_salv_c_bool_sap=>true ).

      lo_col = lo_cols->get_column( 'ESTADO_ICON' ).
      lo_col->set_technical( if_salv_c_bool_sap=>true ).

      lo_col = lo_cols->get_column( 'ESTADO' ).
      lo_col->set_technical( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.

ENDMETHOD.


METHOD build_header.
  DATA: settings TYPE REF TO cl_salv_tree_settings,
        title TYPE salv_de_tree_text.

  settings = alv_tree->get_tree_settings( ).
  settings->set_hierarchy_header(  'Bug Hierarchy'(001) ).
  settings->set_hierarchy_tooltip( 'Bug Hierarchy'(001) ).
  settings->set_hierarchy_size( 50 ).
  settings->set_header( 'Bug Hierarchy'(001) ).
ENDMETHOD.


METHOD build_tree.
  DATA: l_relationship TYPE salv_de_node_relation,
        l_node_key     TYPE salv_de_node_key,
        lo_node        TYPE REF TO cl_salv_node,
        lt_bugs        TYPE zbt_bugs,
        l_bug_hier     TYPE LINE OF zbt_bughiearchy_tree_tbl,
        l_bug          TYPE LINE OF zbt_bugs,
        lo_estado      TYPE REF TO zcl_estado.

*  lt_bugs = bug->get_prev_bugs( ).
*  LOOP AT lt_bugs INTO l_bug.
*
*    l_bug_hier-bug_id  = l_bug-oref->get_id( ).
*    l_bug_hier-resumen = l_bug-oref->get_resumen( ).
*    lo_estado = bug->get_estado( ).
*    l_bug_hier-estado = lo_estado->get_descripcion( ).
*    l_bug_hier-estado_icon = lo_estado->get_icon( ).
*
*    lo_node = add_node( data         = l_bug_hier
*                        relatnode    = node_key ).
*    l_node_key = lo_node->get_key( ).
*    build_tree( bug = l_bug-oref
*                node_key = l_node_key ).
*
*  ENDLOOP.

  lt_bugs = lt_bugs = bug->get_next_bugs( ).
  LOOP AT lt_bugs INTO l_bug.

    l_bug_hier-bug_id  = l_bug-oref->get_id( ).
    l_bug_hier-resumen = l_bug-oref->get_resumen( ).
    l_bug_hier-bug     = l_bug-oref.
    lo_estado = l_bug-oref->get_estado( ).
    l_bug_hier-estado = lo_estado->get_descripcion( ).
    l_bug_hier-estado_icon = lo_estado->get_icon( ).

    lo_node = add_node( data         = l_bug_hier
                        relatnode    = node_key ).
    l_node_key = lo_node->get_key( ).
    build_tree( bug = l_bug-oref
                node_key = l_node_key ).

  ENDLOOP.


ENDMETHOD.


METHOD constructor.

  TRY.
      CALL METHOD cl_salv_tree=>factory
        EXPORTING
          r_container = container
        IMPORTING
          r_salv_tree = alv_tree
        CHANGING
          t_table     = bug_hierarchy[].

      alv_tree_events = alv_tree->get_event( ).
      SET HANDLER double_click FOR alv_tree_events.

    CATCH cx_salv_error .
  ENDTRY.

  o_bug = bug.
ENDMETHOD.


METHOD display.
  DATA: lo_node        TYPE REF TO cl_salv_node,
        lo_estado      TYPE REF TO zcl_estado,
        l_node_key     TYPE salv_de_node_key,
        l_bug_hier     TYPE LINE OF zbt_bughiearchy_tree_tbl.


  build_header( ).

  l_bug_hier-bug_id  = o_bug->get_id( ).
  l_bug_hier-resumen = o_bug->get_resumen( ).
  l_bug_hier-bug     = o_bug.
  lo_estado = o_bug->get_estado( ).
  l_bug_hier-estado = lo_estado->get_descripcion( ).
  l_bug_hier-estado_icon = lo_estado->get_icon( ).

  lo_node = add_node( data         = l_bug_hier
                      relatnode    = l_node_key ).
  l_node_key = lo_node->get_key( ).
  lo_node->set_folder( abap_true ).

  build_tree( bug = o_bug node_key = l_node_key ).

  build_cols( ).

  alv_tree->display( ).

ENDMETHOD.


METHOD double_click.
  DATA: o_nodes  TYPE REF TO cl_salv_nodes,
        o_node   TYPE REF TO cl_salv_node,
        l_screen TYPE zbt_screen_popup,
        l_data   TYPE REF TO data.

  FIELD-SYMBOLS <row>   TYPE zbt_bughiearchy_tree_str.

  o_nodes = alv_tree->get_nodes( ).
  o_node  = o_nodes->get_node( node_key ).
  l_data  = o_node->get_data_row( ).
  ASSIGN l_data->* TO <row>.

  l_screen-top  = 1.
  l_screen-left = 1.
  CALL FUNCTION 'ZBT_DISPLAY_BUG'
    EXPORTING
      bug               = <row>-bug
      display_mode      = abap_true
      screen_attributes = l_screen.

ENDMETHOD.
ENDCLASS.
