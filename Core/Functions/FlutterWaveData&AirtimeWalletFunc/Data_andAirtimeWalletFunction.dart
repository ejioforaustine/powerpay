import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:powerpay/UIsrc/DataUi/models/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../../UIsrc/Airtime/Models/constants.dart';
import '../../../UIsrc/contact/Contact us.dart';
import '../../../UIsrc/home/Home.dart';
import '../../../Virtual Card/Kvirtual constant.dart';
import '../../../Wallet/walletFunctions.dart';
import '../Api-calls.dart';
import '../constantvaribles.dart';
import '../keys.dart';


//variables for the functions below
var  walletStatusData;
dynamic  dataTransferID;

///Make payment with available wallet balance
Future<void> payDataAndAirtimeWallet(BuildContext context,
    Function() setModalState, int amount, Future Function() performThis,
    void Function() getState) async {
  final url = Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/payDataAndAirtimeWallet'); // Replace with your function URL
  print('we are at data...trying');
  try {
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount.toString(),
        'userEmail': userEmail,
        'usersName': usersName,
        'selectedBundlePackageName': selectedBundlePackageName,
        'walletAccountID': walletAccountID,
      }),
    );
    print('Passed to here');
    if (response.statusCode == 200) {
      print('Passed to here...2');
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        print('Passed to here...3');
        // Payment successful
        dataTransferID = responseBody['transferId'];
        print('we are at data... $dataTransferID');

        await keepVerifyingDataPaymentWallet(context,amount,performThis,getState);
        print('Passed to here...4');
        processingDataBool = true;
        // ... (handle success, e.g., call keepVerifyingDataPaymentWallet if needed) ...processingDataBool = true;
        setModalState();
      } else {
        // Handle error
        print('Payment failed: ${responseBody['message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<dynamic> verifyWalletPayment(BuildContext context,
    dynamic transferID,
    int amount,
    Future Function() performThis,
    void Function() getState) async {
  final url = Uri.parse(
      'https://us-central1-polectro-60b65.cloudfunctions.net/verifyWalletPayment?transferID=$dataTransferID'); // Replace with your function URL

  try {final response = await http.get(url);
  final responseBody = jsonDecode(response.body);
  walletStatusData = responseBody['status'];
    if (response.statusCode == 200) {
      print('success...1');

      if (walletStatusData == 'SUCCESSFUL') {
        // Payment successful
        print('we are performing magic for you,$walletStatusData');

        await performThis();


      } else if (walletStatusData == 'FAILED') {
        // Handle payment failure
        isPayWithWalletClicked = false;
        isAirtimePaid = false;
        processingDataBool = true;
        getState;
        if (context.mounted) {
          AnimatedSnackBar(
            builder: ((context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                height: 50,
                child: Center(
                  child: Text(
                    responseBody['message'],
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
              );
            }),
          ).show(context);
        }
        walletStatusData = '';
        dataTransferID = '';
        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        // Handle other statuses (e.g., pending)
        print(responseBody['status']);
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("$e...error host here");
    }
  }
}


//Keep checking until a result is gotten
Future<dynamic> keepVerifyingDataPaymentWallet (BuildContext context, int amount,Future Function() performThis,void Function() getState) async {
  await verifyWalletPayment(context, dataTransferID,amount,performThis,getState,);

  while (walletStatusData != 'SUCCESSFUL' && walletStatusData != 'FAILED') {
    print('trying .....');
    // Wait for a specified duration before checking again
    await Future.delayed(const Duration(seconds: 5));
    await verifyWalletPayment(context, dataTransferID,amount,performThis,getState,);
  }

  if (walletStatusData == 'FAILED') {
    if(context.mounted) {
      return {
        Navigator.of(context).pop(),
      PopUpFunction(
        secretKey: SecretKey,
        context: context,
        Apikey: ApiKey,
      ).failedPopup4Debitwallet(),
      walletStatusData = '',
      dataTransferID ='',
      };

    }

  } else if (walletStatusData == 'SUCCESSFUL') {
    walletStatusData = '';
    dataTransferID ='';
  } else {
    if (kDebugMode) {
      print('Verified ..hahaha');
    }
  }

}

///Feedback Popup's
void dataSuccessPopUp(BuildContext context) {
  showModalBottomSheet(
    isDismissible: false,

      backgroundColor: kbackgroundColorLightMode,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isScrollControlled: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter myupdate) {
              return IntrinsicHeight(
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: kbackgroundColorLightMode),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 120,
                                width: 120,
                                child: Lottie.asset(
                                    'assets/images/success3.json',repeat: true)

                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'Successful',
                            style: GoogleFonts.kadwa(
                                color: Colors.green.shade900,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: Card(
                          color: kbackgroundColorLightMode,
                          child: ListTile(
                            title: SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: Text(selectedBundlePackageName,
                                style: GoogleFonts.lato(color: ktextColor,fontWeight: FontWeight.normal,fontSize: 12),),
                            ),
                            trailing: Text('N $formattedAmountValue',
                              style: GoogleFonts.lato(color: ktextColor,fontWeight: FontWeight.normal,fontSize: 12),),
                          ),

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0,top: 16,bottom: 8,left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){Navigator.pop(context);},
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width/1.5,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.amber.shade800),child: Center(child:
                                Text('Recharge again!',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w800),)
                                ,),),
                            ),
                          ),
                            const SizedBox(width: 5,),

                            Expanded(
                              child: GestureDetector(
                                onTap: (){Navigator.popUntil(context, ModalRoute.withName('/'));},
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width/1.5,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.green),child: Center(child:
                                Text('Done',style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w800),)
                                  ,),),
                              ),
                            )

                        ],),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
      });
}

