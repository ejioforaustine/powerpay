import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';

import '../../../Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';

Future<void> transferFunds(BuildContext context, dynamic accountNO, dynamic withDrawAmount, dynamic bankCode) async {
  const url = 'https://us-central1-polectro-60b65.cloudfunctions.net/transferFunds';

  var headers = {
    'Content-Type': 'application/json',
  };

  var requestBody = json.encode({
    "email": userEmail,
    "amount": withDrawAmount,
    "bank": "$bankCode",
    "account": "$accountNO",
    "currency": "ngn",
    "narration": "$userEmail + withdraw balance",
    "ref": miniFunction().getReference(),
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      if(context.mounted){
        successPopUp(context);
      }

      print('Response: ${response.body}');
    } else {
      PopUpFunction(Apikey: '', secretKey: '', context: context).failedPopup4Debitwallet();
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}

