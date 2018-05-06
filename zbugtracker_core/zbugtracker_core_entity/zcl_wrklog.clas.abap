class ZCL_WRKLOG definition
  public
  inheriting from ZCL_ENTITY
  create protected

  global friends ZCL_BUG_WRKLOG_CONTROLLER .

public section.
*"* public components of class ZCL_WRKLOG
*"* do not include other source files here!!!

  methods CONSTRUCTOR
    importing
      !BUG type ref to ZCL_BUG
      !ID type ZBT_BUG_WRKLOG-WRKLOG_ID
      !ERDAT type ZBT_BUG_WRKLOG-ERDAT .
  methods GET_BUG
    returning
      value(BUG) type ref to ZCL_BUG .
  methods GET_ID
    returning
      value(WRKLOG_ID) type ZBT_BUG_WRKLOG-WRKLOG_ID .
  methods GET_WRKLOG_CONCEPT
    returning
      value(WRKLOG_CONCEPT) type ref to ZCL_WRKLOG_CONCEPT .
  methods GET_USUARIO
    returning
      value(USUARIO) type ref to ZCL_USUARIO .
  methods GET_TEXTO
    returning
      value(TEXTO) type ZBT_BUG_WRKLOG-TEXTO .
  methods GET_ERDAT
    returning
      value(ERDAT) type ZBT_BUG_WRKLOG-ERDAT .
  methods SET_WRKLOG_CONCEPT
    importing
      !WRKLOG_CONCEPT type ref to ZCL_WRKLOG_CONCEPT .
  methods SET_USUARIO
    importing
      !USUARIO type ref to ZCL_USUARIO .
  methods SET_TEXTO
    importing
      !TEXTO type ZBT_BUG_WRKLOG-TEXTO .
protected section.
*"* protected components of class ZCL_WRKLOG
*"* do not include other source files here!!!

  methods PREPARE_HASH_STRUCTURE
    redefinition .
private section.
*"* private components of class ZCL_WRKLOG
*"* do not include other source files here!!!

  data BUG type ref to ZCL_BUG .
  data WRKLOG_ID type ZBT_BUG_WRKLOG-WRKLOG_ID .
  data WRKLOG_CONCEPT type ref to ZCL_WRKLOG_CONCEPT .
  data USUARIO type ref to ZCL_USUARIO .
  data TEXTO type ZBT_TEXTO_LARGO .
  data ERDAT type ZBT_ERDAT .

  methods SET_ERDAT
    importing
      !ERDAT type ZBT_BUG_WRKLOG-ERDAT optional .
  methods SET_BUG
    importing
      !BUG type ref to ZCL_BUG .
  methods SET_ID
    importing
      !ID type ZBT_BUG_WRKLOG-WRKLOG_ID .
ENDCLASS.



CLASS ZCL_WRKLOG IMPLEMENTATION.


method CONSTRUCTOR.

  super->constructor( ).

  set_bug( bug = bug ).
  set_id( id = id   ).
  set_erdat( erdat ).

endmethod.


method GET_BUG.
  bug = me->bug.
endmethod.


method GET_ERDAT.
  erdat = me->erdat.
endmethod.


method GET_ID.
  wrklog_id = me->wrklog_id.
endmethod.


method GET_TEXTO.
  texto = me->texto.
endmethod.


method GET_USUARIO.
  usuario = me->usuario.
endmethod.


method GET_WRKLOG_CONCEPT.
  wrklog_concept = me->wrklog_concept.
endmethod.


method PREPARE_HASH_STRUCTURE.
* ToDo
endmethod.


METHOD set_bug.
  me->bug = bug.
ENDMETHOD.


METHOD set_erdat.
  DATA: l_timestmp TYPE timestampl.

  IF erdat IS SUPPLIED.
    me->erdat = erdat.
  ELSE.
    GET TIME STAMP FIELD l_timestmp.
    me->erdat = l_timestmp.
  ENDIF.

ENDMETHOD.


method SET_ID.
  me->wrklog_id = wrklog_id.
endmethod.


method SET_TEXTO.
  me->texto = texto.
endmethod.


method SET_USUARIO.
  me->usuario = usuario.
endmethod.


METHOD set_wrklog_concept.
  me->wrklog_concept = wrklog_concept.
ENDMETHOD.
ENDCLASS.
