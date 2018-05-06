class ZCX_NOT_FOUND_EXCEPTION definition
  public
  inheriting from ZCX_BUGTRACKER_SYSTEM
  final
  create public .

*"* public components of class ZCX_NOT_FOUND_EXCEPTION
*"* do not include other source files here!!!
public section.

  constants:
    begin of ZCX_NOT_FOUND_EXCEPTION,
      msgid type symsgid value 'ZBT_CONTROLLER_MSG',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'OBJECT',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZCX_NOT_FOUND_EXCEPTION .
  data OBJECT type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !OBJECT type STRING optional .
protected section.
*"* protected components of class ZCX_NOT_FOUND_EXCEPTION
*"* do not include other source files here!!!
private section.
*"* private components of class ZCX_NOT_FOUND_EXCEPTION
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCX_NOT_FOUND_EXCEPTION IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->OBJECT = OBJECT .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_NOT_FOUND_EXCEPTION .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
