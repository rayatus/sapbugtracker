class ZCL_BUG_PERSIST definition
  public
  final
  create protected

  global friends ZCB_BUG_PERSIST .

public section.
*"* public components of class ZCL_BUG_PERSIST
*"* do not include other source files here!!!

  interfaces IF_OS_STATE .

  methods GET_AEDAT
    returning
      value(RESULT) type ZBT_AEDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_AENAM
    returning
      value(RESULT) type AENAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_ASSIGNED
    returning
      value(RESULT) type ZBT_ASSIGNED
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_BUG_I
    returning
      value(RESULT) type ZBT_ID_BUG_I
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_ASSIGNED
    importing
      !I_ASSIGNED type ZBT_ASSIGNED
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_AENAM
    importing
      !I_AENAM type AENAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_AEDAT
    importing
      !I_AEDAT type ZBT_AEDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_BUG_I
    importing
      !I_BUG_I type ZBT_ID_BUG_I
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_TESTER
    importing
      !I_TESTER type ZBT_TESTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_RESUMEN
    importing
      !I_RESUMEN type ZBT_RESUMEN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_REPORTER
    importing
      !I_REPORTER type ZBT_REPORTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_HORAS_REA
    importing
      !I_HORAS_REA type ZBT_HORAS_REALES
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_HORAS_EST
    importing
      !I_HORAS_EST type ZBT_HORAS_ESTIMADAS
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_FINALIZADO
    importing
      !I_FINALIZADO type ZBT_ENDDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_ESTADO
    importing
      !I_ESTADO type ZBT_ID_ESTADO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_DEVELOPER
    importing
      !I_DEVELOPER type ZBT_DEVELOPER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_DEADLINE
    importing
      !I_DEADLINE type ZBT_DEADLINE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CREADO
    importing
      !I_CREADO type ZBT_ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_COMPONENTE
    importing
      !I_COMPONENTE type ZBT_ID_COMPONENTE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_BUGTYPE
    importing
      !I_BUGTYPE type ZBT_ID_BUGTYPE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_BUGSTYPE
    importing
      !I_BUGSTYPE type ZBT_BUGSTYPE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_TESTER
    returning
      value(RESULT) type ZBT_TESTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_RESUMEN
    returning
      value(RESULT) type ZBT_RESUMEN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_REPORTER
    returning
      value(RESULT) type ZBT_REPORTER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PRODUCTO
    returning
      value(RESULT) type ZBT_ID_PRODUCTO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_HORAS_REA
    returning
      value(RESULT) type ZBT_HORAS_REALES
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_HORAS_EST
    returning
      value(RESULT) type ZBT_HORAS_ESTIMADAS
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_FINALIZADO
    returning
      value(RESULT) type ZBT_ENDDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_ESTADO
    returning
      value(RESULT) type ZBT_ID_ESTADO
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_DEVELOPER
    returning
      value(RESULT) type ZBT_DEVELOPER
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_DEADLINE
    returning
      value(RESULT) type ZBT_DEADLINE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CREADO
    returning
      value(RESULT) type ZBT_ERDAT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_COMPONENTE
    returning
      value(RESULT) type ZBT_ID_COMPONENTE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_BUGTYPE
    returning
      value(RESULT) type ZBT_ID_BUGTYPE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_BUGSTYPE
    returning
      value(RESULT) type ZBT_BUGSTYPE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_BUG
    returning
      value(RESULT) type ZBT_ID_BUG
    raising
      CX_OS_OBJECT_NOT_FOUND .
  class CL_OS_SYSTEM definition load .
