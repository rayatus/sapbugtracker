FUNCTION zbt_search_bug.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(SCREEN_ATTRIBUTES) TYPE  ZBT_SCREEN_ATTRIBUTES
*"       OPTIONAL
*"     REFERENCE(RESULTS_ALV_CTRL) TYPE REF TO  ZINF_RESULTS_ALV_CTRL
*"  CHANGING
*"     REFERENCE(BUG) TYPE  ZBT_BUG_RANGE OPTIONAL
*"     REFERENCE(BUGSTYPE) TYPE  ZBT_BUGSTYPE_RANGE OPTIONAL
*"     REFERENCE(BUGTYPE) TYPE  ZBT_BUGTYPE_RANGE OPTIONAL
*"     REFERENCE(COMPONENTE) TYPE  ZBT_COMPONENTE_RANGE OPTIONAL
*"     REFERENCE(DEADLINE) TYPE  ZBT_DATS_RANGE OPTIONAL
*"     REFERENCE(ESTADO) TYPE  ZBT_ESTADO_RANGE OPTIONAL
*"     REFERENCE(HORAS_ESTIMADAS) TYPE  ZBT_HORAS_RANGE OPTIONAL
*"     REFERENCE(HORAS_REALES) TYPE  ZBT_HORAS_RANGE OPTIONAL
*"     REFERENCE(PRODUCTO) TYPE  ZBT_PRODUCTO_RANGE OPTIONAL
*"     REFERENCE(RESUMEN) TYPE  ZBT_TEXT_RANGE OPTIONAL
*"     REFERENCE(CREADO) TYPE  ZBT_TIMESTAMP_RANGE OPTIONAL
*"     REFERENCE(REPORTER) TYPE  ZBT_USER_RANGE OPTIONAL
*"     REFERENCE(DEVELOPER) TYPE  ZBT_USER_RANGE OPTIONAL
*"     REFERENCE(TESTER) TYPE  ZBT_USER_RANGE OPTIONAL
*"     REFERENCE(FINALIZADO) TYPE  ZBT_TIMESTAMP_RANGE OPTIONAL
*"----------------------------------------------------------------------

  PERFORM init_global_data.

  g_title           = screen_attributes-title.
  g_subscreen-repid = sy-repid.
  g_subscreen-dynnr = '0002'.

  go_results_handler = results_alv_ctrl.

  s_bug[]     = bug[].
  s_comp[]    = componente[].
  s_dead[]    = deadline[].
  s_dev[]     = developer[].
  s_enddat[]  = finalizado[].
  s_erdat[]   = creado[].
  s_estado[]  = estado[].
  s_prod[]    = producto[].
  s_rep[]     = reporter[].
  s_stype[]   = bugstype[].
  s_type[]    = bugtype[].
  s_test[]    = tester[].

  CALL SCREEN 0001 STARTING AT screen_attributes-top
                               screen_attributes-left
                   ENDING AT   screen_attributes-bottom
                               screen_attributes-rigth.

  bug[]        = s_bug[].
  componente[] = s_comp[].
  deadline[]   = s_dead[].
  developer[]  = s_dev[].
  finalizado[] = s_enddat[].
  creado[]     = s_erdat[].
  estado[]     = s_estado[].
  producto[]   = s_prod[].
  reporter[]   = s_rep[].
  bugstype[]   = s_stype[].
  bugtype[]    = s_type[].
  tester[]     = s_test[].

ENDFUNCTION.
