*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROF05 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_INTERNAL_BUG_ID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_INTERNAL_BUG_ID .

 DATA: l_number_range TYPE tnro-object.
*

    l_number_range = 'ZBT_BUGIDI'. "Default Number Range

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = l_number_range
      quantity                      = '1'
*     TOYEAR                        = '0000'
   IMPORTING
     number                        = lv_bug_i
*     QUANTITY                      =
*     RETURNCODE                    =
   EXCEPTIONS
     INTERVAL_NOT_FOUND            = 1
     NUMBER_RANGE_NOT_INTERN       = 2
     OBJECT_NOT_FOUND              = 3
     QUANTITY_IS_0                 = 4
     QUANTITY_IS_NOT_1             = 5
     INTERVAL_OVERFLOW             = 6
     BUFFER_OVERFLOW               = 7
     OTHERS                        = 8
            .
  IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " GET_INTERNAL_BUG_ID
