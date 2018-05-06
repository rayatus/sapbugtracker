*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROI05 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0400 INPUT.

data: lv_objkey  like borident-objkey.

   ls_object-objkey = go_bug->get_id( ).

call function 'SWU_OBJECT_RESTORE'
exporting
objtype = 'ZBUG_TRACK'
objkey = lv_objkey.

ENDMODULE.                 " USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400_EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0400_EXIT INPUT.


ENDMODULE.                 " USER_COMMAND_0400_EXIT  INPUT
