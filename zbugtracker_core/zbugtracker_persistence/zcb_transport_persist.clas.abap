class ZCB_TRANSPORT_PERSIST definition
  public
  inheriting from CL_OS_CA_COMMON
  abstract
  create public .

public section.
*"* public components of class ZCB_TRANSPORT_PERSIST
*"* do not include other source files here!!!

  methods CREATE_PERSISTENT
    importing
      !I_BUG type ZBT_ID_BUG
      !I_PRODUCTO type ZBT_ID_PRODUCTO
      !I_TRANSPORTREQ type ZBT_TRANSPORTREQ
    returning
      value(RESULT) type ref to ZCL_TRANSPORT_PERSIST
    raising
      CX_OS_OBJECT_EXISTING .
  methods CREATE_TRANSIENT
    importing
      !I_BUG type ZBT_ID_BUG
      !I_PRODUCTO type ZBT_ID_PRODUCTO
      !I_TRANSPORTREQ type ZBT_TRANSPORTREQ
    returning
      value(RESULT) type ref to ZCL_TRANSPORT_PERSIST
    raising
      CX_OS_OBJECT_EXISTING .
  methods DELETE_PERSISTENT
    importing
      !I_BUG type ZBT_ID_BUG
      !I_PRODUCTO type ZBT_ID_PRODUCTO
      !I_TRANSPORTREQ type ZBT_TRANSPORTREQ
    raising
      CX_OS_OBJECT_NOT_EXISTING .
  methods GET_PERSISTENT
    importing
      !I_BUG type ZBT_ID_BUG
      !I_PRODUCTO type ZBT_ID_PRODUCTO
      !I_TRANSPORTREQ type ZBT_TRANSPORTREQ
    returning
      value(RESULT) type ref to ZCL_TRANSPORT_PERSIST
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_TRANSIENT
    importing
      !I_BUG type ZBT_ID_BUG
      !I_PRODUCTO type ZBT_ID_PRODUCTO
      !I_TRANSPORTREQ type ZBT_TRANSPORTREQ
    returning
      value(RESULT) type ref to ZCL_TRANSPORT_PERSIST
    raising
      CX_OS_OBJECT_NOT_FOUND .

  methods IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY
    redefinition .
  methods IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY_TAB
    redefinition .
  methods IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_QUERY
    redefinition .
  methods IF_OS_CA_SERVICE~SAVE
    redefinition .
  methods IF_OS_CA_SERVICE~SAVE_IN_UPDATE_TASK
    redefinition .
  methods IF_OS_FACTORY~CREATE_PERSISTENT_BY_KEY
    redefinition .
  methods IF_OS_FACTORY~CREATE_TRANSIENT_BY_KEY
    redefinition .
protected section.
*"* protected components of class ZCB_TRANSPORT_PERSIST
*"* do not include other source files here!!!

  types TYP_OID type OS_GUID .
  types TYP_TYPE type OS_GUID .
  types TYP_OBJECT_REF type ref to ZCL_TRANSPORT_PERSIST .
  types:
    begin of TYP_BUSINESS_KEY ,
      BUG type ZBT_ID_BUG ,
      PRODUCTO type ZBT_ID_PRODUCTO ,
      TRANSPORTREQ type ZBT_TRANSPORTREQ ,
    end of TYP_BUSINESS_KEY .
  types:
    TYP_BUSINESS_KEY_TAB type standard table of
      TYP_BUSINESS_KEY with non-unique default key .
  types:
    begin of TYP_DB_DATA ,
      BUG type ZBT_ID_BUG ,
      PRODUCTO type ZBT_ID_PRODUCTO ,
      TRANSPORTREQ type ZBT_TRANSPORTREQ ,
    end of TYP_DB_DATA .
  types:
    TYP_DB_DATA_TAB type standard table of
      TYP_DB_DATA with non-unique default key .
  types:
    TYP_OID_TAB type standard table of
      TYP_OID with non-unique default key .
  types:
    TYP_OBJECT_REF_TAB type standard table of
      TYP_OBJECT_REF with non-unique default key .
  types:
    begin of TYP_SPECIAL_OBJECT_INFO ,
      OBJECT_ID type TYP_INTERNAL_OID ,
      ID_STATUS type TYP_ID_STATUS ,
      BUSINESS_KEY type TYP_BUSINESS_KEY ,
    end of TYP_SPECIAL_OBJECT_INFO .
  types:
    TYP_SPECIAL_OBJECT_INFO_TAB type sorted table of
      TYP_SPECIAL_OBJECT_INFO with unique key
      OBJECT_ID .
  types:
    TYP_SPECIAL_BKEY_TAB type sorted table of
      TYP_SPECIAL_OBJECT_INFO with unique key
      BUSINESS_KEY .
  types:
    TYP_DB_DELETE_TAB type standard table of
      TYP_SPECIAL_OBJECT_INFO with non-unique default key .

  data CURRENT_SPECIAL_OBJECT_INFO type TYP_SPECIAL_OBJECT_INFO .
  data MAP_ATT_INFO_TAB type OSTYP_RT_MAP_ATT_INFO_SRT_TAB .
  data SPECIAL_BKEY_TAB type TYP_SPECIAL_BKEY_TAB .
  data SPECIAL_OBJECT_INFO type TYP_SPECIAL_OBJECT_INFO_TAB .

  methods MAP_EXTRACT_IDENTIFIER
    importing
      !I_DB_DATA type TYP_DB_DATA
    exporting
      value(E_BUSINESS_KEY) type TYP_BUSINESS_KEY .
  methods MAP_GET_ATTRIBUTES
    importing
      !I_OBJECT_REF_TAB type TYP_OBJECT_REF_TAB
    exporting
      value(E_OBJECT_DATA_TAB) type TYP_DB_DATA_TAB .
  methods MAP_INITIALIZE_METADATA .
  methods MAP_LOAD_FROM_DATABASE
    importing
      !I_ORDER_BY_CLAUSE type STRING optional
      !I_SUBCLASSES type OS_BOOLEAN default OSCON_FALSE
      !I_UPTO type I default 0
      !I_WHERE_CLAUSE type STRING optional
      !PAR1 type ANY optional
      !PAR2 type ANY optional
      !PAR3 type ANY optional
    returning
      value(RESULT) type TYP_DB_DATA_TAB .
  methods MAP_LOAD_FROM_DATABASE_KEY
    importing
      !I_BUSINESS_KEY_TAB type TYP_BUSINESS_KEY_TAB
    returning
      value(RESULT) type TYP_DB_DATA_TAB .
  methods MAP_MERGE_IDENTIFIER
    importing
      !I_BUSINESS_KEY_TAB type TYP_BUSINESS_KEY_TAB
    changing
      !C_DB_DATA_TAB type TYP_DB_DATA_TAB .
  methods MAP_SAVE_TO_DATABASE
    importing
      !I_DELETES type TYP_DB_DELETE_TAB
      !I_INSERTS type TYP_DB_DATA_TAB
      !I_UPDATES type TYP_DB_DATA_TAB .
  methods MAP_SERIALIZE_BKEY
    importing
      !I_BUSINESS_KEY type TYP_BUSINESS_KEY
    returning
      value(RESULT) type STRING .
  methods MAP_SET_ATTRIBUTES
    importing
      !I_OBJECT_DATA type TYP_DB_DATA
      !I_OBJECT_REF type TYP_OBJECT_REF
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods PM_CHECK_AND_SET_ATTRIBUTES
    importing
      !I_BUSINESS_KEY type TYP_BUSINESS_KEY optional
      !I_ID_PROVIDED type TYP_ID_STATUS default 0
      !I_OBJECT_DATA type TYP_DB_DATA
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods PM_CREATE_REPRESENTANT
    importing
      !I_BUSINESS_KEY type TYP_BUSINESS_KEY optional
    returning
      value(RESULT) type TYP_OBJECT_REF .
  methods PM_DELETE_PERSISTENT .
  methods PM_LOAD_AND_SET_ATTRIBUTES
    importing
      !I_BUSINESS_KEY type TYP_BUSINESS_KEY optional
    raising
      CX_OS_OBJECT_NOT_FOUND .

  methods DELETE_SPECIAL_OBJECT_INFO
    redefinition .
  methods LOAD_SPECIAL_OBJECT_INFO
    redefinition .
  methods MAP_INVALIDATE
    redefinition .
  methods OS_PM_DELETE_PERSISTENT
    redefinition .
  methods PM_LOAD
    redefinition .
  methods SAVE_SPECIAL_OBJECT_INFO
    redefinition .
private section.
*"* private components of class ZCB_TRANSPORT_PERSIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCB_TRANSPORT_PERSIST IMPLEMENTATION.


method CREATE_PERSISTENT.
***BUILD 093901
*      IMPORTING I_BUG TYPE ZBT_ID_BUG
*      IMPORTING I_PRODUCTO TYPE ZBT_ID_PRODUCTO
*      IMPORTING I_TRANSPORTREQ TYPE ZBT_TRANSPORTREQ
*      RETURNING RESULT TYPE REF TO ZCL_TRANSPORT_PERSIST
************************************************************************
* Purpose        : Create a new persistent object identified by the
*                  given business key
*
* Version        : 2.0
*
* Precondition   : No object exists with the given business key, neither
*                  in memory nor on database.
*
* Postcondition  : The object exists in memory and will result in a
*                  new entry on database when the top transaction is
*                  closed.
*
* OO Exceptions  : CX_OS_OBJECT_EXISTING(
*                            PERSISTENT_CREATING_PERSISTENT,
*                            TRANSIENT_CREATING_PERSISTENT)
*                  propagates OS_PM_CREATED_PERSISTENT
*
* Implementation : 1. Check if there is already an object with the
*                     same key
*                  2. If there is one, let OS_PM_HANDLE_CREATE_ON_EXIST
*                     decide if it is allowed to re-use the object
*                  3. If there is none, create a new object
*                  4. Set Attributes
*                  5. Register the object as NEW and initialize it
*                  6. Clean up
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version 2.0
* - 2000-08-03   : (SB)  OO Exceptions
* - 2001-01-10   : (SB)  persistent attributes as optional parameters
* - 2001-10-30   : (SB)  type mapping
* - 2002-01-17   : (SB)  private attributes in super classes
* - 2003-04-28   : (SB)  reuse of instances reimplemented
************************************************************************

  data: THE_OBJECT   type        TYP_OBJECT_REF,
        BUSINESS_KEY type        TYP_BUSINESS_KEY,
        BKEY_STRING  type        STRING.

  data: TEMP_CURRENT_OBJECT_IREF type ref to object.

  clear CURRENT_OBJECT_IREF.

*< Generated from mapping:
  BUSINESS_KEY-BUG = I_BUG.
  BUSINESS_KEY-PRODUCTO = I_PRODUCTO.
  BUSINESS_KEY-TRANSPORTREQ = I_TRANSPORTREQ.
*>

* * 1. Check if there is already an object with this key
  read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table key BUSINESS_KEY = BUSINESS_KEY.

  if ( SY-SUBRC = 0 ).

    read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
         with table key
         OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
    call method OS_LOAD_AND_VALIDATE_CURRENT
         exporting I_INDEX = SY-TABIX.

  endif. "( entry found )

  if ( not CURRENT_OBJECT_IREF is initial ).

*   * 2. Found an entry. Check if it is allowed to re-use it
    THE_OBJECT ?= CURRENT_OBJECT_IREF.

    case CURRENT_OBJECT_INFO-PM_STATUS.

    when OSCON_OSTATUS_DELETED or
        OSCON_OSTATUS_NOT_LOADED.

      try.

*<  Generated from mapping:
          THE_OBJECT->BUG = I_BUG.
          THE_OBJECT->PRODUCTO = I_PRODUCTO.
          THE_OBJECT->TRANSPORTREQ = I_TRANSPORTREQ.
*>

          call method OS_PM_HANDLE_CREATE_ON_EXIST
               exporting I_TRANSIENT = OSCON_FALSE.

        cleanup.
          clear CURRENT_SPECIAL_OBJECT_INFO.
          call method OS_CLEAR_CURRENT.
      endtry.

    when OSCON_OSTATUS_TRANSIENT.

      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_EXISTING definition load.
      raise exception type CX_OS_OBJECT_EXISTING
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID =
            CX_OS_OBJECT_EXISTING=>TRANSIENT_CREATING_PERSISTENT.

    when others.

      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_EXISTING definition load.
      raise exception type CX_OS_OBJECT_EXISTING
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID =
            CX_OS_OBJECT_EXISTING=>PERSISTENT_CREATING_PERSISTENT.

    endcase.

  else. "( No entry found )

*   * 3. Create a new object
    THE_OBJECT = PM_CREATE_REPRESENTANT(
                   I_BUSINESS_KEY = BUSINESS_KEY ).

*   * 4. Set attributes
*<   Generated from mapping:
*>

*   * 5. register object as 'NEW' and initialize it.
    call method OS_PM_CREATED_PERSISTENT.

  endif. "( Eintrag vorhanden )

* * 6. Clean-up
  clear CURRENT_SPECIAL_OBJECT_INFO.
  RESULT = THE_OBJECT.

           "CREATE_PERSISTENT
endmethod.


