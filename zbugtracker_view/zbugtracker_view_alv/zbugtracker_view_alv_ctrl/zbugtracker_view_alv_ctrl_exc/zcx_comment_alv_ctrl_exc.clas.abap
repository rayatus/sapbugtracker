class ZCX_COMMENT_ALV_CTRL_EXC definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class ZCX_COMMENT_ALV_CTRL_EXC
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of COMMENTS_NOT_MATCH_BUG,
      msgid type symsgid value 'ZBT_ALV_CTRL_MSG',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'BUG_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of COMMENTS_NOT_MATCH_BUG .
  data BUG_ID type ZBT_ID_BUG .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !BUG_ID type ZBT_ID_BUG optional .
protected section.
*"* protected components of class ZCX_COMMENT_ALV_CTRL_EXC
*"* do not include other source files here!!!
private section.
*"* private components of class ZCX_COMMENT_ALV_CTRL_EXC
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCX_COMMENT_ALV_CTRL_EXC IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->BUG_ID = BUG_ID .
clear me->textid.
if textid is initial and ME->IF_T100_MESSAGE~T100KEY IS INITIAL.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
