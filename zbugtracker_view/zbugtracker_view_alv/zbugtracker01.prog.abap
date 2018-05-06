*&---------------------------------------------------------------------*
*& Report  ZBUGTRACKER02
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbugtracker01.

DATA: o_bug        TYPE REF TO zcl_bug.

START-OF-SELECTION.

END-OF-SELECTION.

  CALL FUNCTION 'ZBT_CREATE_BUG'
    IMPORTING
      bug = o_bug.
