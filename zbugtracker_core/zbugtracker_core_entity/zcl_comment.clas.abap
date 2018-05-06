class ZCL_COMMENT definition
  public
  inheriting from ZCL_ENTITY
  final
  create public .

public section.
*"* public components of class ZCL_COMMENT
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !ID type ZBT_BUGCOMMENT-COMENTARIO optional
      !USUARIO type ref to ZCL_USUARIO optional
      value(ERDAT) type ZBT_BUGCOMMENT-ERDAT optional
      !TEXTO type ZBT_BUGCOMMENT-TEXTO optional .
  methods GET_ID
    returning
      value(RETURN) type ZBT_BUGCOMMENT-COMENTARIO .
  methods GET_USUARIO
    returning
      value(RETURN) type ref to ZCL_USUARIO .
  methods GET_TEXTO
    returning
      value(RETURN) type ZBT_BUGCOMMENT-TEXTO .
  methods GET_ERDAT
    returning
      value(RETURN) type ZBT_BUGCOMMENT-ERDAT .
  methods SET_ERDAT
    importing
      value(ERDAT) type ZBT_BUGCOMMENT-ERDAT optional .
  methods SET_TEXTO
    importing
      !TEXTO type ZBT_BUGCOMMENT-TEXTO .
  methods SET_USUARIO
    importing
      !USUARIO type ref to ZCL_USUARIO .
  methods GET_BUG
    returning
      value(RETURN) type ref to ZCL_BUG .
  methods SET_ID
    importing
      !ID type ZBT_BUGCOMMENT-COMENTARIO .
protected section.
*"* protected components of class ZCL_COMMENT
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_COMMENT
*"* do not include other source files here!!!

  data BUG type ref to ZCL_BUG .
  data ID type ZBT_BUGCOMMENT-COMENTARIO .
  data USUARIO type ref to ZCL_USUARIO .
  data TEXTO type ZBT_BUGCOMMENT-TEXTO .
  data ERDAT type ZBT_BUGCOMMENT-ERDAT .
ENDCLASS.



CLASS ZCL_COMMENT IMPLEMENTATION.


METHOD constructor.
  super->constructor( ).
  me->bug = bug.
  me->id  = id.
  IF usuario IS SUPPLIED.
    set_usuario( usuario ).
  ENDIF.
  IF NOT erdat IS SUPPLIED.
    GET TIME FIELD erdat.
  ENDIF.
  set_erdat( erdat ).
  IF texto IS SUPPLIED.
    set_texto( texto ).
  ENDIF.

ENDMETHOD.


method GET_BUG.
  return = bug.
endmethod.


method GET_ERDAT.
  return = erdat.
endmethod.


method GET_ID.
  return = id.
endmethod.


method GET_TEXTO.
  return = texto.
endmethod.


method GET_USUARIO.
  return = usuario.
endmethod.


METHOD prepare_hash_structure.
  DATA: str   TYPE zbt_bugcomment,
        find_result TYPE match_result,
        hash  TYPE hash160,
        txt   TYPE zbt_texto_largo,
        value TYPE LINE OF zbt_objectvalue_hash_calcul,
        i     TYPE i.

  FIELD-SYMBOLS: <field> TYPE any.

  CALL METHOD zcl_comment_controller=>entity_to_structure
    EXPORTING
      entity    = me
    RECEIVING
      structure = str.

  DO.
    ADD 1 TO i.
    ASSIGN COMPONENT i OF STRUCTURE str TO <field>.
    IF sy-subrc IS INITIAL.
*     Due to TEXT could be larger than "value" length we need to calculate its hash, but
      IF i = 6.
*       we only need section between <BODY> and </BODY> because other parts are related
*       to webBrowser version.
        txt = <field>.
        FIND '<BODY>' IN txt RESULTS find_result.
        find_result-offset = find_result-offset + find_result-length.
        txt = txt+find_result-offset.

        FIND '</BODY>' IN txt RESULTS find_result.
        txt = txt(find_result-offset).

        CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
          EXPORTING
            alg            = 'SHA1'
            data           = txt
          IMPORTING
            hash           = hash
          EXCEPTIONS
            unknown_alg    = 1
            param_error    = 2
            internal_error = 3
            OTHERS         = 4.

        value = hash.
      ELSE.
        value = <field>.
      ENDIF.
      SHIFT value LEFT DELETING LEADING space.
      INSERT value INTO TABLE values[].
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.


ENDMETHOD.


METHOD set_erdat.
  DATA: l_timestamp TYPE timestamp.

  IF erdat IS INITIAL.
    GET TIME STAMP FIELD l_timestamp.
    erdat = l_timestamp.
  ENDIF.
  me->erdat = erdat.
ENDMETHOD.


METHOD set_id.
  me->id = id.
ENDMETHOD.


method SET_TEXTO.
  me->texto = texto.
endmethod.


method SET_USUARIO.
  me->usuario = usuario.
endmethod.
ENDCLASS.
