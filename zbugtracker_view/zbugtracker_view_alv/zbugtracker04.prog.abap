*&---------------------------------------------------------------------*
*& Report  ZBUGTRACKER04
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbugtracker04.

DATA: o_search    TYPE REF TO zcl_search_last_mod_alv_ctrl,
      screen_attr TYPE zbt_screen_attributes.

INITIALIZATION.
  screen_attr-title = 'Search by last modification'(001).

START-OF-SELECTION.
  CREATE OBJECT o_search.
  o_search->search( screen_attr ).
