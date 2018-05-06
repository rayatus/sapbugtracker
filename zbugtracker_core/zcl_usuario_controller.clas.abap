class ZCL_USUARIO_CONTROLLER definition
  public
  create public .

*"* public components of class ZCL_USUARIO_CONTROLLER
*"* do not include other source files here!!!
public section.

  class-methods FIND_BY_KEY
    importing
      !ID type XUBNAME default SY-UNAME
    returning
      value(USUARIO) type ref to ZCL_USUARIO
    raising
      ZCX_NOT_FOUND_EXCEPTION .
  class-methods EXIST
    importing
      !USUARIO type ref to ZCL_USUARIO
    returning
      value(RETURN) type FLAG .
protected section.
*"* protected components of class ZCL_USUARIO_CONTROLLER
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_USUARIO_CONTROLLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_USUARIO_CONTROLLER IMPLEMENTATION.


method EXIST.
  DATA: l_id TYPE xubname.

  l_id = usuario->get_id( ).

  TRY .
      zcl_usuario_controller=>find_by_key( l_id ).
      return = 'X'.
    CATCH cx_root.
      return = space.
  ENDTRY.


endmethod.


method FIND_BY_KEY.

  DATA: lo_agent        TYPE REF TO zca_usuario_persist,
        lo_persist      TYPE REF TO zcl_usuario_persist,
        lo_exception    TYPE REF TO cx_root,
        l_string        type string,
        l_developer     TYPE ZBT_IS_developer,
        l_reporter      TYPE ZBT_IS_reporter,
        l_tester        TYPE ZBT_IS_TESTER,
        l_assigned      TYPE ZBT_IS_assigned,
        l_mail          type ZBT_EMAIL.

  lo_agent = zca_usuario_persist=>agent.
  TRY.
      CALL METHOD lo_agent->get_persistent
        EXPORTING
          i_usuario = id
        RECEIVING
          result    = lo_persist.

      l_developer = lo_persist->get_is_developer( ).
      l_reporter  = lo_persist->get_is_reporter( ).
      l_tester    = lo_persist->get_is_tester( ).
      l_assigned  = lo_persist->get_is_assigned( ).
      l_mail      = lo_persist->get_mail( ).
*   Mapeamos contra un entity
      CREATE OBJECT usuario
        EXPORTING
          usuario = id.

      usuario->set_developer( l_developer ).
      usuario->set_reporter( l_reporter ).
      usuario->set_tester( l_tester ).
      usuario->set_assigned( l_assigned ).
      usuario->set_email( l_mail ).

    CATCH cx_os_object_not_found INTO lo_exception.
      l_string = id.
      RAISE EXCEPTION TYPE zcx_not_found_exception
        EXPORTING
          textid   = zcx_not_found_exception=>zcx_not_found_exception
          object   = l_string
          previous = lo_exception.
  ENDTRY.


endmethod.
ENDCLASS.
