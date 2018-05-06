class ZCL_LAST_MODIFIED_BUG_ALV_CTRL definition
  public
  inheriting from ZCL_SEARCHES_ALV_CTRL
  final
  create public .

public section.
*"* public components of class ZCL_LAST_MODIFIED_BUG_ALV_CTRL
*"* do not include other source files here!!!

  methods SEARCH
    redefinition .
protected section.
*"* protected components of class ZCL_LAST_MODIFIED_BUG_ALV_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_LAST_MODIFIED_BUG_ALV_CTRL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_LAST_MODIFIED_BUG_ALV_CTRL IMPLEMENTATION.


METHOD search.
  DATA: lr_aedat    TYPE zbt_timestamp_range,
        l_timestamp TYPE timestamp,
        l_date       TYPE dats,
        l_aedat     TYPE LINE OF zbt_timestamp_range.

  CALL FUNCTION 'ADDR_CONVERT_DATE_TO_TIMESTAMP'
    EXPORTING
      iv_date      = sy-datum
    IMPORTING
      ev_timestamp = l_timestamp.

  l_aedat-high   = l_timestamp.
  l_aedat-sign   = 'I'.
  l_aedat-option = 'BT'.

  l_date = sy-datum - 10. "10 days before

  CALL FUNCTION 'ADDR_CONVERT_DATE_TO_TIMESTAMP'
    EXPORTING
      iv_date      = l_date
    IMPORTING
      ev_timestamp = l_timestamp.

  l_aedat-low    = l_timestamp.
  INSERT l_aedat INTO TABLE lr_aedat.

  CALL FUNCTION 'ZBT_LAST_MODIFIED_BUGS'
    EXPORTING
      screen_attributes = screen_attributes
      results_alv_ctrl  = me
    CHANGING
      modificado        = lr_aedat[].

ENDMETHOD.
ENDCLASS.
