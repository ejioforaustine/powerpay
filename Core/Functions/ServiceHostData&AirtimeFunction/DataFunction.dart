
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import 'package:powerpay/Core/Functions/ServiceHostData&AirtimeFunction/constant_variables.dart';
import 'package:powerpay/UIsrc/DataUi/models/constant.dart';
import '../constantvaribles.dart';
import '../keys.dart';
///purchase data
Future<dynamic> purchaseData2(BuildContext context) async {
  getcurrentdate();
  print({'trying for data',selectedBundlePackageAmount,selectedBundleVariationCode});


  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'api-key': ApiKey,
    'secret-key': SecretKey,
  };

  var request = http.Request('POST', Uri.parse('https://vtpass.com/api/pay'));
  request.bodyFields = {
    "request_id": "$formattedDate",
    "variation_code": selectedBundleVariationCode,
    "billersCode": dataPhoneNUmber,
    "serviceID": dataServiceID,
    "type": "$newtype",
    "phone": dataPhoneNUmber,
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  try {
    if (response.statusCode == 200) {
      feedsOrder = await response.stream.bytesToString();
      print(feedsOrder);
      dataBuyStatus = jsonDecode(feedsOrder)['content']['transactions']['status']
          .toString();
     dataProductName = jsonDecode(feedsOrder)['content']['transactions']
      ['product_name'].toString();

      datauniquePhoneNumber = jsonDecode(feedsOrder)['content']['transactions']
      ['unique_element']
          .toString();
      dataUnitPrice = jsonDecode(feedsOrder)['content']['transactions']
      ['unit_price']
          .toString();
      try {dataTransacDate =
          jsonDecode(feedsOrder)['transaction_date'].toString();} catch(e){print(e);}

      dataResponseDescription =
          jsonDecode(feedsOrder)['response_description'].toString();
      dataTransactionID = jsonDecode(feedsOrder)['content']['transactions']
      ['transactionId']
          .toString();

      print({
        dataBuyStatus,
        dataBuyAmount,
        dataProductName,
        dataTransactionID,
        dataTransacDate,
        dataResponseDescription,
        dataUnitPrice,
        datauniquePhoneNumber,

      });

      if(dataBuyStatus == 'delivered'){
        if(context.mounted){dataSuccessPopUp(context);saveDataTransaction();}
      }else{
        context.mounted?
        failedDataOrAirtimeTransactionPopUp(context) : null;
      }



    } else {
      Fluttertoast.showToast( msg: 'Something Went Wrong');

      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
    responseDescription = 'Failed Complete Transaction';
  }

  return responseDescription;
}

Future<void> purchaseData(
    BuildContext context
    ) async
{
  getcurrentdate();
  print({'trying for data',selectedBundlePackageAmount,selectedBundleVariationCode});
  const url = "https://us-central1-polectro-60b65.cloudfunctions.net/purchaseData";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "transactionReference" : dataTransferID,
        "request_id": "$formattedDate",
        "variation_code": selectedBundleVariationCode,
        "billersCode": dataPhoneNUmber,
        "serviceID": dataServiceID,
        "amount" : selectedBundlePackageAmount,
        "type": "$newtype",
        "phone": dataPhoneNUmber,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Data Purchase Success: $data");
      dataBuyStatus = data['transactionDetails']['status']
          .toString();
      dataProductName = data['transactionDetails']
      ['product_name'].toString();

      datauniquePhoneNumber = data['transactionDetails']
      ['unique_element']
          .toString();
      dataUnitPrice = data['transactionDetails']
      ['unit_price']
          .toString();
      try {dataTransacDate = formattedDate.toString();
         } catch(e){print(e);}

      dataResponseDescription =
          data['message'].toString();
      dataTransactionID = data['transactionDetails']
      ['transactionId']
          .toString();
      if(context.mounted){dataSuccessPopUp(context);saveDataTransaction();}
      print({
        dataBuyStatus,
        dataBuyAmount,
        dataProductName,
        dataTransactionID,
        dataTransacDate,
        dataResponseDescription,
        dataUnitPrice,
        datauniquePhoneNumber,
      });

    } else {
      print("Failed: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

// save Transaction details to database,
void saveDataTransaction() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
  FirebaseFirestore.instance.collection('users').doc(userInstance?.email);
  CollectionReference subcollectedRef =
  documentRef.collection('TransactionHistory');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
    'Product Name': '$dataProductName',
    'Meter No': '$datauniquePhoneNumber',
    'Transaction date': '$dataTransacDate',
    'unit price': '₦ ',
    'vat': '',
    'unit': '',
    'total amount': '₦ $dataUnitPrice',
    'timestamp': FieldValue.serverTimestamp(),
    'Token': '',
    'meterAddress': '',
    'metername': selectedBundlePackageName,
    'type': '',
    'TransactionID': dataTransactionID,
    'serviceProvider': dataServiceProvider,
  })
      .whenComplete(() => print('Uploaded'))
      .catchError((error) {
    print(error.toString());
  });
}