method CREATE_TRANSIENT.
***BUILD 093901
*      IMPORTING I_BUG TYPE ZBT_ID_BUG
*      IMPORTING I_PRODUCTO TYPE ZBT_ID_PRODUCTO
*      IMPORTING I_TRANSPORTREQ TYPE ZBT_TRANSPORTREQ
*      RETURNING RESULT TYPE REF TO ZCL_TRANSPORT_PERSIST
************************************************************************
* Purpose        : Create a new transient object identified by the
*                  given business key
*
* Version        : 2.0
*
* Precondition   : No object exists with the given business key, neither
*                  in memory nor on database.
*
* Postcondition  : The object exists in memory until it is RELEASEd
*
* OO Exceptions  : CX_OS_OBJECT_EXISTING(
*                            PERSISTENT_CREATING_TRANSIENT,
*                            TRANSIENT_CREATING_TRANSIENT)
*                  propagates OS_PM_CREATED_TRANSIENT
*
* Implementation : 1. Check if there is already an object with the
*                     same key
*                  2. If there is one, let OS_PM_HANDLE_CREATE_ON_EXIST
*                     decide if it is allowed to re-use the object
*                  3. If there is none, create a new object
*                  4. Set Attributes
*                  5. Register the object as TRANSIENT and initialize it
*                  6. Clean up
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
* - 2001-01-10   : (SB)  persistent attributes as optional parameters
* - 2001-10-30   : (SB)  type mapping
* - 2002-01-17   : (SB)  private attributes in super classes
* - 2003-04-28   : (SB)  reuse of instances reimplemented
************************************************************************

  data: THE_OBJECT   type        TYP_OBJECT_REF,
        BUSINESS_KEY type        TYP_BUSINESS_KEY,
        BKEY_STRING  type        STRING.

  data: TEMP_CURRENT_OBJECT_IREF type ref to object.

  clear CURRENT_OBJECT_IREF.

*< Generated from mapping:
  BUSINESS_KEY-BUG = I_BUG.
  BUSINESS_KEY-PRODUCTO = I_PRODUCTO.
  BUSINESS_KEY-TRANSPORTREQ = I_TRANSPORTREQ.
*>

* * 1. Check if there is already an object with the same key

  read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table key BUSINESS_KEY = BUSINESS_KEY.

  if ( SY-SUBRC = 0 ).

    read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
         with table key
         OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
    call method OS_LOAD_AND_VALIDATE_CURRENT
         exporting I_INDEX = SY-TABIX.

  endif. "( entry found )

  if ( not CURRENT_OBJECT_IREF is initial ).

*   * 2. Found an entry. Check if it is allowed to re-use it
    THE_OBJECT ?= CURRENT_OBJECT_IREF.

    case CURRENT_OBJECT_INFO-PM_STATUS.

    when OSCON_OSTATUS_DELETED or
        OSCON_OSTATUS_NOT_LOADED.

      try.

*<  Generated from mapping:
          THE_OBJECT->BUG = I_BUG.
          THE_OBJECT->PRODUCTO = I_PRODUCTO.
          THE_OBJECT->TRANSPORTREQ = I_TRANSPORTREQ.
*>

          call method OS_PM_HANDLE_CREATE_ON_EXIST
               exporting I_TRANSIENT = OSCON_TRUE.

        cleanup.
          clear CURRENT_SPECIAL_OBJECT_INFO.
          call method OS_CLEAR_CURRENT.
      endtry.

    when OSCON_OSTATUS_TRANSIENT.

      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_EXISTING definition load.
      raise exception type CX_OS_OBJECT_EXISTING
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID =
            CX_OS_OBJECT_EXISTING=>TRANSIENT_CREATING_TRANSIENT.

    when others.

      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_EXISTING definition load.
      raise exception type CX_OS_OBJECT_EXISTING
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID =
            CX_OS_OBJECT_EXISTING=>PERSISTENT_CREATING_TRANSIENT.

    endcase.

  else. "( Noch kein Eintrag )

*   * 3. If there is none, create a new object
    THE_OBJECT = PM_CREATE_REPRESENTANT(
                   I_BUSINESS_KEY = BUSINESS_KEY ).

*   * 4. Set attributes
*<   Generated from mapping:
*>

*   * 5. Register the object as TRANSIENT and initialize it
    call method OS_PM_CREATED_TRANSIENT.

  endif. "( Eintrag vorhanden )

* * 6. Clean up
  clear CURRENT_SPECIAL_OBJECT_INFO.
  RESULT = THE_OBJECT.

           "CREATE_TRANSIENT
endmethod.


method DELETE_PERSISTENT.
***BUILD 051402
*      IMPORTING I_BUG TYPE ZBT_ID_BUG.
*      IMPORTING I_PRODUCTO TYPE ZBT_ID_PRODUCTO.
*      IMPORTING I_TRANSPORTREQ TYPE ZBT_TRANSPORTREQ.
*      raising   CX_OS_OBJECT_NOT_EXISTING
************************************************************************
* Purpose        : Delete persistent object. It is marked DELETED in
*                  memory and removed from DB when the top transaction
*                  is closed.
*
* Version        : 2.0
*
* Precondition   : The object is persistent (not transient)
*
* Postcondition  : Instance is marked for deletion.
*
* OO Exceptions  : CX_OS_OBJECT_NOT_EXISTING(TRANSIENT_BY_BKEY,
*                  CREATED_AND_DELETED_BY_BKEY,BY_BKEY)
*                  ( propagates PM_LOAD_AND_SET_ATTRIBUTES )
*                  propagates PM_DELETE_PERSISTENT
*
* Implementation : 1. Check if there is already an object with that
*                     business key
*                  2. If not: create representative object and check
*                     if there is an entry on DB (Need to be sure that
*                     no other object exists with the OID that belongs
*                     to the given Business Key)
*                  3. If it already exists: call PM_DELETE_PERSISTENT
*
************************************************************************
* Changelog:
* - 1999-09-21   : (OS)  Initial Version
* - 2000-03-06   : (BGR) Version 2.0
* - 2000-08-03   : (SB)  OO Exceptions
* - 2000-10-30   : (SB)  Type Mapping
************************************************************************

  data: BUSINESS_KEY type TYP_BUSINESS_KEY .
  data: EX_OS_OBJECT_NOT_FOUND type ref to CX_OS_OBJECT_NOT_FOUND.
  data: EX_OS_OBJECT_STATE type ref to CX_OS_OBJECT_STATE.
  data: BKEY_STRING type STRING.

* 1. Check if there is already an object with that business key

  clear: CURRENT_OBJECT_IREF,
         CURRENT_SPECIAL_OBJECT_INFO.

*< Generated from mapping:
  BUSINESS_KEY-BUG = I_BUG.
  BUSINESS_KEY-PRODUCTO = I_PRODUCTO.
  BUSINESS_KEY-TRANSPORTREQ = I_TRANSPORTREQ.
*>

  read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table key BUSINESS_KEY = BUSINESS_KEY.

  if ( SY-SUBRC = 0 ).

    read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
         with table key
         OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
    call method OS_LOAD_AND_VALIDATE_CURRENT
         exporting I_INDEX = SY-TABIX.

  endif.

  if ( CURRENT_OBJECT_IREF is initial ).

*   * 2. If not: create representative object and check
*   *    if there is an entry on DB (Need to be sure that
*   *    no other object exists with the OID that belongs
*   *    to the given Business Key)

    try.

        call method PM_LOAD_AND_SET_ATTRIBUTES
             exporting I_BUSINESS_KEY = BUSINESS_KEY.

      catch CX_OS_OBJECT_NOT_FOUND into EX_OS_OBJECT_NOT_FOUND.
*       * If the object is not found by key - raise object not existing
*       * by key. If a reference has a illegal class GUID (i.e. object
*       * not found by ref error) - ignore.
        if ( EX_OS_OBJECT_NOT_FOUND->TEXTID =
             CX_OS_OBJECT_NOT_FOUND=>BY_BKEY ).
          call method OS_CLEAR_CURRENT.
          class CX_OS_OBJECT_NOT_EXISTING definition load.
          raise exception type CX_OS_OBJECT_NOT_EXISTING
            exporting
              BKEY   = EX_OS_OBJECT_NOT_FOUND->BKEY
              TABLE  = EX_OS_OBJECT_NOT_FOUND->TABLE
              TEXTID = CX_OS_OBJECT_NOT_EXISTING=>BY_BKEY.
        endif.

      cleanup.
        call method OS_CLEAR_CURRENT.

    endtry.



  endif." ( No Entry in administrative data? )


* * 3. If it already exists: call PM_DELETE_PERSISTENT
  if not ( CURRENT_OBJECT_IREF is initial ).

    try.

        call method PM_DELETE_PERSISTENT.

      catch CX_OS_OBJECT_STATE into EX_OS_OBJECT_STATE.
      if ( EX_OS_OBJECT_STATE->TEXTID =
           CX_OS_OBJECT_STATE=>TRANSIENT ).
        BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
        class CX_OS_OBJECT_NOT_EXISTING definition load.
        raise exception type CX_OS_OBJECT_NOT_EXISTING
          exporting
            BKEY   = BKEY_STRING
            TEXTID = CX_OS_OBJECT_NOT_EXISTING=>TRANSIENT_BY_BKEY.
      endif.

      if ( EX_OS_OBJECT_STATE->TEXTID =
           CX_OS_OBJECT_STATE=>CREATED_AND_DELETED ).
        BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
        class CX_OS_OBJECT_NOT_EXISTING definition load.
        raise exception type CX_OS_OBJECT_NOT_EXISTING
          exporting
            BKEY   = BKEY_STRING
            TEXTID =
              CX_OS_OBJECT_NOT_EXISTING=>CREATED_AND_DELETED_BY_BKEY.
      endif.

    endtry.

  endif.
           "DELETE_PERSISTENT
endmethod.


method DELETE_SPECIAL_OBJECT_INFO.
***BUILD 051401
************************************************************************
* Purpose        : Delete current entry SPECIAL_OBJECT_INFO
*
* Version        : 2.0
*
* Precondition   : Index is set in CURRENT_OBJECT_INDEX
*
* Postcondition  : entry is deleted
*
* OO Exceptions  : --
*
* Implementation :
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
* - 2001-10-30   : (SB)  Type Mapping
************************************************************************

  read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
       index CURRENT_OBJECT_INDEX.

  delete table SPECIAL_BKEY_TAB
    with table key
      BUSINESS_KEY = CURRENT_SPECIAL_OBJECT_INFO-BUSINESS_KEY.

  delete SPECIAL_OBJECT_INFO index CURRENT_OBJECT_INDEX.
  clear CURRENT_SPECIAL_OBJECT_INFO.

           "DELETE_SPECIAL_OBJECT_INFO
endmethod.


method GET_PERSISTENT.
***BUILD 051402
*      importing I_BUG TYPE ZBT_ID_BUG.
*      importing I_PRODUCTO TYPE ZBT_ID_PRODUCTO.
*      importing I_TRANSPORTREQ TYPE ZBT_TRANSPORTREQ.
*      returning RESULT TYPE REF TO ZCL_TRANSPORT_PERSIST
*       raising   CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get reference of an persistent object.
*
* Version        : 2.0
*
* Precondition   : --
*
* Postcondition  : Persistent object is active
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*                    (IS_TRANSIENT_BY_BKEY,DELETED_BY_BKEY)
*                  propagates PM_LOAD_AND_SET_ATTRIBUTES
*                  propagates OS_PM_LOADED_PERISISTENT
*
* Implementation : 1. Look for object in SPECIAL_OBJECT_INFO. If found,
*                     check if it is still valid
*                  2. Object found: Check PM_STATUS
*                     2a. If Status is TRANSIENT or DELETED, error!
*                     2b. If Status is NOT_LOADED, continue with 3.
*                     2c. If Status is NEW, LOADED or CHANGED, success!
*                  3. Load object data from database and set object
*                  3.a. Completion in super class
*                  4. clean up
*
************************************************************************
* Changelog:
* - 1999-09-21   : (OS)  Initial Version
* - 2000-03-07   : (BGR) Version 2.0 - Common Superclass
* - 2000-08-02   : (SB)  OO Exceptions
* - 2000-10-30   : (SB)  Type Mapping
* - 2004-01-21   : (SB)  Type Mapping Refactoring
************************************************************************

  data: BUSINESS_KEY    type TYP_BUSINESS_KEY,
        FLAG_NOT_LOADED type OS_BOOLEAN,
        BKEY_STRING     type STRING.

  data: TEMP_CURRENT_OBJECT_IREF type ref to OBJECT.

* * 1. Look for object in SPECIAL_OBJECT_INFO. If found, check if it
* * is still valid

  clear:  CURRENT_OBJECT_IREF.

*< Generated from mapping:
  BUSINESS_KEY-BUG = I_BUG.
  BUSINESS_KEY-PRODUCTO = I_PRODUCTO.
  BUSINESS_KEY-TRANSPORTREQ = I_TRANSPORTREQ.
*>

  read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table key BUSINESS_KEY = BUSINESS_KEY.

  if ( SY-SUBRC = 0 ).

    read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
         with table key
         OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
    call method OS_LOAD_AND_VALIDATE_CURRENT
         exporting I_INDEX = SY-TABIX.

  endif.

  if ( not CURRENT_OBJECT_IREF is initial ).

* * 2. Object found: Check PM_STATUS

    case CURRENT_OBJECT_INFO-PM_STATUS.

*   * 2a. If Status is TRANSIENT or DELETED, error!
    when OSCON_OSTATUS_DELETED.

