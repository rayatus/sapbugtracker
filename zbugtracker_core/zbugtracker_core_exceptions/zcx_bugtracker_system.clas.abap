class ZCX_BUGTRACKER_SYSTEM definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

*"* public components of class ZCX_BUGTRACKER_SYSTEM
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCX_BUGTRACKER_SYSTEM,
      msgid type symsgid value 'ZBT_CONTROLLER_MSG',
      msgno type symsgno value '004',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZCX_BUGTRACKER_SYSTEM .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class ZCX_BUGTRACKER_SYSTEM
*"* do not include other source files here!!!
private section.
*"* private components of class ZCX_BUGTRACKER_SYSTEM
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCX_BUGTRACKER_SYSTEM IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_BUGTRACKER_SYSTEM .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
