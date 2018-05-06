class ZCL_BUG_OBJECTS_ALV_CTRL definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_BUG_OBJECTS_ALV_CTRL
*"* do not include other source files here!!!
  type-pools TRWBO .

  methods CONSTRUCTOR
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER
      !BUG type ref to ZCL_BUG .
  methods GET_OBJECTS
    returning
      value(CONTENT) type ZBT_BUG_OBJECT_ALV_TBL .
  methods DISPLAY .
protected section.
*"* protected components of class ZCL_BUG_OBJECTS_ALV_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_BUG_OBJECTS_ALV_CTRL
*"* do not include other source files here!!!

  data O_GRID type ref to CL_SALV_TABLE .
  data O_CONTAINER type ref to CL_GUI_CONTAINER .
  data O_BUG type ref to ZCL_BUG .
  data OBJECTS type ZBT_BUG_OBJECT_ALV_TBL .

  methods RETRIEVE_OBJECTS .
ENDCLASS.



CLASS ZCL_BUG_OBJECTS_ALV_CTRL IMPLEMENTATION.


METHOD constructor.

  o_container = container.
  o_bug       = bug.

  retrieve_objects( ).

ENDMETHOD.


METHOD display.
  DATA: lo_cols     TYPE REF TO cl_salv_columns_table,
        lo_col      TYPE REF TO cl_salv_column,
        lo_fcodes   TYPE REF TO cl_salv_functions_list,
        l_title     TYPE lvc_title,
        lo_settings TYPE REF TO cl_salv_display_settings.


  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
          r_container  = o_container
        IMPORTING
          r_salv_table = o_grid
        CHANGING
          t_table      = objects[].

      lo_cols = o_grid->get_columns( ).
      lo_cols->set_optimize( ).

      lo_col = lo_cols->get_column( 'COUNTER' ).
      lo_col->SET_SHORT_TEXT( 'Counter'(G04) ).
lo_col->SET_MEDIUM_TEXT( 'Count TR-Entries'(G05) ).
lo_col->SET_LONG_TEXT( 'Count of Transport Entries'(G06) ).

*      lo_col->set_technical( 'X' ).

      lo_settings = o_grid->get_display_settings( ).
      lo_settings->set_striped_pattern( 'X' ).
      l_title = 'Overwiew/Content of Transport Request(s)'(001).
      lo_settings->set_list_header( l_title ).

      lo_fcodes = o_grid->get_functions( ).
      lo_fcodes->set_all( 'X' ).

      o_grid->display( ).
    CATCH cx_salv_msg .

  ENDTRY.

ENDMETHOD.


METHOD get_objects.
  content[] = objects[].
ENDMETHOD.


METHOD retrieve_objects.
  DATA: l_request      TYPE trwbo_request,
        lt_transports  TYPE zbt_transport_tbl,
        l_tr           TYPE LINE OF zbt_transport_tbl,
        l_alv_object   TYPE LINE OF zbt_bug_object_alv_tbl,
        l_object       TYPE LINE OF tr_objects,
        l_key          TYPE LINE OF tr_keys,
        lt_objects     TYPE tr_objects,
        lt_keys        TYPE tr_keys.

  CLEAR objects.

  lt_transports[] = o_bug->get_transports( ) .

  LOOP AT lt_transports INTO l_tr.
    CLEAR: l_request.

    l_request-h-trkorr = l_tr-oref->get_id( ).
    CALL FUNCTION 'TRINT_READ_REQUEST_HEADER'
      EXPORTING
        iv_read_e070   = 'X'
        iv_read_e07t   = 'X'
        iv_read_e070c  = 'X'
        iv_read_e070m  = 'X'
      CHANGING
        cs_request     = l_request-h
      EXCEPTIONS
        empty_trkorr   = 1
        not_exist_e070 = 2
        OTHERS         = 3.
    case sy-subrc.
      when 1.
        clear l_alv_object.
        l_alv_object-trkorr   = L_TR-TRANSPORT_ID.
        l_alv_object-as4text  = 'Empty Transport Request'(G01).
        COLLECT l_alv_object INTO objects.
*        RETURN.
      when 2.
        clear l_alv_object.
        l_alv_object-trkorr   = L_TR-TRANSPORT_ID.
        l_alv_object-as4text  = 'Transport Request does not exist in E070'(G02).
        COLLECT l_alv_object INTO objects.
*        RETURN.
      when 3.
        clear l_alv_object.
        l_alv_object-trkorr   = L_TR-TRANSPORT_ID.
        l_alv_object-as4text  = 'Other Error with Transport Request'(G03).
        COLLECT l_alv_object INTO objects.
*        RETURN.
      when others.

        CALL FUNCTION 'TR_GET_OBJECTS_OF_REQ_AN_TASKS'
          EXPORTING
            is_request_header      = l_request-h
            iv_condense_objectlist = 'X'
          IMPORTING
            et_objects             = l_request-objects
            et_keys                = l_request-keys
          EXCEPTIONS
            invalid_input          = 1
            OTHERS                 = 2.

clear: lt_objects, lt_objects[] , lt_keys, lt_keys[] .

        INSERT LINES OF l_request-objects INTO TABLE lt_objects.
        INSERT LINES OF l_request-keys    INTO TABLE lt_keys.



        LOOP AT lt_objects INTO l_object.
          MOVE-CORRESPONDING l_object TO l_alv_object.
          l_alv_object-trkorr   = l_request-h-trkorr.
          l_alv_object-as4text  = l_request-h-as4text.
          l_alv_object-trstatus = l_request-h-trstatus.
          l_alv_object-as4user  = l_request-h-as4user.
          l_alv_object-objname  = l_object-obj_name.
          COLLECT l_alv_object INTO objects.
        ENDLOOP.

        LOOP AT lt_keys INTO l_key.
          MOVE-CORRESPONDING l_key TO l_alv_object.
          l_alv_object-trkorr   = l_request-h-trkorr.
          l_alv_object-as4text  = l_request-h-as4text.
          l_alv_object-trstatus = l_request-h-trstatus.
          l_alv_object-as4user  = l_request-h-as4user.
          COLLECT l_alv_object INTO objects.
        ENDLOOP.

    ENDCASE.

  ENDLOOP.
  clear: l_alv_object .
*  BREAK-POINT.
  loop at objects into l_alv_object .
    l_alv_object-COUNTER = sy-tabix.
    modify objects from l_alv_object .
  endloop.

ENDMETHOD.
ENDCLASS.