*!!!!! Error: Object activation failed - Object marked for deletion
      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_NOT_FOUND definition load.
      raise exception type CX_OS_OBJECT_NOT_FOUND
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID = CX_OS_OBJECT_NOT_FOUND=>DELETED_BY_BKEY.

    when OSCON_OSTATUS_TRANSIENT.

*!!!!! Error: Object activation failed - Object is transient
      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_NOT_FOUND definition load.
      raise exception type CX_OS_OBJECT_NOT_FOUND
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID = CX_OS_OBJECT_NOT_FOUND=>IS_TRANSIENT_BY_BKEY.


*   * 2b. If Status is NOT_LOADED, continue with 3.
    when OSCON_OSTATUS_NOT_LOADED.

      FLAG_NOT_LOADED      = OSCON_TRUE.

*   * 2c. If Status is NEW, LOADED or CHANGED, success!
    when others.

      FLAG_NOT_LOADED      = OSCON_FALSE.

    endcase. "PM_STATUS

  else." ( CURRENT_OBJECT_IREF is initial ).

    FLAG_NOT_LOADED      = OSCON_TRUE.

  endif." ( Entry in administrative data? )

* * 3. Load object data from database and set object

  if (  FLAG_NOT_LOADED = OSCON_TRUE ).

*   * internal Undo
    append INTERNAL_NEXT_UNDO_INFO to INTERNAL_TRANSACTION_STACK.
    INTERNAL_CURRENT_TRANSACTION = SY-TABIX.

    try.
        call method PM_LOAD_AND_SET_ATTRIBUTES
             exporting I_BUSINESS_KEY = BUSINESS_KEY.

        result ?= CURRENT_OBJECT_IREF.

*       * 3.a. Completion in super class
        call method OS_PM_LOADED_PERSISTENT.

      cleanup.
        call method OS_INTERNAL_UNDO.
        call method OS_CLEAR_CURRENT.
        clear CURRENT_SPECIAL_OBJECT_INFO.
    endtry.

*   * Clean-up internal Undo
    delete INTERNAL_TRANSACTION_STACK
           index INTERNAL_CURRENT_TRANSACTION.
    add -1 to INTERNAL_CURRENT_TRANSACTION.
    if ( INTERNAL_TRANSACTION_STACK is initial ).
      clear INTERNAL_UNDO_INFO.
      INTERNAL_NEXT_UNDO_INFO = 1.
    endif. "( INTERNAL_TRANSACTION_STACK is initial? )

  else. "( Object already loaded )

    RESULT ?= CURRENT_OBJECT_IREF.
    call method OS_CLEAR_CURRENT.

  endif. "( Loading necessesary? )

* * 4. clean up

  clear  CURRENT_SPECIAL_OBJECT_INFO.


           "GET_PERSISTENT
endmethod.


method GET_TRANSIENT.
***BUILD 051402
*      IMPORTING I_BUG TYPE ZBT_ID_BUG.
*      IMPORTING I_PRODUCTO TYPE ZBT_ID_PRODUCTO.
*      IMPORTING I_TRANSPORTREQ TYPE ZBT_TRANSPORTREQ.
*      RETURNING RESULT TYPE REF TO ZCL_TRANSPORT_PERSIST
*       raising   CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get reference of an transient object.
*
* Version        : 2.0
*
* Precondition   : object has been created transient
*
* Postcondition  : --
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*                  (TRANSIENT_BY_BKEY, IS_PERSISTENT_BY_BKEY)
*
* Implementation : 1. look for entry in SPECIAL_OBJECT_INFO and check
*                     if it is still valid
*                  2. If it not valid or no object found: Error
*                  3. If it is valid: Check state
*                    3a. Not Transient: Error!
*                    3b. Transient: Success!
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version
* - 2000-08-03   : (SB)  OO Exceptions
* - 2000-10-30   : (SB)  Type Mapping
************************************************************************

  data: BUSINESS_KEY type TYP_BUSINESS_KEY,
        BKEY_STRING  type STRING .

  data: TEMP_CURRENT_OBJECT_IREF type ref to OBJECT.

* * 1. look for entry in SPECIAL_OBJECT_INFO and check if it is
* *    still valid

  clear CURRENT_OBJECT_IREF.

*< Generated from mapping:
  BUSINESS_KEY-BUG = I_BUG.
  BUSINESS_KEY-PRODUCTO = I_PRODUCTO.
  BUSINESS_KEY-TRANSPORTREQ = I_TRANSPORTREQ.
*>

  read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table KEY BUSINESS_KEY = BUSINESS_KEY.

  if ( SY-SUBRC = 0 ).

    read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
         with table key
         OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
    call method OS_LOAD_AND_VALIDATE_CURRENT
         exporting I_INDEX = SY-TABIX.

  endif.

* * 2. If it not valid or no object found: Error
  if ( CURRENT_OBJECT_IREF is initial ).

*!!! Error: Object activation failed - no entry in administrative data
    BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
    clear CURRENT_SPECIAL_OBJECT_INFO.
    class CX_OS_OBJECT_NOT_FOUND definition load.
    raise exception type CX_OS_OBJECT_NOT_FOUND
      exporting
        BKEY   = BKEY_STRING
        TEXTID = CX_OS_OBJECT_NOT_FOUND=>TRANSIENT_BY_BKEY.

  else. "( Entry exists )

*   * 3. If it is valid: Check state
    if ( CURRENT_OBJECT_INFO-PM_STATUS <> OSCON_OSTATUS_TRANSIENT ).

*     * 3a. Not Transient: Error!
*!!!!! Error: Object is not transient
      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_NOT_FOUND definition load.
      raise exception type CX_OS_OBJECT_NOT_FOUND
        exporting
          OBJECT = TEMP_CURRENT_OBJECT_IREF
          BKEY   = BKEY_STRING
          TEXTID = CX_OS_OBJECT_NOT_FOUND=>IS_PERSISTENT_BY_BKEY.

    endif. "( PM_STATUS <> transient )

  endif." ( Entry in administrative data? )

* * 3b. Transient: Success!
  RESULT ?= CURRENT_OBJECT_IREF.
  call method OS_CLEAR_CURRENT.
  clear CURRENT_SPECIAL_OBJECT_INFO.

           "GET_TRANSIENT
endmethod.


method IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY.
***BUILD 051402
*      importing I_KEY type any
*      returning result type ref to object
************************************************************************
* Purpose        : Get a persistent object identified by the
*                  given business key
*
* Version        : 2.0
*
* Precondition   : The object exists with the given business key,
*                  either in memory or on database.
*
* Postcondition  : The object exists in memory, RESULT is the reference
*
* OO Exceptions  : propagates GET_PERSISTENT
*
* Implementation : call GET_PERSISTENT
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************

  data: BUSINESS_KEY             type TYP_BUSINESS_KEY.

  BUSINESS_KEY = I_KEY.

*< Generated from mapping:
  call method GET_PERSISTENT
       exporting I_BUG = BUSINESS_KEY-BUG
                 I_PRODUCTO = BUSINESS_KEY-PRODUCTO
                 I_TRANSPORTREQ = BUSINESS_KEY-TRANSPORTREQ
       receiving RESULT = RESULT.
*>

           "IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY
endmethod.


method IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY_TAB.
***BUILD 051402
      "importing I_KEY_TAB type INDEX TABLE
      "returning value(RESULT) type OSREFTAB
      "raising   CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get persistent objects by Business Key table
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : For each entry in the KEY table, there is a corres-
*                  ponding entry in the RESULT table. If the object was
*                  found in the cache or the database, then a reference
*                  to this object can be found in the RESULT table,
*                  if not, the reference is initial. The persistent
*                  objects are active.
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*                    (IS_TRANSIENT_BY_BKEY,DELETED_BY_BKEY)
*                  propagates PM_LOAD_AND_SET_ATTRIBUTES
*                  propagates OS_PM_LOADED_PERISISTENT
*
* Implementation : 1. Look for object in SPECIAL_OBJECT_INFO. If found,
*                     check if it is still valid
*                  2. Object found: Check PM_STATUS
*                     2a. If Status is TRANSIENT or DELETED, error!
*                     2b. If Status is NOT_LOADED, continue with 3.
*                     2c. If Status is NEW, LOADED or CHANGED, success!
*                  3. Load object data from database and set object
*                     3.a Completion in super class
*                  4. clean up
*
************************************************************************
* Changelog:
* - 2004-01-07   : (SB)  Initial version
************************************************************************

  types: begin of TYP_BUSINESS_KEY_INDEX,
           BUSINESS_KEY     type TYP_BUSINESS_KEY,
           INDEX            type SY-TABIX,
         end of TYP_BUSINESS_KEY_INDEX,
         TYP_BUSINESS_KEY_INDEX_TAB type sorted table
           of TYP_BUSINESS_KEY_INDEX with non-unique key BUSINESS_KEY.

  data: FLAG_NOT_LOADED        type OS_BOOLEAN,
        BKEY_STRING            type STRING,
        TEMP_OBJECT_REF        type TYP_OBJECT_REF,
        BUSINESS_KEY           type TYP_BUSINESS_KEY,
        BUSINESS_KEY_TAB       type TYP_BUSINESS_KEY_TAB,
        OBJECT_DATA_TAB        type TYP_DB_DATA_TAB,
        BUSINESS_KEY_INDEX     type TYP_BUSINESS_KEY_INDEX,
        BUSINESS_KEY_INDEX_TAB type TYP_BUSINESS_KEY_INDEX_TAB,
        NEXT_INDEX             type SY-TABIX.

  data: TEMP_CURRENT_OBJECT_IREF type ref to OBJECT.

  field-symbols: <FS_OBJECT_DATA>  type TYP_DB_DATA,
                 <FS_BUSINESS_KEY> type TYP_BUSINESS_KEY,
                 <FS_BUSINESS_KEY_INDEX> type TYP_BUSINESS_KEY_INDEX.

* * 1. Look for objects in SPECIAL_OBJECT_INFO. If found, check if they
* * are still valid

  loop at I_KEY_TAB assigning <FS_BUSINESS_KEY>. "#EC GEN_OK

    clear CURRENT_OBJECT_IREF.

    read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
       with table key BUSINESS_KEY = <FS_BUSINESS_KEY>.

    if ( SY-SUBRC = 0 ).

      read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
           with table key
           OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
      call method OS_LOAD_AND_VALIDATE_CURRENT
           exporting I_INDEX = SY-TABIX.

    endif.

    if ( not CURRENT_OBJECT_IREF is initial ).

*   * 2. Object found: Check PM_STATUS

      case CURRENT_OBJECT_INFO-PM_STATUS.

*     * 2a. If Status is TRANSIENT or DELETED, error!
      when OSCON_OSTATUS_DELETED.

*!!!!!!! Error: Object activation failed - Object marked for deletion
        TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
        BKEY_STRING  = MAP_SERIALIZE_BKEY( <FS_BUSINESS_KEY> ).
        call method OS_CLEAR_CURRENT.
        clear CURRENT_SPECIAL_OBJECT_INFO.
        class CX_OS_OBJECT_NOT_FOUND definition load.
        raise exception type CX_OS_OBJECT_NOT_FOUND
          exporting
            OBJECT = TEMP_CURRENT_OBJECT_IREF
            BKEY   = BKEY_STRING
            TEXTID = CX_OS_OBJECT_NOT_FOUND=>DELETED_BY_BKEY.

      when OSCON_OSTATUS_TRANSIENT.

*!!!!!!! Error: Object activation failed - Object is transient
        TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
        BKEY_STRING  = MAP_SERIALIZE_BKEY( <FS_BUSINESS_KEY> ).
        call method OS_CLEAR_CURRENT.
        clear CURRENT_SPECIAL_OBJECT_INFO.
        class CX_OS_OBJECT_NOT_FOUND definition load.
        raise exception type CX_OS_OBJECT_NOT_FOUND
          exporting
            OBJECT = TEMP_CURRENT_OBJECT_IREF
            BKEY   = BKEY_STRING
            TEXTID = CX_OS_OBJECT_NOT_FOUND=>IS_TRANSIENT_BY_BKEY.

*     * 2b. If Status is NOT_LOADED, continue with 3.
      when OSCON_OSTATUS_NOT_LOADED.

        FLAG_NOT_LOADED = OSCON_TRUE.

*     * 2c. If Status is NEW, LOADED or CHANGED, success!
      when others.

        FLAG_NOT_LOADED = OSCON_FALSE.

      endcase.

    else." ( CURRENT_OBJECT_IREF is initial )

      FLAG_NOT_LOADED = OSCON_TRUE.

    endif.

    if ( FLAG_NOT_LOADED = OSCON_TRUE ).

      append <FS_BUSINESS_KEY> to BUSINESS_KEY_TAB.

    endif.

    TEMP_OBJECT_REF ?= CURRENT_OBJECT_IREF.
    append TEMP_OBJECT_REF to RESULT.

    call method OS_CLEAR_CURRENT.

  endloop.

* * 3. Load object data from database and set objects

  if ( BUSINESS_KEY_TAB is not initial ).

