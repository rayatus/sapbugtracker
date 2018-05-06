FORM CD_CALL_ZBUGTRACKER.
  IF   ( UPD_ZBT_ATTACHMENT NE SPACE )
    OR ( UPD_ZBT_BUG NE SPACE )
    OR ( UPD_ZBT_BUGCOMMENT NE SPACE )
    OR ( UPD_ZBT_BUGSECCION NE SPACE )
    OR ( UPD_ZBT_PROGRAMS NE SPACE )
    OR ( UPD_ZBT_TRANSPORTER NE SPACE )
    OR ( UPD_ICDTXT_ZBUGTRACKER NE SPACE )
  .
    CALL FUNCTION 'SWE_REQUESTER_TO_UPDATE'.
    CALL FUNCTION 'ZBUGTRACKER_WRITE_DOCUMENT' IN UPDATE TASK
        EXPORTING
          OBJECTID                = OBJECTID
          TCODE                   = TCODE
          UTIME                   = UTIME
          UDATE                   = UDATE
          USERNAME                = USERNAME
          PLANNED_CHANGE_NUMBER   = PLANNED_CHANGE_NUMBER
          OBJECT_CHANGE_INDICATOR = CDOC_UPD_OBJECT
          PLANNED_OR_REAL_CHANGES = CDOC_PLANNED_OR_REAL
          NO_CHANGE_POINTERS      = CDOC_NO_CHANGE_POINTERS
          YZBT_BUGCOMMENT
                      = YZBT_BUGCOMMENT
          XZBT_BUGCOMMENT
                      = XZBT_BUGCOMMENT
* updateflag of ZBT_ATTACHMENT
          UPD_ZBT_ATTACHMENT
                      = UPD_ZBT_ATTACHMENT
* workarea_old of OLD_BUG
          O_OLD_BUG
                      = OLD_BUG
* workarea_new of ZBT_BUG
          N_ZBT_BUG
                      = ZBT_BUG
* updateflag of ZBT_BUG
          UPD_ZBT_BUG
                      = UPD_ZBT_BUG
* updateflag of ZBT_BUGCOMMENT
          UPD_ZBT_BUGCOMMENT
                      = UPD_ZBT_BUGCOMMENT
* updateflag of ZBT_BUGSECCION
          UPD_ZBT_BUGSECCION
                      = UPD_ZBT_BUGSECCION
* updateflag of ZBT_PROGRAMS
          UPD_ZBT_PROGRAMS
                      = UPD_ZBT_PROGRAMS
* updateflag of ZBT_TRANSPORTER
          UPD_ZBT_TRANSPORTER
                      = UPD_ZBT_TRANSPORTER
          UPD_ICDTXT_ZBUGTRACKER
                      = UPD_ICDTXT_ZBUGTRACKER
        TABLES
          ICDTXT_ZBUGTRACKER
                      = ICDTXT_ZBUGTRACKER
          XZBT_ATTACHMENT
                      = XZBT_ATTACHMENT
          YZBT_ATTACHMENT
                      = YZBT_ATTACHMENT
          XZBT_BUGSECCION
                      = XZBT_BUGSECCION
          YZBT_BUGSECCION
                      = YZBT_BUGSECCION
          XZBT_PROGRAMS
                      = XZBT_PROGRAMS
          YZBT_PROGRAMS
                      = YZBT_PROGRAMS
          XZBT_TRANSPORTER
                      = XZBT_TRANSPORTER
          YZBT_TRANSPORTER
                      = YZBT_TRANSPORTER
    .
  ENDIF.
  CLEAR PLANNED_CHANGE_NUMBER.
ENDFORM.
