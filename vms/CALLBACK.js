var vid = $('#P444_PRODUCT_CODE').val();
apex.server.process('VATFORMULADTL', {
  pageItems: "#P444_PRODUCT_CODE"
}, {
  dataType: 'json',
  success: function(data) {
    var items = data.items;
    // Get the Interactive Grid region by static ID
    var ig = apex.region("coefficint_dtl").widget().interactiveGrid('getViews', 'grid');
    var model = ig.model;
    // Ensure that ig and model are valid
    if (!model) {
      console.error('Model not found!');
      return;
    }
    // Check if the grid already has records
    if (model.getTotalRecords() > 1) {
      console.warn('Grid already has records. No new data will be added.');
      return; // Stop execution if records are present
    }
    // Iterate through each item in the response and add it to the grid
    items.forEach(item => {
      var myNewRecordId = model.insertNewRecord();
      var myNewRecord = model.getRecord(myNewRecordId);
      model.setValue(myNewRecord, 'HSCODE', (item.hsc ?? "").toString());
      model.setValue(myNewRecord, 'RMPMEXP_CODE', (item.rmid ?? "").toString());
      model.setValue(myNewRecord, 'REQUIRED_QTY', (item.reqqty ?? "").toString());
      model.setValue(myNewRecord, 'UOM', (item.um ?? "").toString());
      model.setValue(myNewRecord, 'WASTAGE_PER', (item.wstprcnt ?? "").toString());
      model.setValue(myNewRecord, 'WASTAGE_QTY', (item.wstqty ?? "").toString());
      model.setValue(myNewRecord, 'UNIT_PRICE', (item.uprc ?? "").toString());
      model.setValue(myNewRecord, 'REQUIRED_QTY_DISP', (item.reqdqty ?? "").toString());
      model.setValue(myNewRecord, 'PRICE', (item.prc ?? "").toString());
      model.setValue(myNewRecord, 'EXP_CODE', (item.expid ?? "").toString());
      model.setValue(myNewRecord, 'EXP_PRICE', (item.exprc ?? "").toString());
      model.setValue(myNewRecord, 'EXP_TYPE', (item.exptyp ?? "").toString());
      model.setValue(myNewRecord, 'SLNO', (item.sl ?? "").toString());
    });
    // Refresh the entire Interactive Grid
    ig.refresh();
  },
  error: function() {
    console.error('Error fetching data from Application Process');
  }
});