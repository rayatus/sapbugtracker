*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZBUGTRACKERMODEL
*   generation date: 17.03.2013 at 21:51:21 by user BCUSER
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZBUGTRACKERMODEL   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
