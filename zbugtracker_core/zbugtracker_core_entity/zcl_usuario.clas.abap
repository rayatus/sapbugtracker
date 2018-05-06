class ZCL_USUARIO definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_USUARIO
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !USUARIO type ZBT_USUARIO-USUARIO optional .
  methods GET_EMAIL
    returning
      value(RETURN) type ZBT_USUARIO-MAIL .
  methods IS_ASSIGNED
    returning
      value(RETURN) type ZBT_USUARIO-IS_ASSIGNED .
  methods IS_DEVELOPER
    returning
      value(RETURN) type ZBT_USUARIO-IS_DEVELOPER .
  methods IS_REPORTER
    returning
      value(RETURN) type ZBT_USUARIO-IS_REPORTER .
  methods IS_TESTER
    returning
      value(RETURN) type ZBT_USUARIO-IS_TESTER .
  methods SET_DEVELOPER
    importing
      !DEVELOPER type ZBT_USUARIO-IS_DEVELOPER .
  methods SET_ASSIGNED
    importing
      !ASSIGNED type ZBT_USUARIO-IS_ASSIGNED .
  methods SET_EMAIL
    importing
      !EMAIL type ZBT_USUARIO-MAIL .
  methods SET_REPORTER
    importing
      !REPORTER type ZBT_USUARIO-IS_REPORTER .
  methods SET_TESTER
    importing
      !TESTER type ZBT_USUARIO-IS_TESTER .
  methods GET_ID
    returning
      value(RESULT) type ZBT_USUARIO-USUARIO .
  methods GET_NAME
    returning
      value(NAME) type STRING .
protected section.
*"* protected components of class ZCL_USUARIO
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_USUARIO
*"* do not include other source files here!!!

  data USUARIO type ZBT_USUARIO-USUARIO .
  data REPORTER type ZBT_USUARIO-IS_REPORTER .
  data TESTER type ZBT_USUARIO-IS_TESTER .
  data DEVELOPER type ZBT_USUARIO-IS_DEVELOPER .
  data ASSIGNED type ZBT_USUARIO-IS_ASSIGNED .
  data MAIL type ZBT_USUARIO-MAIL .
ENDCLASS.



CLASS ZCL_USUARIO IMPLEMENTATION.


METHOD constructor.
  super->constructor( ).
  me->usuario = usuario.
ENDMETHOD.


method GET_EMAIL.
  RETURN = me->mail.
endmethod.


METHOD get_id.
  result = me->usuario.
ENDMETHOD.


METHOD get_name.
  DATA: lt_return TYPE STANDARD TABLE OF bapiret2,
        l_address TYPE bapiaddr3.

  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username = usuario
    IMPORTING
      address  = l_address
    TABLES
      return   = lt_return[].

  name = l_address-fullname.

ENDMETHOD.


method IS_ASSIGNED.
  return = me->assigned.
endmethod.


method IS_DEVELOPER.
  return = me->developer.
endmethod.


method IS_REPORTER.
  return = me->reporter.
endmethod.


method IS_TESTER.
  return = me->tester.
endmethod.


METHOD prepare_hash_structure.
  DATA: id    TYPE zbt_usuario-usuario,
        value TYPE LINE OF zbt_objectvalue_hash_calcul.

  value = id = get_id( ).
  SHIFT value LEFT DELETING LEADING space.
  INSERT value INTO TABLE values[].

ENDMETHOD.


method SET_ASSIGNED.
  me->assigned = assigned.
endmethod.


method SET_DEVELOPER.
  me->developer = developer.
endmethod.


method SET_EMAIL.
  me->mail = email.
endmethod.


method SET_REPORTER.
  me->reporter = reporter.
endmethod.


method SET_TESTER.
  me->tester = tester.
endmethod.
ENDCLASS.
