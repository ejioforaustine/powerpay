

import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/PIN.dart';


import '../../../Core/Functions/constantvaribles.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../Kvirtual constant.dart';
import 'enter_pin.dart';

TextEditingController answerController = TextEditingController();
Future resetPin(BuildContext context, ) {


  Future<void> verifyAnswers(Function () callState, BuildContext context) async {

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    // Retrieve hashed answers from Firestore
    String correctAnswer1 = userDoc['security_answer_1'];


    // Hash the entered answers
    String enteredAnswer1 =
    sha256.convert(utf8.encode(answerController.text)).toString();


    // Check if the answers match
    if (enteredAnswer1 == correctAnswer1) {
      // Redirect to PIN reset page
      if(context.mounted){
        Navigator.pop(context);
        setPin(context);
      }

    } else {

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
                        Text('Oops..!',style: GoogleFonts.inter(
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
                          child: Text("Security Answer does not match",
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


    }
  }


  return showModalBottomSheet(
      context: context,
      backgroundColor: kbackgroundColorLightMode,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        bool pop = false;
        Future<bool> shouldPop() async {
          pop = false;
          return pop;
        }
        return WillPopScope(
          onWillPop: () async {
            return shouldPop();},
          child: StatefulBuilder(


            builder: (BuildContext context, StateSetter setState) {
              void callState(){
                setState((){});
              }
              double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
              return Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/2.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //heading Text
                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24,),
                        child: Row(
                          children: [
                            Text('Enter Security Answer',style: GoogleFonts.inter(
                                color: kbottomNavigationIconcolor,
                                fontSize: 16/textScaleFactor,
                                fontWeight: FontWeight.w900
                            ),),

                          ],),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 24,right: 24),
                        child: Row(
                          children: [
                            Text('"${question1 ?? ''}"',style: GoogleFonts.inter(color: ktextColor,fontSize: 12/textScaleFactor),),
                            const Spacer(),

                          ],),
                      ),

                      //Amount to withdraw
                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                        child: TextFormField(
                          controller: answerController,
                          onChanged: (value){
                            setState((){});

                          },
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),

                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:  const BorderSide(color: Colors.grey, width: 0.25),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(16)),
                            fillColor: kbackgroundColorLightMode,
                            suffixIcon: Icon(
                              Icons.abc_sharp,
                              color: ktextColor.withOpacity(0.5),
                            ),
                            labelText: 'Answer',
                            labelStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.normal, color: ktextColor),
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 24,right: 24),
                        child: Row(
                          children: [
                            Text('Remember your answer are case sensitive!',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),
                            const Spacer(),
                            Text('',style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 10/textScaleFactor,
                                fontWeight: FontWeight.w300
                            ),),
                          ],),
                      ),


                      const Spacer(),
                      ///close
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () async {

                            await verifyAnswers(callState,context);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.amber.shade500,
                            ),

                            child: Center(
                              child: kPin ==false ?
                              const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(color: Colors.black,),
                              ) :
                              Text('Confirm',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),) ,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            },

          ),
        );
      });
}