*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 23.03.2022 at 21:57:32
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZBT_BUG_STYPE...................................*
DATA:  BEGIN OF STATUS_ZBT_BUG_STYPE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_BUG_STYPE                 .
CONTROLS: TCTRL_ZBT_BUG_STYPE
            TYPE TABLEVIEW USING SCREEN '0007'.
*...processing: ZBT_BUG_TYPE....................................*
DATA:  BEGIN OF STATUS_ZBT_BUG_TYPE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_BUG_TYPE                  .
CONTROLS: TCTRL_ZBT_BUG_TYPE
            TYPE TABLEVIEW USING SCREEN '0009'.
*...processing: ZBT_COMPONT.....................................*
DATA:  BEGIN OF STATUS_ZBT_COMPONT                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_COMPONT                   .
CONTROLS: TCTRL_ZBT_COMPONT
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZBT_CONFIG......................................*
DATA:  BEGIN OF STATUS_ZBT_CONFIG                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_CONFIG                    .
CONTROLS: TCTRL_ZBT_CONFIG
            TYPE TABLEVIEW USING SCREEN '0012'.
*...processing: ZBT_ESTADO......................................*
DATA:  BEGIN OF STATUS_ZBT_ESTADO                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_ESTADO                    .
CONTROLS: TCTRL_ZBT_ESTADO
            TYPE TABLEVIEW USING SCREEN '0004'.
*...processing: ZBT_ESTADO_HIER.................................*
DATA:  BEGIN OF STATUS_ZBT_ESTADO_HIER               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_ESTADO_HIER               .
CONTROLS: TCTRL_ZBT_ESTADO_HIER
            TYPE TABLEVIEW USING SCREEN '0005'.
*...processing: ZBT_PRODUCTO....................................*
DATA:  BEGIN OF STATUS_ZBT_PRODUCTO                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_PRODUCTO                  .
CONTROLS: TCTRL_ZBT_PRODUCTO
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZBT_PRODUCTO_TAG................................*
DATA:  BEGIN OF STATUS_ZBT_PRODUCTO_TAG              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_PRODUCTO_TAG              .
CONTROLS: TCTRL_ZBT_PRODUCTO_TAG
            TYPE TABLEVIEW USING SCREEN '0006'.
*...processing: ZBT_USUARIO.....................................*
DATA:  BEGIN OF STATUS_ZBT_USUARIO                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_USUARIO                   .
CONTROLS: TCTRL_ZBT_USUARIO
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZBT_WORKCONCEPT.................................*
DATA:  BEGIN OF STATUS_ZBT_WORKCONCEPT               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBT_WORKCONCEPT               .
CONTROLS: TCTRL_ZBT_WORKCONCEPT
            TYPE TABLEVIEW USING SCREEN '0008'.
*.........table declarations:.................................*
TABLES: *ZBT_BUG_STYPE                 .
TABLES: *ZBT_BUG_TYPE                  .
TABLES: *ZBT_COMPONT                   .
TABLES: *ZBT_COMPONT_TXT               .
TABLES: *ZBT_CONFIG                    .
TABLES: *ZBT_ESTADO                    .
TABLES: *ZBT_ESTADO_HIER               .
TABLES: *ZBT_ESTADO_TXT                .
TABLES: *ZBT_PRODUCTO                  .
TABLES: *ZBT_PRODUCTOTAGT              .
TABLES: *ZBT_PRODUCTO_TAG              .
TABLES: *ZBT_PRODUCTO_TXT              .
TABLES: *ZBT_STYPE_TXT                 .
TABLES: *ZBT_TYPE_TXT                  .
TABLES: *ZBT_USUARIO                   .
TABLES: *ZBT_WORKCONCEPT               .
TABLES: *ZBT_WORKCONCEPTT              .
TABLES: ZBT_BUG_STYPE                  .
TABLES: ZBT_BUG_TYPE                   .
TABLES: ZBT_COMPONT                    .
TABLES: ZBT_COMPONT_TXT                .
TABLES: ZBT_CONFIG                     .
TABLES: ZBT_ESTADO                     .
TABLES: ZBT_ESTADO_HIER                .
TABLES: ZBT_ESTADO_TXT                 .
TABLES: ZBT_PRODUCTO                   .
TABLES: ZBT_PRODUCTOTAGT               .
TABLES: ZBT_PRODUCTO_TAG               .
TABLES: ZBT_PRODUCTO_TXT               .
TABLES: ZBT_STYPE_TXT                  .
TABLES: ZBT_TYPE_TXT                   .
TABLES: ZBT_USUARIO                    .
TABLES: ZBT_WORKCONCEPT                .
TABLES: ZBT_WORKCONCEPTT               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
