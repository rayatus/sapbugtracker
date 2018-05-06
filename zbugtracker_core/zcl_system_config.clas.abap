class ZCL_SYSTEM_CONFIG definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_SYSTEM_CONFIG
*"* do not include other source files here!!!

  class-methods CLASS_CONSTRUCTOR .
  class-methods IS_BUGID_MANDATORY_TR_RELEASED
    returning
      value(IS_MANDATORY) type ZBT_TRRELEASED_BUGID .
protected section.
*"* protected components of class ZCL_SYSTEM_CONFIG
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_SYSTEM_CONFIG
*"* do not include other source files here!!!

  class-data SYSTEM_CONFIG type ZBT_CONFIG .
ENDCLASS.



CLASS ZCL_SYSTEM_CONFIG IMPLEMENTATION.


METHOD class_constructor.

  data: lv_SYSTEM_CONFIG  Type  ZBT_CONFIG.
* read the masterclient settings
  select single * from zbt_config into lv_SYSTEM_CONFIG
    where conf_type = 'CLNT'.

  if lv_SYSTEM_CONFIG-uname = sy-mandt.
* actuell client is the masterclient -> read the TRSP Config
* from this client
    SELECT SINGLE * INTO system_config FROM zbt_config
      where uname = sy-uname and conf_type = 'TRSP'.

  else.
* all right, the actuell client is not the masterclient
* then check for the fact: read the actuell client or the
* masterclient for the TRSP Config

    if lv_SYSTEM_CONFIG-TRRELEASED_BUGID = 5.
*      TRSP Config is in the actuell client
      SELECT SINGLE * INTO system_config FROM zbt_config
        where uname = sy-uname and conf_type = 'TRSP'.

    else.
      SELECT SINGLE   * INTO system_config
        FROM zbt_config client specified
      where mandt = lv_SYSTEM_CONFIG-uname
        and uname = sy-uname
        and conf_type = 'TRSP'.

    endif.

  endif.
ENDMETHOD.


METHOD is_bugid_mandatory_tr_released.
  is_mandatory = system_config.
ENDMETHOD.
ENDCLASS.
