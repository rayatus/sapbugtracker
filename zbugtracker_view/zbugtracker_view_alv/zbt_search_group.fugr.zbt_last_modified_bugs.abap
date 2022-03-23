FUNCTION zbt_last_modified_bugs.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(SCREEN_ATTRIBUTES) TYPE  ZBT_SCREEN_ATTRIBUTES
*"       OPTIONAL
*"     REFERENCE(RESULTS_ALV_CTRL) TYPE REF TO  ZINF_RESULTS_ALV_CTRL
*"  CHANGING
*"     REFERENCE(BUG) TYPE  ZBT_BUG_RANGE OPTIONAL
*"     REFERENCE(PRODUCTO) TYPE  ZBT_PRODUCTO_RANGE OPTIONAL
*"     REFERENCE(COMPONENTE) TYPE  ZBT_COMPONENTE_RANGE OPTIONAL
*"     REFERENCE(MODIFICADO) TYPE  ZBT_TIMESTAMP_RANGE OPTIONAL
*"----------------------------------------------------------------------
  PERFORM init_global_data.

  s_aedat[] = modificado[].
  s_bug[]   = bug[].
  s_prod[]  = producto[].
  s_comp[]  = componente[].

  g_title           = screen_attributes-title.
  g_subscreen-repid = sy-repid.
  g_subscreen-dynnr = '0003'.

  go_results_handler = results_alv_ctrl.

  CALL SCREEN 0001 STARTING AT screen_attributes-top
                               screen_attributes-left
                   ENDING AT   screen_attributes-bottom
                               screen_attributes-rigth.

  modificado[] = s_aedat[].
  bug[]        = s_bug[].
  producto[]   = s_prod[].
  componente[] = s_comp[].

ENDFUNCTION.
