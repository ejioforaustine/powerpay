import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/enter_pin.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/security_Question.dart';

import '../../Kvirtual constant.dart';



class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

TextEditingController _textEditingController = TextEditingController();



class _TransferState extends State<Transfer> {






  void _addToTextField(String value) {
    setState(() {
      _textEditingController.text += value;
    });
  }
  void _deleteFromTextField() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        _textEditingController.text = _textEditingController.text
            .substring(0, _textEditingController.text.length - 1);
      }
    });
  }
  void _updateFormattedValue(String value) {
    final numberFormat = NumberFormat("#,###");
    final unformattedValue = value.replaceAll(',', '');
    final formattedValue =
    numberFormat.format(int.tryParse(unformattedValue) ?? 0);
    setState(() {
      _textEditingController.text = formattedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Set PIN',
          style: GoogleFonts.inter(
            fontSize: 16/textScaleFactor,
              fontWeight: FontWeight.w700, color: ktextColor),
        ),
        centerTitle: true,

        backgroundColor: kbackgroundColorLightMode,
        iconTheme:  IconThemeData(color: ktextColor),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(100.0, 20, 100, 5),
            child: TextFormField(
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(prefixText: '  '),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              readOnly: true,
              controller: _textEditingController,
              cursorHeight: 30,
              style: GoogleFonts.arimo(
                  fontWeight: FontWeight.w900,
                  color: ktextColor,
                  fontSize: 50),
            ),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('1');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('2');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('3');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '3',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('4');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '4',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('5');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('6');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '6',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('7');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '7',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(

                child: GestureDetector(
                  onTap: (){_addToTextField('8');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '8',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('9');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '9',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('.');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '.',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_addToTextField('0');},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:20,
                  child: VerticalDivider(color: ktextColor,)),
              Expanded(
                child: GestureDetector(
                  onTap: (){_deleteFromTextField();},
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.backspace,color: ktextColor,),

                    ],
                  ),
                ),
              )
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 0.0,bottom: 20),
            child: GestureDetector(
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=> const EnterPin()));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.amber),
                child: Center(child: Text('Proceed',

                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14/textScaleFactor),)),
              ),
            ),
          )



        ],
      ),
    );
  }
}


class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final _numberFormat = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newString = _numberFormat.format(int.tryParse(newValue.text) ?? 0);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}


/// showmodal

Future setPin(BuildContext context, ) {

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
              void callState (){
                setState((){});
              }
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

              String hashPin(String pin) {
                var bytes = utf8.encode(pin);
                var digest = sha256.convert(bytes);
                return digest.toString();
              }

              void savePin(String pin) async {
                // Hash the PIN and store it in Firestore
                String hashedPin = hashPin(pin);
                String userId = FirebaseAuth.instance.currentUser!.uid;
                print('yellowing...');

                await FirebaseFirestore.instance.collection('users').doc(userEmail!).update({
                  'pin_hash': hashedPin,
                });
              }


              void addToTextField(String value) {
                setState(() {
                  _textEditingController.text += value;
                });
              }
              void deleteFromTextField() {
                setState(() {
                  if (_textEditingController.text.isNotEmpty) {
                    _textEditingController.text = _textEditingController.text
                        .substring(0, _textEditingController.text.length - 1);
                  }
                });
              }
              return Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/1.08,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Set PIN',
                            style: GoogleFonts.inter(
                                fontSize: 16/textScaleFactor,
                                fontWeight: FontWeight.w700, color: ktextColor),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(100.0, 40, 100, 5),
                        child: TextFormField(
                          obscureText: true,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(prefixText: '  '),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandsSeparatorInputFormatter(),
                          ],
                          readOnly: true,
                          controller: _textEditingController,
                          cursorHeight: 30,
                          style: GoogleFonts.arimo(
                              fontWeight: FontWeight.w900,
                              color: ktextColor,
                              fontSize: 50),
                        ),
                      ),
                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('1');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('2');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '2',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('3');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('4');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '4',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('5');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '5',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('6');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '6',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('7');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '7',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(

                            child: GestureDetector(
                              onTap: (){addToTextField('8');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '8',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('9');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '9',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('.');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '.',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){addToTextField('0');},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: GoogleFonts.aclonica(color: ktextColor,fontSize: 25/textScaleFactor,fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:20,
                              child: VerticalDivider(color: ktextColor,)),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){deleteFromTextField();},
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Icon(Icons.backspace,color: ktextColor,),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0,bottom: 20),
                        child: GestureDetector(
                          onTap: (){
                            savePin(_textEditingController.text);
                            Navigator.pop(context);
                            securityQuestion(context);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.3,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.amber),
                            child: Center(child: Text('Proceed',

                              style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 14/textScaleFactor),)),
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

