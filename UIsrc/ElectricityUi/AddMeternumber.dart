import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/Core/Functions/BuyPowerservice/buyPowerApi.dart';
import 'package:powerpay/UIsrc/ElectricityUi/OrderSummary.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


import '../../Core/Functions/constantvaribles.dart';
import '../../UIKonstant/KUiComponents.dart';

const List<String> States = <String>[
  'Delta ',
  'Edo ',
  'Ondo',
  'Ekiti',
  'Lagos',
  'Enugu',
  'FCT',
  'Anambra',
  'Imo',
  'Rivers',
  'Osun',
  'Ogun',
  'Kano',
  'Bauchi',
  'Kaduna',
  'Nasarawa',
  'Borno',
  'Abia',
  'Adamawa',
  'Cross River',
  'Akwa Ibom',
  'Bayelsa',
  'Gombe',
  'Katsina',
  'Benue',
  'Kwara',
  'Plateau',
  'Oyo',
  'Kogi',
  'Taraba',
  'Jigawa',
  'Yobe',
  'Niger',
  'Sokoto',
  'Kebbi',
  'Zamfara',

];
List<String> optionImages = [
  'assets/images/PowerproviderLogo/BEDC.jpg',
  'assets/images/PowerproviderLogo/AEDC-LOGO.jpg',
  'assets/images/PowerproviderLogo/EkoAtlantic.jpeg',
  'assets/images/PowerproviderLogo/APLE.png',
  'assets/images/PowerproviderLogo/enugu.jpeg',
  'assets/images/PowerproviderLogo/Ibedc.png',
  'assets/images/PowerproviderLogo/ikejaLagos.jpeg',
  'assets/images/PowerproviderLogo/JED.png',
  'assets/images/PowerproviderLogo/kaduna.jpeg',
  'assets/images/PowerproviderLogo/Kedco-spon.jpg',
  'assets/images/PowerproviderLogo/portharcourt.png',


];
const List<String> powerProvider = <String>['BEDC','AEDC','EKEDC','APLE','EEDC','IBEDC','IKEDC','JEDC','KAEDC','KEDCO','PHED'];

const List<String> powerDescriptions = <String> [
  'Benin Electricity',
  'Abuja Electricity',
  'Eko Electricity',
  'Aba Electricity',
  'Enugu Electricity',
  'Ibadan Electricity',
  'Ikeja Electricity',
  'Jos Electricity',
  'Kaduna Electricity',
  'kano Electricity',
  'Portharcourt Electricity',

];
const List<String> powerProviderType = <String>['prepaid', 'postpaid'];
var newvalues;
var newPowerProviderValue;
var serviceProvider;
dynamic buyPowerServiceProvider;
var newPowerProviderType;
TextEditingController inputmeternum = TextEditingController();
TextEditingController Amount = TextEditingController();
var successCode;
var feed;
var meterAddress;
var holdAmountTemporaryToCheckMinimumAmount;

class MeterNumber extends StatefulWidget {
  const MeterNumber({Key? key}) : super(key: key);

  @override
  State<MeterNumber> createState() => _MeterNumberState();
}

void saveMeterNumber() async {
  var userInstance = FirebaseAuth.instance.currentUser;
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('users').doc(userInstance?.email);
  CollectionReference subcollectedRef = documentRef.collection('MeterNum');
  await subcollectedRef
      .doc(userInstance?.tenantId)
      .set({
        'Meter number': inputmeternum.text,
        'timestamp': FieldValue.serverTimestamp(),
        'meterName': verifiedMeterName,
        'MeterAddress': meterAddress,
        'type': newPowerProviderType,
        'Disco': serviceProvider,
      })
      .whenComplete(() => print('Updated'))
      .catchError((error) {
        print(error.toString());
      });
}

var userInstance = FirebaseAuth.instance.currentUser;
CollectionReference subcollectionRef = FirebaseFirestore.instance
    .collection('users')
    .doc(userInstance?.email)
    .collection('MeterNum');
