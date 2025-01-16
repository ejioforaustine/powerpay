import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:powerpay/Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import 'package:powerpay/Core/Functions/ServiceHostData&AirtimeFunction/DataFunction.dart';
import 'package:powerpay/UIsrc/DataUi/models/constant.dart';
import '../../../Core/Functions/constantvaribles.dart';
import '../../../Core/Functions/keys.dart';
import '../../../KYC/BVN.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../../Wallet/walletFace.dart';
import '../../Airtime/Models/Models.dart';
import '../../Airtime/Models/constants.dart';

///Data purchase form
class DataForms extends StatefulWidget {
  const DataForms({super.key});

  @override
  State<DataForms> createState() => _DataFormsState();
}

class _DataFormsState extends State<DataForms> {
  void updateBundle() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      body: const Column(
        children: [

          SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }
}

List<String> dataBundles = [];
List<String> dataPrice = [];
List<String> dataVariationCode = [];

///Get Bundles for each Network functions
class DataSubscription {
  ///Function that retrieves Network data bundle json data from host and stores in a list

  static Future<dynamic> getDataBundles(BuildContext context) async {
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'api-key': ApiKey,
        'secret-key': "",
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://api-service.vtpass.com/api/service-variations?serviceID=$dataServiceID'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var firstSort = jsonDecode(data)['content']['variations'];
        List<dynamic> dataVariation = firstSort;

        for (int i = 0; i < dataVariation.length; i++) {
          var bundlesName =
              jsonDecode(data)['content']['variations'][i]['name'];
          var bundlesPrice =
              jsonDecode(data)['content']['variations'][i]['variation_amount'];
          var bundleVariationCode =
              jsonDecode(data)['content']['variations'][i]['variation_code'];
          print(bundlesPrice);
          print(bundleVariationCode);

          dataBundles.add(bundlesName.toString());
          dataPrice.add(bundlesPrice.toString());
          dataVariationCode.add(bundleVariationCode.toString());
          isDataBundleLoaded = true;


        }

      } else {
        Fluttertoast.showToast(msg: 'Check your Internet');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             backgroundColor: Colors.red.shade800,
             content: const Center(child: Text('Something went wwrong, please again later'))),
      );
    }
  }
}