*   * internal Undo
    append INTERNAL_NEXT_UNDO_INFO to INTERNAL_TRANSACTION_STACK.
    INTERNAL_CURRENT_TRANSACTION = SY-TABIX.

    try.
        call method MAP_LOAD_FROM_DATABASE_KEY
             exporting I_BUSINESS_KEY_TAB = BUSINESS_KEY_TAB
             receiving result = OBJECT_DATA_TAB.
      catch CX_OS_DB_SELECT.
        clear OBJECT_DATA_TAB.
    endtry.

    loop at I_KEY_TAB assigning <FS_BUSINESS_KEY>. "EC GEN_OK
      BUSINESS_KEY_INDEX-BUSINESS_KEY = <FS_BUSINESS_KEY>.
      BUSINESS_KEY_INDEX-INDEX = SY-TABIX.
      insert BUSINESS_KEY_INDEX into table BUSINESS_KEY_INDEX_TAB.
    endloop.

    try.

        loop at OBJECT_DATA_TAB assigning <FS_OBJECT_DATA>.

          call method MAP_EXTRACT_IDENTIFIER
               exporting I_DB_DATA  = <FS_OBJECT_DATA>
               importing E_BUSINESS_KEY = BUSINESS_KEY.

          clear CURRENT_OBJECT_IREF.

          call method PM_CHECK_AND_SET_ATTRIBUTES
               exporting I_OBJECT_DATA  = <FS_OBJECT_DATA>
                         I_ID_PROVIDED  = ID_STATUS_NONE.

          TEMP_OBJECT_REF ?= CURRENT_OBJECT_IREF.

          read table BUSINESS_KEY_INDEX_TAB
               with key BUSINESS_KEY = BUSINESS_KEY
               assigning <FS_BUSINESS_KEY_INDEX>.

          while ( ( SY-SUBRC = 0 ) and
                  ( <FS_BUSINESS_KEY_INDEX>-BUSINESS_KEY =
                    BUSINESS_KEY ) ).

            NEXT_INDEX = SY-TABIX + 1.

            modify RESULT from TEMP_OBJECT_REF
                          index <FS_BUSINESS_KEY_INDEX>-INDEX.

            read table BUSINESS_KEY_INDEX_TAB
                 index NEXT_INDEX
                 assigning <FS_BUSINESS_KEY_INDEX>.

          endwhile.

*         * 3.a. Completion in super class
          call method OS_PM_LOADED_PERSISTENT.

          clear CURRENT_SPECIAL_OBJECT_INFO.

        endloop.

      cleanup.
        call method OS_INTERNAL_UNDO.
        call method OS_CLEAR_CURRENT.
        clear CURRENT_SPECIAL_OBJECT_INFO.
    endtry.

*   * Clean-up internal Undo
    delete INTERNAL_TRANSACTION_STACK
           index INTERNAL_CURRENT_TRANSACTION.
    add -1 to INTERNAL_CURRENT_TRANSACTION.
    if ( INTERNAL_TRANSACTION_STACK is initial ).
      clear INTERNAL_UNDO_INFO.
      INTERNAL_NEXT_UNDO_INFO = 1.
    endif. "( INTERNAL_TRANSACTION_STACK is initial? )

  endif.

* * 4. clean up

  clear CURRENT_SPECIAL_OBJECT_INFO.


           "IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_KEY_TAB
endmethod.


method IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_QUERY.
***BUILD 051402
     " importing I_QUERY type ref to IF_OS_QUERY
     "           I_PARAMETER_TAB type OSTYP_DREF_TAB optional
     "           I_PAR1 type ANY optional
     "           I_PAR2 type ANY optional
     "           I_PAR3 type ANY optional
     "           I_SUBCLASSES type OS_BOOLEAN default OSCON_FALSE
     "           I_UPTO type I default 0
     " returning value(RESULT) type OSREFTAB
     " raising   CX_OS_OBJECT_NOT_FOUND
     "           CX_OS_QUERY_ERROR
************************************************************************
* Purpose        : Get persistent objects by Query
*
* Version        : 2.0
*
* Precondition   : --
*
* Postcondition  : For each instance that satifies the filter
*                  expression, there is a corresponding entry in the
*                  RESULT table. The persistent objects are active.
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*                    (DELETED_BY_BKEY,TRANSIENT_BY_BKEY)
*                  propagates PM_CHECK_AND_SET_ATTRIBUTES
*                  propagates OS_PM_LOADED_PERISISTENT
*
* Implementation : 1. Load data by query
*                  2. Set objects from data
*                  2a. Object found: Check PM_STATUS
*                  2b. Object not found, replace
*                  2c. Set attributes
*                  2d. Completion in super class
*                  3. clean up
*
************************************************************************
* Changelog:
* - 2004-03-25   : (SB)  Initial version
************************************************************************

  data: FLAG_NOT_LOADED  type OS_BOOLEAN,
        BKEY_STRING      type STRING,
        TEMP_OBJECT_REF  type TYP_OBJECT_REF,
        BUSINESS_KEY     type TYP_BUSINESS_KEY,
        OBJECT_DATA_TAB  type TYP_DB_DATA_TAB,
        QUERY            type ref to IF_OS_QRY_SERVICE,
        WHERE_CLAUSE     type STRING,
        ORDER_BY_CLAUSE  type STRING.

  data: TEMP_CURRENT_OBJECT_IREF type ref to OBJECT.

  field-symbols: <FS_OBJECT_DATA>  type TYP_DB_DATA.

* * 1. Load data with query

  try.
      call method MAP_INITIALIZE_METADATA.

      QUERY ?= I_QUERY.

      call method QUERY->MAP
           exporting I_CLASS_AGENT = ME
                     I_MAP_ATT_TAB = MAP_ATT_INFO_TAB.

      call method QUERY->GET_ORDER_BY_CLAUSE
           receiving RESULT = ORDER_BY_CLAUSE.

      if ( I_PARAMETER_TAB is supplied ).

        if ( ( I_PAR1 is supplied ) or
             ( I_PAR2 is supplied ) or
             ( I_PAR3 is supplied ) ).

          raise exception type CX_OS_QUERY_PARAMETER_ERROR
            exporting TEXTID = CX_OS_QUERY_PARAMETER_ERROR=>CALL_ERROR.

        endif.

        call method QUERY->GET_WHERE_CLAUSE
             exporting I_PARAMETER_TAB = I_PARAMETER_TAB
             receiving RESULT = WHERE_CLAUSE.

        call method MAP_LOAD_FROM_DATABASE
             exporting I_WHERE_CLAUSE    = WHERE_CLAUSE
                       I_ORDER_BY_CLAUSE = ORDER_BY_CLAUSE
                       I_SUBCLASSES      = I_SUBCLASSES
                       I_UPTO            = I_UPTO
             receiving result = OBJECT_DATA_TAB.

      else.

        call method QUERY->GET_WHERE_CLAUSE
             receiving RESULT = WHERE_CLAUSE.

        call method MAP_LOAD_FROM_DATABASE
             exporting I_WHERE_CLAUSE    = WHERE_CLAUSE
                       I_ORDER_BY_CLAUSE = ORDER_BY_CLAUSE
                       I_SUBCLASSES      = I_SUBCLASSES
                       I_UPTO            = I_UPTO
                       PAR1              = I_PAR1
                       PAR2              = I_PAR2
                       PAR3              = I_PAR3
             receiving result = OBJECT_DATA_TAB.

      endif.
    catch CX_OS_DB_SELECT.
      clear OBJECT_DATA_TAB.
  endtry.

* * 2. Set objects from data

  try.

*     * internal Undo
      append INTERNAL_NEXT_UNDO_INFO to INTERNAL_TRANSACTION_STACK.
      INTERNAL_CURRENT_TRANSACTION = SY-TABIX.

      loop at OBJECT_DATA_TAB assigning <FS_OBJECT_DATA>.

        call method MAP_EXTRACT_IDENTIFIER
             exporting I_DB_DATA  = <FS_OBJECT_DATA>
             importing E_BUSINESS_KEY = BUSINESS_KEY.

        clear CURRENT_OBJECT_IREF.

        read table SPECIAL_BKEY_TAB into CURRENT_SPECIAL_OBJECT_INFO
           with table key BUSINESS_KEY = BUSINESS_KEY.

        if ( SY-SUBRC = 0 ).

          read table SPECIAL_OBJECT_INFO
               into CURRENT_SPECIAL_OBJECT_INFO
               with table key
               OBJECT_ID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.
          call method OS_LOAD_AND_VALIDATE_CURRENT
               exporting I_INDEX = SY-TABIX.

        endif.

        if ( not CURRENT_OBJECT_IREF is initial ).

*       * 2a. Object found: Check PM_STATUS

          case CURRENT_OBJECT_INFO-PM_STATUS.

*         * 2a1. If Status is TRANSIENT or DELETED, error!
          when OSCON_OSTATUS_DELETED.

* !!!!!!!! Error: Object activation failed - Object marked for deletion
            TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
            BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
            call method OS_CLEAR_CURRENT.
            clear CURRENT_SPECIAL_OBJECT_INFO.
            class CX_OS_OBJECT_NOT_FOUND definition load.
            raise exception type CX_OS_OBJECT_NOT_FOUND
              exporting
                OBJECT = TEMP_CURRENT_OBJECT_IREF
                BKEY   = BKEY_STRING
                TEXTID = CX_OS_OBJECT_NOT_FOUND=>DELETED_BY_BKEY.

          when OSCON_OSTATUS_TRANSIENT.

* !!!!!!!!!! Error: Object activation failed - Object is transient
            TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
            BKEY_STRING  = MAP_SERIALIZE_BKEY( BUSINESS_KEY ).
            call method OS_CLEAR_CURRENT.
            clear CURRENT_SPECIAL_OBJECT_INFO.
            class CX_OS_OBJECT_NOT_FOUND definition load.
            raise exception type CX_OS_OBJECT_NOT_FOUND
              exporting
                OBJECT = TEMP_CURRENT_OBJECT_IREF
                BKEY   = BKEY_STRING
                TEXTID = CX_OS_OBJECT_NOT_FOUND=>IS_TRANSIENT_BY_BKEY.

*         * 2a2. If Status is NOT_LOADED, replace
          when OSCON_OSTATUS_NOT_LOADED.

            FLAG_NOT_LOADED = OSCON_TRUE.

*         * 2a2. If Status is NEW, LOADED or CHANGED, don't replace
          when others.

            FLAG_NOT_LOADED = OSCON_FALSE.

          endcase.

        else." ( CURRENT_OBJECT_IREF is initial )

*       * 2b. Object not found, replace

          FLAG_NOT_LOADED = OSCON_TRUE.

        endif.

        TEMP_OBJECT_REF ?= CURRENT_OBJECT_IREF.

        if ( FLAG_NOT_LOADED = OSCON_TRUE ).

*         * 2c. Set attributes
          call method PM_CHECK_AND_SET_ATTRIBUTES
               exporting I_OBJECT_DATA  = <FS_OBJECT_DATA>
                         I_ID_PROVIDED  = ID_STATUS_NONE.

          TEMP_OBJECT_REF ?= CURRENT_OBJECT_IREF.

*         * 2d. Completion in super class
          call method OS_PM_LOADED_PERSISTENT.

        endif.

        append TEMP_OBJECT_REF to RESULT.

        call method OS_CLEAR_CURRENT.

      endloop.

*     * Clean-up internal Undo
      delete INTERNAL_TRANSACTION_STACK
             index INTERNAL_CURRENT_TRANSACTION.
      add -1 to INTERNAL_CURRENT_TRANSACTION.
      if ( INTERNAL_TRANSACTION_STACK is initial ).
        clear INTERNAL_UNDO_INFO.
        INTERNAL_NEXT_UNDO_INFO = 1.
      endif. "( INTERNAL_TRANSACTION_STACK is initial? )

    cleanup.
      call method OS_INTERNAL_UNDO.
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
  endtry.

* * 3. clean up

  clear CURRENT_SPECIAL_OBJECT_INFO.


           "IF_OS_CA_PERSISTENCY~GET_PERSISTENT_BY_QUERY
endmethod.


method IF_OS_CA_SERVICE~SAVE.
***BUILD 051401
************************************************************************
* Purpose        : Prepare data for database (buffer) transfer
*
* Version        : 2.0
*
* Precondition   : --
*
* Postcondition  : data is prepared for saving
*                  if UPDATE_MODE is direct, it is saved to DB
*                  if UPDATE_MODE is LOCAL or UPDATE_TASK,
*                    the corresponding function call is registered
*
* OO Exceptions  : propagates MAP_SAVE_TO_DATABASE
*                  propagates MAP_GET_ATTRIBUTES.
*
* Implementation :
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
* - 2000-08-02   : (SB) OO Exceptions
* - 2001-01-06   : (SB) Update with EXPORT TO DATA BUFFER
* - 2003-03-20   : (SB) post only if there dirty instances
************************************************************************

  data: NEW_OBJECT_REF_TAB       type TYP_OBJECT_REF_TAB,
        CHANGED_OBJECT_REF_TAB   type TYP_OBJECT_REF_TAB,
        INSERT_DATA_TAB          type TYP_DB_DATA_TAB ,
        INSERT_KEY_TAB           type TYP_BUSINESS_KEY_TAB,
        UPDATE_DATA_TAB          type TYP_DB_DATA_TAB ,
        UPDATE_KEY_TAB           type TYP_BUSINESS_KEY_TAB,
        DELETE_TAB               type TYP_DB_DELETE_TAB ,
        UPDATE_MODE              type OS_DMODE,
        OBJECT_REF               type TYP_OBJECT_REF,
        OBJECT_INDEX             type TYP_INDEX,
        XCONTAINER               type XSTRING.

  field-symbols:
          <FS_OBJECT_INFO_ITEM>         type TYP_OBJECT_INFO,
          <FS_SPECIAL_OBJECT_INFO_ITEM> type TYP_SPECIAL_OBJECT_INFO.

