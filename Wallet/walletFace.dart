import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Wallet/walletFunctions.dart';
import 'package:powerpay/Wallet/walletHistory.dart';
import 'package:powerpay/Wallet/withdrawal.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Core/Functions/constantvaribles.dart';
import '../UIsrc/home/Home.dart';
import '../Virtual Card/Api Functions/createVirtualCustomer.dart';
import '../Virtual Card/Kvirtual constant.dart';

class walletTestface extends StatefulWidget {
  const walletTestface({Key? key}) : super(key: key);

  @override
  State<walletTestface> createState() => _walletTestfaceState();
}

bool visibleButton = false;
bool visibleButton2 = false;

bool isLoadingCreationWallet = true;

dynamic walletBalance;
var ledgerBalance;
void _copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied to clipboard')),
  );
}

void visibility() {
  if (walletAccountNumber != null) {
    visibleButton = true;
    visibleButton2 = false;
  } else {
    visibleButton2 = true;
    visibleButton = false;
  }
}

class _walletTestfaceState extends State<walletTestface> {
  //format balance into currency
  String formatCurrency(double amount) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_NG', name: 'NGN');
    return currencyFormatter.format(amount);
  }
  void callState(){
    setState(() {});
  }
  PageController walletControllerPage = PageController();
  @override
  void initState() {
    visibility();
    getWalletBalanceVirtual(userEmail!,callState);
    fetchVirtualWalletDetails(userEmail!, callState);
    fetchDataFromSubcollection(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColorLightMode,
        elevation: 7,
        iconTheme: IconThemeData(color: ktextColor, size: 30),
        title: Text('WALLET',
            style: GoogleFonts.kadwa(
                color: ktextColor,
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.w900)),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: EdgeInsets.only(
                      top: 50 * MediaQuery.of(context).size.height / 768),
                  child: Center(
                    child: Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width / 1.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kbalanceContainerColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: const Offset(0, 3), // Offset
                          ),
                        ],
                      ),
                      child: PageView(
                        controller: walletControllerPage,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Bill Wallet",
                                          style: GoogleFonts.arimo(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: loadindingBalance
                                            ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ))
                                            : Text(
                               formatCurrency((walletBalance??0.00).toDouble()),
                                          style: GoogleFonts.arimo(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontSize: 40 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height),
                                        ),
                                      ),
                                      Icon(
                                        Iconsax.add_circle,
                                        color: Colors.white,
                                        size: 30 *
                                            MediaQuery.of(context).size.height /
                                            MediaQuery.of(context).size.height,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Virtual Wallet",
                                          style: GoogleFonts.arimo(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: loadindingBalance
                                            ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ))
                                            : Text(
                                          formatCurrency((virtualWalletBalance??0.00).toDouble()),
                                          style: GoogleFonts.arimo(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontSize: 35 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height),
                                        ),
                                      ),
                                      Icon(
                                        Iconsax.add_circle,
                                        color: Colors.white,
                                        size: 30 *
                                            MediaQuery.of(context).size.height /
                                            MediaQuery.of(context).size.height,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:16,bottom: 2),
                  child: SizedBox(
                    height: 10,

                    child: SmoothPageIndicator(

                        controller: walletControllerPage,  // PageController
                        count:  2,
                        effect:  ExpandingDotsEffect(
                            dotHeight: 10,
                            activeDotColor: ktextColor,

                            dotWidth: 10,
                            expansionFactor: 2
                        ),  // your preferred effect
                        onDotClicked: (index){
                        }
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      top: 20 * MediaQuery.of(context).size.height / 768),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                30,
                                24 * MediaQuery.of(context).size.height / 768,
                                0,
                                5),
                            child: Row(children: [
                              Text("Bill Payment Wallet", style: GoogleFonts.arimo(
                                  color: ktextColor.withOpacity(0.5),
                                  fontSize: MediaQuery.of(context).size.height*0.013,
                                  fontWeight: FontWeight.w900),),
                            ],),
                          ),
                          SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0,left: 24,right: 24),
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16, right: 16,bottom: 5),
                                              child: Row(
                                                children: [
                                                  Text('${walletBankName ?? ''}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(color: ktextColor,
                                                        fontSize: 10/textScaleFactor),),
                                                  const Spacer(),
                                                  SelectableText('${walletAccountNumber ?? ''}',
                                                    style: GoogleFonts.inter(color: ktextColor,
                                                        fontSize: 10/textScaleFactor),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${walletAccountName ?? 'No wallet yet ? Create below Get Wallet details'}',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.inter(color: ktextColor.withOpacity(0.5) ,
                                                        fontSize: 8/textScaleFactor),),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          _copyToClipboard(context, walletAccountNumber);
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
                          ),
                      
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                30,
                                8 * MediaQuery.of(context).size.height / 768,
                                0,
                                0),
                            child: Row(children: [
                              Text("Virtual Card Wallet", style: GoogleFonts.arimo(
                                  color: ktextColor.withOpacity(0.5),
                                  fontSize: MediaQuery.of(context).size.height*0.013,
                                  fontWeight: FontWeight.w900),),
                            ],),
                          ),

                          SizedBox(
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2,left: 24,right: 24),
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16, right: 16,bottom: 5),
                                              child: Row(
                                                children: [
                                                  Text('${virtualBankName ?? ''}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(color: ktextColor,
                                                        fontSize: 10/textScaleFactor),),
                                                  const Spacer(),
                                                  SelectableText('${virtualAccountNumber ?? ''}',
                                                    style: GoogleFonts.inter(color: ktextColor,
                                                        fontSize: 10/textScaleFactor),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${virtualAccountName ?? 'No wallet yet ? Create below Get Wallet details'}',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.inter(color: ktextColor.withOpacity(0.5) ,
                                                        fontSize: 8/textScaleFactor),),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          _copyToClipboard(context, virtualAccountNumber);
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
                          ),
                      
                      
                          SizedBox(
                            height:
                                10 * MediaQuery.of(context).size.height / 768,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 0, 24,
                                8 * MediaQuery.of(context).size.height / 768),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                height: 90 *
                                    MediaQuery.of(context).size.height /
                                    768,
                                width:
                                    MediaQuery.of(context).size.width / 1.085,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Note:',
                                            style: GoogleFonts.arimo(
                                                color: Colors.grey.shade700,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.017,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.all(8 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                      child: Text(
                                        'To fund your wallet, make a payment into this account.'
                                        ' This account number is dedicated to crediting your wallet.'
                                        ' And just like every other transfers, '
                                        'you could experience a slight delay in wallet funding.',
                                        style: GoogleFonts.arimo(
                                            color: Colors.grey.shade700,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.012,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: .0),
                              child: Container(
                                height: 150 *
                                    MediaQuery.of(context).size.height /
                                    768,
                                width: MediaQuery.of(context).size.width / 1.07,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Visibility(
                                          visible: visibleButton2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              isLoadingCreationWallet = false;
                                              setState(() {});
                                              print('seen');
                                              await createWallet();

                                              isLoadingCreationWallet = true;
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 60 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  768,
                                              width: 180 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  768,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  color:
                                                      Colors.grey.shade200),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        8 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            768),
                                                    child: Visibility(
                                                      visible:
                                                          isLoadingCreationWallet,
                                                      child: Icon(
                                                        Iconsax.add_square,
                                                        size: 17 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            768,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(1.0),
                                                    child:
                                                        isLoadingCreationWallet
                                                            ? Text(
                                                                'CREATE',
                                                                style: GoogleFonts.kadwa(
                                                                    fontSize:
                                                                        MediaQuery.of(context).size.height *
                                                                            0.014,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : SizedBox(
                                                                height: 50 *
                                                                    MediaQuery.of(context)
                                                                        .size
                                                                        .height /
                                                                    768,
                                                                width: 50 *
                                                                    MediaQuery.of(context)
                                                                        .size
                                                                        .height /
                                                                    768,
                                                                child: const Center(
                                                                    child: CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                ))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), // create button...
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const walletHistory()));
                                          },
                                          child: Container(
                                            height: 60 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                768,
                                            width: 185 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                768,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade200),
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      768),
                                                  child: Icon(
                                                    Iconsax.receipt4,
                                                    size: 17 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        768,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Transaction History',
                                                    style: GoogleFonts.kadwa(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 12 *
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            768),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
  }
}
