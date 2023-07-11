realtime: function syncSheetToFirebase() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var dataRange = sheet.getDataRange();
  var data = dataRange.getValues();

  var firebaseUrl = "app-de-cadastro-imobiliario-default-rtdb.firebaseio.com"; // Insira a URL do Firebase Realtime Database
  var firebaseApiKey = "app-de-cadastro-imobiliario"; // Insira a chave da API do Firebase

  var firebaseBase = "https://" + firebaseUrl + "/"; // URL base do Firebase
  var firebaseEndpoint = "data.json?auth=" + firebaseApiKey; // Endpoint para a coleção "data" no Firebase
  var firebaseUrl = firebaseBase + firebaseEndpoint; // URL completa para enviar os dados ao Firebase

  var payload = {
    data: data,
  };

  var options = {
    method: "put",
    contentType: "application/json",
    payload: JSON.stringify(payload),
    muteHttpExceptions: true,
  };

  var response = UrlFetchApp.fetch(firebaseUrl, options);
  Logger.log(response.getContentText());

  UrlFetchApp.fetch(firebaseUrl, options);
}
