# Introduction #

HowTo Install SAPBT 8.31

**prerequisite for installation**

SAP-Basis 7.02,
but is also installable under 7.00 with some manual adjustments

**import the Transport Request**

The following TR K9A000Q.zip contains the version 8.31

**manual adjustments for SAP BASIS 7.00**

**first adjustment**
Method
> ZCL\_TRANSPORT\_CONTROLLER      UPDATE\_TR\_ATTRIBUTES

**REPLACE 1 start**

del line   DATA:   lt\_attributes     TYPE trwbo\_t\_e070a,

del line           lt\_attributes\_aux TYPE trwbo\_t\_e070a,

> DATA:   lt\_attributes     TYPE TRATTRIBUTES,

> lt\_attributes\_aux TYPE TRATTRIBUTES,

**REPLACE 1 end**

> l\_trkorr          TYPE trkorr,

> lo\_producto       TYPE REF TO zcl\_producto,

> l\_bug\_id          TYPE LINE OF zbt\_producto\_bug\_id\_tbl,


**REPLACE 2 start**

del line    l\_attribute       TYPE LINE OF trwbo\_t\_e070a,

> l\_attribute       TYPE LINE OF TRATTRIBUTES,

**REPLACE 2 end**

**second adjustment**
Method
ZCB\_BUG\_TAG\_PERSIST    IF\_OS\_CA\_PERSISTENCY~GET\_PERSISTENT\_BY\_QUERY

during the import the following error comes up.

Programm **ZCB\_BUG\_PERSIST**===============CP, Include ZCB\_BUG\_PERSIST===============CM00P: Syntaxerror line 000152
Field 'I\_OPTIONS-DATABASE\_QUERY\_OPTIONS' unknown. (SAP BASIS 7.00)

Programm **ZCB\_BUG\_TAG\_PERSIST**===========CP, Include ZCB\_BUG\_TAG\_PERSIST===========CM00V: Syntaxerror line 000152
Feld 'I\_OPTIONS-DATABASE\_QUERY\_OPTIONS' unknown.

Well, I don't know if theres a better way, but I played around with "deleting the redefinition" from the methods ZCB\_BUG\_PERSIST/ZCB\_BUG\_TAG\_PERSIST and redefine again (Create Redefinition) and it worked for me.