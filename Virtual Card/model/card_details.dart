import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';

import '../../UIKonstant/KUiComponents.dart';
import '../Api Functions/CardTransaction/card transactions.dart';
import 'cards.dart';

///Credit card show modal bottom sheet class
class CardDetailsClass {

   late final cardModel _cardModel;

   CardDetailsClass(cardModel model) {
     _cardModel = model;
   }

  void cardDetails(BuildContext context, ) => showModalBottomSheet(
      context: context,
      backgroundColor: kbackgroundColorLightMode,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        void copyToClipboard(BuildContext context, String text) {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height/1.1,
          child: ListView(
            shrinkWrap: true,
            children: [
               //Copy card Number
              Padding(
                padding: const EdgeInsets.only(top: 24,),
                child: ListTile(
                  leading: const Icon(Icons.credit_card,size: 25,),
                  title: Text(cardData[cardIndex]['number']?? '',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('#card number',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['number']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),
              // Copy CVV
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.lock_outline,size: 25,),
                  title: Text(cardData[cardIndex]['ccv']??'',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('#CVV',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['ccv']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //expiry date
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.abc_sharp,size: 25,),
                  title: Text(cardData[cardIndex]['expiry']?? '',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('#Expiration date',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['name']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //Card Holder name
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.abc_sharp,size: 25,),
                  title: Text(cardData[cardIndex]['name']?? '',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('#Card Holder name',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['name']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //Card address
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.maps_home_work_outlined,size: 25,),
                  title: Text(cardData[cardIndex]['street']??'',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('#Street',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['street']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //Postal code
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.code,size: 25,),
                  title: Text(cardData[cardIndex]['postal_code']??'',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('Postal code',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['postal code']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //City
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.location_city,size: 25,),
                  title: Text(cardData[cardIndex]['city']??'',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text(cardData[cardIndex]['state']??'',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['city']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),

              //country
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListTile(
                  leading: const Icon(Icons.golf_course,size: 25,),
                  title: Text(cardData[cardIndex]['country']?? '',style: GoogleFonts.inter(fontWeight: FontWeight.bold,fontSize: 16,color: kbottomNavigationIconcolor),),
                  subtitle:Text('Country',style: GoogleFonts.inter(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                  trailing: GestureDetector(
                      onTap: (){copyToClipboard(context, cardData[cardIndex]['country']);},
                      child: const Icon(Icons.copy_rounded,size: 25,color: Colors.grey,)),
                ),
              ),


              ///close
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber.shade700,
                            ),

                            child: Center(
                              child: Text('Close',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionsPage(transactions: fetchTransactions(cardData[cardIndex]['card_id'])),
                              ),
                            );

                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
                            ),

                            child: Center(
                              child: Text('Card Transactions',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        );
      });

}

