import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/Core/Functions/BuyPowerservice/buyPowerApi.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/UIsrc/settings/EditProfile.dart';
import 'package:powerpay/UIsrc/Authentication/Signin.dart';
import 'package:powerpay/legal/TermsOfUse.dart';
import 'package:powerpay/UIsrc/Receipt/History/purchase%20History.dart';
import 'package:powerpay/Wallet/walletFunctions.dart';
import 'package:powerpay/testing/Api%20testings.dart';
import '../../Core/Functions/FlutterWaveData&AirtimeWalletFunc/Data_andAirtimeWalletFunction.dart';
import '../../KYC/BVN.dart';
import '../../UIKonstant/KUiComponents.dart';
import 'FAQ.dart';
import '../../FireBaseAuth/2ndAuthService.dart';
import '../../Wallet/walletHistory.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

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



  String sanitizeEmail(String email) {
    return email.replaceAll('.', '_'); // Replace '.' with ','
  }
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
  @override
  void initState(){
    super.initState();
    createKYCCollection(userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:  SystemUiOverlayStyle(
            statusBarColor: kbackgroundColorLightMode,
            statusBarIconBrightness: StatusIcon),
        child: Scaffold(
          backgroundColor: kbackgroundColorLightMode,
            body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: ()async{
                     /*await PayBEDCWithBuyPower(
                          buyPowerAmount: 600,
                          meterNumberBuyPower: 95300739539,
                          discoProviderBuyPower: 'ABUJA',
                          discoTypeBP: 'PREPAID'
                      ).verifyMeter();*/
                     /*PayBEDCWithBuyPower(
                       buyPowerAmount: 600,
                       meterNumberBuyPower: 95300739539,
                       discoProviderBuyPower: 'ABUJA',
                       discoTypeBP: 'PREPAID',).vendMeter();*/
                      print('ongoing');
                      fetchBalances('FLWSECK-7e896c05e94ab8fe1901d9001aceaa0d-192ca1543b1vt-X');
                     /*adminPolicyWithdrawal('', 400,'');*/
                      /*startGettingEmails();*/
                    },
                    child: Text(
                      'Account',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.w900,
                          color: ktextColor,
                          fontSize: 20*MediaQuery.of(context).size.height/768),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20*MediaQuery.of(context).size.height/768,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const editProfile()));
                    },
                    child: Container(
                      height: 70*MediaQuery.of(context).size.height/768,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                 Icon(
                                  Iconsax.profile_circle,
                                  color: ktextColor,
                                  size: 25*MediaQuery.of(context).size.height/768,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text('Profile',style: TextStyle(color: ktextColor),),
                                    ),
                                  ],
                                ),
                               const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Iconsax.edit,
                                    color: ktextColor,
                                    size: 20*MediaQuery.of(context).size.height/768,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), //edit profile
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PurchaseHistory()));
                    },
                    child: Container(
                      height: 70*MediaQuery.of(context).size.height/768,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                 Icon(
                                  Iconsax.receipt4,
                                  color: ktextColor,
                                  size: 25*MediaQuery.of(context).size.height/768,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [
                                    Text('  Purchase History',style: TextStyle(color: ktextColor),),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Iconsax.arrow_circle_right,
                                    color: ktextColor,
                                    size: 25*MediaQuery.of(context).size.height/768,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), //Purchase history

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if(kYCStatus == false && submittedStatus == false ){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BVNandNINDetails()));
                      }
                      else if (kYCStatus== true && submittedStatus == true){

                        AnimatedSnackBar(
                          builder: ((context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black,),

                              height: 50,
                              child: Center(child: Text(
                                'KYC Details Approved',
                                style: GoogleFonts.inter(color: Colors.white),)),
                            );
                          }),
                        ).show(context);
                        setState(() {});
                      }
                      else{
                        AnimatedSnackBar(
                          builder: ((context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,),

                              height: 50,
                              child: Center(child: Text(
                                'KYC DETAILS SUBMITTED',
                                style: GoogleFonts.inter(color: Colors.white),)),
                            );
                          }),
                        ).show(context);
                        setState(() {});
                      }

                    },
                    child: Container(
                      height: 70*MediaQuery.of(context).size.height/768,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.document,
                                  color: ktextColor,
                                  size: 25*MediaQuery.of(context).size.height/768,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [
                                    Text('  KYC VERICATION',style: TextStyle(color: ktextColor),),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Iconsax.arrow_circle_right,
                                    color: ktextColor,
                                    size: 25*MediaQuery.of(context).size.height/768,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),//KYC

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const walletHistory()));
                    },
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                 Icon(
                                  Iconsax.empty_wallet_time,
                                  color: ktextColor,
                                  size: 25*MediaQuery.of(context).size.height/768,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [
                                    Text('  Wallet History',style: TextStyle(color: ktextColor),),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Iconsax.arrow_circle_right,
                                    color: ktextColor,
                                    size: 25*MediaQuery.of(context).size.height/768,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), //wallet history

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Faq()));
                    },
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                 Icon(
                                  Iconsax.message_question,
                                  color:ktextColor,
                                  size: 25*MediaQuery.of(context).size.height/768,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [
                                    Text('  FAQ',style: TextStyle(color: ktextColor),),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Iconsax.arrow_circle_right,
                                    color: ktextColor,
                                    size: 25*MediaQuery.of(context).size.height/768,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), //FAQ



                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: (){},
                  child: Text(
                    'version 4.2.0',
                    style: GoogleFonts.pacifico(
                      color: ktextColor,
                        fontSize: 13*MediaQuery.of(context).size.height/768, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      CustomAuthProvider().logOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      height: 50*MediaQuery.of(context).size.height/768,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.amber),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.kadwa(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const termsandconditions(url: 'https://powerpay.com.ng/terms-and-conditions/'),
                      ),
                    );
                  },
                  child: Text(
                    'Terms & condition',
                    style: GoogleFonts.pacifico(
                      color: ktextColor,
                        fontSize: 13*MediaQuery.of(context).size.height/768, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}
