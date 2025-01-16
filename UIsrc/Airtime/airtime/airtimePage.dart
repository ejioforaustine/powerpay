import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/UIsrc/Airtime/Models/Models.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../Models/constants.dart';

class airtimePage extends StatefulWidget {
  const airtimePage({super.key});

  @override
  State<airtimePage> createState() => _airtimePageState();
}

class _airtimePageState extends State<airtimePage> {
  void updateAirtimeBundles (){
    setState(() {
    });
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
    return  Scaffold(
      backgroundColor: kbackgroundColorLightMode,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kbackgroundColorLightMode,
        leading:  GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back_ios_new,size: 20,color: ktextColor,)),
        title: Text('Airtime',style: GoogleFonts.kadwa(color: ktextColor,fontWeight: FontWeight.w600,fontSize: 20),),

      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header text
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 10),
              child: Row(children: [
                Text('Select Network',style: GoogleFonts.kadwa(color: ktextColor,fontWeight: FontWeight.w600,fontSize: 16),)
              ],),
            ),

            ///Network Providers
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 20),
              child: SizedBox(
                height: 200,
                child: GridView.count(
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
                  crossAxisCount: 2,children: [
                  GestureDetector(
                    onTap: (){
                      setState((){
                        networkImageNumber = 0;
                        networkProvider = 'MTN';
                        airtimeServiceID = 'mtn';
                        mtnBorderColor = Colors.yellow.shade600;
                        gloBorderColor = Colors.black;
                        nineMobileBorderColor = Colors.black;
                        airtelBorderColor = Colors.black;
                        //width logics
                        mtnBorderWidth = 3;
                        gloBorderWidth = 0.2;
                        nineMobileBorderWidth = 0.2;
                        airtelBorderWidth = 0.2;

                      });

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: mtnBorderColor,width: mtnBorderWidth),
                        borderRadius: BorderRadius.circular(16),),

                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Hero(
                            tag: 'networkProvider',
                            child: CircleAvatar(backgroundColor: Colors.transparent,
                              radius: 25,
                              backgroundImage: AssetImage(networkProviderImages[0].toString()),

                            ),
                          )

                        ],),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState((){
                        networkImageNumber = 1;
                        airtimeServiceID = 'glo';
                        networkProvider = 'GLO';
                        gloBorderColor = Colors.green.shade600;
                        mtnBorderColor = Colors.black;
                        nineMobileBorderColor = Colors.black;
                        airtelBorderColor = Colors.black;
                        //width logics
                         mtnBorderWidth = 0.2;
                         gloBorderWidth = 3;
                         nineMobileBorderWidth = 0.2;
                         airtelBorderWidth = 0.2;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: gloBorderColor,width: gloBorderWidth),
                        borderRadius: BorderRadius.circular(16),),

                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          CircleAvatar(backgroundColor: Colors.transparent,
                            radius: 25,
                            backgroundImage: AssetImage(networkProviderImages[1].toString()),

                          )

                        ],),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState((){
                        airtimeServiceID = 'etisalat';
                        networkImageNumber = 2;
                        networkProvider = '9Mobile';
                        nineMobileBorderColor = Colors.green.shade200;
                        gloBorderColor = Colors.black;
                        mtnBorderColor = Colors.black;
                        airtelBorderColor = Colors.black;
                        //width Logic
                        mtnBorderWidth = 0.2;
                        gloBorderWidth = 0.2;
                        nineMobileBorderWidth = 3;
                        airtelBorderWidth = 0.2;

                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: nineMobileBorderColor,width: nineMobileBorderWidth),
                        borderRadius: BorderRadius.circular(16),),

                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          CircleAvatar(backgroundColor: Colors.transparent,
                            radius: 25,
                            backgroundImage: AssetImage(networkProviderImages[2].toString()),

                          )

                        ],),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState((){
                        networkImageNumber = 3;
                        airtimeServiceID = 'airtel';
                        networkProvider = 'Airtel';
                        airtelBorderColor = Colors.red.shade200;
                        gloBorderColor = Colors.black;
                        mtnBorderColor = Colors.black;
                        nineMobileBorderColor = Colors.black;
                        //width logic
                         mtnBorderWidth = 0.2;
                         gloBorderWidth = 0.2;
                         nineMobileBorderWidth = 0.2;
                         airtelBorderWidth = 3;

                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: airtelBorderColor,width: airtelBorderWidth),
                        borderRadius: BorderRadius.circular(16),),

                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          CircleAvatar(backgroundColor: Colors.transparent,
                            radius: 25,
                            backgroundImage: AssetImage(networkProviderImages[3].toString()),

                          )

                        ],),),
                    ),
                  ),
                ],),
              ),
            ),//

            ///Airtime Input Form
            const Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 16,),
              child: SizedBox(
                  height: 200,

                  child: AirtimeForm()),
            ),

            ///Proceed Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                  });
                  airtimePhoneNumber =AirtimeForm.textEditingControllerAirtimePhoneNo.text;
                  airtimeAmount = AirtimeForm.textEditingControllerAirtime.text;
                  if (airtimeAmount.toString().isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.red.shade800,
                        content:
                        const Center(child: Text("Amount can't be empty"))),
                  );}else if(airtimePhoneNumber.toString().isEmpty){

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red.shade800,
                          content:
                          const Center(child: Text("Number can't be empty"))),
                    );
                  }else if (airtimePhoneNumber.toString().length < 11){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red.shade800,
                          content:
                          const Center(child: Text('Enter up to 11 digits number'))),
                    );
                  }
                  else if (networkProvider.toString().isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red.shade800,
                          content:
                          const Center(child: Text('Please select your network provider'))),
                    );
                  }

                  else{
                    airtimeAmount = int.parse(AirtimeForm.textEditingControllerAirtime.text);
                    AirtimeOrderSummary.showOrderSummary(context,updateAirtimeBundles);
                  }

                },

                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),


    );
  }
}



