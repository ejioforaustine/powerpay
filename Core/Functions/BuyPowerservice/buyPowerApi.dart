
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';

class PayBEDCWithBuyPower {

  int buyPowerAmount = 0;
  dynamic meterNumberBuyPower;
  dynamic discoProviderBuyPower;
  dynamic discoTypeBP;

  PayBEDCWithBuyPower ({
    required this.buyPowerAmount,
    required this.meterNumberBuyPower,
    required this.discoProviderBuyPower,
    required this.discoTypeBP,
  });



  Future<dynamic> verifyMeter() async {
    if (kDebugMode) {
      print({
      meterNumberBuyPower,
      discoProviderBuyPower,
      discoTypeBP
    });
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'Bearer 182db8bfce04a98028d07e95c3731f8f8fd90b5734e1f5422f661bd42ec1caf6'
    };

    var request = http.Request('GET', Uri.parse('https://api.buypower.ng/v2/check/meter?meter=$meterNumberBuyPower&disco=ABUJA&vendType=$discoTypeBP'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

    }
    else {
      print(await response.stream.bytesToString());
    }


  }

  Future<dynamic> vendMeter() async {
    if (kDebugMode) {
      print({
        'Vending Meter now',
        meterNumberBuyPower,
        discoProviderBuyPower,
        discoTypeBP
      });
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'Bearer 182db8bfce04a98028d07e95c3731f8f8fd90b5734e1f5422f661bd42ec1caf6'
    };

    var request = http.Request('POST', Uri.parse('https://api.buypower.ng/v2/vend?strict=0'));

    request.body = json.encode({

      "orderId": miniFunction().getReference(),
      "vendType": "$discoTypeBP",
      "amount": "{$buyPowerAmount}",
      "phone": "07033005327",
      "meter": "$meterNumberBuyPower",
      "disco": "$discoProviderBuyPower",
      "vertical": "ELECTRICITY",
      "paymentType": "B2B"

    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(await response.stream.bytesToString());
    }


  }




}