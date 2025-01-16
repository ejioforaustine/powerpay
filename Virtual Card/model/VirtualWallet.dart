import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'package:powerpay/Virtual%20Card/UI/withdrawtoBank.dart';

import '../../UIKonstant/KUiComponents.dart';

class VirtualWalletForm{

  Future walletDetailsModal(BuildContext context, ) {
    TextEditingController fundAmount =  TextEditingController();
    double rate = 1560;
    double totalFundAmount = 0;
    return showModalBottomSheet(
        context: context,
        backgroundColor: kbackgroundColorLightMode,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {


          return StatefulBuilder(

            builder: (BuildContext context, StateSetter setState) {
              void copyToClipboard(BuildContext context, String text) {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
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
                            Text('Wallet account details',style: GoogleFonts.inter(
                                color: kbottomNavigationIconcolor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900
                            ),),

                          ],),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 24,left: 24,right: 24),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(

                                 decoration: BoxDecoration(
                                   borderRadius: const BorderRadius.only(
                                       topRight: Radius.circular(16),
                                       topLeft:Radius.circular(16),
                                       bottomRight: Radius.circular(16) ),
                                   border: Border.all(color: Colors.grey)
                                 ),
                                child: ListTile(
                                  trailing: Text('${virtualAccountNumber ?? ''}',
                                    style: GoogleFonts.inter(color: ktextColor,
                                        fontSize: 10/textScaleFactor),),
                                  leading: Text('${virtualAccountName ?? 'No wallet yet ? Create Card to Get Wallet details'}',
                                    style: GoogleFonts.inter(color: ktextColor,
                                        fontSize: 10/textScaleFactor),),
                                  title: Text('${virtualBankName ?? ''}',
                                    style: GoogleFonts.inter(color: ktextColor,
                                        fontSize: 8/textScaleFactor),),

                                )
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 8),
                                child: GestureDetector(
                                  onTap: (){
                                    copyToClipboard(context, virtualAccountNumber);
                                  },
                                  child: Container(
                                    height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child:  Icon(Icons.copy_rounded,color: ktextColor,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Text('Fee: A charge may apply on crediting your wallet',style: GoogleFonts.inter(color: Colors.grey,fontSize: 6/textScaleFactor),),
                          )),



                      const Spacer(),
                      ///close
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16,right: 16,left: 16),
                              child: GestureDetector(
                                onTap: (){
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
                                    child: Text('Done',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16,right: 16,left: 16),
                              child: GestureDetector(
                                onTap: (){
                                  if(virtualWalletBalance > 60000)
                                    {}
                                  else {}
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=> const WithdrawToBank() ));
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width/1.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.black,
                                  ),
                            
                                  child: Center(
                                    child: Text('Withdraw',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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