import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:powerpay/UIsrc/ElectricityUi/AddMeternumber.dart';
import 'package:powerpay/UIsrc/home/Home.dart';
import 'package:powerpay/UIsrc/ElectricityUi/OrderSummary.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';

import '../../../Core/Functions/constantvaribles.dart';

class Receipts extends StatefulWidget {
  const Receipts({Key? key}) : super(key: key);

  @override
  State<Receipts> createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {
  bool _hasAnimated = false;

  void animate() {
    if(!_hasAnimated){
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
        _width = MediaQuery.of(context).size.width / 1.1;
        height = 50.0;
        color = Colors.amber;
      }));
    }

  }

  double _width = 0;
  double height = 0.0;
  Color color = Colors.amber.shade900;
  final globalKey = GlobalKey();

  var providerLogo = Image.asset(
    'assets/images/PowerproviderLogo/BEDC.jpg',
    color: Colors.transparent,
  );
  Future<Uint8List> _camptureScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print('capture');
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _saveAsPdf(Uint8List image) async {
    final pdf = pw.Document();
    final imageMemory = pw.MemoryImage(image);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(imageMemory),
        ),
      ),
    );

    final directory = Directory(
        '/storage/emulated/0/Download'); // Access the Downloads directory
    if (!directory.existsSync()) {
      directory.createSync(); // Create the directory if it doesn't exist
    }

    final file = File("${directory.path}/$transactionID.pdf");
    await file.writeAsBytes(await pdf.save());
    Fluttertoast.showToast(msg: 'Downloaded to ${file.path}');
  }

  void ReturnToHomePage() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  bool _isLoading = false;
  bool _isTimerActive = false;
  DateTime? _nextAllowedTime;

  Future<void> requeryTransaction(String formattedDate) async {
    if (_isTimerActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please try again after 5 minutes.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(
            'https://us-central1-polectro-60b65.cloudfunctions.net/queryTransactionBill'),
        headers: {
          'Content-Type': 'application/json', // Set JSON content type
        },
        body: jsonEncode(
            {'request_id': requestID}), // Send the request_id as JSON
      );

      // Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Transaction status: $data");
        billToken = data['purchased_code'].toString();
        responseDescription = data['response_description'].toString();
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
      _isTimerActive = true;
      _nextAllowedTime = DateTime.now().add(const Duration(minutes: 5));
    });

    // Start the timer for 5 minutes
    Future.delayed(const Duration(minutes: 5)).then((_) {
      setState(() {
        _isTimerActive = false;
      });
    });
  }

  Image switchLogo() {
    switch (productName) {
      case '':
        providerLogo = Image.asset('assets/images/PowerproviderLogo/BEDC.jpg');
        print(productName);
        break;
      case 'Benin Electricity - BEDC':
        providerLogo = Image.asset('assets/images/PowerproviderLogo/BEDC.jpg');
        print(productName);
        break;
      case 'Abuja Electricity Distribution Company- AEDC':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/AEDC-LOGO.jpg');
        print(productName);
        break;
      case 'Enugu Electric - EEDC':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/enugu.jpeg');
        print(productName);
        break;
      case 'Eko Electric Payment - EKEDC':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/EkoAtlantic.jpeg');
        print(serviceProvider);
        break;
      case 'IBEDC - Ibadan Electricity Distribution Company':
        providerLogo = Image.asset('assets/images/PowerproviderLogo/Ibedc.png');
        print(serviceProvider);
        break;
      case 'Kano Electric Payment - KEDCO':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/Kedco-spon.jpg');
        print(serviceProvider);
        break;
      case 'PHED - Port Harcourt Electric':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/portharcourt.png');
        print(serviceProvider);
        break;
      case 'Jos Electric Payment - JED':
        providerLogo = Image.asset('assets/images/PowerproviderLogo/JED.png');
        print(serviceProvider);
        break;
      case 'Kaduna Electric Payment - KAEDCO':
        providerLogo =
            Image.asset('assets/images/PowerproviderLogo/kaduna.jpeg');
        print(serviceProvider);
        break;
    }
    return providerLogo;
  }

  @override
  void dispose() {
    // Set the variable when the page is exited
    responseDescription = 'null';

    print(responseDescription);



    super.dispose();
  }

  bool shouldPop = true;
  void iniState() {
    switchLogo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _width = 200.0;
        height = 200.0;
        color = Colors.red;
      });
    });

    super.initState();
  }

  var parser = EmojiParser();
  var coffee = Emoji('coffee', '☕');
  var heart = Emoji('heart', '❤️');

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    animate();
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return shouldPop;
      },
      child: Scaffold(
          backgroundColor: kbackgroundColorLightMode,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: kbackgroundColorLightMode,
            elevation: 1,
            leading: GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Icon(
                  Icons.arrow_back,
                  color: ktextColor,
                )),
            iconTheme: IconThemeData(
                color: ktextColor,
                size: 30 *
                    MediaQuery.of(context).size.height /
                    MediaQuery.of(context).size.height),
            title: Text('RECEIPTS',
                style: GoogleFonts.kadwa(
                    color: ktextColor,
                    fontSize: 15 / textScaleFactor,
                    fontWeight: FontWeight.w900)),
          ),
          body: RepaintBoundary(
            key: globalKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kbackgroundColorLightMode,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height:
                                  60 * MediaQuery.of(context).size.height / 768,
                              width:
                                  60 * MediaQuery.of(context).size.width / 375,
                              child: Image.asset(
                                  'assets/images/logowithname.png')),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height:
                                60 * MediaQuery.of(context).size.height / 768,
                            width: 60 * MediaQuery.of(context).size.width / 375,
                            child: switchLogo(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 1,
                    ),

                    //Status
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Status:',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11 / textScaleFactor,
                                  color: ktextColor.withOpacity(0.3)),
                            ),
                          ),
                          const Spacer(),
                          IntrinsicWidth(
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: responseDescription == 'Successful'
                                      ? Colors.greenAccent.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2)),
                              child: Text(
                                '   $responseDescription   ',
                                style: GoogleFonts.inter(
                                    fontSize: 12 / textScaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: ktextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //meter name
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Meter Name :',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11 / textScaleFactor,
                                  color: ktextColor.withOpacity(0.3)),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$verifiedMeterName',
                            style: GoogleFonts.inter(
                                fontSize: 12 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    //meter address
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Meter Address:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 5,
                            child: Text(
                              '$meterAddress',
                              style: GoogleFonts.inter(
                                  fontSize: 11 / textScaleFactor,
                                  fontWeight: FontWeight.w600,
                                  color: ktextColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //customers phone
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Customers Phone:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          Text(
                            '$usersPhone',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12 / textScaleFactor,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    //Meter Number
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Meter No:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '$uniqueMeterNum',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    //Disco
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Disco:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '$productName',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Date:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '$transactionDate',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Transaction ID:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '$transactionID',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    //Customer Email
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Customer Email:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '$userEmail',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 11 / textScaleFactor,
                                color: ktextColor.withOpacity(0.3)),
                          ),
                          const Spacer(),
                          SelectableText(
                            '₦ $newTotalBedcAmount',
                            style: GoogleFonts.inter(
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                          ),
                        ],
                      ),
                    ),

                    // token
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24, left: 16, right: 16, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '$billToken',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w900,
                                fontSize: 14 / textScaleFactor,
                                color: Colors.red.shade900),
                          ),
                        ],
                      ),
                    ),

                    //details
                    /*ExpansionTile(
                      collapsedBackgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                      ),
                      iconColor: ktextColor,
                      collapsedIconColor: kotherTextcolorGrey ,


                      title: Text('Details',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 11/textScaleFactor,
                            color: kotherTextcolorGrey.withOpacity(0.7)),),
                    children: [

                      Card(
                        elevation: 0,
                        color: kbackgroundColorLightMode,
                        child: ListTile(
                          title: Text(
                            'Total Unit:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,

                                color: ktextColor.withOpacity(0.5)),
                          ),
                          trailing: Text(
                            '$Units',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,

                                color: ktextColor),
                          ),

                        ),
                      ),

                      Card(
                        elevation: 0,
                        color: kbackgroundColorLightMode,
                        child: ListTile(
                          title: Text(
                            'Customers Phone:',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,

                                color: ktextColor.withOpacity(0.5)),
                          ),
                          trailing: Text(
                            usersPhone,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,

                                color: ktextColor),
                          ),

                        ),
                      ),

                    ],
                    ),*/

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isLoading) {
                                  requeryTransaction(
                                      requestID); // Replace with your actual requestID
                                }
                              },
                              child: AnimatedContainer(
                                height: height,
                                width: _width / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: _isLoading || _isTimerActive
                                      ? Colors.grey.shade700
                                      : Colors.black,
                                ),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInCubic,
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                      : Text(
                                          _isTimerActive
                                              ? "Retry in ${_nextAllowedTime != null ? _nextAllowedTime!.difference(DateTime.now()).inSeconds : 0}s"
                                              : "  Didn't get Token? Retry  ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.kadwa(
                                            fontSize: 10 /
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                print(responseDescription);
                                final image = await _camptureScreenshot();
                                await _saveAsPdf(image);
                                try {
                                  final Directory? appDocumentsDir =
                                      await getExternalStorageDirectory();
                                  final imagePath =
                                      '${appDocumentsDir?.path}/$transactionID.png';

                                  File(imagePath).writeAsBytesSync(image);
                                  print('saved');

                                  await GallerySaver.saveImage(imagePath);
                                  Timer(const Duration(seconds: 4), () {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Returning to Home Page In 15 Seconds');
                                  });
                                  Timer(const Duration(seconds: 19), () {
                                    ReturnToHomePage();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: AnimatedContainer(
                                height: height,
                                width: _width / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: color),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInCubic,
                                child: Center(
                                  child: Text(
                                    '   Download Receipt   ',
                                    style: GoogleFonts.kadwa(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10 / textScaleFactor,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Thank you and sharing button
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thank you for Choosing PowerPay ${heart.code}",
                            style: GoogleFonts.inter(
                                color: ktextColor.withOpacity(0.5),
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tell your loved one's about us",
                            style: GoogleFonts.inter(
                                color: ktextColor.withOpacity(0.5),
                                fontSize: 11 / textScaleFactor,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
