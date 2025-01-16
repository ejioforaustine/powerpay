import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/KYC/BVN.dart';
import 'package:powerpay/UIsrc/contact/Contact%20us.dart';
import 'package:powerpay/UIsrc/home/Home.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/conversion/conversion.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'package:intl/intl.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/PIN.dart';
import 'package:powerpay/Virtual%20Card/UI/PIN/enter_pin.dart';
import 'package:powerpay/Virtual%20Card/model/Fund%20Card/Fund%20Card.dart';
import 'package:powerpay/Virtual%20Card/model/VirtualWallet.dart';
import 'package:powerpay/Virtual%20Card/model/Withdraw%20Card/withdrawfromCard.dart';
import 'package:powerpay/Virtual%20Card/model/cards.dart';
import 'package:powerpay/Virtual%20Card/model/createCard/createCard.dart';
import 'package:powerpay/Wallet/walletFunctions.dart';
import 'package:powerpay/testing/Api%20testings.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import '../../UIKonstant/KUiComponents.dart';
import '../../UIKonstant/KUiComponents.dart';
import '../Api Functions/createVirtualCustomer.dart';
import '../Api Functions/get CardDetails/getCardBalance.dart';
import '../model/Freeze Card/freeze/terminate.dart';

class VirtualCardHomePage extends StatefulWidget {
  const VirtualCardHomePage({super.key});

  @override
  State<VirtualCardHomePage> createState() => _VirtualCardHomePageState();
}

class _VirtualCardHomePageState extends State<VirtualCardHomePage> {

