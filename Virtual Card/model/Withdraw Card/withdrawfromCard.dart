import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/withdrawFromCard/withdrawfromcard.dart';

import '../../../UIKonstant/KUiComponents.dart';
import '../../Kvirtual constant.dart';
import '../cards.dart';

class WithdrawCardClass {
  late final cardModel _cardModel;

  WithdrawCardClass (cardModel model){
    _cardModel = model;
  }

  Future withdrawFromCardModal(BuildContext context, ) {


    return showModalBottomSheet(
        context: context,
        backgroundColor: kbackgroundColorLightMode,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {


          return StatefulBuilder(


            builder: (BuildContext context, StateSetter setState) {
              void callState(){
                setState;
              }
              double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
              return Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //heading Text
                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                        child: Row(
                          children: [
                            Text('Withdraw to wallet',style: GoogleFonts.inter(
                                color: kbottomNavigationIconcolor,
                                fontSize: 16/textScaleFactor,
                                fontWeight: FontWeight.w900
                            ),),

                          ],),
                      ),

                      //Amount to withdraw
                      Padding(
                        padding: const EdgeInsets.only(top: 16,left: 24,right: 24),
                        child: TextFormField(
                          controller: withdrawCardAmount,
                          onChanged: (value){
                            totalFundAmount = double.parse(withdrawCardAmount.text) * nairaRate;
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
                            prefixIcon: Icon(
                              Icons.numbers_outlined,
                              color: ktextColor.withOpacity(0.5),
                            ),
                            labelText: 'Amount',
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
                            Text('Rate: ${nairaRate.toStringAsFixed(2)} X ${withdrawCardAmount.text}  = N ${totalFundAmount.toStringAsFixed(2)}',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),

                          ],),
                      ),


                      const Spacer(),
                      ///close
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: ()async {
                            if(kWithdrawCard == true){
                              setState((){kWithdrawCard=false;});
                              await withdraw4rmCard(callState,context);
                            }
                            setState((){kWithdrawCard=true;});
                            if(context.mounted){Navigator.pop(context);}
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.amber.shade500,
                            ),

                            child: Center(
                              child: kWithdrawCard == false ? const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(color: Colors.black,),):
                              Text('Withdraw from Card',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),)

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