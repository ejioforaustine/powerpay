import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';

import '../createVirtualCustomer.dart';

//Conversion NG to USD
Future<Map<String, dynamic>> currencyConverterNGToUSD() async {
  const url = 'https://us-central1-polectro-60b65.cloudfunctions.net/convertNGNToUSD'; // Replace with your server endpoint

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    var rate = jsonResponse['rate'];
    dollarRate = jsonResponse['dollarRate'];

    // Now you can use rate and dollarRate as needed
    return {
      'rate': rate,
      'dollarRate': dollarRate,
    };
  } else {
    throw Exception('Failed to fetch exchange rate');
  }
}


//conversion USD to NG
Future<Map<String, dynamic>> currencyConverterUSDToNG() async {
  const url = 'https://us-central1-polectro-60b65.cloudfunctions.net/convertUSDToNGN'; // Replace with your server endpoint

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    var rate = jsonResponse['rate'];
    profitRateWithdraw = jsonResponse['profitRateWithdraw'];
    nairaRate = jsonResponse['nairaRate'];

    // Now you can use rate, profitRateWithdraw, and nairaRate as needed
    return {
      'rate': rate,
      'profitRateWithdraw': profitRateWithdraw,
      'nairaRate': nairaRate,
    };
  } else {
    throw Exception('Failed to fetch exchange rate');
  }
}


//Get bank List
Future<dynamic> getVirtualBanks (Function() callState) async{
print('starting...');
  var headers = {
    'Authorization': 'Bearer $testKeys'
  };
  var request = http.Request('GET', Uri.parse('https://sandbox.payscribe.ng/api/v1/payouts/bank/list'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    var responseBody = await response.stream.bytesToString();
    print(responseBody);
    var jsonResponseBody = jsonDecode(responseBody);
    var bankListDetails = jsonResponseBody['message']['details'];
    // Optionally, create a list of bank names and codes
    // Update bankList with bank names

    bankMap = {for (var bank in bankListDetails) bank['name']: bank['code']};


    callState();
  }
  else {
    print(response.reasonPhrase);
  }

}

//Account Lookup
Future<dynamic> accountLookUp () async {
  var headers = {
    'Authorization': 'Bearer $testKeys',
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('https://sandbox.payscribe.ng/api/v1/payouts/account/lookup'));
  request.body = json.encode({
    "account": accountNumber.text,
    "bank": "$selectedBankCode"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {


    var responseBody = await response.stream.bytesToString();
    var jsonBody = jsonDecode(responseBody);
    accountVirtualName = jsonBody['message']['details']['account_name'];
    print(accountVirtualName);
  }
  else {
    print(await response.stream.bytesToString());
    print(response.reasonPhrase);
  }

}