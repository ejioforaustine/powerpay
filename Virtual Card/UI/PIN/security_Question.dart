import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../Kvirtual constant.dart';
import 'enter_pin.dart';

final List<String> questionType = [
  "What's your Mother's Maiden Name",
  'City of Birth',
];
dynamic question;

TextEditingController answerController = TextEditingController();
Future securityQuestion(BuildContext context, ) {
  void addPinSetFieldToExistingUsers() async {
    print("checking");
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    print("checking2");
    if(!userDoc.exists){
      // Cast the document data to a Map<String, dynamic>
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (userData.containsKey('pinSet')) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail!)
            .update({'pinSet': true}); // Add pinSet field to users who don't have it
        print("Migration complete: Added pinSet field to existing users");
      }
    }else{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail!)
          .update({'pinSet': true});
      print("Migration completed....");
    }
    print("checking3");
  }
  Future<void> saveSecurityAnswers() async {

    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'security_question_1': "$question",
      'security_answer_1': sha256.convert(utf8.encode(answerController.text)).toString(),

    });
    addPinSetFieldToExistingUsers();
    print("Security questions saved successfully.");
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
                            Text('Security Question',style: GoogleFonts.inter(
                                color: kbottomNavigationIconcolor,
                                fontSize: 16/textScaleFactor,
                                fontWeight: FontWeight.w900
                            ),),

                          ],),
                      ),

                      //drop down card selection
                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(

                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            // Add more decoration..
                          ),
                          hint:  Text(
                            'Select Question',
                            style: TextStyle(
                                color: ktextColor,
                                fontSize: 12/textScaleFactor),
                          ),
                          items: questionType
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style:  TextStyle(
                                color: ktextColor,
                                fontSize: 12/textScaleFactor,
                              ),
                            ),
                          ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select Question';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                            question = value.toString();
                          },
                          onSaved: (value) {

                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData:  IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: ktextColor,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              color: kbackgroundColorLightMode,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
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
                            Text('Your answer are case sensitive',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),
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

                            await saveSecurityAnswers();
                            if(context.mounted){
                              Navigator.pop(context);
                              enterPin(context,callState);
                            }

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