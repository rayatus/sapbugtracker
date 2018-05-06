*"* components of interface ZINF_RESULTS_ALV_CTRL
interface ZINF_RESULTS_ALV_CTRL
  public .

  type-pools COL .

  data RESULTS type ZBT_BUGS .

  methods ON_RESULTS_SELECTED
    importing
      !BUGS type ZBT_BUGS .
  methods DISPLAY_RESULTS
    importing
      !CONTAINER type ref to CL_GUI_CONTAINER .
  methods DO_SEARCH
    importing
      !BUG type ZBT_BUG_RANGE optional
      !BUGSTYPE type ZBT_BUGSTYPE_RANGE optional
      !BUGTYPE type ZBT_BUGTYPE_RANGE optional
      !COMPONENTE type ZBT_COMPONENTE_RANGE optional
      !DEADLINE type ZBT_DATS_RANGE optional
      !ESTADO type ZBT_ESTADO_RANGE optional
      !HORAS_ESTIMADAS type ZBT_HORAS_RANGE optional
      !HORAS_REALES type ZBT_HORAS_RANGE optional
      !PRODUCTO type ZBT_PRODUCTO_RANGE optional
      !RESUMEN type ZBT_TEXT_RANGE optional
      !CREADO type ZBT_TIMESTAMP_RANGE optional
      !REPORTER type ZBT_USER_RANGE optional
      !DEVELOPER type ZBT_USER_RANGE optional
      !ASSIGNED type ZBT_USER_RANGE optional
      !TESTER type ZBT_USER_RANGE optional
      !FINALIZADO type ZBT_TIMESTAMP_RANGE optional
      !AEDAT type ZBT_TIMESTAMP_RANGE optional
      !AENAM type ZBT_USER_RANGE optional
      value(MAX_ROWS) type I optional .
endinterface.
