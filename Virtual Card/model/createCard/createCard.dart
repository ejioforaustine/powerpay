
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/VirtualWalletManagement/virtualWalletManagement.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../Api Functions/createVirtualCustomer.dart';
import '../../Kvirtual constant.dart';
import '../cards.dart';

class CreateCardClass {
  late final cardModel _cardModel;

  final List<String> cardTypeItems = [
    'VISA',
    'MASTERCARD',
  ];

  String? selectedBrandCard;

  final _formKey = GlobalKey<FormState>();

  FundCardClass(cardModel model){
    _cardModel = model;
  }


  Future createCardModal(BuildContext context, ) {


    return showModalBottomSheet(
        context: context,
        backgroundColor: kbackgroundColorLightMode,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {

          return StatefulBuilder(

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
                            Text('Create USD Card',style: GoogleFonts.inter(
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
                            'Select Card Type',
                            style: TextStyle(
                                color: ktextColor,
                                fontSize: 12/textScaleFactor),
                          ),
                          items: cardTypeItems
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
                              return 'Please select Card Type';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                            cardBrand = value.toString();
                            print(cardBrand);
                          },
                          onSaved: (value) {
                            selectedBrandCard = value.toString();
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

                      //Amount to Top up
                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                        child: TextFormField(
                          controller: topAmount,
                          onChanged: (value){

                            totalFundAmount = (double.parse(topAmount.text) + 2) * dollarRate;
                            setState((){});

                          },
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),
                          keyboardType: TextInputType.number,
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
                              Icons.numbers_outlined,
                              color: ktextColor.withOpacity(0.5),
                            ),
                            labelText: 'Top Up Amount',
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
                            Text('${topAmount.text} + 2 X ${dollarRate.toStringAsFixed(2)} = N ${totalFundAmount.toStringAsFixed(2)}',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),
                            const Spacer(),
                            Text('+\$2 creation fee',style: GoogleFonts.inter(
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

                            if (kCreatingCard == true){
                              setState((){
                                kCreatingCard = false;
                              });
                              await createVirtualCard(context,
                                'Your card have been created, Kindly slide down to refresh.',
                                callState,
                                'Card Created Successfully',

                              );
                              setState((){
                                kCreatingCard = true;
                              });
                              if(context.mounted){ Navigator.pop(context);}
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
                              child: kCreatingCard ==false ?
                              const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(color: Colors.black,),
                              ) :
                              Text('Create card with \$2',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),) ,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            },

          );
        });
  }

}