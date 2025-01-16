import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/ServiceHostData&AirtimeFunction/AirtimeFunction.dart';
import 'package:powerpay/KYC/ID%20card.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/UIsrc/Airtime/Models/constants.dart';
import 'package:powerpay/Wallet/walletFace.dart';

import '../../../Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import '../../../Core/Functions/constantvaribles.dart';
import '../../../KYC/BVN.dart';

///Airtime purchase form
class AirtimeForm extends StatefulWidget {
   const AirtimeForm({super.key});
  static TextEditingController textEditingControllerAirtime = TextEditingController();
  static TextEditingController textEditingControllerAirtimePhoneNo = TextEditingController();


  @override
  State<AirtimeForm> createState() => _AirtimeFormState();
}

Future<void> initializeRemoteConfig() async {
  final FirebaseRemoteConfig  remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  await remoteConfig.fetchAndActivate();
}

class _AirtimeFormState extends State<AirtimeForm> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      body: Column(
        children: [
          TextFormField(
            controller: AirtimeForm.textEditingControllerAirtimePhoneNo,
            style: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.45),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              fillColor: kbackgroundColorLightMode,
              prefixIcon: Icon(
                Icons.phone,
                color: ktextColor.withOpacity(0.5),
              ),
              labelText: 'Phone Number',
              labelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.normal, color: ktextColor),
              filled: true,
              border: InputBorder.none,
            ),
          ), // Phone Number
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: AirtimeForm.textEditingControllerAirtime,
            style: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.45),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              fillColor: kbackgroundColorLightMode,
              prefixIcon: Icon(
                Icons.numbers_sharp,
                color: ktextColor.withOpacity(0.5),
              ),
              labelText: 'amount',
              labelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.normal, color: ktextColor),
              filled: true,
              border: InputBorder.none,
            ),
          ), // Airtime Amount
        ],
      ),
    );
  }
}

