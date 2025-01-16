import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/keys.dart';
import 'package:powerpay/Wallet/walletFace.dart';
import '../Core/Functions/constantvaribles.dart';
import '../UIsrc/home/Home.dart';

///  i called USSD payment API for the sole purpose of creating customer.
var customerTxRef;
var customerUSSDstatus;
var walletAccountID;
var walletAccountName;
var walletAccountNumber;
var walletBankName;
var walletStatus;

Future<dynamic> createWallet() async {
  var url = 'https://us-central1-polectro-60b65.cloudfunctions.net/createWallet'; // Replace with your Cloud Function URL

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "accountName": '$usersName',
        "email": userEmail,
        "mobilenumber": usersPhone,
        "country": 'NG',
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      walletAccountID = data['account_reference'];
      walletAccountName = data['account_name'];
      walletAccountNumber = data['nuban'];
      walletBankName = data['bank_name'];
      walletCreated = true;

      saveWalletDetails(); // Call your method to save wallet details locally
    } else {
      // Handle error response
      Fluttertoast.showToast(msg: 'Failed to create wallet: ${response.body}');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'An error occurred: $e');
  }
}


Future<dynamic> fetchBalance() async {
  try {
    final response = await http.post(
      Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/FetchBalance'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "walletAccountID": walletAccountID,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      walletBalance = data['data']['available_balance'];

      if (walletBalance != null) {
        loadindingBalance = false;
        saveWalletBalance();
      } else {
        loadindingBalance = false;
      }
    } else {
      loadindingBalance = true;

    }
  } catch (e) {
    loadindingBalance = true;
    Fluttertoast.showToast(msg: "Something went wrong - We have taken report on this");
    if (kDebugMode) {
      print(e);
    }
  }
  return walletBalance;
}


Future<dynamic> refreshBalance(VoidCallback setStateCallback) async {
  int counter = 0;

  while (walletBalance == null && counter < 4) {
    await fetchDataFromSubcollection(() {});
    await fetchBalance();
    loadindingBalance = false;
    setStateCallback();
    counter++;
  }

  if ( counter == 4){

  }

  return walletBalance;
}

void saveWalletDetails() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Wallet').doc(userInstance?.email);
  CollectionReference subcollectedRef = documentRef.collection('WalletDetails');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
        'Account Name': '$walletAccountName',
        'Account No': '$walletAccountNumber',
        'Account ID': '$walletAccountID',
        'Bank name': '$walletBankName',
        'walletCreated': '$walletCreated',
      })
      .whenComplete(() => print('Updated'))
      .catchError((error) {
        print(error.toString());
      });
}

void saveWalletBalance() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Wallet').doc(userInstance?.email);
  CollectionReference subcollectedRef =
      documentRef.collection('WalletBalanceAmount');
  await subcollectedRef
      .doc(userInstance?.uid)
      .set({
        'Account Balance': '₦ $walletBalance',
      })
      .whenComplete(() => print('Updated'))
      .catchError((error) {
        print(error.toString());
      });
}

Future<dynamic> getWalletBalance() async {
  try {
    dynamic datas;
    var userInstance = FirebaseAuth.instance.currentUser;

    final DocumentReference document = FirebaseFirestore.instance
        .collection("Wallet")
        .doc(userInstance!.email);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) {
      datas = snapshot.data();
    });
    usersName = datas['name'];


    return datas;
  } catch (e) {

    Fluttertoast.showToast(msg: 'Your Internet Maybe slow');
  }
}

Future<void> fetchDataFromSubcollection(VoidCallback setStateCallback) async {
  try {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('Wallet');
    final DocumentReference documentReference =
        mainCollection.doc('$userEmail');
    final CollectionReference subCollection =
        documentReference.collection('WalletDetails');

    QuerySnapshot querySnapshot = await subCollection.get();
    for (var doc in querySnapshot.docs) {
      // Access individual document fields using doc.data()
      walletAccountID = doc.get('Account ID');
      walletAccountNumber = doc.get('Account No');
      walletBankName = doc.get('Bank name');
      walletAccountName = doc.get('Account Name');
      if (kDebugMode) {
        print(walletAccountID);
      }

      visibility();
      setStateCallback();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching data: $e');
    }
  }
}


///Back End api calls
Future<dynamic> adminPolicyWithdrawal(String subAccountId,int adminSubAmount, String  key) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $key'
  };
  var request = http.Request(
      'POST', Uri.parse('https://api.flutterwave.com/v3/transfers'));
  request.body = json.encode({
    "account_bank": "011",
    "account_number": "2042647018",
    "debit_subaccount": subAccountId,
    "narration": "Violation in user",
    "currency": "NGN",
    "amount": adminSubAmount,
    "debit_currency": "NGN",

  });
  request.headers.addAll(headers);



  http.StreamedResponse response = await request.send();
  print('reached here');
  if (response.statusCode == 200) {
    String feed;
    feed = await response.stream.bytesToString();


    print({
      feed
    });
  } else {

    print(await response.stream.bytesToString(),);
  }
}

Future<dynamic> adminPolicyUpdateDetails() async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer '
  };
  var request = http.Request(
      'PUT', Uri.parse('https://api.flutterwave.com/v3/payout-subaccounts/PSA99CD36C0431853588/'));
  request.body = json.encode({
    "account_name": "FRAUD, DO NOT SEND",
    "email": "jumiaonlineshopping999@yahoo.com",
    "mobilenumber": "+2347065748577",
    "country": "NG"

  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String feed;
    feed = await response.stream.bytesToString();


    print({
      feed
    });
  } else {
    print(response.reasonPhrase);
  }
}



///Verification
Future<dynamic> adminBvnVerification() async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
    'Bearer '
  };
  var request = http.Request(
      'POST', Uri.parse('https://api.flutterwave.com/v3/bvn/verifications'));
  request.body = json.encode({

    "bvn": "",
    "firstname": "",
    "lastname": "",
    "redirect_url": "https://example.com",

  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String feed;
    feed = await response.stream.bytesToString();


    print({
      feed
    });
  } else {
    print(response.reasonPhrase);
  }
}



