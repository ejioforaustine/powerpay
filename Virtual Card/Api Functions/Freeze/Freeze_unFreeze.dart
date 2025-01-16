import 'dart:convert';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../Core/Functions/Api-calls.dart';
import '../../../Core/Functions/constantvaribles.dart';
import '../../Kvirtual constant.dart';

Future<void> freezeCard(BuildContext context,String cardId, String ref, actionId, Function () callState) async {
  final url = Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/freezeCardAndUnfreeze');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final response = await http.patch(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cardId': cardId,
        'actionId': actionId,
        'ref': miniFunction().getReference()}), // Send cardId and ref
    );
    if(response.statusCode == 200){
      if (actionId == 'freeze'){
        isFrozen = true;
        await firestore
            .collection("users")
            .doc(userEmail)
            .collection("cards")
            .doc(cardData[cardIndex]['card_id'])
            .update({
          "isFrozen": isFrozen,
        });
      } else{
        isFrozen = false;
        await firestore
            .collection("users")
            .doc(userEmail)
            .collection("cards")
            .doc(cardData[cardIndex]['card_id'])
            .update({
          "isFrozen": isFrozen,
        });
      }
      print('Card Frozen/Unfrozen');

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
                      Text('Successful',style: GoogleFonts.inter(
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
      callState();
    }
    else {
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
                      Text('Something went wrong.',style: GoogleFonts.inter(
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

    }
    // ... (rest of the response handling logic) ...

  } catch (e) {
    print('Something went wrong');
    // ... (error handling) ...
  }
}