class DataOrderSummary {
  static void showOrderSummary(BuildContext context, Function callState) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (BuildContext context) {
          var screenH = MediaQuery.of(context).size.height;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateSetter) {
              void callthisState(){
                setStateSetter((){});
              }
              void handleDataPayButton() async {
                print('we got here');

                await initializeRemoteConfig();
                final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

                bool limitLogicEnabled = remoteConfig.getBool('limitLogicEnabled');

                if (!isPayDataButtonClicked) {
                  isPayDataButtonClicked = true;


                  // Get the current user ID (replace this with your own method)
                  String userId = userEmail
                      .toString(); // Replace with your actual user ID

                  // Get the timestamp from Firestore
                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get();

                  DateTime lastActionTime;

                  // Cast data to Map<String, dynamic> to use containsKey
                  Map<String, dynamic>? userData = userDoc.data() as Map<
                      String,
                      dynamic>?;

                  // Check if the 'lastActionTime' field exists
                  if (userData != null && userData.containsKey('lastActionTime')) {
                    lastActionTime =
                        (userData['lastActionTime'] as Timestamp).toDate();
                  }
                  else {
                    // Initialize the timestamp if it doesn't exist
                    lastActionTime =
                        DateTime.now().subtract(Duration(hours: 7));

                    // Create the 'lastActionTime' field in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(
                        userId).set({
                      'lastActionTime': DateTime.now(),
                    }, SetOptions(merge: true));
                  }

                  // Check if 20 hours have passed
                  if (!limitLogicEnabled || DateTime.now()
                      .difference(lastActionTime)
                      .inHours >= 6) {
                    if (kYCStatus == false && limitLogicEnabled == true && selectedBundlePackageAmount.toInt() > 10000 ){
                      isPayDataButtonClicked = false;
                      processingDataBool = true;
                      setStateSetter(() {});
                      if(context.mounted){AnimatedSnackBar(
                        builder: ((context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red,),

                            height: 50,
                            child: Center(child: Text(
                              "You can't buy this amount with your account Level",
                              style: GoogleFonts.inter(color: Colors.white),)),
                          );
                        }),
                      ).show(context);}


                    }
                    else {
                      if (walletBalance >= selectedBundlePackageAmount.toInt()) {
                        await payDataAndAirtimeWallet(
                            context, () => setStateSetter(() {}),
                            selectedBundlePackageAmount.toInt(), () =>
                            purchaseData(context), callthisState
                        ).then((value) =>
                        {
                          isPayDataButtonClicked = false,

                        });
                      }
                      else {
                        isPayDataButtonClicked = false;
                        processingDataBool = true;
                        setStateSetter(() {});
                        if(context.mounted){AnimatedSnackBar(
                          builder: ((context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,),

                              height: 50,
                              child: Center(child: Text(
                                'Insufficient funds - please add money in wallet',
                                style: GoogleFonts.inter(color: Colors.white),)),
                            );
                          }),
                        ).show(context);}
                      }
                    }

                  }else {
                    // Suggest KYC if the time hasn't passed
                    if (kYCStatus == false && submittedStatus == false)
                    {
                      setStateSetter(() {});
                      if(context.mounted){Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context)=>
                          const BVNandNINDetails()
                      )
                      );}

                    }
                    else if (kYCStatus == false && submittedStatus == true) {
                      if(context.mounted){
                        AnimatedSnackBar(builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Container(
                            height: 80,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Awaiting KYC approval',style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),)
                              ],
                            ),
                          ),
                        );

                      }).show(context);}

                      setStateSetter(() {});

                    }
                    else if(kYCStatus == true && submittedStatus == true){

                      if (walletBalance >= selectedBundlePackageAmount.toInt()) {
                        await payDataAndAirtimeWallet(
                            context, () => setStateSetter(() {}),
                            selectedBundlePackageAmount.toInt(), () =>
                            purchaseData(context), callthisState
                        ).then((value) =>
                        {
                          isPayDataButtonClicked = false,

                        });
                      } else {
                        isPayDataButtonClicked = false;
                        processingDataBool = true;
                        setStateSetter(() {});
                        AnimatedSnackBar(
                          builder: ((context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,),

                              height: 50,
                              child: Center(child: Text(
                                'Insufficient funds - please add money in wallet',
                                style: GoogleFonts.inter(color: Colors.white),)),
                            );
                          }),
                        ).show(context);
                      }


                    }

                    isPayDataButtonClicked = false;
                    setStateSetter(() {});
                  }
                }

              } //button to avoid duplicated transaction.
              return IntrinsicHeight(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kbackgroundColorLightMode),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    IntrinsicHeight(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kbackgroundColorLightMode,
                            border: Border.all(color: ktextColor, width: 0.2)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kairtimeAmountContainerColor
                                      .withOpacity(0.2)),
                              child: Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        networkProviderImages[networkImageNumber]
                                            .toString()),
                                  ).animate().slideY(
                                      curve: Curves.decelerate,
                                      duration: 1.seconds)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              selectedBundlePackageName,
                              style: GoogleFonts.lato(
                                  color: ktextColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16),
                              child: IntrinsicHeight(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: kbalanceContainerColor),
                                  child: ListTile(
                                    leading: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text('N$formattedAmountValue',style: GoogleFonts.lato(color: Colors.white,fontSize: 13* screenH/768,fontWeight: FontWeight.w600),),
                                            ],
                                          ),
                                        ),

                                        Flexible(
                                          child: Text(
                                            'Wallet balance : N $walletBalance',
                                            style: GoogleFonts.lato(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10* screenH/768),
                                          ),
                                        ),

                                      ],
                                    ),

                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Discount: - N $discountAmountData',
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11 * screenH/768),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            dataPhoneNUmber,
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11 * screenH/768),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///Pay with wallet Button
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: GestureDetector(
                        onTap: () async {

                          processingDataBool = false;
                          setStateSetter((){});

                          handleDataPayButton();


                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber.shade600),
                          child: Center(
                              child: processingDataBool ?Text(
                                'Pay with Wallet',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 14),
                              ): const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(color: Colors.black,))
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ); },

          );
        });
  }
}
//Formatting number in 3 zeros for better readability
String formatDouble(double value) {
  NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
  return numberFormat.format(value);
}

class TopSnackBar extends SnackBar {
  const TopSnackBar({Key? key, required content})
      : super(key: key, content: content, behavior: SnackBarBehavior.floating);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: build(context),
    );
  }
}

