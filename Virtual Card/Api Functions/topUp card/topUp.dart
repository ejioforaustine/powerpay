import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/createVirtualCustomer.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../../Kvirtual constant.dart';

//Top up card
Future<void> topUpCard(BuildContext context,
    String headerMessage,
    Function () callState,
    String bodyMessage) async {
  var headers = {
    'Content-Type': 'application/json',
  };

  var requestBody = json.encode({
    'equivalentAmount': totalFundAmount,
    'amount': topAmount.text,
    'userEmail': userEmail, // Make sure to include user email
  });

  // Make the request to your Firebase function
  var response = await http.patch(
    Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/topUpCard/${cardData[cardIndex]['card_id']}'),
    headers: headers,
    body: requestBody,
  );

  if (response.statusCode == 200) {
    print('Top-up successful: ${response.body}');
    if(context.mounted){
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
                      Text(headerMessage,style: GoogleFonts.inter(
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
                        child: Text(bodyMessage,
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
    }
    callState();
  } else {
    print('Failed to top up card: ${response.body}');
  }
}