///Feedback Popup's
void successPopUp(BuildContext context) {
  showModalBottomSheet(
      isDismissible: false,

      backgroundColor: kbackgroundColorLightMode,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isScrollControlled: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter myupdate) {
              return IntrinsicHeight(
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: kbackgroundColorLightMode),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 120,
                                width: 120,
                                child: Lottie.asset(
                                    'assets/images/success3.json',repeat: true)

                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'Withdrawal Success(Pending Approval)',
                            style: GoogleFonts.kadwa(
                                color: Colors.green.shade900,
                                fontSize: 10/textScaleFactor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),



                      Padding(
                        padding: const EdgeInsets.only(right: 20.0,top: 16,bottom: 8,left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: GestureDetector(
                                onTap: (){Navigator.popUntil(context, ModalRoute.withName('/'));},
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width/1.5,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.green),child: Center(child:
                                Text('Done',style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w800),)
                                  ,),),
                              ),
                            )

                          ],),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
      });
}

// failed transaction form
void failedDataOrAirtimeTransactionPopUp(BuildContext context) {
  Future<bool> shouldPop() async {
    bool Pop = false;
    return Pop;
  }

  showModalBottomSheet(
      backgroundColor: kbackgroundColorLightMode,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            return shouldPop();
          },
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter myupdate) {
                return IntrinsicHeight(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: kbackgroundColorLightMode),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 10
                        ),
                        SizedBox(
                            height: 150 *
                                MediaQuery.of(context).size.height /
                                MediaQuery.of(context).size.height,
                            width: 150 *
                                MediaQuery.of(context).size.width /
                                MediaQuery.of(context).size.width,
                            child: Lottie.asset(
                                'assets/images/87614-failed-task.json')),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.cancel_presentation_outlined,color: Colors.red,),
                              title:SizedBox(
                                width: 20,
                                child: Text(
                                  'Oops, something went wrong, Please contact support to resolve this for you.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                  color: ktextColor,
                                  fontSize: 10 *
                                      MediaQuery.of(context).size.height /
                                      MediaQuery.of(context).size.height,
                                  fontWeight: FontWeight.normal),
                                                      ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ContactUs()));
                                },
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Contact Support?',
                                        style: GoogleFonts.aBeeZee(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 12 *
                                                MediaQuery.of(context).size.height /
                                                MediaQuery.of(context).size.height),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ),),
                        ),
                        const SizedBox(
                          height: 10
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      });
}

