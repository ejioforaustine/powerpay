import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';

import '../../UIsrc/ElectricityUi/AddMeternumber.dart';
import '../../UIsrc/ElectricityUi/OrderSummary.dart';

var BedcAmount;
var BedcAmountAfterVAT;
var Status;
var productName;
var uniqueMeterNum;
var unitPrice;
var amountAfterVat;
var billToken;
dynamic tempRequestID;
var requestID;
var temPserviceProvider;
var responseDescription;
var Units;
var transactionDate;
var transactionID;
var FlutterWaveStatus;
var feedsOrder;
var vat;
var newTotalBedcAmount;
var initialamount = Amount.text;
var newtype = newPowerProviderType;
var provider = newPowerProviderValue;
var newMeterNum = inputmeternum.text;
var publicKey = 'pk_live_1ce7bdcf189fe0588b88f13a7ab39658493b4d61';
var ussdFeed;
var bankTranferFeed;
var bankTransferNumber;
var bankTransferName;
var bankTransferAmount;
var bankTransferBeneficiary;
var bankTransferTransactionID;
var FlutterwaveTransferRef;
var ussdCode;
var TxRef;
var TxRefTransfer;
final plugin = PaystackPlugin();
final auth = FirebaseAuth.instance;
String? userEmail;
var BankIdCode;
bool isLoading2 = false;
bool isLoading3 = false;
bool isLoadingWalletTransfer = true;
var time;
var formattedDate;
var transferID;
var TxWalletStatus;
var payButtonText;
var payButtonTransferText;
var copyUSSDdescription = 'Please choose your bank to begin payment';
var copyTransferDescription = 'Please proceed to begin Payment';
var payViaWalletDebitStatus;
bool isTransferButtonclicked = false;
bool isUssdButtonclicked = false;
bool isPaymentViaTransferButtonclicked = false;

double usersBalanceDevice = 0;



//mini Functions to call upon.

Future<String?> getCurrentuserEmail() async {
  final user = auth.currentUser;
  userEmail = user?.email;
  print(userEmail);
  return userEmail;
} // retrieve users emails from Authentication

void takeOffVat() {
  BedcAmount = int.parse(Amount.text);
  BedcAmountAfterVAT = BedcAmount - (BedcAmount * 0.06);
  vat = BedcAmount * 0.06;
}// Here we minus VAT amount from Users intended purchase Power.



void getcurrentdate() {
  time = DateTime.now().toIso8601String();
  DateTime now = DateTime.now();
  formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
  print(time);
  return formattedDate;
} // Time variable Function... this is where we get Time.

///Save Transaction
void saveTransaction() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('users').doc(userInstance?.email);
  CollectionReference subcollectedRef =
      documentRef.collection('TransactionHistory');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
        'Product Name': '$productName',
        'Meter No': '$uniqueMeterNum',
        'Transaction date': '$transactionDate',
        'unit price': '₦ $unitPrice',
        'vat': '₦ $vat',
        'unit': '$Units',
        'total amount': '₦ $newTotalBedcAmount',
        'timestamp': FieldValue.serverTimestamp(),
        'Token': '$billToken',
        'meterAddress': meterAddress,
        'metername': verifiedMeterName,
        'type': newPowerProviderType,
         'requestID': formattedDate.toString(),
        'TransactionID': transactionID,
        'serviceProvider': serviceProvider,
      })
      .whenComplete(() => print('Updated'))
      .catchError((error) {
        print(error.toString());
      });
} // save Transaction details to database,
// so we can extract it from Transaction receipt page.

void SaveTransacREF() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef = FirebaseFirestore.instance
      .collection('TransacREF')
      .doc(userInstance?.email);
  CollectionReference subcollectedRef = documentRef.collection('refHistory');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
    'FlwTransREF': '$FlutterwaveTransferRef',
    'Tx_ref': '$TxRefTransfer',
  })
      .whenComplete(() => print('Updated'))
      .catchError((error) {
    print(error.toString());
  });
}// Save Customers Transaction Reference so we can help them sort out payment issue later.


///KYC variables
dynamic kYCStatus = false;
dynamic submittedStatus = false;