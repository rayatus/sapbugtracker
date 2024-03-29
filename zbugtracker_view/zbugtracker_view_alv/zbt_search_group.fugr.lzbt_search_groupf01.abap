*----------------------------------------------------------------------*
***INCLUDE LZBT_SEARCH_GROUPF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CHK_SELECTION_SCREEN_A0002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_selection_screen_a0002 .

ENDFORM.                    " CHK_SELECTION_SCREEN_A0002
*&---------------------------------------------------------------------*
*&      Form  progress
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERCENTAGE  text
*      -->P_TEXT  text
*----------------------------------------------------------------------*
FORM progress  USING    p_percentage
                        p_text.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = p_percentage
      text       = p_text.

ENDFORM.                    " progress
*&---------------------------------------------------------------------*
*&      Form  INIT_GLOBAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_global_data .

  CLEAR: g_title,
         g_subscreen,
         go_results_handler,
         s_bug[],
         s_comp[],
         s_dead[],
         s_dev[],
         s_enddat[],
         s_erdat[],
         s_aedat[],
         s_estado[],
         s_prod[],
         s_rep[],
         s_stype[],
         s_type[],
         s_test[].


ENDFORM.                    " INIT_GLOBAL_DATA
