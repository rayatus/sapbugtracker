class ZCL_BUG_WRKLOG_PERSIST definition
  public
  final
  create protected

  global friends ZCB_BUG_WRKLOG_PERSIST .

public section.
*"* public components of class ZCL_BUG_WRKLOG_PERSIST
*"* do not include other source files here!!!

  interfaces IF_OS_STATE .

  methods GET_BUG
    returning
      value(RESULT) type ZBT_ID_BUG
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_ERDAT
    returning
      value(RESULT) type ZBT_ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PRODUCTO
    returning
      value(RESULT) type ZBT_ID_PRODUCTO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_TEXTO
    returning
      value(RESULT) type ZBT_TEXTO_LARGO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_USUARIO
    returning
      value(RESULT) type XUBNAME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_WRKLOG_CONCEPT
    returning
      value(RESULT) type ZBT_WORKLOG_CONCEPT_ID
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_WRKLOG_ID
    returning
      value(RESULT) type ZBT_ID_WRKLOG
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_ERDAT
    importing
      !I_ERDAT type ZBT_ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_TEXTO
    importing
      !I_TEXTO type ZBT_TEXTO_LARGO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_USUARIO
    importing
      !I_USUARIO type XUBNAME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_WRKLOG_CONCEPT
    importing
      !I_WRKLOG_CONCEPT type ZBT_WORKLOG_CONCEPT_ID
    raising
      CX_OS_OBJECT_NOT_FOUND .
  class CL_OS_SYSTEM definition load .
protected section.
*"* protected components of class ZCL_BUG_WRKLOG_PERSIST
*"* do not include other source files here!!!

  data PRODUCTO type ZBT_ID_PRODUCTO .
  data BUG type ZBT_ID_BUG .
  data WRKLOG_ID type ZBT_ID_WRKLOG .
  data WRKLOG_CONCEPT type ZBT_WORKLOG_CONCEPT_ID .
  data USUARIO type XUBNAME .
  data TEXTO type ZBT_TEXTO_LARGO .
  data ERDAT type ZBT_ERDAT .
private section.
*"* private components of class ZCL_BUG_WRKLOG_PERSIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BUG_WRKLOG_PERSIST IMPLEMENTATION.


method GET_BUG.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute BUG
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

  result = BUG.

           " GET_BUG
endmethod.


method GET_ERDAT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute ERDAT
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

  result = ERDAT.

           " GET_ERDAT
endmethod.


method GET_PRODUCTO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute PRODUCTO
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

  result = PRODUCTO.

           " GET_PRODUCTO
endmethod.


method GET_TEXTO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute TEXTO
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

  result = TEXTO.

           " GET_TEXTO
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


method GET_WRKLOG_CONCEPT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute WRKLOG_CONCEPT
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

  result = WRKLOG_CONCEPT.

           " GET_WRKLOG_CONCEPT
endmethod.


method GET_WRKLOG_ID.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute WRKLOG_ID
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

  result = WRKLOG_ID.

           " GET_WRKLOG_ID
endmethod.


method IF_OS_STATE~GET.
***BUILD 090501
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
***BUILD 090501
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
***BUILD 090501
"#EC NEEDED
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
***BUILD 090501
"#EC NEEDED
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
***BUILD 090501
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


method SET_ERDAT.
***BUILD 090501
     " importing I_ERDAT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute ERDAT
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

  if ( I_ERDAT <> ERDAT ).

    ERDAT = I_ERDAT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_ERDAT <> ERDAT )

           " GET_ERDAT
endmethod.


method SET_TEXTO.
***BUILD 090501
     " importing I_TEXTO
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute TEXTO
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

  if ( I_TEXTO <> TEXTO ).

    TEXTO = I_TEXTO.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_TEXTO <> TEXTO )

           " GET_TEXTO
endmethod.


method SET_USUARIO.
***BUILD 090501
     " importing I_USUARIO
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute USUARIO
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

  if ( I_USUARIO <> USUARIO ).

    USUARIO = I_USUARIO.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_USUARIO <> USUARIO )

           " GET_USUARIO
endmethod.


method SET_WRKLOG_CONCEPT.
***BUILD 090501
     " importing I_WRKLOG_CONCEPT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute WRKLOG_CONCEPT
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

  if ( I_WRKLOG_CONCEPT <> WRKLOG_CONCEPT ).

    WRKLOG_CONCEPT = I_WRKLOG_CONCEPT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_WRKLOG_CONCEPT <> WRKLOG_CONCEPT )

           " GET_WRKLOG_CONCEPT
endmethod.
ENDCLASS.