protected section.
*"* protected components of class ZCL_BUG_PERSIST
*"* do not include other source files here!!!

  data AEDAT type ZBT_AEDAT .
  data AENAM type AENAM .
  data ASSIGNED type ZBT_ASSIGNED .
  data BUG type ZBT_ID_BUG .
  data BUGSTYPE type ZBT_BUGSTYPE .
  data BUGTYPE type ZBT_ID_BUGTYPE .
  data BUG_I type ZBT_ID_BUG_I .
  data COMPONENTE type ZBT_ID_COMPONENTE .
  data CREADO type ZBT_ERDAT .
  data DEADLINE type ZBT_DEADLINE .
  data DEVELOPER type ZBT_DEVELOPER .
  data ESTADO type ZBT_ID_ESTADO .
  data FINALIZADO type ZBT_ENDDAT .
  data HORAS_EST type ZBT_HORAS_ESTIMADAS .
  data HORAS_REA type ZBT_HORAS_REALES .
  data PRODUCTO type ZBT_ID_PRODUCTO .
  data REPORTER type ZBT_REPORTER .
  data RESUMEN type ZBT_RESUMEN .
  data TESTER type ZBT_TESTER .
private section.
*"* private components of class ZCL_BUG_PERSIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_BUG_PERSIST IMPLEMENTATION.


method GET_AEDAT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute AEDAT
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

  result = AEDAT.

           " GET_AEDAT
endmethod.


method GET_AENAM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute AENAM
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

  result = AENAM.

           " GET_AENAM
endmethod.


method GET_ASSIGNED.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute ASSIGNED
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

  result = ASSIGNED.

           " GET_ASSIGNED
endmethod.


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


method GET_BUGSTYPE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute BUGSTYPE
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

  result = BUGSTYPE.

           " GET_BUGSTYPE
endmethod.


method GET_BUGTYPE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute BUGTYPE
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

  result = BUGTYPE.

           " GET_BUGTYPE
endmethod.


method GET_BUG_I.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute BUG_I
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

  result = BUG_I.

           " GET_BUG_I
endmethod.


method GET_COMPONENTE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute COMPONENTE
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

  result = COMPONENTE.

           " GET_COMPONENTE
endmethod.


method GET_CREADO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CREADO
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

  result = CREADO.

           " GET_CREADO
endmethod.


method GET_DEADLINE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute DEADLINE
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

  result = DEADLINE.

           " GET_DEADLINE
endmethod.


method GET_DEVELOPER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute DEVELOPER
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

  result = DEVELOPER.

           " GET_DEVELOPER
endmethod.


method GET_ESTADO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute ESTADO
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

  result = ESTADO.

           " GET_ESTADO
endmethod.


method GET_FINALIZADO.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute FINALIZADO
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

  result = FINALIZADO.

           " GET_FINALIZADO
endmethod.


method GET_HORAS_EST.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute HORAS_EST
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

  result = HORAS_EST.

           " GET_HORAS_EST
endmethod.


method GET_HORAS_REA.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute HORAS_REA
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

  result = HORAS_REA.

           " GET_HORAS_REA
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


method GET_REPORTER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute REPORTER
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

  result = REPORTER.

           " GET_REPORTER
endmethod.


method GET_RESUMEN.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute RESUMEN
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

  result = RESUMEN.

           " GET_RESUMEN
endmethod.


method GET_TESTER.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute TESTER
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

  result = TESTER.

           " GET_TESTER
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


method SET_AEDAT.
***BUILD 090501
     " importing I_AEDAT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute AEDAT
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

  if ( I_AEDAT <> AEDAT ).

    AEDAT = I_AEDAT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_AEDAT <> AEDAT )

           " GET_AEDAT
endmethod.


method SET_AENAM.
***BUILD 090501
     " importing I_AENAM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute AENAM
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

  if ( I_AENAM <> AENAM ).

    AENAM = I_AENAM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_AENAM <> AENAM )

           " GET_AENAM
endmethod.


method SET_ASSIGNED.
***BUILD 090501
     " importing I_ASSIGNED
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute ASSIGNED
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

  if ( I_ASSIGNED <> ASSIGNED ).

    ASSIGNED = I_ASSIGNED.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_ASSIGNED <> ASSIGNED )

           " GET_ASSIGNED
endmethod.


method SET_BUGSTYPE.
***BUILD 090501
     " importing I_BUGSTYPE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute BUGSTYPE
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

  if ( I_BUGSTYPE <> BUGSTYPE ).

    BUGSTYPE = I_BUGSTYPE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_BUGSTYPE <> BUGSTYPE )

           " GET_BUGSTYPE
