"! <p class="shorttext synchronized" lang="en">BugSection Entity</p>
CLASS zcl_bug_section DEFINITION
  PUBLIC
  INHERITING FROM zcl_entity
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    "!
    "! @parameter id      | <p class="shorttext synchronized" lang="en">Sección</p>
    "! @parameter bug     | <p class="shorttext synchronized" lang="en">Bug Entity</p>
    "! @parameter comment | <p class="shorttext synchronized" lang="en">Comment Entity</p>
    METHODS constructor
      IMPORTING
        !id      TYPE zbt_bugseccion-seccion
        !bug     TYPE REF TO zcl_bug
        !comment TYPE REF TO zcl_comment OPTIONAL .
    "! <p class="shorttext synchronized" lang="en">GetBug</p>
    "!
    "! @parameter return | <p class="shorttext synchronized" lang="en">Bug Entity</p>
    METHODS get_bug
      RETURNING
        VALUE(return) TYPE REF TO zcl_bug .
    "! <p class="shorttext synchronized" lang="en">GetId</p>
    "!
    "! @parameter return | <p class="shorttext synchronized" lang="en">Sección</p>
    METHODS get_id
      RETURNING
        VALUE(return) TYPE zbt_bugseccion-seccion .
    "! <p class="shorttext synchronized" lang="en">GetComment</p>
    "!
    "! @parameter return | <p class="shorttext synchronized" lang="en">Comment Entity</p>
    METHODS get_comment
      RETURNING
        VALUE(return) TYPE REF TO zcl_comment .
    "! <p class="shorttext synchronized" lang="en">SetComment</p>
    "!
    "! @parameter comment | <p class="shorttext synchronized" lang="en">Comment Entity</p>
    METHODS set_comment
      IMPORTING
        !comment TYPE REF TO zcl_comment .
  PROTECTED SECTION.
*"* protected components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

    METHODS prepare_hash_structure
        REDEFINITION .
  PRIVATE SECTION.
*"* private components of class ZCL_BUG_SECTION
*"* do not include other source files here!!!

    "! <p class="shorttext synchronized" lang="en">Bug Entity</p>
    DATA bug TYPE REF TO zcl_bug .
    "! <p class="shorttext synchronized" lang="en">Sección</p>
    DATA id TYPE zbt_bugseccion-seccion .
    "! <p class="shorttext synchronized" lang="en">Comment Entity</p>
    DATA comment TYPE REF TO zcl_comment .
ENDCLASS.



CLASS zcl_bug_section IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    me->id      = id.
    me->bug     = bug.
    me->comment = comment.
  ENDMETHOD.


  METHOD get_bug.
    return = me->bug.

  ENDMETHOD.


  METHOD get_comment.
    return = comment.
  ENDMETHOD.


  METHOD get_id.
    return = id.
  ENDMETHOD.


  METHOD prepare_hash_structure.
    DATA: str       TYPE zbt_bugseccion,
          hash      TYPE hash160,
          o_comment TYPE REF TO zcl_comment,
          value     TYPE LINE OF zbt_objectvalue_hash_calcul,
          i         TYPE i.

    FIELD-SYMBOLS: <field> TYPE any.

    CALL METHOD zcl_bugsection_controller=>entity_to_structure
      EXPORTING
        entity    = me
      RECEIVING
        structure = str.

    DO.
      ADD 1 TO i.
      ASSIGN COMPONENT i OF STRUCTURE str TO <field>.
      IF sy-subrc IS INITIAL.
        value = <field>.
        SHIFT value LEFT DELETING LEADING space.
        INSERT value INTO TABLE values[].
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    o_comment = get_comment( ).
    hash = o_comment->get_hash( ).
    value = hash.
    SHIFT  value LEFT DELETING LEADING space.
    INSERT value INTO TABLE values[].

  ENDMETHOD.


  METHOD set_comment.
    me->comment = comment.
  ENDMETHOD.
ENDCLASS.