CollectionReference subcollectionRef2 = FirebaseFirestore.instance
    .collection('users')
    .doc(userInstance?.email)
    .collection('TransactionHistory');

bool isLoading = false;

String titleMeter = '';
String typeMeter = '';
String descriptionMeter = '';
String discoTypeMeter = '';
dynamic subAmount = 0;

/// We select Disco logically here

void switchDisco(){
  switch(newPowerProviderValue){
    case 'BEDC':
      serviceProvider = 'benin-electric';
      print(newPowerProviderValue);
      break;
    case 'AEDC':
      serviceProvider = 'abuja-electric';
      buyPowerServiceProvider = 'ABUJA';
      print(serviceProvider);
      break;
    case 'EEDC':
      serviceProvider = 'enugu-electric';
      print(serviceProvider);
      break;
    case 'EKEDC':
      serviceProvider = 'eko-electric';
      buyPowerServiceProvider = 'EKO';
      print(serviceProvider);
      break;
    case 'IBEDC':
      serviceProvider = 'ibadan-electric';
      print(serviceProvider);
      break;
    case 'IKEDC':
      serviceProvider = 'ikeja-electric';
      print(serviceProvider);
      break;

    case 'PHED':
      serviceProvider = 'portharcourt-electric';
      print(serviceProvider);
      break;
    case 'JEDC':
      serviceProvider = 'jos-electric';
      print(serviceProvider);
      break;
    case 'KAEDC':
      serviceProvider = 'kaduna-electric';
      print(serviceProvider);
      break;
    case 'KEDCO':
      serviceProvider = 'kano-electric';
      print(serviceProvider);
      break;
    case 'APLE':
      serviceProvider = 'aba-electric';
      if (kDebugMode) {
        print(serviceProvider);
      }
      break;




  }
}

///END

void getMeterDetailsFromFirebase() {}

