import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import '../../../UIKonstant/KUiComponents.dart';
import '../../Api Functions/VirtualWalletManagement/virtualWalletManagement.dart';
import '../../Api Functions/topUp card/topUp.dart';
import '../cards.dart';

class FundCardClass {
  late final cardModel _cardModel;

  FundCardClass(cardModel model){
    _cardModel = model;
  }


  Future fundCardModal(BuildContext context, ) {

    return showModalBottomSheet(
      context: context,
      backgroundColor: kbackgroundColorLightMode,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {


        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void callState (){
             setState((){});
            }
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
                          Text('Fund Card',style: GoogleFonts.inter(
                              color: kbottomNavigationIconcolor,
                              fontSize: 20,
                              fontWeight: FontWeight.w900
                          ),),

                        ],),
                    ),

                    //Amount to withdraw
                    Padding(
                      padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                      child: TextFormField(
                        controller: topAmount,
                        onChanged: (value){

                          totalFundAmount = double.parse(topAmount.text) * dollarRate;
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
                            Icons.attach_money,
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
                        Text('${topAmount.text} X ${dollarRate.toStringAsFixed(2)} = N ${totalFundAmount.toStringAsFixed(2)}',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),
                          const Spacer(),
                          Text('${cardData[cardIndex]['masked_card']}',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),
                      ],),
                    ),

                    const Spacer(),
                    ///close
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: ()async{
                          if(kFundingCard== true){
                            setState((){kFundingCard=false;});
                            await topUpCard(
                              context,
                              "Card Funded Successful",
                              callState, // callback setState
                              'Your card has been funded respectively - Happy shopping',
                            );

                          }
                          setState((){kFundingCard=true;});
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width/1.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.amber.shade500,
                          ),

                          child: Center(
                            child: kFundingCard == false ? const SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(color: Colors.black,),
                            ) :Text('Fund from wallet',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),),
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