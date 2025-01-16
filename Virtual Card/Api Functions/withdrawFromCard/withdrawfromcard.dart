import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/VirtualWalletManagement/virtualWalletManagement.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/createVirtualCustomer.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../Core/Functions/constantvaribles.dart';
import '../../Kvirtual constant.dart';

//Withdraw from card to wallet

Future<void> withdraw4rmCard(Function() callState, BuildContext context) async {
  final url = Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/withdraw4rmCard'); // Replace with your function URL

  try {
    print('trying....');
    final response = await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        // Add any other necessary headers, like authorization
      },
      body: jsonEncode({
        'equivalentAmount': totalFundAmount,
        'cardId': cardData[cardIndex]['card_id'],
        'amount': withdrawCardAmount.text,
        'ref': miniFunction().getReference(),
        'userEmail': userEmail,
      }),
    );

    if (response.statusCode == 200) {
      print('client side Okay....');
      AnimatedSnackBar(builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
            width: screenWidth/1.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Withdrawal success',style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12/textScaleFactor,
                          fontWeight: FontWeight.w900),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text('Your Wallet have been credited',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,

                              fontSize: 8/textScaleFactor,
                              fontWeight: FontWeight.w200),),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );

      }).show(context);
      // Success: Call addToWallet and fetchCardData

      await fetchCardData(callState);
      callState();
    } else {
      print('Oops from client side....');
      AnimatedSnackBar(builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
            width: screenWidth/1.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Oops..',style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12/textScaleFactor,
                          fontWeight: FontWeight.w900),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("${response.reasonPhrase}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,

                              fontSize: 8/textScaleFactor,
                              fontWeight: FontWeight.w200),),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );

      }).show(context);
      // Handle error
      print('Request failed with status: ${response.reasonPhrase}.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