endmethod.


method SET_BUGTYPE.
***BUILD 090501
     " importing I_BUGTYPE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute BUGTYPE
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

  if ( I_BUGTYPE <> BUGTYPE ).

    BUGTYPE = I_BUGTYPE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_BUGTYPE <> BUGTYPE )

           " GET_BUGTYPE
endmethod.


method SET_BUG_I.
***BUILD 090501
     " importing I_BUG_I
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute BUG_I
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

  if ( I_BUG_I <> BUG_I ).

    BUG_I = I_BUG_I.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_BUG_I <> BUG_I )

           " GET_BUG_I
endmethod.


method SET_COMPONENTE.
***BUILD 090501
     " importing I_COMPONENTE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute COMPONENTE
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

  if ( I_COMPONENTE <> COMPONENTE ).

    COMPONENTE = I_COMPONENTE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_COMPONENTE <> COMPONENTE )

           " GET_COMPONENTE
endmethod.


method SET_CREADO.
***BUILD 090501
     " importing I_CREADO
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CREADO
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

  if ( I_CREADO <> CREADO ).

    CREADO = I_CREADO.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CREADO <> CREADO )

           " GET_CREADO
endmethod.


method SET_DEADLINE.
***BUILD 090501
     " importing I_DEADLINE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute DEADLINE
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

  if ( I_DEADLINE <> DEADLINE ).

    DEADLINE = I_DEADLINE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_DEADLINE <> DEADLINE )

           " GET_DEADLINE
endmethod.


method SET_DEVELOPER.
***BUILD 090501
     " importing I_DEVELOPER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute DEVELOPER
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

  if ( I_DEVELOPER <> DEVELOPER ).

    DEVELOPER = I_DEVELOPER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_DEVELOPER <> DEVELOPER )

           " GET_DEVELOPER
endmethod.


method SET_ESTADO.
***BUILD 090501
     " importing I_ESTADO
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute ESTADO
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

  if ( I_ESTADO <> ESTADO ).

    ESTADO = I_ESTADO.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_ESTADO <> ESTADO )

           " GET_ESTADO
endmethod.


method SET_FINALIZADO.
***BUILD 090501
     " importing I_FINALIZADO
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute FINALIZADO
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

  if ( I_FINALIZADO <> FINALIZADO ).

    FINALIZADO = I_FINALIZADO.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_FINALIZADO <> FINALIZADO )

           " GET_FINALIZADO
endmethod.


method SET_HORAS_EST.
***BUILD 090501
     " importing I_HORAS_EST
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute HORAS_EST
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

  if ( I_HORAS_EST <> HORAS_EST ).

    HORAS_EST = I_HORAS_EST.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_HORAS_EST <> HORAS_EST )

           " GET_HORAS_EST
endmethod.


method SET_HORAS_REA.
***BUILD 090501
     " importing I_HORAS_REA
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute HORAS_REA
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

  if ( I_HORAS_REA <> HORAS_REA ).

    HORAS_REA = I_HORAS_REA.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_HORAS_REA <> HORAS_REA )

           " GET_HORAS_REA
endmethod.


method SET_REPORTER.
***BUILD 090501
     " importing I_REPORTER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute REPORTER
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

  if ( I_REPORTER <> REPORTER ).

    REPORTER = I_REPORTER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_REPORTER <> REPORTER )

           " GET_REPORTER
endmethod.


method SET_RESUMEN.
***BUILD 090501
     " importing I_RESUMEN
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute RESUMEN
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

  if ( I_RESUMEN <> RESUMEN ).

    RESUMEN = I_RESUMEN.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_RESUMEN <> RESUMEN )

           " GET_RESUMEN
endmethod.


method SET_TESTER.
***BUILD 090501
     " importing I_TESTER
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute TESTER
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

  if ( I_TESTER <> TESTER ).

    TESTER = I_TESTER.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_TESTER <> TESTER )

           " GET_TESTER
endmethod.
ENDCLASS.
