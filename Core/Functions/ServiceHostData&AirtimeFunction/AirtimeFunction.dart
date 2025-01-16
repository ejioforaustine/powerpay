import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import 'package:powerpay/UIsrc/Airtime/Models/constants.dart';
import 'package:powerpay/UIsrc/DataUi/models/constant.dart';
import '../constantvaribles.dart';
import '../keys.dart';

///purchase data
Future<dynamic> purchaseAirtime2(
    BuildContext context, void Function() getState) async
{
  getcurrentdate();
  if (kDebugMode) {
    print({
      'trying for Airtime',
      selectedBundlePackageAmount,
      selectedBundleVariationCode
    });
  }

  try {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'api-key': ApiKey,
      'secret-key': SecretKey,
    };

    var request = http.Request('POST', Uri.parse('https://vtpass.com/api/pay'));
    request.bodyFields = {
      "request_id": "$formattedDate",
      "serviceID": airtimeServiceID,
      "amount": airtimeAmount.toString(),
      "type": "$newtype",
      "phone": airtimePhoneNumber,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    try {
      if (response.statusCode == 200) {
        feedsOrder = await response.stream.bytesToString();
        print(feedsOrder);
        airtimeBuyStatus = jsonDecode(feedsOrder)['content']['transactions']
                ['status']
            .toString();
        airtimeProductName = jsonDecode(feedsOrder)['content']['transactions']
                ['product_name']
            .toString();

        airtimeUniquePhoneNumber = jsonDecode(feedsOrder)['content']
                ['transactions']['unique_element']
            .toString();
        airtimePrice = jsonDecode(feedsOrder)['content']['transactions']
                ['unit_price']
            .toString();
        try {
          airtimeTransacDate =
              jsonDecode(feedsOrder)['transaction_date']['date'].toString();
        } catch (e) {
          print(e);
        }
        airtimeResponseDesc =
            jsonDecode(feedsOrder)['response_description'].toString();
        airtimeTransacID = jsonDecode(feedsOrder)['content']['transactions']
                ['transactionId']
            .toString();

        if (airtimeBuyStatus == 'delivered') {
          isAirtimePaid = false;
          getState;
          if (context.mounted) {
            dataSuccessPopUp(context);
            saveAirtimeTransaction();
          }
        } else {
          context.mounted ? failedDataOrAirtimeTransactionPopUp(context) : null;
          isAirtimePaid = false;
          getState;
        }
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong');

        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
      responseDescription = 'Failed Complete Transaction';
    }
  } catch (e) {
    context.mounted
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red.shade800,
                content: const Center(
                    child: Text(
                        "Somethings didn't work out well, please try again or contact us"))),
          )
        : null;
  }

  return responseDescription;
}

Future<void> purchaseAirtime(
  BuildContext context,
  void Function() getState,
) async
{
  getcurrentdate();
  const url =
      "https://us-central1-polectro-60b65.cloudfunctions.net/purchaseAirtime";

  print({
    formattedDate,
    airtimeServiceID,
    newtype.toString(),
    airtimePhoneNumber,
    airtimeAmount.toString()
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "transactionReference" : dataTransferID,
        "request_id": formattedDate.toString(),
        "serviceID": airtimeServiceID,
        "amount": airtimeAmount.toString(),
        "type": "$newtype",
        "phone": airtimePhoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Airtime Purchase Success: $data");

      print(data['transactionDetails']['product_name']);

      airtimeProductName =
          data['transactionDetails']['product_name'].toString();

      print(airtimeProductName);

      airtimeUniquePhoneNumber =
          data['transactionDetails']['unique_element'].toString();
      print(airtimeUniquePhoneNumber);
      airtimePrice =
          data['transactionDetails']['unit_price'].toString();
      print(airtimePrice);
      try {
        airtimeTransacDate = formattedAmountValue;
        print(airtimeTransacDate);
      } catch (e) {
        print(e);
      }
      airtimeResponseDesc = data['status'].toString();
      print(airtimeResponseDesc);
      airtimeTransacID =
          data['transactionDetails']['transactionId'].toString();
      print(airtimeTransacID);

      isAirtimePaid = false;
      getState;
      dataSuccessPopUp(context);
      saveAirtimeTransaction();
      print('success');
    } else {
      context.mounted ? failedDataOrAirtimeTransactionPopUp(context) : null;
      isAirtimePaid = false;
      getState;
    }
  } catch (e) {
    context.mounted
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red.shade800,
                content: const Center(
                    child: Text(
                        "Somethings didn't work out well, please try again or contact us"))),
          )
        : null;
  }
}

// save Transaction details to database,
void saveAirtimeTransaction() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('users').doc(userInstance?.email);
  CollectionReference subcollectedRef =
      documentRef.collection('TransactionHistory');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
        'Product Name': airtimeProductName,
        'Meter No': airtimeUniquePhoneNumber,
        'Transaction date': airtimeTransacDate,
        'unit price': '₦ ',
        'vat': '',
        'unit': '',
        'total amount': '₦ $airtimePrice',
        'timestamp': FieldValue.serverTimestamp(),
        'Token': '',
        'meterAddress': '',
        'metername': '',
        'type': '',
        'TransactionID': airtimeTransacID,
        'serviceProvider': networkProvider,
      })
      .whenComplete(() => print('Uploaded'))
      .catchError((error) {
        print(error.toString());
      });
}
