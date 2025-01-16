import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'package:powerpay/Virtual%20Card/model/card_details.dart';

class cardModel extends StatefulWidget {
  cardModel({
    super.key,
    required this.cardType,
    required this.cardNUmber,
    required this.cardExpryDate,
    required this.cardHolderName,
    required this.cardBalance,
  });

  dynamic cardType = 'VISA';
  dynamic cardBalance = '34.5';
  dynamic cardNUmber = '5326 ***** 5345';
  dynamic cardExpryDate = '5/25';
  dynamic cardHolderName = 'CHIAGOZIE EJIOFOR';

  @override
  State<cardModel> createState() => _cardModelState();
}

class _cardModelState extends State<cardModel> {
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: (
                  cardData.isNotEmpty &&
                      cardIndex < cardData.length &&
                      cardData[cardIndex]['isFrozen'] == true)?
              ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ]),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: kBoxShadow,
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ],
                    image: DecorationImage(
                        image: cardData.isEmpty
                            ? const AssetImage(
                                'assets/Virtual assets/digital-art-portrait-person-listening-music-headphones.jpg')
                            : cardData[cardIndex]['brand'] == 'VISA'
                                ? const AssetImage(
                                    'assets/Virtual assets/digital-art-portrait-person-listening-music-headphones.jpg')
                                : const AssetImage(
                                    'assets/Virtual assets/cartoon-style-character-wearing-headphones.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Card Type
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(widget.cardType,
                                style: GoogleFonts.kadwa(
                                    fontSize: 10 / textScaleFactor,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            const Text(
                              'Virtual Card',
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32)),
                              color: Colors.white.withOpacity(0.1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //Card balance
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 0, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$ ${widget.cardBalance}',
                                      style: GoogleFonts.kanit(
                                          decorationStyle:
                                              TextDecorationStyle.dashed,
                                          color: Colors.black,
                                          fontSize: 40 / textScaleFactor,
                                          fontWeight: FontWeight.w900),
                                    )
                                  ],
                                ),
                              ),

                              //Card Number
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.cardNUmber,
                                      style: GoogleFonts.kadwa(
                                          fontSize: 15 / textScaleFactor,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                ),
                              ),

                              //Card Expry Date
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 0),
                                child: Row(
                                  children: [
                                    Text(widget.cardExpryDate,
                                        style: GoogleFonts.kadwa(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),

                              //Card Holder Name
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text(widget.cardHolderName,
                                        style: GoogleFonts.kadwa(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ) :
              Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: kBoxShadow,
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    )
                  ],
                  image: DecorationImage(
                      image: cardData.isEmpty
                          ? const AssetImage(
                          'assets/Virtual assets/digital-art-portrait-person-listening-music-headphones.jpg')
                          : cardData[cardIndex]['brand'] == 'VISA'
                          ? const AssetImage(
                          'assets/Virtual assets/digital-art-portrait-person-listening-music-headphones.jpg')
                          : const AssetImage(
                          'assets/Virtual assets/cartoon-style-character-wearing-headphones.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Card Type
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(widget.cardType,
                              style: GoogleFonts.kadwa(
                                  fontSize: 10 / textScaleFactor,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          const Text(
                            'Virtual Card',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32)),
                            color: Colors.white.withOpacity(0.1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //Card balance
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 0, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$ ${widget.cardBalance}',
                                    style: GoogleFonts.kanit(
                                        decorationStyle:
                                        TextDecorationStyle.dashed,
                                        color: Colors.black,
                                        fontSize: 40 / textScaleFactor,
                                        fontWeight: FontWeight.w900),
                                  )
                                ],
                              ),
                            ),

                            //Card Number
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 16, bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    widget.cardNUmber,
                                    style: GoogleFonts.kadwa(
                                        fontSize: 15 / textScaleFactor,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                            ),

                            //Card Expry Date
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 0),
                              child: Row(
                                children: [
                                  Text(widget.cardExpryDate,
                                      style: GoogleFonts.kadwa(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),

                            //Card Holder Name
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(widget.cardHolderName,
                                      style: GoogleFonts.kadwa(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 60,
              child: GestureDetector(
                onTap: () {
                  if(cardIndex != -1){
                    cardModel model = cardModel(
                      cardType: 'Visa',
                      cardNUmber: '5429-9873-7896-1124',
                      cardExpryDate: '05/26',
                      cardHolderName: 'CHIAGOZIE EJIOFOR',
                      cardBalance: '',
                    );
                    CardDetailsClass cardDetailsInstance =
                    CardDetailsClass(model);
                    cardDetailsInstance.cardDetails(context);
                  }

                },
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: Center(
                        child: Icon(
                      Icons.open_in_full_rounded,
                      color: Colors.amber,
                    ))),
              ),
            )
          ],
        ));
  }
}
