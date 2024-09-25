// URL of the API endpoint
var apiURL = "https://apex.oracle.com/pls/apex/auth/hr/empinfo/";

// Fetch data from the API
fetch(apiURL)
  .then(response => response.json())
  .then(data => {
    // Extract items array from the API response
    var items = data.items;

    // Get the Interactive Grid region
    var ig = apex.region("EMPLOYEES").widget().interactiveGrid('getViews', 'grid');
    var model = ig.model;
    var view = ig.view;

    // Add new data to the grid
    items.forEach(item => {
        var myNewRecordId = model.insertNewRecord();
        var myNewRecord = model.getRecord(myNewRecordId);
        // model.setValue(myNewRecord, 'EMPNO', item.empno || 'N/A');
        model.setValue(myNewRecord, 'ENAME', item.ename || 'N/A');
        model.setValue(myNewRecord, 'MGR', item.mgr || 'N/A');
        model.setValue(myNewRecord, 'HIREDATE', new Date(item.hiredate).toLocaleDateString() || 'N/A');
        model.setValue(myNewRecord, 'JOB', item.job || 'N/A');
        model.setValue(myNewRecord, 'SAL', item.sal || 'N/A');
        model.setValue(myNewRecord, 'COMM', item.comm || 'N/A');
        model.setValue(myNewRecord, 'DEPTNO', item.deptno || 'N/A');
    });

    // Refresh the grid view to show the new data
    view.refresh();

  })
  .catch(error => {
    console.error('Error fetching data:', error);
  });