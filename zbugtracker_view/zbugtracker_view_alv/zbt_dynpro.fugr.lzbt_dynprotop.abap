FUNCTION-POOL zbt_dynpro.                   "MESSAGE-ID ..

TYPE-POOLS: abap, icon, vrm.

TYPES: BEGIN OF gtype_users_text,
        reporter  TYPE string,
        developer TYPE string,
        tester    TYPE string,
       END   OF gtype_users_text.

*&---------------------------------------------------------------------*
*&       Class LCL_HANDLER
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    METHODS: on_comment_added FOR EVENT comment_added OF zcl_comment_gui_controller
                IMPORTING sender.

ENDCLASS.               "LCL_HANDLER

CONSTANTS: BEGIN OF c_main_tc_def,
             tab1 LIKE sy-ucomm VALUE 'TAB1',
             tab2 LIKE sy-ucomm VALUE 'TAB2',
             tab3 LIKE sy-ucomm VALUE 'TAB3',
             tab4 LIKE sy-ucomm VALUE 'TAB4',
             tab5 LIKE sy-ucomm VALUE 'TAB5',
           END OF c_main_tc_def,
           c_initial_bug_status TYPE zbt_id_estado VALUE '1',
           c_initial_bug_id     TYPE zbt_id_bug    VALUE '0000000000'.

CONTROLS main_tc TYPE TABSTRIP.
DATA:  BEGIN OF gt_main_tc_ctr,
        icon        TYPE icon-id,
        text(10)    TYPE c,
        subscreen   TYPE sy-dynnr,
        prog        TYPE sy-repid VALUE sy-repid,
        pressed_tab TYPE sy-ucomm VALUE c_main_tc_def-tab1,
       END OF gt_main_tc_ctr.

DATA: g_top_screen                  TYPE sy-dynnr,
      g_bug_status_icon             TYPE char80,
      g_bug_stype_icon              TYPE char80,
      g_display_mode                TYPE flag,
      g_display_mode_txt            TYPE string,
      g_bug                         TYPE zbt_bug,
      go_bug                        TYPE REF TO zcl_bug,
      go_old_bug                    TYPE REF TO zcl_bug,
      g_users_txt                   TYPE gtype_users_text,
      g_producto                    TYPE zbt_producto_structure,
      g_componente                  TYPE zbt_compont_txt,
      g_comments_container          TYPE REF TO cl_gui_custom_container,
      g_problem_section_container   TYPE REF TO cl_gui_container,
      g_steps_section_container     TYPE REF TO cl_gui_container,
      g_more_info_section_container TYPE REF TO cl_gui_container,
      g_info_container              TYPE REF TO cl_gui_custom_container,
      g_info_splitter_container     TYPE REF TO cl_gui_splitter_container,
      g_problem_btf                 TYPE REF TO zcl_btf_editor,
      g_steps_btf                   TYPE REF TO zcl_btf_editor,
      g_more_info_btf               TYPE REF TO zcl_btf_editor,
      go_handler                    TYPE REF TO lcl_handler.