  // Function to retrieve the 'submitted_status' field from Firestore
  Future<bool?> getSubmittedStatus(String email) async {
    // Sanitize the email to use it as a Firestore document ID
    String sanitizedEmail = email.replaceAll('.', '_');

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

    try {
      // Get the document snapshot
      DocumentSnapshot docSnapshot = await userDocRef.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Retrieve the 'submitted_status' field
        bool? submittedStatus = docSnapshot.get('submitted_status') as bool?;
        return submittedStatus;
      } else {
        print('Document does not exist.');
        return null; // Document does not exist
      }
    } catch (e) {
      print('Error retrieving document: $e');
      return null; // Error occurred
    }
  }

  void checkSubmittedStatus(String email) async {
    // Retrieve the submitted status
    submittedStatus = await getSubmittedStatus(email);

    // Handle the retrieved status
    if (submittedStatus != null) {
      if (submittedStatus) {
        print('The status is submitted.');
      } else {
        print('The status is not submitted.');
      }
    } else {
      print('Failed to retrieve the status.');
    }
  }

  //format balance into currency
  String formatCurrency(double? amount) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_NG', name: 'NGN');
    return currencyFormatter.format(amount ?? 0.00);
  }



  // Function to retrieve the 'submitted_status' field from Firestore
  Future<bool?> getKycStatus(String email) async {
    // Sanitize the email to use it as a Firestore document ID
    String sanitizedEmail = email.replaceAll('.', '_');

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

    try {
      // Get the document snapshot
      DocumentSnapshot docSnapshot = await userDocRef.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Retrieve the 'submitted_status' field
        bool? KYCStatus = docSnapshot.get('kyc_status') as bool?;
        return KYCStatus;
      } else {
        print('Document does not exist.');
        return null; // Document does not exist
      }
    } catch (e) {
      print('Error retrieving document: $e');
      return null; // Error occurred
    }
  }

  void checkKycStatus(String email) async {
    // Retrieve the submitted status
    kYCStatus = await getKycStatus(userEmail!);

    // Handle the retrieved status
    if (kYCStatus != null) {
      if (kYCStatus) {
        print('The status is submitted.');
      } else {
        print('The status is not submitted.');
      }
    } else {
      print('Failed to retrieve the status.');
    }
  }

  Future<void> checkSecurityQuestions() async {

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    // Retrieve hashed answers from Firestore
    question1 = userDoc['security_question_1'];


  }




  String sanitizeEmail(String email) {
    return email.replaceAll('.', '_'); // Replace '.' with ','
  }
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "defaultUserId";
  bool isPinSet = false;

  /// check for KYC field in database and update
  Future<void> createKYCCollection(String email) async {
    // Sanitize the email to use it as a Firestore document ID
    String sanitizedEmail = sanitizeEmail(email);

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(email);

    // Fetch the user's document
    DocumentSnapshot userSnapshot = await userDocRef.get();

    // Check if the user's document exists
    if (userSnapshot.exists) {
      // Cast the document data to a Map<String, dynamic>
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      // Check if the 'kyc_status' field exists
      if (userData != null && !userData.containsKey('kyc_status')) {
        // If the 'kyc_status' field does not exist, create it and set default values
        await userDocRef.update({
          'kyc_status': false, // Set KYC status to false
          'created_at': FieldValue.serverTimestamp(),
          'submitted_status': false, // Set Submitted status to false
        });
        print('KYC fields created and initialized for user $sanitizedEmail.');
      } else {
        checkSubmittedStatus(userEmail!);
        checkKycStatus(userEmail!);
        print('KYC fields already exist for user $sanitizedEmail.');
      }
    } else {
      print('User document does not exist for email $sanitizedEmail.');
    }
  }

  /// Check if the user has already set their PIN
  Future<void> _checkPinStatus(BuildContext context, Function () callstate) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (userDoc.exists) {
      // Cast the document data to a Map<String, dynamic>
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Check if 'pinSet' field exists and its value
      if (userData.containsKey('pinSet')) {
        setState(() {
          isPinSet = userDoc.get('pinSet');
        });
      } else {
        // If the 'pinSet' field doesn't exist, assume the user hasn't set a PIN yet
        setState(() {
          isPinSet = false;
        });
      }

      // Navigate based on pin status
      if (isPinSet) {
        enterPin(context,callstate);
      } else {
        setPin(context);
      }
    } else {
      // Handle the case where the user document doesn't exist (if necessary)
      print("User document does not exist");
    }
  }


  bool loadingData = false;
  //Call on refresh data
  Future<void> _refreshSliderDataVirtual() async {
    setState(() {
      loadingData = true;

    });
    //virtual functions & info

    await fetchVirtualWalletDetails(userEmail!, callState);
    await getWalletBalanceVirtual(userEmail!,callState);
    await fetchWalletBalanceHistory(userEmail!, callState);
    await fetchCustomerDetails(callState);
    await fetchCardData(callState);
    await currencyConverterNGToUSD();
    await currencyConverterUSDToNG();
    await checkSecurityQuestions();
    await fetchAndStoreCardDetails (userEmail!, cardData[cardIndex]['card_id']);


    setState(() {
      loadingData = false;

    });
  }

  //setState call back function
  void callState(){
    setState(() {});
  }

  PageController cardController = PageController();

  @override
  void initState(){
    super.initState();
    //kyc
    createKYCCollection(userEmail!);
    _checkPinStatus(context,callState);
    //virtual functions & info
    getWalletBalanceVirtual(userEmail!,callState);
    fetchWalletBalanceHistory(userEmail!,callState);
    fetchCustomerDetails(callState);

    fetchCardData(callState);
    currencyConverterNGToUSD();
    currencyConverterUSDToNG();
    checkSecurityQuestions();
    fetchVirtualCardBalance();
    fetchVirtualWalletDetails(userEmail!, callState);
  }


  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: StatusIcon),
      child: Scaffold(
        backgroundColor: kbackgroundColorLightMode,
        body: RefreshIndicator(
          onRefresh: _refreshSliderDataVirtual,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  //card display UI
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 500,
                      child: cardData.isEmpty? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: cardModel(
                          cardType:  'N/A',
                          cardNUmber: 'N/A',
                          cardExpryDate: 'N/A',
                          cardHolderName:  'N/A',
                          cardBalance: '0',
                        ),
                      ): PageView.builder(
                        controller: cardController,
                        scrollDirection: Axis.horizontal,
                        itemCount: cardData.length,
                        itemBuilder: (BuildContext context, int index) {
                          cardIndex = index;
                          var card = cardData[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: cardModel(
                              cardType: card['brand'] ?? 'N/A',
                              cardNUmber: '${card['first_six']}*****${card['last_four']}',
                              cardExpryDate: card['expiry'] ?? 'N/A',
                              cardHolderName: card['name'] ?? 'N/A',
                              cardBalance: card['card_balance']?.toString() ?? '0',
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: 10,

                      child: SmoothPageIndicator(

                          controller: cardController,  // PageController
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

                  //wallet
                  Padding(
                    padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
                    child: Ink(
                      child: InkWell(
                        onTap: (){
                          VirtualWalletForm().walletDetailsModal(context);
                        },
                        child: Container(
                          height: 60,

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.red,Colors.green,Colors.green,Colors.blue],

                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(1.9),
                                child: Container(
                                  height: 60,

                                  decoration: BoxDecoration(


                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Text('Virtual Wallet:',
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize:12/textScaleFactor),
                                        ),
                                        const Spacer(),
                                        Text(
                                          formatCurrency(((virtualWalletBalance ?? 0).toDouble())) ,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,

                                            fontSize:12/textScaleFactor),),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 14,)
                                      ],
                                    ),
                                  ),

                                ),
                              )),

                        ),
                      ),
                    ),
                  ),

                  // Quick action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Create card
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:()async{

                               /* fetchAndDownloadBalances();*/
                                if(virtualWalletBalance > 60000){
                                  if (kYCStatus == false && submittedStatus == false)
                                  {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context)=>
                                        const BVNandNINDetails()
                                    )
                                    );
                                  }
                                  else if (kYCStatus == false && submittedStatus == true) {
                                    AnimatedSnackBar(builder: (BuildContext context) {
                                      return IntrinsicHeight(
                                        child: Container(
                                          width: screenWidth/1.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.black
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Awaiting KYC approval',style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 12/textScaleFactor,
                                                        fontWeight: FontWeight.w900),)
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text("We're currently reviewing your document, this can take up to 4 - 72 hours",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.inter(
                                                            color: Colors.white,

                                                            fontSize: 8/textScaleFactor,
                                                            fontWeight: FontWeight.w200),),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );

                                    }).show(context);
                                    setState(() {
                                    });

                                  }
                                  else if(kYCStatus == true && submittedStatus == true)
                                  {
                                    //KYC verification passed.... get new card

                                    if(kCreatingCardUser ==true){
                                      setState(() {
                                        kCreatingCardUser = false;
                                      });
                                      await currencyConverterNGToUSD();
                                      await currencyConverterUSDToNG();
                                      //Get customer ID to determine if user is
                                      await fetchCustomerDetails(callState);


                                      setState(() {
                                        kCreatingCardUser = true;
                                      });
                                      //call bottom sheet form after the above function
                                      if(context.mounted){CreateCardClass().createCardModal(context);}
                                      print('Getting new card');
                                    }



                                  }
                                } else {
                                  //KYC verification passed.... get new card

                                  if(kCreatingCardUser ==true){
                                    setState(() {
                                      kCreatingCardUser = false;
                                    });
                                    await currencyConverterNGToUSD();
                                    await currencyConverterUSDToNG();
                                    //Get customer ID to determine if user is
                                    await fetchCustomerDetails(callState);


                                    setState(() {
                                      kCreatingCardUser = true;
                                    });
                                    //call bottom sheet form after the above function
                                    if(context.mounted){CreateCardClass().createCardModal(context);}
                                    print('Getting new card');
                                  }



                                }

                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child:  kCreatingCardUser == false ? const SizedBox(
                                  height: 5,
                                  width: 5,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.black,),
                                ) : const Icon(Icons.create),
                              ),
                            ),
                            Text('New Card',style: TextStyle(color: kbottomNavigationIconcolor))
                          ],
                        ),
                      ),

                      //Fund
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(virtualWalletBalance > 60000){
                                  if (kYCStatus == false && submittedStatus == false)
                                  {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context)=>
                                        const BVNandNINDetails()
                                    )
                                    );
                                  }
                                  else if (kYCStatus == false && submittedStatus == true) {
                                    AnimatedSnackBar(builder: (BuildContext context) {
                                      return IntrinsicHeight(
                                        child: Container(
                                          width: screenWidth/1.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.black
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Awaiting KYC approval',style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 12/textScaleFactor,
                                                        fontWeight: FontWeight.w900),)
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text("We're currently reviewing your document, this can take up to 4 - 72 hours",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.inter(
                                                            color: Colors.white,

                                                            fontSize: 8/textScaleFactor,
                                                            fontWeight: FontWeight.w200),),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );

                                    }).show(context);
                                    setState(() {
                                    });

                                  }
                                  else if(kYCStatus == true && submittedStatus == true)
                                  {
                                    if(cardIndex!= -1){
                                    if(cardData[cardIndex]['isFrozen'] == false){
                                      totalFundAmount=0;
                                      topAmount.text ='';
                                      cardModel model = cardModel(cardType: 'Visa', cardNUmber: '5429-9873-7896-1124', cardExpryDate: '05/26', cardHolderName: 'CHIAGOZIE EJIOFOR', cardBalance: '',);
                                      FundCardClass fundCardClassInstance = FundCardClass(model);
                                      fundCardClassInstance.fundCardModal(context);
                                    }
                                    else if (cardData[cardIndex]['isFrozen'] == null) {
                                      totalFundAmount=0;
                                      topAmount.text ='';
                                      cardModel model = cardModel(cardType: 'Visa', cardNUmber: '5429-9873-7896-1124', cardExpryDate: '05/26', cardHolderName: 'CHIAGOZIE EJIOFOR', cardBalance: '',);
                                      FundCardClass fundCardClassInstance = FundCardClass(model);
                                      fundCardClassInstance.fundCardModal(context);
                                    }
                                    else {
                                      AnimatedSnackBar(
                                          builder: (BuildContext context) {
                                            return IntrinsicHeight(
                                              child: Container(
                                                width: screenWidth/1.1,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.black
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Card is Frozen',style: GoogleFonts.inter(
                                                              color: Colors.white,
                                                              fontSize: 12/textScaleFactor,
                                                              fontWeight: FontWeight.w900),)
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Text("You can't fund a Frozen Card!, Can we?",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.inter(
                                                                  color: Colors.white,

                                                                  fontSize: 8/textScaleFactor,
                                                                  fontWeight: FontWeight.w200),),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );

                                          }).show(context);
                                      setState(() {});
                                    }

                                  }
                                  else{
                                    AnimatedSnackBar(
                                        builder: (BuildContext context) {
                                          return IntrinsicHeight(
                                            child: Container(
                                              width: screenWidth/1.1,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.black
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('No Card Found',style: GoogleFonts.inter(
                                                            color: Colors.white,
                                                            fontSize: 12/textScaleFactor,
                                                            fontWeight: FontWeight.w900),)
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Text("You can't fund a non existing card!, Can we?",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                                color: Colors.white,

                                                                fontSize: 8/textScaleFactor,
                                                                fontWeight: FontWeight.w200),),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );

                                        }).show(context);
                                    setState(() {});
                                  }
                                  }
                                }
                                else{

                                  if(cardIndex!= -1){
                                    if(cardData[cardIndex]['isFrozen'] == false){
                                      totalFundAmount=0;
                                      topAmount.text ='';
                                      cardModel model = cardModel(cardType: 'Visa', cardNUmber: '5429-9873-7896-1124', cardExpryDate: '05/26', cardHolderName: 'CHIAGOZIE EJIOFOR', cardBalance: '',);
                                      FundCardClass fundCardClassInstance = FundCardClass(model);
                                      fundCardClassInstance.fundCardModal(context);
                                    }
                                    else if (cardData[cardIndex]['isFrozen'] == null) {
                                      totalFundAmount=0;
                                      topAmount.text ='';
                                      cardModel model = cardModel(cardType: 'Visa', cardNUmber: '5429-9873-7896-1124', cardExpryDate: '05/26', cardHolderName: 'CHIAGOZIE EJIOFOR', cardBalance: '',);
                                      FundCardClass fundCardClassInstance = FundCardClass(model);
                                      fundCardClassInstance.fundCardModal(context);
                                    }
                                    else {
                                      AnimatedSnackBar(
                                          builder: (BuildContext context) {
                                            return IntrinsicHeight(
                                              child: Container(
                                                width: screenWidth/1.1,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.black
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Card is Frozen',style: GoogleFonts.inter(
                                                              color: Colors.white,
                                                              fontSize: 12/textScaleFactor,
                                                              fontWeight: FontWeight.w900),)
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Text("You can't fund a Frozen Card!, Can we?",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.inter(
                                                                  color: Colors.white,

                                                                  fontSize: 8/textScaleFactor,
                                                                  fontWeight: FontWeight.w200),),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );

                                          }).show(context);
                                      setState(() {});
                                    }

                                  }
                                  else{
                                    AnimatedSnackBar(
                                        builder: (BuildContext context) {
                                          return IntrinsicHeight(
                                            child: Container(
                                              width: screenWidth/1.1,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.black
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('No Card Found',style: GoogleFonts.inter(
                                                            color: Colors.white,
                                                            fontSize: 12/textScaleFactor,
                                                            fontWeight: FontWeight.w900),)
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Text("You can't fund a non existing card!, Can we?",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                                color: Colors.white,

                                                                fontSize: 8/textScaleFactor,
                                                                fontWeight: FontWeight.w200),),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );

                                        }).show(context);
                                    setState(() {});
                                  }
                                }


                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            Text('Fund',style: TextStyle(color: kbottomNavigationIconcolor),)
                          ],
                        ),
                      ),

                      //Withdraw
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if (virtualWalletBalance > 60000){
                                  if (kYCStatus == false && submittedStatus == false)
                                  {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context)=>
                                        const BVNandNINDetails()
                                    )
                                    );
                                  }
                                  else if (kYCStatus == false && submittedStatus == true) {
                                    AnimatedSnackBar(builder: (BuildContext context) {
                                      return IntrinsicHeight(
                                        child: Container(
                                          width: screenWidth/1.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.black
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Awaiting KYC approval',style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 12/textScaleFactor,
                                                        fontWeight: FontWeight.w900),)
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text("We're currently reviewing your document, this can take up to 4 - 72 hours",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.inter(
                                                            color: Colors.white,

                                                            fontSize: 8/textScaleFactor,
                                                            fontWeight: FontWeight.w200),),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );

                                    }).show(context);
                                    setState(() {
                                    });

                                  }
                                  else if(kYCStatus == true && submittedStatus == true)
                                  {
                                    if(cardData[cardIndex]['isFrozen'] == false){
                                      setState(() {
                                        totalFundAmount=0;
                                        withdrawCardAmount.text ='';
                                      });
                                      cardModel model = cardModel(cardType: 'Visa',
                                        cardNUmber: '5429-9873-7896-1124',
                                        cardExpryDate: '05/26',
                                        cardHolderName: 'CHIAGOZIE EJIOFOR',
                                        cardBalance: '',);
                                      WithdrawCardClass withdrawCardClassInstance = WithdrawCardClass(model);
                                      withdrawCardClassInstance.withdrawFromCardModal(context);
                                    }
                                    else if (cardData[cardIndex]['isFrozen'] == null) {
                                      setState(() {
                                        totalFundAmount=0;
                                        withdrawCardAmount.text ='';
                                      });
                                      cardModel model = cardModel(cardType: 'Visa',
                                        cardNUmber: '5429-9873-7896-1124',
                                        cardExpryDate: '05/26',
                                        cardHolderName: 'CHIAGOZIE EJIOFOR',
                                        cardBalance: '',);
                                      WithdrawCardClass withdrawCardClassInstance = WithdrawCardClass(model);
                                      withdrawCardClassInstance.withdrawFromCardModal(context);
                                    }
                                    else{

                                      AnimatedSnackBar(
                                          builder: (BuildContext context) {
                                            return IntrinsicHeight(
                                              child: Container(
                                                width: screenWidth/1.1,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.black
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Card is Frozen',style: GoogleFonts.inter(
                                                              color: Colors.white,
                                                              fontSize: 12/textScaleFactor,
                                                              fontWeight: FontWeight.w900),)
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Text("You can't withdraw a Frozen Card!, Uuh!?",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.inter(
                                                                  color: Colors.white,

                                                                  fontSize: 8/textScaleFactor,
                                                                  fontWeight: FontWeight.w200),),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );

                                          }).show(context);
                                      setState(() {});

                                    }
                                  }
                                }
                                else{
                                  if(cardData[cardIndex]['isFrozen'] == false){
                                    setState(() {
                                      totalFundAmount=0;
                                      withdrawCardAmount.text ='';
                                    });
                                    cardModel model = cardModel(cardType: 'Visa',
                                      cardNUmber: '5429-9873-7896-1124',
                                      cardExpryDate: '05/26',
                                      cardHolderName: 'CHIAGOZIE EJIOFOR',
                                      cardBalance: '',);
                                    WithdrawCardClass withdrawCardClassInstance = WithdrawCardClass(model);
                                    withdrawCardClassInstance.withdrawFromCardModal(context);
                                  }
                                  else if (cardData[cardIndex]['isFrozen'] == null) {
                                    setState(() {
                                      totalFundAmount=0;
                                      withdrawCardAmount.text ='';
                                    });
                                    cardModel model = cardModel(cardType: 'Visa',
                                      cardNUmber: '5429-9873-7896-1124',
                                      cardExpryDate: '05/26',
                                      cardHolderName: 'CHIAGOZIE EJIOFOR',
                                      cardBalance: '',);
                                    WithdrawCardClass withdrawCardClassInstance = WithdrawCardClass(model);
                                    withdrawCardClassInstance.withdrawFromCardModal(context);
                                  }
                                  else{

                                    AnimatedSnackBar(
                                        builder: (BuildContext context) {
                                          return IntrinsicHeight(
                                            child: Container(
                                              width: screenWidth/1.1,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.black
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Card is Frozen',style: GoogleFonts.inter(
                                                            color: Colors.white,
                                                            fontSize: 12/textScaleFactor,
                                                            fontWeight: FontWeight.w900),)
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Text("You can't withdraw a Frozen Card!, Uuh!?",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                                color: Colors.white,

                                                                fontSize: 8/textScaleFactor,
                                                                fontWeight: FontWeight.w200),),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );

                                        }).show(context);
                                    setState(() {});

                                  }
                                }


                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.remove),
                              ),
                            ),
                            Text('Withdraw',style: TextStyle(color: kbottomNavigationIconcolor))
                          ],
                        ),
                      ),

                      //Freeze
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:(){
                                freezeOrTerminate(context);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.ac_unit),
                              ),
                            ),
                            Text('Freeze',style: TextStyle(color: kbottomNavigationIconcolor))
                          ],
                        ),
                      ),


                    ],
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 32,left: 24,right: 24,bottom: 8),
                    child: Row(
                      children: [
                        Text('Transaction history',style: TextStyle(
                            color: kbottomNavigationIconcolor)),
                        const Spacer(),
                        Text('See all',
                          style: GoogleFonts.inter(color: Colors.red),),
                      ],
                    ),
                  ),// label

                  //Transactions list
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: balanceHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      final history = balanceHistory[index];
                      final incrementAmount = history['incrementAmount'];
                      final type = history['type'];
                      final newBalance = history['newBalance'];
                      // Check if 'timestamp' exists and is a Timestamp before casting
                      final timestamp = (history['timestamp'] is Timestamp)
                          ? (history['timestamp'] as Timestamp).toDate()
                          : DateTime.now();

                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ListTile(
                          leading: type == 'debit'?
                          Transform.scale(scaleY : -1,scaleX: -1,child: Icon(Icons.transit_enterexit,color: Colors.red,)):
                          Icon(Icons.transit_enterexit,color: Colors.green,) ,

                          title: type == 'debit'?
                          Text(
                            'Debit Successful',
                            style: TextStyle(color: kbottomNavigationIconcolor),
                          ):
                          Text(
                            'Funding Successful',
                            style: TextStyle(color: kbottomNavigationIconcolor),
                          ),
                          subtitle: Text(
                            timestamp.toLocal().toString().split(' ')[0],
                            style: GoogleFonts.inter(
                                color: kbottomNavigationIconcolor,
                                fontWeight: FontWeight.w300,
                                fontSize: 10/textScaleFactor)
                          ),
                          trailing: Text(
                            formatCurrency((incrementAmount.toDouble()) ?? 0.0),
                            style: TextStyle(
                                fontSize: 12/textScaleFactor,
                                color: kbottomNavigationIconcolor),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )


                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ktextColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.headset_mic_outlined,color: kbackgroundColorLightMode,),

            ],
          ),
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=> const ContactUs()));
          },),
      ),
    );
  }
}