* * 1. get strong reference, BKey for all objects with status
* *    NEW, CHANGED or DELETED

  loop at OBJECT_INFO assigning <FS_OBJECT_INFO_ITEM> "#EC CI_SORTSEQ
       where ( PM_STATUS = OSCON_OSTATUS_NEW or       "#EC CI_SORTSEQ
               PM_STATUS = OSCON_OSTATUS_CHANGED or   "#EC CI_SORTSEQ
              PM_STATUS = OSCON_OSTATUS_DELETED ) and "#EC CI_SORTSEQ
               OM_IGNORE = OSCON_FALSE.               "#EC CI_SORTSEQ

    OBJECT_INDEX = sy-tabix.

    case <FS_OBJECT_INFO_ITEM>-PM_STATUS.

      when OSCON_OSTATUS_NEW.

        read table SPECIAL_OBJECT_INFO
             assigning <FS_SPECIAL_OBJECT_INFO_ITEM>
             index OBJECT_INDEX.

        OBJECT_REF ?= <FS_OBJECT_INFO_ITEM>-OBJECT_IREF.
        append OBJECT_REF
            to NEW_OBJECT_REF_TAB.
        append <FS_SPECIAL_OBJECT_INFO_ITEM>-BUSINESS_KEY
            to INSERT_KEY_TAB.

      when OSCON_OSTATUS_CHANGED.

        read table SPECIAL_OBJECT_INFO
             assigning <FS_SPECIAL_OBJECT_INFO_ITEM>
             index OBJECT_INDEX.

        OBJECT_REF ?= <FS_OBJECT_INFO_ITEM>-OBJECT_IREF.
        append OBJECT_REF
            to CHANGED_OBJECT_REF_TAB.
        append <FS_SPECIAL_OBJECT_INFO_ITEM>-BUSINESS_KEY
            to UPDATE_KEY_TAB.

      when OSCON_OSTATUS_DELETED.

        read table SPECIAL_OBJECT_INFO
             assigning <FS_SPECIAL_OBJECT_INFO_ITEM>
             index OBJECT_INDEX.

        append <FS_SPECIAL_OBJECT_INFO_ITEM> to DELETE_TAB.

    endcase." Status

  endloop. "at OBJECT_INFO


* * 2. get attributes for new and changed objects

* * New Objects
  if ( not NEW_OBJECT_REF_TAB is initial ).

    call method MAP_GET_ATTRIBUTES
         exporting I_OBJECT_REF_TAB  = NEW_OBJECT_REF_TAB
         importing E_OBJECT_DATA_TAB = INSERT_DATA_TAB.

    call method MAP_MERGE_IDENTIFIER
         exporting I_BUSINESS_KEY_TAB = INSERT_KEY_TAB
         changing  C_DB_DATA_TAB      = INSERT_DATA_TAB.

  endif. "( not NEW_OBJECT_REF_TAB is initial ).

* * Changed Objects
  if ( not CHANGED_OBJECT_REF_TAB is initial ).

    call method MAP_GET_ATTRIBUTES
         exporting I_OBJECT_REF_TAB  = CHANGED_OBJECT_REF_TAB
         importing E_OBJECT_DATA_TAB = UPDATE_DATA_TAB.

    call method MAP_MERGE_IDENTIFIER
         exporting I_BUSINESS_KEY_TAB = UPDATE_KEY_TAB
         changing  C_DB_DATA_TAB      = UPDATE_DATA_TAB.

  endif. "( not CHANGED_OBJECT_REF_TAB is initial ).

* * 3. perform or subscribe DB operations

  if ( ( INSERT_DATA_TAB is not initial ) or
       ( UPDATE_DATA_TAB is not initial ) or
       ( DELETE_TAB is not initial ) ).

    UPDATE_MODE = PERSISTENCY_MANAGER->GET_UPDATE_MODE(  ).
    if ( UPDATE_MODE = DMODE_DIRECT ).

*     * Direct DB operations
      call method MAP_SAVE_TO_DATABASE
           exporting I_INSERTS = INSERT_DATA_TAB
                     I_UPDATES = UPDATE_DATA_TAB
                     I_DELETES = DELETE_TAB.

    else." ( Update task )

*     * export data to be saved to DB to data buffer
      export
        INSERT_DATA_TAB = INSERT_DATA_TAB
        UPDATE_DATA_TAB = UPDATE_DATA_TAB
        DELETE_TAB      = DELETE_TAB
          to data buffer XCONTAINER.

*     * call update function in update task. this function
*     * calls the method if_os_ca_service~save_in_update_task
*     * of this class agent.
      call function 'OS_UPDATE_CLASS' in update task
        exporting
          CLASSNAME = CLASS_INFO-CLASS_AGENT_NAME
          XCONTAINER = XCONTAINER.

    endif." (Update mode?)

  endif." (something to post?)

           "IF_OS_CA_SERVICE~SAVE
endmethod.


method IF_OS_CA_SERVICE~SAVE_IN_UPDATE_TASK.
***BUILD 051401
     " importing XCONTAINER type XSTRING optional
************************************************************************
* Purpose        : save object data to DB when running in update task
*                  mode.
*
* Version        : 2.0
*
* Precondition   : no object service environment is set, no objects
*                  exist in update task
*
* Postcondition  : data has been saved to DB
*
* OO Exceptions  : propagates MAP_SAVE_TO_DATABASE
*
* Implementation :
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
* - 2000-08-02   : (SB) OO Exceptions
* - 2001-01-06   : (SB) Update with EXPORT TO DATA BUFFER
************************************************************************

  data: INSERT_DATA_TAB       type TYP_DB_DATA_TAB ,
        UPDATE_DATA_TAB       type TYP_DB_DATA_TAB ,
        DELETE_TAB            type TYP_DB_DELETE_TAB .

* * import data to be saved to DB from data buffer
  import
    INSERT_DATA_TAB = INSERT_DATA_TAB
    UPDATE_DATA_TAB = UPDATE_DATA_TAB
    DELETE_TAB      = DELETE_TAB
      from data buffer XCONTAINER.

* * store them to DB
  call method MAP_SAVE_TO_DATABASE
       exporting I_INSERTS = INSERT_DATA_TAB
                 I_UPDATES = UPDATE_DATA_TAB
                 I_DELETES = DELETE_TAB.

           "IF_OS_CA_SERVICE~SAVE_IN_UPDATE_TASK
endmethod.


method IF_OS_FACTORY~CREATE_PERSISTENT_BY_KEY.
***BUILD 051402
*      importing I_KEY type any
*      returning result type ref to object
************************************************************************
* Purpose        : Create a new persistent object identified by the
*                  given business key
*
* Version        : 2.0
*
* Precondition   : No object exists with the given business key, neither
*                  in memory nor on database.
*
* Postcondition  : The object exists in memory and will result in a
*                  new entry on database when the top transaction is
*                  closed.
*
* OO Exceptions  : propagates CREATE_PERSISTENT
*
* Implementation : call CREATE_PERSISTENT
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************

  data: BUSINESS_KEY             type TYP_BUSINESS_KEY.

  BUSINESS_KEY = I_KEY.

*< Generated from mapping:
  call method CREATE_PERSISTENT
       exporting I_BUG = BUSINESS_KEY-BUG
                 I_PRODUCTO = BUSINESS_KEY-PRODUCTO
                 I_TRANSPORTREQ = BUSINESS_KEY-TRANSPORTREQ
       receiving RESULT = RESULT.
*>

           "IF_OS_FACTORY~CREATE_PERSISTENT_BY_KEY
endmethod.


method IF_OS_FACTORY~CREATE_TRANSIENT_BY_KEY.
***BUILD 051402
*      importing I_KEY type any
*      returning result type ref to object
************************************************************************
* Purpose        : Create a new transient object identified by the
*                  given business key
*
* Version        : 2.0
*
* Precondition   : No object exists with the given business key
*
* Postcondition  : The object exists in memory
*
* OO Exceptions  : propagates CREATE_TRANSIENT
*
* Implementation : call CREATE_TRANSIENT
*
************************************************************************
* Changelog:
* - 2001-01-01   : (SB)  Initial Version 2.0
************************************************************************

  data: BUSINESS_KEY             type TYP_BUSINESS_KEY.

  BUSINESS_KEY = I_KEY.

*< Generated from mapping:
  call method CREATE_TRANSIENT
       exporting I_BUG = BUSINESS_KEY-BUG
                 I_PRODUCTO = BUSINESS_KEY-PRODUCTO
                 I_TRANSPORTREQ = BUSINESS_KEY-TRANSPORTREQ
       receiving RESULT = RESULT.
*>

           "IF_OS_FACTORY~CREATE_TRANSIENT_BY_KEY
endmethod.


method LOAD_SPECIAL_OBJECT_INFO.
***BUILD 051401
************************************************************************
* Purpose        : Load CURRENT_SPECIAL_OBJECT_INFO from
*                  SPECIAL_OBJECT_INFO
*
* Version        : 2.0
*
* Precondition   : Index is set in CURRENT_OBJECT_INDEX
*
* Postcondition  : entry is loaded
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
************************************************************************

  read table SPECIAL_OBJECT_INFO into CURRENT_SPECIAL_OBJECT_INFO
       index CURRENT_OBJECT_INDEX.

           "LOAD_SPECIAL_OBJECT_INFO
endmethod.


method MAP_EXTRACT_IDENTIFIER.
***BUILD 051402
     " importing I_DB_DATA type TYP_DB_DATA
     " exporting E_BUSINESS_KEY type TYP_BUSINESS_KEY
************************************************************************
* Purpose        : Extract Business Key from given DB_DATA
*
* Version        : 2.0
*
* Precondition   : DB_DATA is a structure with object data read from
*                  DB including Keys and GUID
*
* Postcondition  : E_BUSINESS_KEY is the business key extracted from
*                  I_DB_DATA
*
* OO Exceptions  : --
*
* Implementation :
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version
* - 2000-08-02   : (SB) OO Exceptions
************************************************************************
* Generated! Do not modify!
************************************************************************

*<Generated from mapping:
  E_BUSINESS_KEY-BUG  = I_DB_DATA-BUG.
  E_BUSINESS_KEY-PRODUCTO  = I_DB_DATA-PRODUCTO.
  E_BUSINESS_KEY-TRANSPORTREQ  = I_DB_DATA-TRANSPORTREQ.
*>

           "MAP_EXTRACT_IDENTIFIER
endmethod.


method MAP_GET_ATTRIBUTES.
***BUILD 093901
     " importing I_OBJECT_REF_TAB  type TYP_OBJECT_REF_TAB
     " exporting value(E_OBJECT_DATA_TAB) type TYP_DB_DATA_TAB
************************************************************************
* Purpose        : Get object data from objects
*
* Version        : 2.0
*
* Precondition   : I_OBJECT_REF_TAB is a list of objects that have a
*                  valid state (new, changed)
*
* Postcondition  : E_OBJECT_DATA_TAB contains all object data of the
*                  given objects. It is a table of the same size like
*                  I_OBJECT_REF_TAB with corresponding entries.
*                  GUID (and Business Key) will be added later.
*
* OO Exceptions  : CX_OS_OBJECT_REFERENCE collects GET_OID_BY_REF
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version
* - 2000-08-03   : (SB)  OO Exceptions
* - 2002-01-17   : (SB)  private attributes in super classes
************************************************************************
* Generated! Do not modify!
************************************************************************

  data: THE_OBJECT type ref to ZCL_TRANSPORT_PERSIST,
        OBJECT_DATA_ITEM type TYP_DB_DATA,
        PM_SERVICE       type ref to IF_OS_PM_SERVICE. "#EC NEEDED

  data: EX     type ref to CX_OS_ERROR, "#EC NEEDED
        EX_SYS type ref to CX_OS_SYSTEM_ERROR, "#EC NEEDED
        EX_TAB type OSTABLEREF.

  PM_SERVICE ?= PERSISTENCY_MANAGER.

  loop at I_OBJECT_REF_TAB into THE_OBJECT.

    clear OBJECT_DATA_ITEM.

*<  Generated from mapping:
    OBJECT_DATA_ITEM-BUG = THE_OBJECT->BUG.
    OBJECT_DATA_ITEM-PRODUCTO = THE_OBJECT->PRODUCTO.
    OBJECT_DATA_ITEM-TRANSPORTREQ = THE_OBJECT->TRANSPORTREQ.
*>

    APPEND OBJECT_DATA_ITEM TO E_OBJECT_DATA_TAB.

  endloop."at I_OBJECT_REF_TAB

  if ( not EX_TAB is initial ).
    raise exception type CX_OS_OBJECT_REFERENCE
          exporting EXCEPTION_TAB = EX_TAB.
  endif.

           "MAP_GET_ATTRIBUTES
"#EC CI_VALPAR
endmethod.