class _MeterNumberState extends State<MeterNumber> {
  /// RESTAPI CONNECTS HERE///
  bool isOrderSummaryButtonclicked = false;
  void handleButtonClickToAvoidDuplicateTransaction() {
    if (!isOrderSummaryButtonclicked) {
      isOrderSummaryButtonclicked = true;

      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrderSummary()))
          .then((value) => isOrderSummaryButtonclicked = false);
    }
  }

  Future<void> verifyMeterNumber() async {
    newMeterNum = inputmeternum.text;

    var requestBody = {
      "billersCode": inputmeternum.text,
      "serviceID": "$serviceProvider",
      "type": "$newPowerProviderType"
    };

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/verifyMeterNumber'), // Firebase Function URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          verifiedMeterName = data['customerName'];
          meterAddress = data['address'];
          saveMeterNumber();
          handleButtonClickToAvoidDuplicateTransaction();
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Something went wrong.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong');
        print(response.reasonPhrase);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Server error: $e');
    }
  }

  Future<dynamic> verifyMeterNumberOnSelectMeter() async {
    var requestBody = {
      "billersCode": newMeterNum,
      "serviceID": "$serviceProvider",
      "type": "Prepaid"
    };

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/verifyMeterNumber'), // Firebase Function URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          verifiedMeterName = data['customerName'];
          meterAddress = data['address'];
          handleButtonClickToAvoidDuplicateTransaction();
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Something went wrong.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong');
        print(response.reasonPhrase);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Server error: $e');
    }
  }

  Future<dynamic> verifyMeterNumberOnEachKeyInputs() async {
    newMeterNum =inputmeternum.text;
    var requestBody = {
      "billersCode": inputmeternum.text,
      "serviceID": "$serviceProvider",
      "type": "Prepaid"
    };

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/verifyMeterNumber'), // Firebase Function URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          verifiedMeterName = data['customerName'];
          meterAddress = data['address'];

        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Something went wrong.');
        }
        isLoading = false;
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong');
        print(response.reasonPhrase);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Server error: $e');
    }
  }

  Future<dynamic> VerifyMeterNumberOnEachKeyInputsSavedMeter() async {

    var requestBody = {
      "billersCode": newMeterNum,
      "serviceID": "$serviceProvider",
      "type": "Prepaid"
    };

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/verifyMeterNumber'), // Firebase Function URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          verifiedMeterName = data['customerName'];
          meterAddress = data['address'];
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Something went wrong.');
        }
        isLoading = false;
      } else {
        Fluttertoast.showToast(msg: 'Something Went Wrong');
        print(response.reasonPhrase);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Server error: $e');
    }
  }
  /// ENDS HERE


  final FocusNode _focusNode = FocusNode();
  void callstate() {
    print('this reached here');
    setState(() {});
  }

  void _additionFunction(String) {
    setState(() {
      verifyMeterNumberOnEachKeyInputs();
    });
  }

  void _additionFunction2(String) {
    setState(() {
      VerifyMeterNumberOnEachKeyInputsSavedMeter();
    });
  }

  void showAddMeterForm() {

    //Fetch coupon from database
    Future<Map<String, dynamic>?> getCouponFromDatabase(String Powerpay1k) async {
      final couponDoc = await FirebaseFirestore.instance
          .collection('Coupon')
          .doc(Powerpay1k)
          .get();

      if (couponDoc.exists) {
        print(couponDoc.data());
        return couponDoc.data();

      } else {
        return null;
      }
    }

    //Give discount value
    void applyDiscount(String discountAmount){
      subAmount = int.parse(discountAmount).truncate();

    }

    //validate coupon and offer discount value
    void applyCoupon(String couponCode, String userId) async {
      final couponData = await getCouponFromDatabase(couponCode);

      if (couponData != null) {
        final expirationDate = couponData['expirationDate'].toDate();
        final usersApplied = List<String>.from(couponData['usersApplied'] ?? []);
        final usageLimit = couponData['usageLimit'];

        if (DateTime.now().isAfter(expirationDate)) {
          Fluttertoast.showToast(msg: 'Coupon has expired.');
        }

        else if (usersApplied.length >= usageLimit) {
          Fluttertoast.showToast(msg: 'Coupon Limit reached, Please check again Tomorrow');
        }
        else if (usersApplied.contains(userId)) {
          Fluttertoast.showToast(msg: 'You have already used this coupon.');
        } else {
          // Apply the discount
          final discountAmount = couponData['amount'];
          if (double.parse(discountAmount) * 2 > double.parse(Amount.text)){
            Fluttertoast.showToast(msg: 'Amount too small for discount');
          }
          else{

            applyDiscount(discountAmount);
            // Update the coupon document to mark it as used by this user
            await FirebaseFirestore.instance
                .collection('Coupon')
                .doc(couponCode)
                .update({
              'usersApplied': FieldValue.arrayUnion([userId]),
            });

            Fluttertoast.showToast(msg: 'Coupon applied successfully.');
          }



        }
      } else {
        Fluttertoast.showToast(msg: 'Invalid coupon code.');
      }
    }
    TextEditingController _discounCode = TextEditingController();

    showModalBottomSheet(
        backgroundColor: Colors.transparent,

        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter myupdate) {
              return SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: kbackgroundColorLightMode),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 7*MediaQuery.of(context).size.height/768,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                          ),
                        ),

                        ///mini button for making modal look more slidable..lol
                         SizedBox(
                          height: 8*MediaQuery.of(context).size.height/768,
                        ),
                        Flexible(
                          child: ListView(
                            children: [

                              /// power provider section below///
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: fillUpFormsColors,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [

                                        Disco(callstate: callstate),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),

                              /// Meter type///
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: fillUpFormsColors,
                                    ),
                                    child: Row(

                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        DiscoType(callstate: callstate),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),

                              /// Input Meter Number TextForm-field below///
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0,right: 16),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: inputmeternum,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(16),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:  BorderSide(
                                                color: fillUpFormsColors)),
                                        suffixIcon:  Icon(Icons.speed,color: Colors.grey.shade700,),
                                        fillColor: fillUpFormsColors,
                                        filled: true,
                                        labelText: "Meter Number",
                                        labelStyle: TextStyle(color: Colors.grey.shade700),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                const BorderSide(width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    style:  TextStyle(
                                        fontWeight: FontWeight.bold,color: ktextColor),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Text(
                                  verifiedMeterName != null
                                      ? verifiedMeterName.toString().toUpperCase()
                                      : '',
                                  style: GoogleFonts.kadwa(
                                      fontSize: 13,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),

                              //Amount
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0,right: 16),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      _additionFunction(String);
                                      myupdate(() {});
                                    },

                                    keyboardType: TextInputType.number,
                                    controller: Amount,
                                    decoration: InputDecoration(

                                        contentPadding: const EdgeInsets.all(16),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:  BorderSide(
                                                color: popUpFormColors)),
                                        suffixIcon:  SizedBox(
                                            width: 20,
                                            child: Center(
                                                child: Text(
                                                    'NGN',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w900
                                                  ),
                                                ))),
                                        fillColor: fillUpFormsColors,
                                        filled: true,
                                        labelText: "Amount",
                                        labelStyle: TextStyle(color: Colors.grey.shade700),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                const BorderSide(width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    style:  TextStyle(
                                        fontWeight: FontWeight.bold,color: ktextColor),
                                  ),
                                ),
                              ),

                              //Apply coupon discount here
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16,right: 8,top: 24),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: TextFormField(

                                          onChanged: (value) {

                                          },
                                          keyboardType: TextInputType.text,
                                          controller: _discounCode,
                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(8),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide:  BorderSide(
                                                      color: popUpFormColors)),
                                              prefixIcon:  Icon(Icons.discount,color: Colors.grey.shade700,),
                                              fillColor: fillUpFormsColors,
                                              filled: true,
                                              labelText: "Have a discount code?",
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(width: 0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(10))),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,color: ktextColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0,top: 24),
                                      child: GestureDetector(
                                        onTap: (){
                                          applyCoupon(_discounCode.text, userEmail.toString());
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                32,
                                              ),
                                              color: Colors.green.shade900
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Apply',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),

                              //Proceed button
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    holdAmountTemporaryToCheckMinimumAmount =
                                        double.parse(Amount.text.isNotEmpty
                                            ? Amount.text
                                            : "0.0");
                                    print(
                                        holdAmountTemporaryToCheckMinimumAmount);

                                    if (newPowerProviderValue == null) {
                                      Fluttertoast.showToast(
                                          msg: 'please Select Disco, Example: BEDC');
                                    }
                                    else if (newPowerProviderType == null) {
                                      Fluttertoast.showToast( msg: 'please Select Meter type');
                                    }
                                    else if (inputmeternum.text.isEmpty) {
                                      {
                                        Fluttertoast.showToast(
                                             msg: 'please Enter Your Meter Number');
                                      }
                                    }
                                    else if (Amount.text.isEmpty) {
                                      {
                                        Fluttertoast.showToast( msg: 'Please Enter Amount');
                                      }
                                    }
                                    else if (holdAmountTemporaryToCheckMinimumAmount < 1000) {
                                      Fluttertoast.showToast( msg: 'Please Enter Amount Above ₦1,000');
                                    }
                                    else {
                                      myupdate(() {
                                        isLoading = true;
                                        FocusScope.of(context).unfocus();
                                      });

                                      await verifyMeterNumber();
                                      Future.delayed(const Duration(seconds: 1)).then((value) => myupdate((){isLoading = false;}));


                                    }
                                  },

                                  ///Logic to counter Empty selection///
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.amber),
                                    child: Center(
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              'Proceed',
                                              style: GoogleFonts.kadwa(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )

                        /// i had to wrap listview in Flexible widget to prevent it from taking too much space than required
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  void inputAmountFormWhenUserClickOnSavedMeter() {
    //Fetch coupon from database
    Future<Map<String, dynamic>?> getCouponFromDatabase(String Powerpay1k) async {
      final couponDoc = await FirebaseFirestore.instance
          .collection('Coupon')
          .doc(Powerpay1k)
          .get();

      if (couponDoc.exists) {
        print(couponDoc.data());
        return couponDoc.data();

      } else {
        return null;
      }
    }

    //Give discount value
    void applyDiscount(String discountAmount){
      subAmount = int.parse(discountAmount).truncate();
      print(subAmount);

    }

    //validate coupon and offer discount value
    void applyCoupon(String couponCode, String userId) async {
      final couponData = await getCouponFromDatabase(couponCode);

      if (couponData != null) {
        final expirationDate = couponData['expirationDate'].toDate();
        final usersApplied = List<String>.from(couponData['usersApplied'] ?? []);
        final usageLimit = couponData['usageLimit'];

        if (DateTime.now().isAfter(expirationDate)) {
          Fluttertoast.showToast(msg: 'Coupon has expired.');
        }

        else if (usersApplied.length >= usageLimit) {
          Fluttertoast.showToast(msg: 'Coupon Limit reached, Please check again Tomorrow');
        }
        else if (usersApplied.contains(userId)) {
          Fluttertoast.showToast(msg: 'You have already used this coupon.');
        } else {
          // Apply the discount
          final discountAmount = couponData['amount'];
          if (double.parse(discountAmount) * 2 > double.parse(Amount.text)){
            Fluttertoast.showToast(msg: 'Amount too small for discount');
          }
          else{

            applyDiscount(discountAmount);
            // Update the coupon document to mark it as used by this user
            await FirebaseFirestore.instance
                .collection('Coupon')
                .doc(couponCode)
                .update({
              'usersApplied': FieldValue.arrayUnion([userId]),
            });

            Fluttertoast.showToast(msg: 'Coupon applied successfully.');
          }



        }
      } else {
        Fluttertoast.showToast(msg: 'Invalid coupon code.');
      }
    }
    TextEditingController _discounCode = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left:8,right: 8),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter myupdate) {
              return SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: kbackgroundColorLightMode),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 7,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                          ),
                        ),

                        ///mini button for making modal look more slidable..lol
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 2, 0, 0),
                                child: Text(
                                  verifiedMeterName.toString().toUpperCase(),
                                  style: GoogleFonts.kadwa(
                                      fontSize: 17,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),

                              ///Amount
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      _additionFunction2(String);
                                      myupdate(() {});
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: Amount,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(16),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:  BorderSide(
                                                color: fillUpFormsColors)),
                                        suffixIcon:  Icon(Icons.numbers,color: ktextColor,),
                                        fillColor: fillUpFormsColors,
                                        filled: true,
                                        labelText: "Amount",
                                        labelStyle: TextStyle(color: Colors.grey.shade700),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                const BorderSide(width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,color: ktextColor),
                                  ),
                                ),
                              ),

                              //Apply coupon discount here
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: TextFormField(
                                          controller: _discounCode,
                                          onChanged: (value) {

                                          },
                                          keyboardType: TextInputType.text,

                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(8),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide:  BorderSide(
                                                      color: fillUpFormsColors)),
                                              prefixIcon:  Icon(Icons.discount,color: Colors.grey.shade700,),
                                              fillColor: fillUpFormsColors,
                                              filled: true,
                                              labelText: "Have a discount code?",
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(width: 0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(10))),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,color: ktextColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          applyCoupon(_discounCode.text, userEmail.toString());
                                        },
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            color: Colors.green.shade700
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Apply',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),

                              ///Proceed Button
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    holdAmountTemporaryToCheckMinimumAmount =
                                        double.parse(Amount.text.isNotEmpty
                                            ? Amount.text
                                            : "0.0");
                                    print(
                                        holdAmountTemporaryToCheckMinimumAmount);
                                    if (holdAmountTemporaryToCheckMinimumAmount <
                                        1000) {
                                      {
                                        Fluttertoast.showToast(
                                             msg: 'Please Enter Amount Above ₦1,000');
                                      }
                                    } else {
                                      myupdate(() {
                                        isLoading = true;

                                        FocusScope.of(context).unfocus();
                                      });

                                      await verifyMeterNumberOnSelectMeter();
                                      Future.delayed(const Duration(seconds: 1)).then((value) => myupdate((){isLoading = false;}));
                                    }

                                  },

                                  ///Logic to counter Empty selection///
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.amber),
                                    child: Center(
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              'Proceed',
                                              style: GoogleFonts.kadwa(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )

                        /// i had to wrap listview in Flexible widget to prevent it from taking too much space than required
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: kbackgroundColorLightMode,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: kbackgroundColorLightMode,
            elevation: 7,
            shadowColor: Colors.black,
            iconTheme:  IconThemeData(color: ktextColor,size: 25*MediaQuery.of(context).size.height/768),
            title:  Text('BUY ELECTRICITY',style: GoogleFonts.kadwa(color: ktextColor,
                fontSize: 15*MediaQuery.of(context).size.height/768,
                fontWeight: FontWeight.w900)),


          ),
          body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

               SizedBox(
                height: 20*MediaQuery.of(context).size.height/768,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    showAddMeterForm();
                  },
                  child: Container(
                    height: 80*MediaQuery.of(context).size.height/768,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.add_circle,
                            color: Colors.green.shade900,
                            size: 25*MediaQuery.of(context).size.height/768,
                          ),

                          Expanded(
                            child: Text(
                              '   ADD NEW METER NUMBER',
                              style: GoogleFonts.kadwa(
                                  fontWeight: FontWeight.w700,
                                  color: ktextColor,
                                  fontSize: 11*MediaQuery.of(context).size.height/768),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
                    Text(
                      '   Saved Meter Number   ',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.w700,
                          color: ktextColor,
                          fontSize: 12*MediaQuery.of(context).size.height/768),
                    ),
                    const Expanded(
                        child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
                  ],
                ),
              ), //Divider-Recent Activities_
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height/1.6,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.1)),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: subcollectionRef.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          print(
                              'Connection state: ${snapshot.connectionState}');
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            );
                          }
                          List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          documents.sort((a, b) =>
                              b['timestamp'].compareTo(a['timestamp']));
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Build the list item widget
                              DocumentSnapshot document = documents[index];
                              String title = document.get('Meter number');
                              String description = document.get('meterName');
                              String type = document.get('type');
                              String discoType = document.get('Disco');

                              return ListTile(
                                title: Text(
                                  title,
                                  style: GoogleFonts.kadwa(
                                      fontSize: 13*MediaQuery.of(context).size.height/768,
                                      fontWeight: FontWeight.w900,color: ktextColor.withOpacity(0.9)),
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(child: Text(description,style: TextStyle(color: ktextColor.withOpacity(0.5)),)),
                                    const Spacer(),
                                    Expanded(child: Text(discoType,style: TextStyle(color: ktextColor.withOpacity(0.4)),)),
                                  ],
                                ),
                                trailing: Text(
                                  '- $type',
                                  style: GoogleFonts.kadwa(
                                      fontSize: 12*MediaQuery.of(context).size.height/768,
                                      fontWeight: FontWeight.w200,color: ktextColor.withOpacity(0.7)),
                                ),
                                onTap: () {
                                  // Handle the item tap event
                                  print(discoType);
                                  titleMeter = title;
                                  descriptionMeter = description;
                                  typeMeter = type;
                                  /// Logic to move existing BEDC users to the new app version.
                                  if (discoType == 'BEDC'){discoType = 'benin-electric';
                                    serviceProvider = discoType;}
                                  else{serviceProvider = discoType;}
                                  ///assign values to new variables in order summary page
                                  newMeterNum = titleMeter;
                                  newtype = typeMeter;

                                  provider = serviceProvider;
                                  verifiedMeterName = descriptionMeter;
                                  inputAmountFormWhenUserClickOnSavedMeter();
                                  print({
                                    newMeterNum,
                                    verifiedMeterName,
                                    newtype,
                                    provider
                                  });
                                },
                              );
                            },
                          );
                        },
                      ))),
            ],
          )
        ],
      )),
    );
  }
}

