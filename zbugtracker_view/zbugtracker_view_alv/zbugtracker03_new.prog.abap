*&---------------------------------------------------------------------*
*& Report  ZBUGTRACKER03_NEW
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZBUGTRACKER03_NEW.

tables ZBT_BUG.
tables ZBT_TYPE_TXT.
tables ZBT_BUG_TAG.
tables ZBT_STYPE_TXT.
tables ZBT_TRANSPORTER.
tables ZBT_PRODUCTOTAGT.
tables ZBT_ESTADO_TXT.
*tables ZBT_BUGCOMMENT.

type-POOLS: abap.

data: gt_bug_show type standard table of zbt_bug_show with header line.
data: gt_bug_show_save type standard table of zbt_bug_show with header line.
data: gw_bug_show like line of gt_bug_show.

data: gt_bug_comment type standard table of ZBT_BUGCOMMENT with header line.
data: gw_bug_comment like line of gt_bug_comment.


DATA: gt_results_comments TYPE match_result_tab,   " Bugcomments
      gt_results_bug type match_result_tab,   " bugdata
      wa_results LIKE LINE OF gt_results_bug.

data: begin of gt_search_bug OCCURS 0,
  PRODUCTO like zbt_bug-PRODUCTO,
  bug like ZBT_BUG-bug,
  result type c length 1.
data: END OF gt_search_bug.
data: gw_search_bug like line of gt_search_bug.

selection-screen begin of block qsel
                          with frame title text-s02.
select-options SP$00001 for ZBT_BUG-PRODUCTO memory id ZBT_PRODUCT_ID.
select-options SP$00002 for ZBT_BUG-BUG  memory id  ZBT_BUG_ID.
select-options SP$00003 for ZBT_BUG-BUG_I.
select-options SP$00004 for ZBT_BUG-CREADO.
select-options SP$00005 for ZBT_BUG-FINALIZADO.
select-options SP$00006 for ZBT_BUG-DEADLINE.
select-options SP$00007 for ZBT_BUG-REPORTER.
select-options SP$00008 for ZBT_BUG-ASSIGNED.
select-options SP$00009 for ZBT_BUG-DEVELOPER.
select-options SP$00010 for ZBT_BUG-TESTER.
select-options SP$00011 for ZBT_BUG-RESUMEN.
select-options SP$00012 for ZBT_BUG-ESTADO.
select-options SP$00013 for ZBT_BUG-HORAS_EST.
select-options SP$00014 for ZBT_BUG-HORAS_REA.
select-options SP$00015 for ZBT_BUG-COMPONENTE.
select-options SP$00016 for ZBT_BUG-BUGTYPE.
select-options SP$00017 for ZBT_BUG-BUGSTYPE.
select-options SP$00018 for ZBT_BUG-AEDAT.
select-options SP$00019 for ZBT_BUG-AENAM.
select-options SP$00020 for ZBT_BUG_TAG-TAG.
select-options SP$00021 for ZBT_BUG_TAG-TAGVAL.
select-options SP$00022 for ZBT_TRANSPORTER-TRANSPORTREQ.
select-options SP$00023 for ZBT_TYPE_TXT-SPRAS memory id SPR no INTERVALS NO-EXTENSION.
selection-screen end of block qsel.
selection-screen begin of block search with frame title text-p01.
PARAMETER: p_suche type c LENGTH 100.
selection-screen end of block search.
selection-screen begin of block stdsel with frame title text-s03.
PARAMETERs p_single  as CHECKBOX DEFAULT abap_true.
parameters p_varia like disvariant-variant default '/default'.
selection-screen end of block stdsel.


at selection-screen on value-request for p_varia.
  perform alv_variant_f4 changing p_varia.




