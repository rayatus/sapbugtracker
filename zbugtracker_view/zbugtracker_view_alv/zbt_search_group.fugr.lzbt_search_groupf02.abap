*----------------------------------------------------------------------*
***INCLUDE LZBT_SEARCH_GROUPF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  STATUS_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM status_0001 .
  SET PF-STATUS 'S0001'.
  SET TITLEBAR 'T0001' WITH g_title.

ENDFORM.                    " STATUS_0001
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command_0001 .
  DATA: lt_data  TYPE zbt_bugs,
        l_ucomm  TYPE sy-ucomm.

  l_ucomm = sy-ucomm.
  CLEAR sy-ucomm.
  CASE l_ucomm.
    WHEN 'BACK' OR 'UP' OR 'CANCEL'.
      LEAVE TO SCREEN 0.

    WHEN 'EXECUTE'.
      IF NOT go_container IS INITIAL.
        go_container->free( ).
        FREE go_container.
        CLEAR go_container.
      ENDIF.

      CREATE OBJECT go_container
        EXPORTING
          repid     = sy-repid
          dynnr     = sy-dynnr
          side      = cl_gui_docking_container=>dock_at_bottom
          extension = 150.

      go_results_handler->do_search(
        bug             = s_bug[]
        bugstype        = s_stype[]
        bugtype         = s_type[]
        componente      = s_comp[]
        deadline        = s_dead[]
        estado          = s_estado[]
        horas_estimadas = s_hest[]
        horas_reales    = s_hreal[]
        producto        = s_prod[]
        resumen         = s_resum[]
        creado          = s_erdat[]
        reporter        = s_rep[]
        developer       = s_dev[]
        tester          = s_test[]
        finalizado      = s_enddat[]
        aedat           = s_aedat[] ).

      go_results_handler->display_results( go_container ).
    WHEN OTHERS.

  ENDCASE.
ENDFORM.                    " USER_COMMAND_0001
*&---------------------------------------------------------------------*
*&      Form  CHK_SELECTION_SCREEN_A0003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_selection_screen_a0003 .

ENDFORM.                    " CHK_SELECTION_SCREEN_A0003