method MAP_INITIALIZE_METADATA.
***BUILD 093901
************************************************************************
* Purpose        : Initialize the mapping metadata,
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The mapping metadata table MAP_ATT_INFO_TAB
*                  contains an entry for all persistent attributes
*                  accessible from a query expression
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2004-03-25   : (SB)  Initial Version
************************************************************************


  data: MAP_ATT_INFO type OSTYP_RT_MAP_ATT_INFO.

  if MAP_ATT_INFO_TAB is initial.

    clear MAP_ATT_INFO.
    MAP_ATT_INFO-NAME = 'BUG'.
    MAP_ATT_INFO-EXPOSURE = '2'.
    MAP_ATT_INFO-RECORDNAME = 'ZBT_TRANSPORTER'.
    MAP_ATT_INFO-FIELD_NAME1  = 'BUG'.
    insert MAP_ATT_INFO into table MAP_ATT_INFO_TAB.

    clear MAP_ATT_INFO.
    MAP_ATT_INFO-NAME = 'PRODUCTO'.
    MAP_ATT_INFO-EXPOSURE = '2'.
    MAP_ATT_INFO-RECORDNAME = 'ZBT_TRANSPORTER'.
    MAP_ATT_INFO-FIELD_NAME1  = 'PRODUCTO'.
    insert MAP_ATT_INFO into table MAP_ATT_INFO_TAB.

    clear MAP_ATT_INFO.
    MAP_ATT_INFO-NAME = 'TRANSPORTREQ'.
    MAP_ATT_INFO-EXPOSURE = '2'.
    MAP_ATT_INFO-RECORDNAME = 'ZBT_TRANSPORTER'.
    MAP_ATT_INFO-FIELD_NAME1  = 'TRANSPORTREQ'.
    insert MAP_ATT_INFO into table MAP_ATT_INFO_TAB.

  endif.

           "MAP_INITIALIZE_METADATA
endmethod.


method MAP_INVALIDATE.
***BUILD 093901
     " importing I_OBJECT_IREF_TAB type TYP_OBJECT_TAB
************************************************************************
* Purpose        : Invalidate state of all objects in I_OBJECT_IREF_TAB
*
* Version        : 2.0
*
* Precondition   : Objects in I_OBJECT_IREF_TAB exist
*
* Postcondition  : Their state in cleared
*
* OO Exceptions  : -
*
* Implementation : - call method IF_OS_STATE~INVALIDATE
*                  - clear object's (persistent) attributes
*
************************************************************************
* Changelog:
* - 2000-04-17   : (BGR) Initial Version
* - 2000-08-02   : (SB)  OO Exceptions
* - 2002-01-17   : (SB)  private attributes in super classes
************************************************************************

  data: OBJECT_IREF type TYP_OBJECT_IREF,
        THE_OBJECT  type ref TO ZCL_TRANSPORT_PERSIST.

  loop at I_OBJECT_IREF_TAB into OBJECT_IREF.

    if ( not OBJECT_IREF is initial ).

      call method OBJECT_IREF->INVALIDATE.

      THE_OBJECT ?= OBJECT_IREF.

*<    Generated from Mapping:
      clear: THE_OBJECT->BUG,
             THE_OBJECT->PRODUCTO,
             THE_OBJECT->TRANSPORTREQ.
*>

    endif. "( not initial )

  endloop. "at I_OBJECT_IREF_TAB

           "MAP_INVALIDATE
endmethod.


method MAP_LOAD_FROM_DATABASE.
***BUILD 093901
     " importing I_WHERE_CLAUSE type STRING optional
     "           I_ORDER_BY_CLAUSE type STRING optional
     "           I_SUBCLASSES type OS_BOOLEAN default OSCON_FALSE
     "           I_UPTO type I value 0
     "           PAR1 type ANY optional
     "           PAR2 type ANY optional
     "           PAR3 type ANY optional
     " returning value(RESULT) type TYP_DB_DATA_TAB
************************************************************************
* Purpose        : Load object data identified by I_WHERE_CLAUSE with
*                  PAR1, PAR2 and PAR3 from DB to DB_DATA Table
*
* Version        : 2.0
*
* Precondition   : I_WHERE_CLAUSE is valid where clause in Open-SQL
*
* Postcondition  : RESULT is the corresponding table of object
*                  attributes read from DB
*
* OO Exceptions  : CX_OS_DB_SELECT
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2004-03-25   : (SB)  Initial Version
* - 2005-04-06   : (SB)  Single Table
************************************************************************


  data: DB_DATA           type TYP_DB_DATA.

*< Generated from mapping:
  types: TYP_DB_DATA_LOCAL type ZBT_TRANSPORTER.
*>

  types:
    TYP_DB_DATA_LOCAL_TAB type standard table of
      TYP_DB_DATA_LOCAL with non-unique default key .

  data: DB_DATA_LOCAL_TAB type TYP_DB_DATA_LOCAL_TAB.

  field-symbols: <FS_DB_DATA_LOCAL> type TYP_DB_DATA_LOCAL.

*< Generated from mapping:
  field-symbols: <FS_DB_ZBT_TRANSPORTER> type ZBT_TRANSPORTER.
*>

*< Generated from mapping:
  select * from ZBT_TRANSPORTER
           up to I_UPTO rows
           into table DB_DATA_LOCAL_TAB
           where (I_WHERE_CLAUSE)
           order by (I_ORDER_BY_CLAUSE).
*>

*   * error handling
  if ( SY-SUBRC <> 0 ).
    class CX_OS_DB_SELECT definition load.
    raise exception type CX_OS_DB_SELECT
         exporting TABLE  = 'ZBT_TRANSPORTER'
                   WHERE_CLAUSE = I_WHERE_CLAUSE
                   TEXTID = CX_OS_DB_SELECT=>BY_QUERY.
  endif. "( Error )

  loop at DB_DATA_LOCAL_TAB assigning <FS_DB_DATA_LOCAL>.

    assign <FS_DB_DATA_LOCAL> to <FS_DB_ZBT_TRANSPORTER>.

*< Generated from mapping:
    DB_DATA-BUG = <FS_DB_ZBT_TRANSPORTER>-BUG.
    DB_DATA-PRODUCTO = <FS_DB_ZBT_TRANSPORTER>-PRODUCTO.
    DB_DATA-TRANSPORTREQ = <FS_DB_ZBT_TRANSPORTER>-TRANSPORTREQ.
*>

    append DB_DATA to RESULT.

  endloop." at DB_TAB

           "MAP_LOAD_FROM_DATABASE
"#EC CI_VALPAR
endmethod.


method MAP_LOAD_FROM_DATABASE_KEY.
***BUILD 093901
     " importing I_BUSINESS_KEY_TAB type TYP_BUSINESS_KEY_TAB
     " returning value(RESULT) type TYP_DB_DATA_TAB
************************************************************************
* Purpose        : Load object data identified by I_BUSINESS_KEY_TAB
*                  from DB to DB_DATA Table
*
* Version        : 2.0
*
* Precondition   : I_BUSINESS_KEY_TAB is a table of valid business keys
*
* Postcondition  : RESULT is the corresponding table of object
*                  attributes read from DB
*
* OO Exceptions  : CX_OS_DB_SELECT
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-21   : (OS)  Initial Version
* - 2000-03-06   : (BGR) Version 2.0 - difference between loading 1 and
*                  many entries
* - 2000-06-15   : (BGR) Support for multi-table loading
* - 2000-08-03   : (SB)  OO Exceptions
* - 2001-03-27   : (MWI) Loading several objects (type mapping)
* - 2001-11-26   : (SB)  Refactoring Generation
* - 2002-01-17   : (SB)  Bugfix for tables with namespace
* - 2002-01-17   : (SB)  private attributes in super classes
* - 2004-01-07   : (SB)  Multi Access
* - 2005-02-22   : (SB)  Inner Joins
* - 2005-04-06   : (SB)  Single Table
************************************************************************


  data: DB_DATA           type TYP_DB_DATA.

*< Generated from mapping:
  types: TYP_DB_DATA_LOCAL type ZBT_TRANSPORTER.
*>

  types:
    TYP_DB_DATA_LOCAL_TAB type standard table of
      TYP_DB_DATA_LOCAL with non-unique default key .

  data: DB_DATA_LOCAL_TAB type TYP_DB_DATA_LOCAL_TAB.

  field-symbols: <FS_DB_DATA_LOCAL> type TYP_DB_DATA_LOCAL.

*< Generated from mapping:
  field-symbols: <FS_DB_ZBT_TRANSPORTER> type ZBT_TRANSPORTER.
*>

*< Generated from mapping:
  select * from ZBT_TRANSPORTER
           into table DB_DATA_LOCAL_TAB
           for all entries in I_BUSINESS_KEY_TAB
           where ZBT_TRANSPORTER~BUG = I_BUSINESS_KEY_TAB-BUG
             and ZBT_TRANSPORTER~PRODUCTO = I_BUSINESS_KEY_TAB-PRODUCTO
             and ZBT_TRANSPORTER~TRANSPORTREQ =
             I_BUSINESS_KEY_TAB-TRANSPORTREQ.
*>

* * error handling
  if ( SY-SUBRC <> 0 ).
    class CX_OS_DB_SELECT definition load.
    raise exception type CX_OS_DB_SELECT
         exporting TABLE  = 'ZBT_TRANSPORTER'
                   TEXTID = CX_OS_DB_SELECT=>BY_BKEYTAB.
  endif. "( Error )

  loop at DB_DATA_LOCAL_TAB assigning <FS_DB_DATA_LOCAL>.

    assign <FS_DB_DATA_LOCAL> to <FS_DB_ZBT_TRANSPORTER>.

*< Generated from mapping:
    DB_DATA-BUG = <FS_DB_ZBT_TRANSPORTER>-BUG.
    DB_DATA-PRODUCTO = <FS_DB_ZBT_TRANSPORTER>-PRODUCTO.
    DB_DATA-TRANSPORTREQ = <FS_DB_ZBT_TRANSPORTER>-TRANSPORTREQ.
*>

    append DB_DATA to RESULT.

  endloop." at DB_DATA_LOCAL_TAB

           "MAP_LOAD_FROM_DATABASE_KEY
"#EC CI_VALPAR
endmethod.


method MAP_MERGE_IDENTIFIER.
***BUILD 051402
     " importing I_BUSINESS_KEY_TAB type TYP_BUSINESS_KEY_TAB
     " changing C_DB_DATA_TAB type TYP_DB_DATA_TAB
************************************************************************
* Purpose        : Merge Table I_BUSINESS_KEY_TAB to C_DB_DATA_TAB.
*                  The result is a complete DB_DATA table to be stored
*                  in DB.
*
* Version        : 2.0
*
* Precondition   : C_DB_DATA is a Table filled with object data
*                  I_BUSINESS_KEY_TAB is a table of the same size with
*                  corresponding entries.
*
* Postcondition  : C_DB_DATA_TAB is complete
*
* OO Exceptions  : --
*
* Implementation :
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version
************************************************************************
* Generated! Do not modify!
************************************************************************

  data: BUSINESS_KEY type TYP_BUSINESS_KEY.

  field-symbols <FS_OBJECT_DATA> type TYP_DB_DATA.

  loop at C_DB_DATA_TAB assigning <FS_OBJECT_DATA>.

    read table I_BUSINESS_KEY_TAB into BUSINESS_KEY
         index SY-TABIX.

*<  Generated from mapping:
    <FS_OBJECT_DATA>-BUG = BUSINESS_KEY-BUG.
    <FS_OBJECT_DATA>-PRODUCTO = BUSINESS_KEY-PRODUCTO.
    <FS_OBJECT_DATA>-TRANSPORTREQ = BUSINESS_KEY-TRANSPORTREQ.
*>


  endloop." at C_DB_DATA_TAB

           "MAP_MERGE_IDENTIFIER
endmethod.


method MAP_SAVE_TO_DATABASE.
***BUILD 093901
     " importing I_DELETES type TYP_DB_DELETE_TAB
     "           I_INSERTS type TYP_DB_DATA_TAB
     "           I_UPDATES type TYP_DB_DATA_TAB
************************************************************************
* Purpose        : Do database operations:
*                  Insert new object data from I_INSERTS,
*                  Update changed object data from I_UPDATES and
*                  Delete entries for deleted objects from I_DELETES
*
* Version        : 2.0
*
* Precondition   : I_DELETES,I_INSERTS and I_UPDATES contain ALL
*                  necessary information (Keys, Data)
*                  If this method is called in update task, there
*                  is NO MORE information, no objects exist anymore.
*
* Postcondition  : All database operations have been performed.
*
* OO Exceptions  : CX_OS_DB_INSERT, CX_OS_DB_UPDATE, CX_OS_DB_DELETE
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-21   : (OS)  Initial Version
* - 2000-03-06   : (BGR) Version 2.0
* - 2001-11-26   : (SB)  Refactoring Generation
* - 2002-01-17   : (SB)  private attributes in super classes
************************************************************************

*< Generated from mapping:

* * ZBT_TRANSPORTER: internal tables for mass operation
  data DB_ITB_ZBT_TRANSPORTER type STANDARD TABLE OF ZBT_TRANSPORTER.
  data DB_UTB_ZBT_TRANSPORTER type STANDARD TABLE OF ZBT_TRANSPORTER.
  data DB_DTB_ZBT_TRANSPORTER type STANDARD TABLE OF ZBT_TRANSPORTER.

* * ZBT_TRANSPORTER: headlines for tables
  data DB_ILN_ZBT_TRANSPORTER type ZBT_TRANSPORTER.
  data DB_ULN_ZBT_TRANSPORTER type ZBT_TRANSPORTER.
  data DB_DLN_ZBT_TRANSPORTER type ZBT_TRANSPORTER.

*>

  field-symbols <FS_INSERT> type TYP_DB_DATA.
  field-symbols <FS_UPDATE> type TYP_DB_DATA.
  field-symbols <FS_DELETE> type TYP_SPECIAL_OBJECT_INFO.

