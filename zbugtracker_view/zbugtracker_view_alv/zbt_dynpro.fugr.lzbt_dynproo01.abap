*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0001 OUTPUT.
  PERFORM status_0001.
ENDMODULE.                 " STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SET_SUBSCREENS_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_subscreens_0001 OUTPUT.
  PERFORM set_subscreens_0001.
ENDMODULE.                 " SET_SUBSCREENS_0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0300 OUTPUT.
  PERFORM pbo_0300.
ENDMODULE.                 " PBO_0300  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SET_DISPLAY_MODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_display_mode OUTPUT.
  PERFORM set_dynpro_display_mode USING g_display_mode.
ENDMODULE.                 " SET_DISPLAY_MODE  OUTPUT
