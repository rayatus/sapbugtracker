FUNCTION-POOL zbt_search_group.             "MESSAGE-ID ..

TABLES: zbt_bug, zbt_producto, zbt_compont.

DATA: go_container         TYPE REF TO cl_gui_docking_container,
      go_results_handler   TYPE REF TO zinf_results_alv_ctrl,
      g_title              TYPE sy-title,
      BEGIN OF g_subscreen,
        repid TYPE sy-repid,
        dynnr TYPE sy-dynnr,
      END   OF g_subscreen.

*--------------------------------------------------------------------*
* Selection Screen with all allowed criterias
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0002 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK a0002 WITH FRAME.
SELECT-OPTIONS: s_bug     FOR zbt_bug-bug             MEMORY ID zbt_bug_id,
                s_prod    FOR zbt_producto-producto   MEMORY ID zbt_product_id,
                s_comp    FOR zbt_compont-componente,
                s_dev     FOR zbt_bug-developer       MATCHCODE OBJECT zbt_f4_developers,
                s_test    FOR zbt_bug-tester          MATCHCODE OBJECT zbt_f4_testers,
                s_rep     FOR zbt_bug-reporter        MATCHCODE OBJECT zbt_f4_reporters,
                s_erdat   FOR zbt_bug-creado,
                s_enddat  FOR zbt_bug-finalizado,
                s_dead    FOR zbt_bug-deadline,
                s_estado  FOR zbt_bug-estado,
                s_type    FOR zbt_bug-bugtype,
                s_stype   FOR zbt_bug-bugstype,
                s_hest    FOR zbt_bug-horas_est,
                s_hreal   FOR zbt_bug-horas_rea,
                s_resum   FOR zbt_bug-resumen.
SELECTION-SCREEN END OF BLOCK a0002.
SELECTION-SCREEN END   OF SCREEN 0002.


*--------------------------------------------------------------------*
* Selection Screen with all allowed criterias
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0003 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK a0003 WITH FRAME.
SELECTION-SCREEN INCLUDE SELECT-OPTIONS: s_bug,
                                         s_prod,
                                         s_comp.
SELECT-OPTIONS: s_aedat   FOR zbt_bug-aedat .
PARAMETERS: p_rows TYPE i.
SELECTION-SCREEN END OF BLOCK a0003.
SELECTION-SCREEN END   OF SCREEN 0003.

AT SELECTION-SCREEN ON BLOCK a0002.
  PERFORM chk_selection_screen_a0002.

AT SELECTION-SCREEN ON BLOCK a0003.
  PERFORM chk_selection_screen_a0003.
