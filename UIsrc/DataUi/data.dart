import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/ServiceHostData&AirtimeFunction/DataFunction.dart';
import 'package:powerpay/Core/Functions/ServiceHostData&AirtimeFunction/constant_variables.dart';
import 'package:powerpay/UIsrc/DataUi/models/models.dart';

import '../../Core/Functions/constantvaribles.dart';
import '../../UIKonstant/KUiComponents.dart';
import '../Airtime/Models/constants.dart';
import 'models/constant.dart';

class InternetDataPage extends StatefulWidget {
  const InternetDataPage({super.key});

  @override
  State<InternetDataPage> createState() => _InternetDataPageState();
}

class _InternetDataPageState extends State<InternetDataPage> {
  final _formKey = GlobalKey<FormState>();
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();
  final TextEditingController _phoneDataController = TextEditingController();

  void updateBundle() {
    setState(() {});
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
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kbackgroundColorLightMode,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: ktextColor,
            )),
        title: GestureDetector(
          onTap: () {
            assignThis();
            saveDataTransaction();
          },
          child: Text(
            'Internet Data',
            style: GoogleFonts.kadwa(
                color: ktextColor, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // Header text
              Padding(
                padding:
                    EdgeInsets.only(left: 20, top: screenHeight * 30 / 768),
                child: Row(
                  children: [
                    Text(
                      'Select Network',
                      style: GoogleFonts.kadwa(
                          color: ktextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
              ),

              ///Network Providers
              Padding(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: screenHeight * 8 / 768,
                    bottom: screenHeight * 20 / 768),
                child: SizedBox(
                  height: screenHeight * 200 / 768,
                  child: GridView.count(
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2,
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            //clear data list by any selection
                            dataBundles = [];
                            dataPrice = [];
                            dataVariationCode = [];
                            selectedBundlePackageName = '';
                            selectedBundlePackageAmount = 0;
                            selectedBundleVariationCode = '';
                            isDataBundleLoaded =
                                false; // bool to logic loading bar
                            //declare variables by selection
                            networkImageNumber = 0;
                            dataServiceID = 'mtn-data';
                            dataNetworkProvider = 'MTN';
                            dataGloBorderColor = Colors.black;
                            dataMtnBorderColor = Colors.yellow.shade600;
                            dataNineMobileBorderColor = Colors.black;
                            dataAirtelBorderColor = Colors.black;

                            ///width Logic
                            dataMtnBorderWidth = 3;
                            dataGloBorderWidth = 0.2;
                            dataNineMobileBorderWidth = 0.2;
                            dataAirtelBorderWidth = 0.2;
                          });
                          //Lets fetch Bundle data packages
                          await DataSubscription.getDataBundles(context)
                              .then((value) => {
                                    isDataBundleLoaded = true,
                                  });
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: dataMtnBorderColor,
                                width: dataMtnBorderWidth),
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      'assets/images/AirtimeAssets/mtn.png'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            ///clear data list bundles by selection
                            dataPrice = [];
                            dataBundles = [];
                            dataVariationCode = [];
                            selectedBundlePackageName = '';
                            selectedBundlePackageAmount = 0;
                            selectedBundleVariationCode = '';
                            isDataBundleLoaded = false;

                            ///Declare variables by selection
                            networkImageNumber = 1;
                            dataServiceID = 'glo-data';
                            dataNetworkProvider = 'Glo';
                            dataGloBorderColor = Colors.green.shade600;
                            dataMtnBorderColor = Colors.black;
                            dataNineMobileBorderColor = Colors.black;
                            dataAirtelBorderColor = Colors.black;

                            ///width Logic
                            dataMtnBorderWidth = 0.2;
                            dataGloBorderWidth = 3;
                            dataNineMobileBorderWidth = 0.2;
                            dataAirtelBorderWidth = 0.2;
                          });
                          //Lets fetch Bundle data packages
                          await DataSubscription.getDataBundles(context)
                              .then((value) => {
                                    isDataBundleLoaded = true,
                                  });
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: dataGloBorderColor,
                                width: dataGloBorderWidth),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      'assets/images/AirtimeAssets/Glo_Limited.png'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            ///clear data list bundles by selection
                            dataPrice = [];
                            dataBundles = [];
                            dataVariationCode = [];
                            selectedBundlePackageName = '';
                            selectedBundlePackageAmount = 0;
                            selectedBundleVariationCode = '';
                            isDataBundleLoaded = false;

                            ///Declare variables by selection
                            networkImageNumber = 2;
                            dataServiceID = 'etisalat-data';
                            dataNetworkProvider = '9mobile';
                            dataGloBorderColor = Colors.black;
                            dataMtnBorderColor = Colors.black;
                            dataNineMobileBorderColor = Colors.green.shade200;
                            dataAirtelBorderColor = Colors.black;

                            ///width Logic
                            dataMtnBorderWidth = 0.2;
                            dataGloBorderWidth = 0.2;
                            dataNineMobileBorderWidth = 3;
                            dataAirtelBorderWidth = 0.2;
                          });
                          //Lets fetch Bundle data packages
                          await DataSubscription.getDataBundles(context)
                              .then((value) => {
                                    isDataBundleLoaded = true,
                                  });
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: dataNineMobileBorderColor,
                                width: dataNineMobileBorderWidth),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      'assets/images/AirtimeAssets/9mobile-Logo.png'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            ///clear data list bundles by selection
                            dataPrice = [];
                            dataBundles = [];
                            dataVariationCode = [];
                            selectedBundlePackageName = '';
                            selectedBundlePackageAmount = 0;
                            selectedBundleVariationCode = '';
                            isDataBundleLoaded = false;

                            ///Declare variables by selection
                            networkImageNumber = 3;
                            dataServiceID = 'airtel-data';
                            dataNetworkProvider = 'Airtle';
                            dataGloBorderColor = Colors.black;
                            dataMtnBorderColor = Colors.black;
                            dataNineMobileBorderColor = Colors.black;
                            dataAirtelBorderColor = Colors.red.shade500;

                            ///width Logic
                            dataMtnBorderWidth = 0.2;
                            dataGloBorderWidth = 0.2;
                            dataNineMobileBorderWidth = 0.2;
                            dataAirtelBorderWidth = 3;
                          });
                          //Lets fetch Bundle data packages
                          await DataSubscription.getDataBundles(context)
                              .then((value) => {
                                    isDataBundleLoaded = true,
                                  });
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: dataAirtelBorderColor,
                                width: dataAirtelBorderWidth),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      'assets/images/AirtimeAssets/Airtel.png'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), //

              ///Data Input Form
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: screenHeight * 16 / 768,
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _phoneDataController,
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: ktextColor),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      return (
                          value == null ||
                              value.isEmpty ||
                              value.length < 11||
                          value.contains('.') ||
                          value.contains('-')
                              )
                          ? 'Your Phone Number Must be up to 11 digits'
                          : null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.45),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16)),
                      fillColor: kbackgroundColorLightMode,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: ktextColor.withOpacity(0.5),
                      ),
                      labelText: 'Phone Number',
                      labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.normal, color: ktextColor),
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ), // Phone Number
              ),

              ///data Bundles
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                    top: screenHeight * 16 / 768,
                    bottom: screenHeight * 50 / 768),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ktextColor, width: 0.5)),
                  child: Theme(
                    data: ThemeData(
                        splashColor: Colors.transparent,
                        dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      controller: _expansionTileController,
                      childrenPadding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: isDataBundleLoaded
                          ? selectedBundlePackageName == ''
                              ? Text(
                                  'Data Bundle',
                                  style: GoogleFonts.lato(color: ktextColor),
                                )
                              : Text(
                                  selectedBundlePackageName,
                                  style: GoogleFonts.lato(color: ktextColor),
                                )
                          : UnconstrainedBox(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.amber.shade800,
                                    strokeWidth: 3,
                                  )),
                            ),
                      initiallyExpanded: false,
                      iconColor: ktextColor,
                      collapsedIconColor: ktextColor,
                      children: [
                        SizedBox(
                          height: dataBundles.isEmpty
                              ? screenHeight * 50 / 768
                              : screenHeight * 200 / 768,
                          child: dataBundles.isEmpty
                              ? Center(
                                  child: Opacity(
                                  opacity: 0.4,
                                  child: Text(
                                    'Please Select Your Network Provider',
                                    style: TextStyle(color: ktextColor),
                                  ),
                                ))
                              : ListView.builder(
                                  itemCount: dataBundles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        _expansionTileController.collapse();
                                        setState(() {
                                          discountAmountData = (double.parse(
                                                  dataPrice[index].toString()) *
                                              0.01);
                                          selectedBundleVariationCode =
                                              dataVariationCode[index]
                                                  .toString();
                                          selectedBundlePackageName =
                                              dataBundles[index].toString();
                                          selectedBundlePackageAmount =
                                              double.parse(dataPrice[index]
                                                      .toString()) -
                                                  (discountAmountData);
                                          formattedAmountValue = formatDouble(
                                              selectedBundlePackageAmount);
                                        });
                                      },
                                      child: Ink(
                                        child: Card(
                                          color: kbackgroundColorLightMode,
                                          elevation: 0,
                                          child: ListTile(
                                            minLeadingWidth: 40,
                                            leading: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(dataBundles[index],
                                                    style: GoogleFonts.lato(
                                                        color: ktextColor))),
                                            trailing: Text(dataPrice[index],
                                                style: GoogleFonts.lato(
                                                    color: ktextColor)),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              ///Proceed Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      dataPhoneNUmber = _phoneDataController.text.toString();
                      DataOrderSummary.showOrderSummary(context, updateBundle);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.red.shade800,
                            content:
                                const Center(child: Text('Invalid Number'))),
                      );
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
      ),
    );
  }
}