* * Collect Inserts
  loop at I_INSERTS assigning <FS_INSERT>.

*< Generated from mapping:






   DB_ILN_ZBT_TRANSPORTER-BUG = <FS_INSERT>-BUG.
   DB_ILN_ZBT_TRANSPORTER-PRODUCTO = <FS_INSERT>-PRODUCTO.
   DB_ILN_ZBT_TRANSPORTER-TRANSPORTREQ = <FS_INSERT>-TRANSPORTREQ.
   append DB_ILN_ZBT_TRANSPORTER to DB_ITB_ZBT_TRANSPORTER.
*>

  endloop. "at I_INSERTS

* * Collect Updates
  loop at I_UPDATES assigning <FS_UPDATE>.

*< Generated from mapping:






   DB_ULN_ZBT_TRANSPORTER-BUG = <FS_UPDATE>-BUG.
   DB_ULN_ZBT_TRANSPORTER-PRODUCTO = <FS_UPDATE>-PRODUCTO.
   DB_ULN_ZBT_TRANSPORTER-TRANSPORTREQ = <FS_UPDATE>-TRANSPORTREQ.
   append DB_ULN_ZBT_TRANSPORTER TO DB_UTB_ZBT_TRANSPORTER.
*>

  endloop. "at I_UPDATES

* * Collect Deletes
  loop at I_DELETES assigning <FS_DELETE>.

    DB_DLN_ZBT_TRANSPORTER-BUG = <FS_DELETE>-BUSINESS_KEY-BUG.
    DB_DLN_ZBT_TRANSPORTER-PRODUCTO = <FS_DELETE>-BUSINESS_KEY-PRODUCTO.
    DB_DLN_ZBT_TRANSPORTER-TRANSPORTREQ =
    <FS_DELETE>-BUSINESS_KEY-TRANSPORTREQ.

    append DB_DLN_ZBT_TRANSPORTER TO DB_DTB_ZBT_TRANSPORTER.

  endloop. "at I_DELETES

* * Perform DB Operations:

*< Generated from mapping:

* * DB Deletes
  delete ZBT_TRANSPORTER FROM TABLE DB_DTB_ZBT_TRANSPORTER.
  if SY-SUBRC <> 0.
    raise exception type CX_OS_DB_DELETE
      exporting
        TABLE = 'ZBT_TRANSPORTER'.
  endif.

* * DB Inserts
  insert ZBT_TRANSPORTER FROM TABLE DB_ITB_ZBT_TRANSPORTER
    accepting duplicate keys.
  if SY-SUBRC <> 0.
    raise exception type CX_OS_DB_INSERT
      exporting
        TABLE = 'ZBT_TRANSPORTER'.
  endif.

* * DB Updates
  update ZBT_TRANSPORTER FROM TABLE DB_UTB_ZBT_TRANSPORTER.
  if SY-SUBRC <> 0.
    raise exception type CX_OS_DB_UPDATE
      exporting
        TABLE = 'ZBT_TRANSPORTER'.
  endif.

*>
           "MAP_SAVE_TO_DATABASE
endmethod.


method MAP_SERIALIZE_BKEY.
***BUILD 093901
     " importing I_BUSINESS_KEY type TYP_BUSINESS_KEY
     " returning value(RESULT) type STRING
************************************************************************
* Purpose        : Converts business key to string. Can't be done
*                  by move because of possible GUIDs (type X) in
*                  business key structure.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-11-23   : (SB)  initial versiuon
************************************************************************
* Generated! Do not modify!
************************************************************************

  data: TEMP_STRING type STRING.
  data: COMP_STRING type STRING.

*< Generated from mapping:
  COMP_STRING = I_BUSINESS_KEY-BUG.
  concatenate COMP_STRING TEMP_STRING into TEMP_STRING.
  COMP_STRING = I_BUSINESS_KEY-PRODUCTO.
  concatenate COMP_STRING TEMP_STRING into TEMP_STRING.
  COMP_STRING = I_BUSINESS_KEY-TRANSPORTREQ.
  concatenate COMP_STRING TEMP_STRING into TEMP_STRING.
*>

  RESULT = TEMP_STRING.

           " MAP_SERIALIZE_BKEY
endmethod.


method MAP_SET_ATTRIBUTES.
***BUILD 093901
     " importing I_OBJECT_DATA type TYP_DB_DATA
     "           I_OBJECT_REF  type TYP_OBJECT_REF
     " raising   CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set objects from given object data
*
* Version        : 2.0
*
* Precondition   : I_OBJECT_REF is a reference to the object that will
*                  be set with data from I_OBJECT_DATA
*
* Postcondition  : The object's attributes are set.
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version
* - 2000-08-03   : (SB)  OO Exceptions
* - 2002-01-17   : (SB)  private attributes in super classes
************************************************************************
* Generated! Do not modify!
************************************************************************

  data: THE_OBJECT type ref to ZCL_TRANSPORT_PERSIST,
        AN_OBJECT  type ref to object, "#EC NEEDED
        PM_SERVICE type ref to IF_OS_PM_SERVICE. "#EC NEEDED

  PM_SERVICE ?= PERSISTENCY_MANAGER.
  THE_OBJECT = I_OBJECT_REF.

*<  Generated from mapping:
  THE_OBJECT->BUG = I_OBJECT_DATA-BUG.
  THE_OBJECT->PRODUCTO = I_OBJECT_DATA-PRODUCTO.
  THE_OBJECT->TRANSPORTREQ = I_OBJECT_DATA-TRANSPORTREQ.
*>

           "MAP_SET_ATTRIBUTES
endmethod.


method OS_PM_DELETE_PERSISTENT.
***BUILD 051401
************************************************************************
* Purpose        : Delete persistent object. It is marked DELETED in
*                  memory and removed from DB when the top transaction
*                  is closed.
*
* Version        : 2.0
*
* Precondition   : The object is persistent (not transient), CURRENT
*                  is set
*
* Postcondition  : Instance is marked for deletion.
*
* OO Exceptions  : propagates PM_DELETE_PERSISTENT
*
* Implementation : load special object info and
*                  call PM_DELETE_PERSISTENT
*
************************************************************************
* Changelog:
* - 2001-12-14   : (SB)  Initial Version
************************************************************************

  call method LOAD_SPECIAL_OBJECT_INFO( ).

  call method PM_DELETE_PERSISTENT( ).

           "OS_PM_DELETE_PERSISTENT .
endmethod.


method PM_CHECK_AND_SET_ATTRIBUTES.
***BUILD 051401
     " importing I_OBJECT_DATA  type TYP_DB_DATA
     " importing I_BUSINESS_KEY type TYP_BUSINESS_KEY optional
     "           I_ID_PROVIDED type TYP_ID_STATUS default ID_STATUS_NONE
************************************************************************
* Purpose        : check loaded object data of a persistent object and
*                  set object's attributes
*                  if CURRENT is clear, create new representant,
*                  if CURRENT is set, use this object to set the loaded
*                  data
*                  If I_ID_PROVIDED is set to ID_STATUS_NONE, Look for
*                  an entry in SPECIAL_OBJECT_INFO with the given
*                  Business Key
*
* Version        : 2.0
*
* Precondition   :
*
* Postcondition  : Persistent object data is checked and object
*                  attributes are set. CURRENT is set.
*
* OO Exception   : CX_OS_OBJECT_STATE(INTERNAL_CHANGED,INTERNAL_DELETED,
*                                     INTERNAL_TRANSIENT, INTERNAL_NEW)
*                  propagates MAP_SET_ATTRIBUTES
*
* Implementation : 1. If CURRENT is clear:
*                   1a. I_ID_PROVIDED = ID_STATUS_NONE?:
*                       Check if another object exists with this
*                       Business Key
*                   1b. I_ID_PROVIDED <> ID_STATUS_NONE or no entry
*                       found:
*                       Create a new Representative object
*                   1c. If an object has been found:
*                       Check if it is allowed to set it
*                  2. set PM_DBSTATUS EXISTING
*                  3. Temporarily save CURRENT_*
*                  4. set object attributes (resolving references)
*                  5. restore CURRENT_*
*
************************************************************************
* Changelog:
* - 2000-05-17   : (BGR) Initial Version 2.0
* - 2000-08-03   : (SB) OO Exceptions
************************************************************************

  data: LOADED_BUSINESS_KEY       type TYP_BUSINESS_KEY.

  data: TEMP_CURRENT_OBJECT_INFO  type TYP_OBJECT_INFO,
        TEMP_CURRENT_OBJECT_INDEX type TYP_INDEX,
        TEMP_CURRENT_SPECIAL_OI   type TYP_SPECIAL_OBJECT_INFO,
        TEMP_CURRENT_OBJECT_IREF  type TYP_OBJECT_IREF,
        INTERNAL_UNDO_INFO_ITEM   type TYP_INTERNAL_UNDO_INFO,
        TEMP_OBJECT_REF           type TYP_OBJECT_REF.

* * Get both Business Key from DB data
  call method MAP_EXTRACT_IDENTIFIER
       exporting I_DB_DATA      = I_OBJECT_DATA
       importing E_BUSINESS_KEY = LOADED_BUSINESS_KEY.

  if ( CURRENT_OBJECT_IREF is initial ).

*   * 1. If CURRENT is clear:

    if ( I_ID_PROVIDED = ID_STATUS_NONE ).

*   * 1a. Check if another object exists with this Business Key

      read table SPECIAL_BKEY_TAB into TEMP_CURRENT_SPECIAL_OI
           with table key BUSINESS_KEY = LOADED_BUSINESS_KEY.
      if ( sy-subrc = 0 ).

        read table SPECIAL_OBJECT_INFO into
             CURRENT_SPECIAL_OBJECT_INFO
             with table key
             OBJECT_ID = TEMP_CURRENT_SPECIAL_OI-OBJECT_ID.
        call method OS_LOAD_AND_VALIDATE_CURRENT
             exporting I_INDEX = sy-tabix.

      endif. " ( Entry found for BKEY? )

    endif. "( no ID Provided )

    if ( CURRENT_OBJECT_IREF is initial ).

*     * 1b. Create a new Representative object and a new entry
      call method PM_CREATE_REPRESENTANT
           exporting I_BUSINESS_KEY = LOADED_BUSINESS_KEY.

    else. "( Found an entry for the business key )

*     * Now we know an entry exists on DB
      CURRENT_OBJECT_INFO-PM_DBSTATUS = OSCON_DBSTATUS_EXISTING.
      modify OBJECT_INFO from CURRENT_OBJECT_INFO
             index CURRENT_OBJECT_INDEX.

*     * 1c. Check if it is allowed to use the found object.
      case CURRENT_OBJECT_INFO-PM_STATUS.

*       * PM_STATUS = NOT_LOADED: re-use entry and object
        when OSCON_OSTATUS_NOT_LOADED.

*       * PM_STATUS = LOADED: re-use entry and object
        when OSCON_OSTATUS_LOADED.

*       *  other PM_STATUS: Error!
        when OSCON_OSTATUS_NEW.

*!!!!!!!!!! Error! Object already exists on DB
*         * This NEW object should be created on DB by the next
*         * COMMIT. Now an entry was found with the same key!
          class CX_OS_OBJECT_STATE definition load.
          raise exception type CX_OS_OBJECT_STATE
               exporting OBJECT = CURRENT_OBJECT_IREF
                         TEXTID = CX_OS_OBJECT_STATE=>INTERNAL_NEW.

        when OSCON_OSTATUS_CHANGED.

*!!!!!!!!!!! Error: Object has a DB relevant status
          class CX_OS_OBJECT_STATE definition load.
          raise exception type CX_OS_OBJECT_STATE
               exporting OBJECT = CURRENT_OBJECT_IREF
                         TEXTID = CX_OS_OBJECT_STATE=>INTERNAL_CHANGED.

        when OSCON_OSTATUS_DELETED.

*!!!!!!!!!!! Error: Object marked for deletion
          class CX_OS_OBJECT_STATE definition load.
          raise exception type CX_OS_OBJECT_STATE
               exporting OBJECT = CURRENT_OBJECT_IREF
                         TEXTID = CX_OS_OBJECT_STATE=>INTERNAL_DELETED.

        when OSCON_OSTATUS_TRANSIENT.

*!!!!!!!!!!! Error: Object is transient
          class CX_OS_OBJECT_STATE definition load.
          raise exception type CX_OS_OBJECT_STATE
               exporting OBJECT = CURRENT_OBJECT_IREF
                        TEXTID = CX_OS_OBJECT_STATE=>INTERNAL_TRANSIENT.

      endcase.

    endif. "( CURRENT initial? )
  endif. "( CURRENT initial? )

* * 2. set PM_DBSTATUS EXISTING
  CURRENT_OBJECT_INFO-PM_DBSTATUS          = OSCON_DBSTATUS_EXISTING.

* * internal Undo entry:
  INTERNAL_UNDO_INFO_ITEM-OBJECT_INDEX = CURRENT_OBJECT_INDEX.
  INTERNAL_UNDO_INFO_ITEM-OBJECT_INFO  = CURRENT_OBJECT_INFO.
  append INTERNAL_UNDO_INFO_ITEM to INTERNAL_UNDO_INFO.
  INTERNAL_NEXT_UNDO_INFO = sy-tabix + 1.

* * To avoid recursive loading of the same object (INIT method)
* * temporarily set status 'LOADING'
  CURRENT_OBJECT_INFO-PM_STATUS = OSCON_OSTATUS_LOADING.
  modify OBJECT_INFO from CURRENT_OBJECT_INFO
         index CURRENT_OBJECT_INDEX.

