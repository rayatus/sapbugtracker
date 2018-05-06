*----------------------------------------------------------------------*
***INCLUDE LZBT_TR_BUG_GROUPF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command_0001 .
  DATA: lo_exception TYPE REF TO zcx_transport_alv_ctrl_exc,
        l_string     TYPE string.

  CASE sy-ucomm.
    WHEN 'CONTINUE'.
      TRY .
          go_trbug_ctrl->save_data( ).
          commit WORK.
          gv_continue = 'X'.
          PERFORM exit.
        CATCH zcx_transport_alv_ctrl_exc INTO lo_exception.
          l_string = lo_exception->get_text( ).
          MESSAGE l_string TYPE 'I' DISPLAY LIKE 'E'.
      ENDTRY.

  ENDCASE.
ENDFORM.                    " USER_COMMAND_0001
*&---------------------------------------------------------------------*
*&      Form  EXIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exit .
  LEAVE TO SCREEN 0.
ENDFORM.                    " EXIT
