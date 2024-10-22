var vid = $('#P6631_INT_INVOICE').val();
//var deptnoValue = document.getElementById('P500_ID').value;

apex.server.process('DETAIL_ITEMS', {
//  x01: null
pageItems: "#P6631_INT_INVOICE"
}, {
  dataType: 'json',
  success: function(data) {
    var items = data.items;

    // Get the Interactive Grid region by static ID
    var ig = apex.region("INVDET").widget().interactiveGrid('getViews', 'grid');
    var model = ig.model;

    // Ensure that ig and model are valid
    if (!model) {
      console.error('Model not found!');
      return;
    }

    // Iterate through each item in the response and add it to the grid
    items.forEach(item => {
      var myNewRecordId = model.insertNewRecord();
      var myNewRecord = model.getRecord(myNewRecordId);
      model.setValue(myNewRecord, 'INV_ID', item.invid || '0');
      model.setValue(myNewRecord, 'INV_NO', item.invno || '0'); 
      model.setValue(myNewRecord, 'PRODUCT_ID', (item.productid !== null ? item.productid : "").toString());
      model.setValue(myNewRecord, 'PRODUCTID', (item.productid !== null ? item.productid : "").toString());
      model.setValue(myNewRecord, 'INV_QTY', (item.invqty !== null ? item.invqty : "").toString());     
      model.setValue(myNewRecord, 'INV_CTN', (item.invctn !== null ? item.invctn : "").toString());
      model.setValue(myNewRecord, 'TOT_TRADE_PRICE', (item.tottradeprice || '0').toString());
      model.setValue(myNewRecord, 'TOT_AMOUNT_T', (item.amount !== null ? item.amount : "").toString());
      model.setValue(myNewRecord, 'TOT_AMOUNT', (item.totalamount !== null ? item.totalamount : "").toString());
      model.setValue(myNewRecord, 'TOT_VAT_PRICE', (item.vatamount !== null ? item.vatamount : "").toString());
      model.setValue(myNewRecord, 'INCL_VAT_AMT', (item.incvatamt !== null ? item.incvatamt : "").toString());      
      model.setValue(myNewRecord, 'UNIT_VAT', (item.unitvat !== null ? item.unitvat : "").toString());
      model.setValue(myNewRecord, 'INV_TYPE', (item.invtype || 'N').toString());
    });

    // Refresh the entire Interactive Grid
    ig.refresh();
  },
  error: function() {
    console.error('Error fetching data from Application Process');
  }
});