* * 3. Temporarily save CURRENT_*
  TEMP_CURRENT_OBJECT_IREF  = CURRENT_OBJECT_IREF.
  TEMP_CURRENT_OBJECT_INFO  = CURRENT_OBJECT_INFO.
  TEMP_CURRENT_OBJECT_INDEX = CURRENT_OBJECT_INDEX.
  TEMP_CURRENT_SPECIAL_OI   = CURRENT_SPECIAL_OBJECT_INFO.

* * 4. set object attributes (resolving references)
  TEMP_OBJECT_REF ?= CURRENT_OBJECT_IREF .

  call method MAP_SET_ATTRIBUTES
       exporting I_OBJECT_DATA = I_OBJECT_DATA
                 I_OBJECT_REF  = TEMP_OBJECT_REF.

* * 5. restore CURRENT_*
  CURRENT_OBJECT_INFO          = TEMP_CURRENT_OBJECT_INFO.
  CURRENT_OBJECT_INDEX         = TEMP_CURRENT_OBJECT_INDEX.
  CURRENT_SPECIAL_OBJECT_INFO  = TEMP_CURRENT_SPECIAL_OI.
  CURRENT_OBJECT_IREF          = TEMP_CURRENT_OBJECT_IREF.

* * the method call get_ref_by_oid in map_set_attributes
* * eventually creates new entries in the
* * administrative data tables, it is necessary to
* * to recalculate the index
  read table OBJECT_INFO transporting no fields
     with table key OBJECT_ID = CURRENT_OBJECT_INFO-OBJECT_ID.
  CURRENT_OBJECT_INDEX = sy-tabix.

           "PM_CHECK_AND_SET_ATTRIBUTES
endmethod.


method PM_CREATE_REPRESENTANT.
***BUILD 051402
     " importing I_BUSINESS_KEY type TYP_BUSINESS_KEY
     " returning result         type TYP_OBJECT_REF
************************************************************************
* Purpose        : Create a new representative object including a new
*                  entry in administrative data (OBJECT_INFO and
*                  SPECIAL_OBJECT_INFO)
*
* Version        : 2.0
*
* Precondition   : No object exists with the same Business Key
*
* Postcondition  : A new object exists, corresponding entries in
*                  OBJECT_INFO and SPECIAL_OBJECT_INFO have been
*                  inserted, CURRENT is set
*
* OO Exceptions  : --
*
* Implementation : 1. Create object and set BKey attributes
*                  2. Get internal OID for the new object
*                  3. Create new entry in SPECIAL_OBJECT_INFO
*                  4. Let super class create a new entry in OBJECT_INFO
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
* - 2001-10-30   : (SB)  Type Mapping
************************************************************************

  data: NEW_OBJECT type ref to ZCL_TRANSPORT_PERSIST.

* * 1. Create object and set BKey attributes
  create object NEW_OBJECT.

* < Generated from mapping:
  NEW_OBJECT->BUG = I_BUSINESS_KEY-BUG.
  NEW_OBJECT->PRODUCTO = I_BUSINESS_KEY-PRODUCTO.
  NEW_OBJECT->TRANSPORTREQ = I_BUSINESS_KEY-TRANSPORTREQ.
* >

* * 2. Get internal OID for the new object and set CURRENT_SPECIAL_OI
  clear CURRENT_SPECIAL_OBJECT_INFO.

  CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID =
      OS_GET_INTERNAL_OID_BY_REF( I_OBJECT = NEW_OBJECT ).
  CURRENT_SPECIAL_OBJECT_INFO-BUSINESS_KEY = I_BUSINESS_KEY.
  CURRENT_SPECIAL_OBJECT_INFO-ID_STATUS = ID_STATUS_COMPLETE.

* * 3. Create new entry in SPECIAL_OBJECT_INFO
  insert CURRENT_SPECIAL_OBJECT_INFO into table SPECIAL_OBJECT_INFO.
  insert CURRENT_SPECIAL_OBJECT_INFO into table SPECIAL_BKEY_TAB.

* * 4. Let super class create a new entry in OBJECT_INFO
  call method OS_CREATE_NEW_ENTRY_FOR_REPR
       exporting I_OBJECT = NEW_OBJECT
                 I_INTERNAL_OID = CURRENT_SPECIAL_OBJECT_INFO-OBJECT_ID.

  RESULT = NEW_OBJECT.

           "PM_CREATE_REPRESENTANT
endmethod.


method PM_DELETE_PERSISTENT.
***BUILD 051401
************************************************************************
* Purpose        : Delete persistent object. It is marked DELETED in
*                  memory and removed from DB when the top transaction
*                  is closed.
*
* Version        : 2.0
*
* Precondition   : The object is persistent (not transient), CURRENT
*                  is set
*
* Postcondition  : Instance is marked for deletion.
*
* OO Exception   : CX_OS_OBJECT_STATE(CREATED_AND_DELETED,TRANSIENT)
*                  propagates OS_PM_DELETED_PERSISTENT
*                  ( propagates MAP_LOAD_FROM_DATABASE_KEY )
*
* Implementation : 1. Check the state of the object:
*                    1a. Object is already deleted - done
*                    1b. Object is transient - Error
*                    1c. Object is new, loaded or changed - continue
*                    1d. Object is not_loaded:
*                        Check DBSTATUS:
*                       1d1. DBSTATUS Unknown/Existing - continue
*                       1d2. DBSTATUS Not existing - Error
*                   2. Completion: call OS_PM_DELETED_PERSISTENT
*
************************************************************************
* Changelog:
* - 2000-03-06   : (BGR) Initial Version 2.0
* - 2000-08-03   : (SB) OO Exceptions
************************************************************************

  data: TEMP_CURRENT_OBJECT_IREF type TYP_OBJECT_IREF .

* * 1. Check the state of the object:
  case CURRENT_OBJECT_INFO-PM_STATUS.

  when OSCON_OSTATUS_DELETED.

*   * 1a. Object is already deleted - done
    call method OS_CLEAR_CURRENT.
    clear CURRENT_SPECIAL_OBJECT_INFO.
    exit.


  when OSCON_OSTATUS_TRANSIENT.

*   * 1b. Object is transient - Error
*!! error: object already exists transient
    TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
    call method OS_CLEAR_CURRENT.
    clear CURRENT_SPECIAL_OBJECT_INFO.
    class CX_OS_OBJECT_STATE definition load.
    raise exception type CX_OS_OBJECT_STATE
         exporting OBJECT = TEMP_CURRENT_OBJECT_IREF
                   TEXTID = CX_OS_OBJECT_STATE=>TRANSIENT.


  when OSCON_OSTATUS_NEW     or
       OSCON_OSTATUS_CHANGED or
       OSCON_OSTATUS_LOADED.

*   * 1c. Object is new, loaded or changed - continue


  when OSCON_OSTATUS_NOT_LOADED.

*   * 1d. Object is not_loaded: Check DBSTATUS:
    case CURRENT_OBJECT_INFO-PM_DBSTATUS.


    when OSCON_DBSTATUS_EXISTING
      or OSCON_DBSTATUS_UNKNOWN.

*     * 1d1. DBSTATUS Existing/Unknown - continue


    when OSCON_DBSTATUS_NOT_EXISTING.
*     * 1d2. DBSTATUS Not existing - Error
*!!!! error: No DB entry for the object
      TEMP_CURRENT_OBJECT_IREF = CURRENT_OBJECT_IREF.
      call method OS_CLEAR_CURRENT.
      clear CURRENT_SPECIAL_OBJECT_INFO.
      class CX_OS_OBJECT_STATE definition load.
      raise exception type CX_OS_OBJECT_STATE
           exporting OBJECT = TEMP_CURRENT_OBJECT_IREF
                     TEXTID = CX_OS_OBJECT_STATE=>CREATED_AND_DELETED.

    endcase. "PM_DBSTATUS
  endcase. "PM_STATUS

* * 2. Completion: call OS_PM_DELETED_PERSISTENT
  call method OS_PM_DELETED_PERSISTENT.

  clear CURRENT_SPECIAL_OBJECT_INFO.

           "PM_DELETE_PERSISTENT
endmethod.


method PM_LOAD.
***BUILD 051401
************************************************************************
* Purpose        : Load data from DB into Object specified by CURRENT
*
* Version        : 2.0
*
* Precondition   : CURRENT_* is set
*
* Postcondition  : object is loaded or exceptions is raised
*
* OO Exceptions  : propagates PM_LOAD_AND_SET_ATTRIBUTES
*
* Implementation : call PM_LOAD_AND_SET_ATTRIBUTES
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
* - 2000-08-03   : (SB)  OO Exceptions
* - 2001-11-14   : (SB)  Type mapping
************************************************************************

  call method PM_LOAD_AND_SET_ATTRIBUTES
       exporting I_BUSINESS_KEY =
                         CURRENT_SPECIAL_OBJECT_INFO-BUSINESS_KEY.

           "PM_LOAD
endmethod.


method PM_LOAD_AND_SET_ATTRIBUTES.
***BUILD 051401
     " importing I_BUSINESS_KEY type TYP_BUSINESS_KEY optional

************************************************************************
* Purpose        : Load object data of a persistent object and set
*                  object's attributes
*                  if CURRENT is clear, load data using I_BUSINESS_KEY.
*                  if CURRENT is set, use the BKEY stored there.
*
* Version        : 2.0
*
* Precondition   : An entry for the given Business Key exists on
*                  database. CURRENT can be set (use this
*                  object to set attributes to) or clear.
*
* Postcondition  : Persistent object data is loaded and object
*                  attributes are set. CURRENT is set.
*
* OO Exceptions  : propagates PM_CHECK_AND_SET_ATTRIBUTES
*                  propagates MAP_LOAD_FROM_DATABASE_KEY/GUID
*
* Implementation : 1. Check Source of DB Keys: Business Key from
*                     CURRENT_SPECIAL_OBJECT_INFO or from I_BUSINESS_KEY
*                  2. Load from Database
*                  2.a. Type Mapping: Set E_TYPE and return if case of
*                       type mismatch
*                  3. Check loaded data and set object's attributes
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-05-17   : (BGR) use PM_CHECK_AND_SET_ATTRIBUTES
* - 2000-08-03   : (SB) OO Exceptions
* - 2004-01-21   : (SB) Type Mapping Refactoring
* - 2005-02-22   : (SB) Set Exception parameters
************************************************************************

  data: OBJECT_DATA_TAB     type TYP_DB_DATA_TAB,
        OBJECT_DATA         type TYP_DB_DATA,
        BUSINESS_KEY        type TYP_BUSINESS_KEY,
        BUSINESS_KEY_TAB    type TYP_BUSINESS_KEY_TAB.

  data: SERIALIZED_BUSINESS_KEY  type STRING .

* * 1. Check Source of DB Keys: Business Key from
* *    CURRENT_SPECIAL_OBJECT_INFO or from I_BUSINESS_KEY?
  if ( CURRENT_OBJECT_IREF is initial ).

    BUSINESS_KEY = I_BUSINESS_KEY.

  else. "( CURRENT is set ).

*   * Get BKey from CURRENT_SPECIAL_OBJECT_INFO
    BUSINESS_KEY = CURRENT_SPECIAL_OBJECT_INFO-BUSINESS_KEY.

  endif. "( CURRENT set? ).


* * 2. Load from Database
  try.
      append BUSINESS_KEY to BUSINESS_KEY_TAB.
      call method MAP_LOAD_FROM_DATABASE_KEY
           exporting I_BUSINESS_KEY_TAB = BUSINESS_KEY_TAB
           receiving result = OBJECT_DATA_TAB.
    catch CX_OS_DB_SELECT.
      class CX_OS_OBJECT_NOT_FOUND definition load.
      call method MAP_SERIALIZE_BKEY
           exporting I_BUSINESS_KEY = BUSINESS_KEY
           receiving RESULT = SERIALIZED_BUSINESS_KEY.
      raise exception type CX_OS_OBJECT_NOT_FOUND
        exporting
          BKEY   = SERIALIZED_BUSINESS_KEY
          TEXTID = CX_OS_OBJECT_NOT_FOUND=>BY_BKEY.
  endtry.

  read table OBJECT_DATA_TAB into OBJECT_DATA index 1.


* * 3. Now Check the loaded data and set the Object.
  call method PM_CHECK_AND_SET_ATTRIBUTES
       exporting I_OBJECT_DATA  = OBJECT_DATA
                 I_BUSINESS_KEY = BUSINESS_KEY
                 I_ID_PROVIDED  = ID_STATUS_COMPLETE.

           "PM_LOAD_AND_SET_ATTRIBUTES
endmethod.


method SAVE_SPECIAL_OBJECT_INFO.
***BUILD 051401
************************************************************************
* Purpose        : Save CURRENT_SPECIAL_OBJECT_INFO into
*                  SPECIAL_OBJECT_INFO
*
* Version        : 2.0
*
* Precondition   : Index is set in CURRENT_OBJECT_INDEX
*
* Postcondition  : entry is saved
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-02   : (BGR) Initial Version
************************************************************************

  modify SPECIAL_OBJECT_INFO from CURRENT_SPECIAL_OBJECT_INFO
         index CURRENT_OBJECT_INDEX.

           "SAVE_SPECIAL_OBJECT_INFO
endmethod.
ENDCLASS.