/// Airtime purchase summary bottom sheet
class AirtimeOrderSummary {
  static void showOrderSummary(BuildContext context,Function callState) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (BuildContext context) {

          return StatefulBuilder(

            builder: (BuildContext context, void Function(void Function()) setState) {

              void updateState (){
                setState(() {
                });
              }

              Future<dynamic> handleAirtimePayButton() async {

                await initializeRemoteConfig();
                final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

                bool limitLogicEnabled = remoteConfig.getBool('limitLogicEnabled');


                if (!isPayWithWalletClicked) {
                  isPayWithWalletClicked = true;

                  // Get the current user ID (replace this with your own method)
                  String userId = userEmail.toString(); // Replace with your actual user ID

                  // Get the timestamp from Firestore
                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get();

                  DateTime lastActionTime;

                  // Cast data to Map<String, dynamic> to use containsKey
                  Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

                  // Check if the 'lastActionTime' field exists
                  if (userData != null && userData.containsKey('lastActionTime')) {
                    lastActionTime = (userData['lastActionTime'] as Timestamp).toDate();
                  }
                  else {
                    // Initialize the timestamp if it doesn't exist
                    lastActionTime = DateTime.now().subtract(const Duration(hours: 7));

                    // Create the 'lastActionTime' field in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userId).set({
                      'lastActionTime': DateTime.now(),
                    }, SetOptions(merge: true));
                  }


                  // Check if 6 hours have passed
                  if (!limitLogicEnabled || DateTime.now().difference(lastActionTime).inHours >= 6) {
                    // Allow the action and update the timestamp
                    if (kYCStatus == false && limitLogicEnabled == true && airtimeAmount.toInt() > 10000 ){
                      isPayWithWalletClicked = false;
                      isAirtimePaid = false;
                      setState(() {});
                      AnimatedSnackBar(
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
                      ).show(context);

                    }
                    else {
                      if (walletBalance >= airtimeAmount) {
                        await payDataAndAirtimeWallet(
                          context,
                              () => setState(() {}),
                          airtimeAmount,
                              () => purchaseAirtime(context, updateState),
                          updateState,
                        ).then((value) => {
                          isPayWithWalletClicked = false,
                          isAirtimePaid = false,
                          setState(() {})
                        });

                        // Update Firestore with the new action timestamp
                        await FirebaseFirestore.instance.collection('users').doc(userId).set({
                          'lastActionTime': DateTime.now(),
                        }, SetOptions(merge: true));
                      }
                      else {
                        isPayWithWalletClicked = false;
                        isAirtimePaid = false;
                        setState(() {});
                        if(context.mounted){AnimatedSnackBar(
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Insufficient funds - please add money in wallet',
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ).show(context);}

                      }
                    }

                  }
                  else {
                    // Suggest KYC if the time hasn't passed
                    if (kYCStatus == false && submittedStatus == false)
                    {
                      if(context.mounted){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context)=>
                            const BVNandNINDetails()
                        )
                        );
                      }

                    }
                    else if (kYCStatus == false && submittedStatus == true) {
                      if(context.mounted){
                        AnimatedSnackBar(builder: (BuildContext context)
                        {
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

                      setState(() {

                      });
                      if (kDebugMode) {
                        print('Awaiting KYC approval');
                      }
                    }
                    else if(kYCStatus == true && submittedStatus == true){

                      if (walletBalance >= airtimeAmount) {
                        await payDataAndAirtimeWallet(
                          context,
                              () => setState(() {}),
                          airtimeAmount,
                              () => purchaseAirtime(context, updateState),
                          updateState,
                        ).then((value) => {
                          isPayWithWalletClicked = false,
                          isAirtimePaid = false,
                          setState(() {})
                        });

                        // Update Firestore with the new action timestamp
                        await FirebaseFirestore.instance.collection('users').doc(userId).set({
                          'lastActionTime': DateTime.now(),
                        }, SetOptions(merge: true));
                      } else {
                        isPayWithWalletClicked = false;
                        isAirtimePaid = false;
                        setState(() {});
                        if(context.mounted){
                          AnimatedSnackBar(
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Insufficient funds - please add money in wallet',
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ).show(context);}

                      }

                    }
                    if (kDebugMode) {
                      print('Complete KYC');
                    }
                    /*showKycSuggestion(context);*/
                    isPayWithWalletClicked = false;
                    setState(() {});
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
                              border: Border.all(color: ktextColor,width: 0.2)),
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
                                    color: kairtimeAmountContainerColor.withOpacity(0.2)),
                                child:  Center(
                                    child: CircleAvatar(backgroundColor: Colors.transparent,
                                      radius: 25,
                                      backgroundImage: AssetImage(networkProviderImages[networkImageNumber].toString()),
                                    ).animate().slideY(curve: Curves.decelerate,duration: 1.seconds)
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'N $airtimeAmount',
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

                                          Flexible(
                                            child: Text(
                                              'Wallet balance : N $walletBalance',
                                              style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        airtimePhoneNumber.toString(),
                                        style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16),
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
                        padding: const EdgeInsets.only(top: 16,bottom: 8),
                        child: GestureDetector(
                          onTap: () async {
                            isAirtimePaid = true;
                            setState((){});
                            await handleAirtimePayButton();
                            isAirtimePaid = false;
                            setState((){});

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.amber.shade600),
                            child: Center(
                              child: isAirtimePaid ? const SizedBox(height: 25,width: 25,
                                child: CircularProgressIndicator(color: Colors.black,)

                                ,) : Text(
                                'Pay with Wallet',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

List<String> networkProviderImages = [
  'assets/images/AirtimeAssets/mtn.png',
  'assets/images/AirtimeAssets/Glo_Limited.png',
  'assets/images/AirtimeAssets/9mobile-Logo.png',
  'assets/images/AirtimeAssets/Airtel.png',
];
