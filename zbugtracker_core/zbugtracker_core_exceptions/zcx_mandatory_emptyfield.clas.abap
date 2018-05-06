class ZCX_MANDATORY_EMPTYFIELD definition
  public
  inheriting from ZCX_VALIDATE_EXCEPTION
  final
  create public .

*"* public components of class ZCX_MANDATORY_EMPTYFIELD
*"* do not include other source files here!!!
public section.

  constants:
    begin of ZCX_MANDATORY_EMPTYFIELD,
      msgid type symsgid value 'ZBT_CONTROLLER_MSG',
      msgno type symsgno value '006',
      attr1 type scx_attrname value 'FIELD',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZCX_MANDATORY_EMPTYFIELD .
  data FIELD type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !FIELD type STRING optional .
protected section.
*"* protected components of class ZCX_MANDATORY_EMPTYFIELD
*"* do not include other source files here!!!
private section.
*"* private components of class ZCX_MANDATORY_EMPTYFIELD
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCX_MANDATORY_EMPTYFIELD IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->FIELD = FIELD .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_MANDATORY_EMPTYFIELD .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
