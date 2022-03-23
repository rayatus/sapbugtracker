FUNCTION conversion_exit_zbtts_input.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CHAR19
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CHAR14
*"----------------------------------------------------------------------

  TRANSLATE input USING '. '.
  TRANSLATE input USING ': '.
  CONDENSE input NO-GAPS.

  CONCATENATE input+4(4)
              input+2(2)
              input(2)
              input+8(6)
                 INTO output.


ENDFUNCTION.
