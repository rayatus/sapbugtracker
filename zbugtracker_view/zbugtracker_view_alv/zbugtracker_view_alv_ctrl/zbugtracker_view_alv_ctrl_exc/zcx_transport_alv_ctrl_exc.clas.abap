class ZCX_TRANSPORT_ALV_CTRL_EXC definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.
*"* public components of class ZCX_TRANSPORT_ALV_CTRL_EXC
*"* do not include other source files here!!!

  interfaces IF_T100_MESSAGE .

  constants:
    begin of BUGS_ARE_MANDATORY,
      msgid type symsgid value 'ZBT_ALV_CTRL_MSG',
      msgno type symsgno value '001',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of BUGS_ARE_MANDATORY .
  data TRANSPORT type ref to ZCL_TRANSPORT .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !TRANSPORT type ref to ZCL_TRANSPORT optional .
protected section.
*"* protected components of class ZCX_TRANSPORT_ALV_CTRL_EXC
*"* do not include other source files here!!!
private section.
*"* private components of class ZCX_TRANSPORT_ALV_CTRL_EXC
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCX_TRANSPORT_ALV_CTRL_EXC IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->TRANSPORT = TRANSPORT .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
