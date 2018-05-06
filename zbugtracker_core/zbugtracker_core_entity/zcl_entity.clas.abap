class ZCL_ENTITY definition
  public
  abstract
  create public .

public section.
*"* public components of class ZCL_ENTITY
*"* do not include other source files here!!!

  methods GET_HASH
    returning
      value(HASH) type HASH160 .
protected section.
*"* protected components of class ZCL_ENTITY
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
  abstract
    returning
      value(VALUES) type ZBT_OBJECTVALUE_HASH_CALCUL .
private section.
*"* private components of class ZCL_ENTITY
*"* do not include other source files here!!!

  methods CALCULATE_HASH
    importing
      !VALUES type ZBT_OBJECTVALUE_HASH_CALCUL
    preferred parameter VALUES
    returning
      value(HASH) type HASH160 .
ENDCLASS.



CLASS ZCL_ENTITY IMPLEMENTATION.


METHOD calculate_hash.
  DATA: string TYPE string,
        raw    TYPE xstring.

  CALL FUNCTION 'SOTR_SERV_TABLE_TO_STRING'
    IMPORTING
      text     = string
    TABLES
      text_tab = values[].

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text   = string
    IMPORTING
      buffer = raw
    EXCEPTIONS
      OTHERS = 9.


  CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
    EXPORTING
      alg            = 'SHA1'
      data           = raw
    IMPORTING
      hash           = hash
*     HASHLEN        =
*     HASHX          =
*     HASHXLEN       =
*     HASHSTRING     =
*     HASHXSTRING    =
*     HASHB64STRING  =
    EXCEPTIONS
      unknown_alg    = 1
      param_error    = 2
      internal_error = 3
      OTHERS         = 4.


ENDMETHOD.


METHOD get_hash.
  DATA: values TYPE zbt_objectvalue_hash_calcul.

  values[] = prepare_hash_structure( ).

  hash = calculate_hash( values[] ).

ENDMETHOD.
ENDCLASS.
