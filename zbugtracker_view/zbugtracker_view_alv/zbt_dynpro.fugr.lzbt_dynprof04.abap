*----------------------------------------------------------------------*
***INCLUDE LZBT_DYNPROF04 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PBO_0400
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo_0400 .


  PERFORM create_attachment_grid.

ENDFORM.                                                    " pbo_0400

*&---------------------------------------------------------------------*
*&      Form  create_attachment_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_attachment_grid .
  DATA: lo_attachment_gui TYPE REF TO zcl_bug_attachment_alv_ctrl.
  DATA: l_title    TYPE lvc_title.

    DATA lo_container TYPE REF TO cl_gui_container.

 IF NOT g_attachment_container IS BOUND.
    CREATE OBJECT  g_attachment_container
      EXPORTING
        container_name = 'ATTACHMENT_CONTAINER'.

 l_title = 'Attachment List'(408).

    CREATE OBJECT go_attachment_gui
      EXPORTING
        bug       = go_bug
        container = g_attachment_container
        title     = l_title.

    set HANDLER go_attachment_gui->handle_hotspot_click FOR ALL INSTANCES.
    set HANDLER go_attachment_gui->user_command FOR ALL INSTANCES.

    go_attachment_gui->display( ).

endif.

ENDFORM.                    " create_attachment_grid
*&---------------------------------------------------------------------*
*&      Form  CREATE_GOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_GOS .

FREE:  g_attachment_GOS .

  IF g_attachment_GOS   IS INITIAL.
* Schlüssel für generisches Objekt MUSS eindeutig sein!!!
    ls_object-objkey = go_bug->get_id_i( ).
    move 'ZBUG_TRACK' to ls_object-objtype.

* Anlagen liegen in der Tabelle  SRGBTBREL !!!!!
* Ausblenden verschiedener Standardservices
* zu finden in der Tabelle SGOSATTR
    SELECT name FROM sgosattr INTO ls_service-low WHERE
        name NE 'VIEW_ATTA' AND
        name NE 'NOTE_CREA' AND
        name NE 'PERS_NOTE' AND
        name NE 'SO_SENDOBJ' AND
        name NE 'PCATTA_CREA'.
      ls_service-sign = 'E'.
      ls_service-option = 'EQ'.
*       ls_service-low = sgosattr-name.
      APPEND ls_service TO lt_service.
    ENDSELECT.

    lv_ip_mode = 'E'.

*IO_CALLBACK  TYPE REF TO IF_GOS_CALLBACK OPTIONAL  Callback for Runtime Determination of Publication
*IP_START_DIRECT  TYPE SGS_FLAG  DEFAULT space  Start Toolbox Immediately (Performance)
*IP_NO_INSTANCE TYPE SGS_FLAG  DEFAULT space  Call from Attachment TA, Object is Notified
*IP_NO_COMMIT	TYPE SGS_CMODE  DEFAULT 'X'	See Fixed Values of SGS_CMODE
*IP_MODE  TYPE SGS_RWMOD  DEFAULT 'E' SGOS: Display/Change Mode of Generic Object Services


    CREATE OBJECT g_attachment_GOS
      EXPORTING
        is_object            = ls_object
        ip_mode              = lv_ip_mode
        ip_no_commit         = ' '
        it_service_selection = lt_service
*        IP_NO_INSTANCE  = 'X'
      EXCEPTIONS
        OTHERS               = 1.

  endif.
ENDFORM.                    " CREATE_GOS
