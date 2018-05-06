class ZCL_SEARCH_LAST_MOD_ALV_CTRL definition
  public
  inheriting from ZCL_SEARCHES_ALV_CTRL
  final
  create public .

public section.
*"* public components of class ZCL_SEARCH_LAST_MOD_ALV_CTRL
*"* do not include other source files here!!!

  methods SEARCH
    redefinition .
protected section.
*"* protected components of class ZCL_SEARCH_LAST_MOD_ALV_CTRL
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_SEARCH_LAST_MOD_ALV_CTRL
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_SEARCH_LAST_MOD_ALV_CTRL IMPLEMENTATION.


METHOD search.

  CALL FUNCTION 'ZBT_LAST_MODIFIED_BUGS'
    EXPORTING
      screen_attributes = screen_attributes
      results_alv_ctrl  = me.

ENDMETHOD.
ENDCLASS.
