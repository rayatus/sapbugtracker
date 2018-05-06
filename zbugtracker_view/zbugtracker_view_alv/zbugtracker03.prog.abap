*&---------------------------------------------------------------------*
*& Report  ZBUGTRACKER03
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbugtracker03.

DATA: o_search    TYPE REF TO zcl_searches_alv_ctrl,
      screen_attr TYPE zbt_screen_attributes.

INITIALIZATION.
  screen_attr-title = 'Advanced Search'(001).

START-OF-SELECTION.
  CREATE OBJECT o_search.
  o_search->search( screen_attr ).
