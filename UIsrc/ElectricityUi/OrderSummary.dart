import 'package:flutter/services.dart';
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Core/Functions/keys.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/UIsrc/ElectricityUi/AddMeternumber.dart';
import 'dart:io' show Platform;
import 'package:webview_flutter/webview_flutter.dart';
import '../../Core/Functions/constantvaribles.dart';
import '../../UIKonstant/KUiComponents.dart';

dynamic verifiedMeterName;

class OrderSummary extends StatefulWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  void callstate() {
    print('this reached here');
    setState(() {});
  }

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    getCurrentuserEmail();

    payButtonText = 'Proceed';
    copyUSSDdescription = 'Please proceed to begin Payment';
    ussdCode = '';
    bankTransferNumber = '';
    bankTransferName = '';
    payButtonTransferText = 'Proceed';
    copyTransferDescription = 'Please proceed to begin Payment';
    isLoading2 = false;

    responseDescription = 'null';

    initialamount = Amount.text;

    newTotalBedcAmount = int.parse(Amount.text) + 100 - subAmount;
    getcurrentdate();
    miniFunction().getReference();
    takeOffVat();
    print(
      '$BedcAmountAfterVAT,time-$formattedDate',
    );
    super.initState();
  }

  @override
  void dispose() {
    subAmount=0;
    super.dispose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kbackgroundColorLightMode,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kbackgroundColorLightMode,
          elevation: 7,
          shadowColor: Colors.black,
          iconTheme: IconThemeData(
              color: ktextColor,
              size: 25 * MediaQuery.of(context).size.height / 768),
          title: Text('ORDER SUMMARY',
              style: GoogleFonts.kadwa(
                  color: ktextColor,
                  fontSize: 15 * MediaQuery.of(context).size.height / 768,
                  fontWeight: FontWeight.w700)),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                ///heading(buy electricity)
                SizedBox(
                  height: 20 * MediaQuery.of(context).size.height / 768,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntrinsicHeight(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.04,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 16, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "$newtype",
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 12 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "$provider",
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 16, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    newMeterNum,
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 12 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "$verifiedMeterName",
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 16, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Amount:",
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 12 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  " $initialamount",
                                  style: GoogleFonts.arimo(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey,
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 16, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Processing Fee:",
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 12 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  " 100",
                                  style: GoogleFonts.arimo(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 16, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Discount:",
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 12 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  " - $subAmount",
                                  style: GoogleFonts.arimo(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                      fontSize: 12 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 16, right: 16, bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total:",
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 20 *
                                            MediaQuery.of(context).size.height /
                                            768),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "₦ $newTotalBedcAmount",
                                  style: GoogleFonts.arimo(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey,
                                      fontSize: 18 *
                                          MediaQuery.of(context).size.height /
                                          768),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Summary details Container
                SizedBox(
                  height: 20 * MediaQuery.of(context).size.height / 768,
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )),
                      Text(
                        'Payment Method',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: ktextColor,
                            fontSize:
                                12 * MediaQuery.of(context).size.height / 768),
                      ),
                      const Expanded(
                          child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )),
                    ],
                  ),
                ), //Divider-Recent Activities_

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    getcurrentdate();
                                    /// Recheck the function to avoid Money Loss
                                    VerifyDataCall(
                                      secretKey: SecretKey,
                                      context: context,
                                      Apikey: ApiKey,
                                    ).charges(context);
                                  },
                                  child: Container(
                                    height: 70 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: PaymentButtonColor),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: SizedBox(
                                                height: 47 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    768,
                                                width: 100,
                                                child: Image.asset(
                                                  'assets/images/cardlogo.png',
                                                  fit: BoxFit.contain,
                                                ))),
                                        Expanded(
                                          child: Text(
                                            'CREDIT/DEBIT CARD',
                                            style: GoogleFonts.kadwa(
                                                fontWeight: FontWeight.w600,
                                                color: ktextColor,
                                                fontSize: 9 *
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    miniFunction().getReference();
                                    PopUpFunction(
                                            Apikey: ApiKey,
                                            secretKey: SecretKey,
                                            context: context,
                                            callstate: callstate)
                                        .selectBankUssd();
                                  },
                                  child: Container(
                                    height: 70 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: PaymentButtonColor),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                              height: 45 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  768,
                                              width: 100,
                                              child: Image.asset(
                                                  'assets/images/5919215-middle-removebg-preview.png')),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'USSD',
                                            style: GoogleFonts.kadwa(
                                                fontWeight: FontWeight.w600,
                                                color: ktextColor,
                                                fontSize: 11 *
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
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    isLoadingWalletTransfer = false;
                                    setState(() {});
                                    TxWalletStatus = 'Reset';
                                    VerifyDataCall(
                                            context: context,
                                            Apikey: ApiKey,
                                            secretKey: SecretKey)
                                        .handleButtonClick4PayViaWallet(
                                            callstate);
                                  },
                                  child: Container(
                                    height: 70 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: PaymentButtonColor),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: isLoadingWalletTransfer,
                                          child: Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 25 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                768,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: isLoadingWalletTransfer
                                                ? Text(
                                                    'WALLET',
                                                    style: GoogleFonts.kadwa(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ktextColor,
                                                      fontSize: 11 *
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          768,
                                                    ),
                                                  )
                                                : Center(
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: ktextColor,
                                                        )))),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    PopUpFunction(
                                            Apikey: ApiKey,
                                            context: context,
                                            secretKey: SecretKey,
                                            callstate: callstate)
                                        .payViaBankTransfer();
                                  },
                                  child: Container(
                                    height: 70 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: PaymentButtonColor),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.bank,
                                          size: 25 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              768,
                                          color: Colors.red.shade900,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'BANK TRANSFER',
                                            style: GoogleFonts.kadwa(
                                                fontWeight: FontWeight.w600,
                                                color: ktextColor,
                                                fontSize: 11 *
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
                    ],
                  ),
                ),

                ///payment methods
              ],
            ),
          ],
        ));
  }
}