START-OF-SELECTION.

  select ZBT_BUG~PRODUCTO ZBT_BUG~BUG ZBT_BUG~BUG_I ZBT_BUG~CREADO ZBT_BUG~FINALIZADO ZBT_BUG~DEADLINE ZBT_BUG~REPORTER
         ZBT_BUG~ASSIGNED ZBT_BUG~DEVELOPER ZBT_BUG~TESTER ZBT_BUG~RESUMEN ZBT_BUG~ESTADO ZBT_BUG~HORAS_EST ZBT_BUG~HORAS_REA
         ZBT_BUG~COMPONENTE ZBT_BUG~BUGTYPE ZBT_BUG~BUGSTYPE ZBT_BUG~AEDAT ZBT_BUG~AENAM ZBT_TYPE_TXT~DESCRIPCION
         ZBT_TYPE_TXT~BUGTYPE ZBT_BUG_TAG~TAG ZBT_BUG_TAG~TAGVAL ZBT_BUG_TAG~BUG ZBT_BUG_TAG~PRODUCTO ZBT_STYPE_TXT~DESCRIPCION
         ZBT_STYPE_TXT~BUGSTYPE ZBT_STYPE_TXT~BUGTYPE ZBT_TRANSPORTER~TRANSPORTREQ ZBT_TRANSPORTER~BUG ZBT_TRANSPORTER~PRODUCTO
    ZBT_ESTADO_TXT~DESCRIPCION
         ZBT_ESTADO_TXT~ESTADO ZBT_ESTADO_TXT~SPRAS
  from ( ZBT_BUG
         inner join ZBT_TYPE_TXT
         on  ZBT_TYPE_TXT~BUGTYPE = ZBT_BUG~BUGTYPE
         left outer join ZBT_BUG_TAG
         on  ZBT_BUG_TAG~BUG = ZBT_BUG~BUG
         and ZBT_BUG_TAG~PRODUCTO = ZBT_BUG~PRODUCTO
         left outer join ZBT_TRANSPORTER
         on  ZBT_TRANSPORTER~BUG = ZBT_BUG~BUG
         and ZBT_TRANSPORTER~PRODUCTO = ZBT_BUG~PRODUCTO
         inner join ZBT_STYPE_TXT
         on  ZBT_STYPE_TXT~BUGSTYPE = ZBT_BUG~BUGSTYPE
         and ZBT_STYPE_TXT~BUGTYPE = ZBT_BUG~BUGTYPE
         and ZBT_STYPE_TXT~SPRAS = ZBT_TYPE_TXT~SPRAS
         inner join ZBT_ESTADO_TXT
         on  ZBT_ESTADO_TXT~ESTADO = ZBT_BUG~ESTADO
         and ZBT_ESTADO_TXT~SPRAS = ZBT_TYPE_TXT~SPRAS )

      into (ZBT_BUG-PRODUCTO , ZBT_BUG-BUG , ZBT_BUG-BUG_I , ZBT_BUG-CREADO , ZBT_BUG-FINALIZADO , ZBT_BUG-DEADLINE
        , ZBT_BUG-REPORTER , ZBT_BUG-ASSIGNED , ZBT_BUG-DEVELOPER , ZBT_BUG-TESTER , ZBT_BUG-RESUMEN , ZBT_BUG-ESTADO
        , ZBT_BUG-HORAS_EST , ZBT_BUG-HORAS_REA , ZBT_BUG-COMPONENTE , ZBT_BUG-BUGTYPE , ZBT_BUG-BUGSTYPE , ZBT_BUG-AEDAT
        , ZBT_BUG-AENAM , ZBT_TYPE_TXT-DESCRIPCION , ZBT_TYPE_TXT-BUGTYPE , ZBT_BUG_TAG-TAG , ZBT_BUG_TAG-TAGVAL , ZBT_BUG_TAG-BUG
        , ZBT_BUG_TAG-PRODUCTO , ZBT_STYPE_TXT-DESCRIPCION , ZBT_STYPE_TXT-BUGSTYPE , ZBT_STYPE_TXT-BUGTYPE
        , ZBT_TRANSPORTER-TRANSPORTREQ , ZBT_TRANSPORTER-BUG , ZBT_TRANSPORTER-PRODUCTO ,
        ZBT_ESTADO_TXT-DESCRIPCION
        , ZBT_ESTADO_TXT-ESTADO , ZBT_ESTADO_TXT-SPRAS )
       where ZBT_BUG~PRODUCTO in SP$00001
         and ZBT_BUG~BUG in SP$00002
         and ZBT_BUG~BUG_I in SP$00003
         and ZBT_BUG~CREADO in SP$00004
         and ZBT_BUG~FINALIZADO in SP$00005
         and ZBT_BUG~DEADLINE in SP$00006
         and ZBT_BUG~REPORTER in SP$00007
         and ZBT_BUG~ASSIGNED in SP$00008
         and ZBT_BUG~DEVELOPER in SP$00009
         and ZBT_BUG~TESTER in SP$00010
         and ZBT_BUG~RESUMEN in SP$00011
         and ZBT_BUG~ESTADO in SP$00012
         and ZBT_BUG~HORAS_EST in SP$00013
         and ZBT_BUG~HORAS_REA in SP$00014
         and ZBT_BUG~COMPONENTE in SP$00015
         and ZBT_BUG~BUGTYPE in SP$00016
         and ZBT_BUG~BUGSTYPE in SP$00017
         and ZBT_BUG~AEDAT in SP$00018
         and ZBT_BUG~AENAM in SP$00019
         and ZBT_TYPE_TXT~SPRAS in SP$00023 .

    gt_bug_show-PRODUCTO = ZBT_BUG-PRODUCTO .
    gt_bug_show-BUG = ZBT_BUG-BUG .
    gt_bug_show-BUG_I = ZBT_BUG-BUG_I .
    gt_bug_show-CREADO = ZBT_BUG-CREADO .
    gt_bug_show-FINALIZADO = ZBT_BUG-FINALIZADO .
    gt_bug_show-DEADLINE = ZBT_BUG-DEADLINE .
    gt_bug_show-REPORTER = ZBT_BUG-REPORTER .
    gt_bug_show-ASSIGNED = ZBT_BUG-ASSIGNED .
    gt_bug_show-DEVELOPER = ZBT_BUG-DEVELOPER .
    gt_bug_show-TESTER = ZBT_BUG-TESTER .
    gt_bug_show-RESUMEN = ZBT_BUG-RESUMEN .
    gt_bug_show-ESTADO = ZBT_BUG-ESTADO .
    gt_bug_show-DESCRIPCION = ZBT_ESTADO_TXT-DESCRIPCION .
    gt_bug_show-HORAS_EST = ZBT_BUG-HORAS_EST .
    gt_bug_show-HORAS_REA = ZBT_BUG-HORAS_REA .
    gt_bug_show-COMPONENTE = ZBT_BUG-COMPONENTE .
    gt_bug_show-BUGTYPE = ZBT_BUG-BUGTYPE .
    gt_bug_show-DESCRIPCION001 = ZBT_TYPE_TXT-DESCRIPCION .
    gt_bug_show-BUGSTYPE = ZBT_BUG-BUGSTYPE .
    gt_bug_show-DESCRIPCION002 = ZBT_STYPE_TXT-DESCRIPCION .
    gt_bug_show-AEDAT = ZBT_BUG-AEDAT .
    gt_bug_show-AENAM = ZBT_BUG-AENAM .
    gt_bug_show-TAG = ZBT_BUG_TAG-TAG .
    gt_bug_show-TAGVAL = ZBT_BUG_TAG-TAGVAL .
    gt_bug_show-TRANSPORTREQ = ZBT_TRANSPORTER-TRANSPORTREQ .

    append gt_bug_show.

  ENDSELECT.


  if p_suche is not initial.
    PERFORM read_bug_comments.
    PERFORM SEARCH_WITHIN_BUGS.
    PERFORM cleanup_bug_show.
  endif.


