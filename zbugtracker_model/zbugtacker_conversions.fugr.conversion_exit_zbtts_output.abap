FUNCTION conversion_exit_zbtts_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CHAR14
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CHAR19
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ltype_timestamp,
          year(4)    TYPE c,
          month(2)   TYPE c,
          day(2)     TYPE c,
          hour(2)    TYPE c,
          minutes(2) TYPE c,
          seconds(2) TYPE c,
         END   OF ltype_timestamp.

  DATA: l_timestamp TYPE ltype_timestamp,
        l_date      TYPE char10,
        l_hour      TYPE char8.

  IF NOT input IS INITIAL.
    l_timestamp = input.

    CONCATENATE l_timestamp-day  l_timestamp-month   l_timestamp-year    INTO l_date SEPARATED BY '.'.
    CONCATENATE l_timestamp-hour l_timestamp-minutes l_timestamp-seconds INTO l_hour SEPARATED BY ':'.

    CONCATENATE l_date l_hour INTO output SEPARATED BY space.
  ENDIF.

ENDFUNCTION.