/// state selection drop down values///
class DropdownButtonExample extends StatefulWidget {
  final Function callstate;
  const DropdownButtonExample({super.key, required this.callstate});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}
class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = States.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width/1.1,
      child: DropdownButton<String>(

        alignment: Alignment.centerLeft,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        isExpanded: true,
        padding: const EdgeInsets.only(left:8, right: 16),
        elevation: 20,
        iconSize: 20,
        dropdownColor: kbackgroundColorLightMode,
        underline: Container(height: 0, width: 0, color: Colors.white),
        hint: Text(
          newvalues ?? 'State',
          style: GoogleFonts.kadwa(
              fontSize: 15, fontWeight: FontWeight.w600, color: ktextColor),
        ),
        style:  TextStyle(color: ktextColor),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          newvalues = value;

          widget.callstate();
          print(value);
          setState(() {
            dropdownValue = value!;
          });
        },
        items: States.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Wrap(
              children: [
                Text(value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
} //State Drop down///

/// power provider drop down below...///
class Disco extends StatefulWidget {
  final Function callstate;
  const Disco({super.key, required this.callstate});

  @override
  State<Disco> createState() => _DiscoState();
}
class _DiscoState extends State<Disco> {
  String dropdownValue = powerProvider.first;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        height: 50,
        child: DropdownButton<String>(

           isExpanded: true,
          iconSize: 20,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          underline: Container(height: 0, width: 0, color: Colors.white),
          hint: Text(
            newPowerProviderValue ?? 'Distribution Company (Disco)',
            style: GoogleFonts.kadwa(
                fontSize: 15, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
          ),
          dropdownColor: kbackgroundColorLightMode,
          style:  TextStyle(color: ktextColor),
          padding: const EdgeInsets.only(left:16, right: 16),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            newPowerProviderValue = value;
            widget.callstate();
            print(value);
            switchDisco();

            setState(() {
              dropdownValue = value!;
            });
          },
          items: powerProvider.asMap().entries.map<DropdownMenuItem<String>>(
                  (entry) {
                    int index = entry.key;
                    String value = entry.value;

            return DropdownMenuItem<String>(
              value: value,
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$value - ${powerDescriptions[index]}'),
                      Image.asset(
                        optionImages[index],
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Meter Type drop down below///
class DiscoType extends StatefulWidget {
  final Function callstate;
  const DiscoType({super.key, required this.callstate});

  @override
  State<DiscoType> createState() => _DiscoTypeState();
}
class _DiscoTypeState extends State<DiscoType> {
  String dropdownValue = powerProvider.first;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        height: 50,

        child: DropdownButton<String>(
          alignment: Alignment.center,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          isExpanded: true,

          iconSize: 20,
          padding: const EdgeInsets.only(left:16, right: 16),
          underline: Container(height: 0, width: 0, color: ktextColor),
          hint: Text(
            newPowerProviderType ?? 'Meter Type',
            style: GoogleFonts.kadwa(
                fontSize: 15, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
          ),
          dropdownColor: kbackgroundColorLightMode,
          style:  TextStyle(color:ktextColor),
          onChanged: (String? value) {

            // This is called when the user selects an item.
            newPowerProviderType = value;

            widget.callstate();
            print(value);
            setState(() {
              dropdownValue = value!;
            });
          },
          items: powerProviderType.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Wrap(
                children: [
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
///End


///validate Minimum amount Class
class MinimumInputFormatter extends TextInputFormatter {
  final int minValue;

  MinimumInputFormatter(this.minValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final intValue = int.tryParse(newValue.text);

    if (intValue != null && intValue < minValue) {
      // Return the old value if the input is less than the minimum value
      return oldValue;
    }

    return newValue;
  }
}
///END