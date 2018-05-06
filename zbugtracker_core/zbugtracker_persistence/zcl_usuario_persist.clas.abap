class ZCL_USUARIO_PERSIST definition
  public
  final
  create protected

  global friends ZCB_USUARIO_PERSIST .

public section.
*"* public components of class ZCL_USUARIO_PERSIST
*"* do not include other source files here!!!

  interfaces IF_OS_STATE .

  methods GET_IS_ASSIGNED
    returning
      value(RESULT) type ZBT_IS_ASSIGNED
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_IS_DEVELOPER
    returning
      value(RESULT) type ZBT_IS_DEVELOPER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_IS_REPORTER
    returning
      value(RESULT) type ZBT_IS_REPORTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_IS_TESTER
    returning
      value(RESULT) type ZBT_IS_TESTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_MAIL
    returning
      value(RESULT) type ZBT_EMAIL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_USUARIO
    returning
      value(RESULT) type XUBNAME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_IS_ASSIGNED
    importing
      !I_IS_ASSIGNED type ZBT_IS_ASSIGNED
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_IS_DEVELOPER
    importing
      !I_IS_DEVELOPER type ZBT_IS_DEVELOPER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_IS_REPORTER
    importing
      !I_IS_REPORTER type ZBT_IS_REPORTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_IS_TESTER
    importing
      !I_IS_TESTER type ZBT_IS_TESTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_MAIL
    importing
      !I_MAIL type ZBT_EMAIL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  class CL_OS_SYSTEM definition load .
protected section.
*"* protected components of class ZCL_USUARIO_PERSIST
*"* do not include other source files here!!!

  data IS_ASSIGNED type ZBT_IS_ASSIGNED .
  data IS_DEVELOPER type ZBT_IS_DEVELOPER .
  data IS_REPORTER type ZBT_IS_REPORTER .
  data IS_TESTER type ZBT_IS_TESTER .
  data MAIL type ZBT_EMAIL .
  data USUARIO type XUBNAME .
private section.
*"* private components of class ZCL_USUARIO_PERSIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_USUARIO_PERSIST IMPLEMENTATION.


method GET_IS_ASSIGNED.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute IS_ASSIGNED
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = IS_ASSIGNED.

           " GET_IS_ASSIGNED
endmethod.


method GET_IS_DEVELOPER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute IS_DEVELOPER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = IS_DEVELOPER.

           " GET_IS_DEVELOPER
endmethod.


method GET_IS_REPORTER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute IS_REPORTER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = IS_REPORTER.

           " GET_IS_REPORTER
endmethod.


method GET_IS_TESTER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute IS_TESTER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = IS_TESTER.

           " GET_IS_TESTER
endmethod.


method GET_MAIL.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute MAIL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = MAIL.

           " GET_MAIL
endmethod.


method GET_USUARIO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute USUARIO
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = USUARIO.

           " GET_USUARIO
endmethod.


method IF_OS_STATE~GET.
***BUILD 051401
     " returning result type ref to object
************************************************************************
* Purpose        : Get state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  create object STATE_OBJECT.
  call method STATE_OBJECT->SET_STATE_FROM_OBJECT( ME ).
  result = STATE_OBJECT.

endmethod.


method IF_OS_STATE~HANDLE_EXCEPTION.
***BUILD 051401
     " importing I_EXCEPTION type ref to IF_OS_EXCEPTION_INFO optional
     " importing I_EX_OS type ref to CX_OS_OBJECT_NOT_FOUND optional
************************************************************************
* Purpose        : Handles exceptions during attribute access.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : If an exception is raised during attribut access,
*                  this method is called and the exception is passed
*                  as a paramater. The default is to raise the exception
*                  again, so that the caller can handle the exception.
*                  But it is also possible to handle the exception
*                  here in the callee.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************
* Modify if you like
************************************************************************

  if i_ex_os is not initial.
    raise exception i_ex_os.
  endif.

endmethod.


method IF_OS_STATE~INIT.
***BUILD 051401
************************************************************************
* Purpose        : Initialisation of the transient state partition.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Transient state is initial.
*
* OO Exceptions  : -
*
* Implementation : Caution!: Avoid Throwing ACCESS Events.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

endmethod.


method IF_OS_STATE~INVALIDATE.
***BUILD 051401
************************************************************************
* Purpose        : Do something before all persistent attributes are
*                  cleared.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : Whatever you like to do.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

endmethod.


method IF_OS_STATE~SET.
***BUILD 051401
     " importing I_STATE type ref to object
************************************************************************
* Purpose        : Set state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  STATE_OBJECT ?= I_STATE.
  call method STATE_OBJECT->SET_OBJECT_FROM_STATE( ME ).

endmethod.


method SET_IS_ASSIGNED.
***BUILD 090501
     " importing I_IS_ASSIGNED
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute IS_ASSIGNED
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_IS_ASSIGNED <> IS_ASSIGNED ).

    IS_ASSIGNED = I_IS_ASSIGNED.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_IS_ASSIGNED <> IS_ASSIGNED )

           " GET_IS_ASSIGNED
endmethod.


method SET_IS_DEVELOPER.
***BUILD 090501
     " importing I_IS_DEVELOPER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute IS_DEVELOPER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_IS_DEVELOPER <> IS_DEVELOPER ).

    IS_DEVELOPER = I_IS_DEVELOPER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_IS_DEVELOPER <> IS_DEVELOPER )

           " GET_IS_DEVELOPER
endmethod.


method SET_IS_REPORTER.
***BUILD 090501
     " importing I_IS_REPORTER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute IS_REPORTER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_IS_REPORTER <> IS_REPORTER ).

    IS_REPORTER = I_IS_REPORTER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_IS_REPORTER <> IS_REPORTER )

           " GET_IS_REPORTER
endmethod.


method SET_IS_TESTER.
***BUILD 090501
     " importing I_IS_TESTER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute IS_TESTER
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_IS_TESTER <> IS_TESTER ).

    IS_TESTER = I_IS_TESTER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_IS_TESTER <> IS_TESTER )

           " GET_IS_TESTER
endmethod.


method SET_MAIL.
***BUILD 090501
     " importing I_MAIL
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute MAIL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_MAIL <> MAIL ).

    MAIL = I_MAIL.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_MAIL <> MAIL )

           " GET_MAIL
endmethod.
ENDCLASS.