end-of-selection.


  if p_single = abap_true.

    PERFORM single_bug_line.

  endif.
  perform read_vtext.
  perform show_alv.


*&---------------------------------------------------------------------*
*&      Form  ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_VARIA  text
*----------------------------------------------------------------------*
FORM ALV_VARIANT_F4  CHANGING P_P_VARIA.


  data: rs_variant like disvariant.
  data nof4 type c.

  clear nof4.
  loop at screen.
    if screen-name = 'P_VARIA'.
      if screen-input = 0.
        nof4 = 'X'.
      endif.
    endif.
  endloop.

  rs_variant-report   = sy-repid.
  rs_variant-username = sy-uname.
  call function 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = rs_variant
      i_save     = 'A'
    IMPORTING
      es_variant = rs_variant
    EXCEPTIONS
      others     = 1.
  if sy-subrc = 0 and nof4 eq space.
    p_varia = rs_variant-variant.
  endif.


ENDFORM.                    " ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_ALV .
  TYPE-POOLS: slis.  " immer benötigt damit nachfolgendes gefunden wird
  data:  ls_fieldcat    type slis_fieldcat_alv,
         lt_fieldcat    type slis_t_fieldcat_alv,
         l_program_name like sy-repid,
         l_variant      like disvariant,
         l_layout       type slis_layout_alv,
         l_tabname      type slis_tabname,
         h_titel        TYPE lvc_title,
         lv_pf          type slis_formname value 'PF_STATUS_SET'.


  l_program_name = sy-repid.

  l_tabname = 'ZBT_BUG_SHOW'.
* Feldkatalog besorgen
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = l_program_name
      I_STRUCTURE_NAME       = l_tabname
*      i_internal_tabname     = l_tabname

      i_inclname             = l_program_name
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      others                 = 3.

  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  loop at lt_fieldcat into ls_fieldcat.
    case LS_FIELDCAT-FIELDNAME.
      when 'BUG'.
        LS_FIELDCAT-hotspot   = 'X'.

    ENDCASE.
    modify lt_fieldcat from ls_fieldcat.
  endloop.

  L_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_save                  = 'A'
      i_callback_program      = l_program_name
      it_fieldcat             = lt_fieldcat
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = l_layout
    TABLES
      t_outtab                = gt_bug_show.
