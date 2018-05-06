class ZCL_TRANSACTION_SERVICE definition
  public
  final
  create public .

*"* public components of class ZCL_TRANSACTION_SERVICE
*"* do not include other source files here!!!
public section.

  methods CONSTRUCTOR .
  methods START .
  methods END .
protected section.
*"* protected components of class ZCL_TRANSACTION_SERVICE
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_TRANSACTION_SERVICE
*"* do not include other source files here!!!

  data TM type ref to IF_OS_TRANSACTION_MANAGER .
  data T type ref to IF_OS_TRANSACTION .
ENDCLASS.



CLASS ZCL_TRANSACTION_SERVICE IMPLEMENTATION.


METHOD constructor.

  tm = cl_os_system=>get_transaction_manager( ).
  t  = tm->create_transaction( ).

ENDMETHOD.


METHOD end.
  t->end( ).
ENDMETHOD.


METHOD start.
  t->start( ).
ENDMETHOD.
ENDCLASS.