ENDFORM. " SHOW_ALV

*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
form user_command using r_ucomm like sy-ucomm

              rs_selfield type slis_selfield.               "#EC CALLED


  case r_ucomm.

    when '&IC1'.
      READ TABLE gt_bug_show INDEX rs_selfield-tabindex
        INTO gw_bug_show.
      case RS_SELFIELD-SEL_TAB_FIELD+2.
        when 'BUG'.
          SET PARAMETER ID 'ZBT_PRODUCT_ID' FIELD gw_bug_show-PRODUCTO.
          SET PARAMETER ID 'ZBT_BUG_ID' FIELD gw_bug_show-BUG.
          call TRANSACTION 'ZBUGTRACKER02'  AND SKIP FIRST SCREEN.
      ENDCASE.


  ENDCASE.

ENDFORM.                    "user_command
*&---------------------------------------------------------------------*
*&      Form  SINGLE_BUG_LINE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SINGLE_BUG_LINE .

  delete ADJACENT DUPLICATES FROM gt_bug_show COMPARING producto bug.

ENDFORM.                    " SINGLE_BUG_LINE
*&---------------------------------------------------------------------*
*&      Form  READ_VTEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_VTEXT .

  loop at gt_bug_show into gw_bug_show where tag is not initial.

    select single vtext from ZBT_PRODUCTOTAGT into gw_bug_show-vtext where
    PRODUCTO = gw_bug_show-PRODUCTO
             and ZBT_PRODUCTOTAGT~TAG = gw_bug_show-TAG and
             SPRAS in SP$00023 .

    modify gt_bug_show from gw_bug_show.

  endloop.


ENDFORM.                    " READ_VTEXT
*&---------------------------------------------------------------------*
*&      Form  READ_BUG_COMMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_BUG_COMMENTS .



  select *  from zbt_bugcomment into CORRESPONDING
    FIELDS OF TABLE gt_bug_comment
    for  ALL ENTRIES IN gt_bug_show WHERE
    producto = gt_bug_show-producto and
    bug = gt_bug_show-bug.


ENDFORM.                    " READ_BUG_COMMENTS
*&---------------------------------------------------------------------*
*&      Form  SEARCH_BUG_COMMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SEARCH_WITHIN_BUGS .

  data: search_string type string.
  data: lf_srch_str(100) TYPE c.
  data: bug_show_string type string.

  move p_suche to search_string.
  move p_suche TO lf_srch_str.

  loop at gt_bug_show into gw_bug_show.

    FIND  lf_srch_str in gw_bug_show-TAGVAL IGNORING CASE in CHARACTER MODE.
    if sy-subrc is INITIAL.
      gw_search_bug-PRODUCTO    = gw_bug_show-PRODUCTO .
      gw_search_bug-bug = gw_bug_show-bug.
      gw_search_bug-result = sy-subrc.
      append gw_search_bug to gt_search_bug.
    else.
      FIND lf_srch_str in  gw_bug_show-resumen IGNORING CASE in CHARACTER MODE.
      if sy-subrc is INITIAL.
        gw_search_bug-PRODUCTO    = gw_bug_show-PRODUCTO .
        gw_search_bug-bug = gw_bug_show-bug.
        gw_search_bug-result = sy-subrc.
        append gw_search_bug to gt_search_bug.
      endif.
    endif.



  endloop.

  loop at gt_bug_comment into gw_bug_comment.

    find search_string in gw_bug_comment-TEXTO IGNORING CASE.

    if sy-subrc is INITIAL.
      gw_search_bug-PRODUCTO    = gw_bug_comment-PRODUCTO .
      gw_search_bug-bug = gw_bug_comment-bug.
      gw_search_bug-result = sy-subrc.
      append gw_search_bug to gt_search_bug.
    endif.

  endloop.

  sort gt_search_bug by PRODUCTO bug result.

  delete ADJACENT DUPLICATES FROM gt_search_bug.

ENDFORM.                    " SEARCH_BUG_COMMENTS
*&---------------------------------------------------------------------*
*&      Form  CLEANUP_BUG_SHOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEANUP_BUG_SHOW .

* at first
  gt_bug_show_save[] = gt_bug_show[].

  clear: gt_bug_show[], gt_bug_show.

  loop at gt_search_bug into gw_search_bug.

    loop at gt_bug_show_save into gw_bug_show where
      PRODUCTO = gw_search_bug-PRODUCTO and
    bug = gw_search_bug-bug.

      append gw_bug_show to gt_bug_show.

    endloop.
  endloop.

ENDFORM.                    " CLEANUP_BUG_SHOW
