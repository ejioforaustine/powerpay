import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'dart:convert';

import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/UIsrc/home/Home.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
String testKeys = 'ps_pk_test_Ml4v5zTgD6LDcCpx8vdZ7ycO0y3yBm';
String baseUrl = 'https://api.payscribe.ng/api/v1';
String url = 'https://sandbox.payscribe.ng/api/v1/customers/create';
String virtualAccountUrl = 'https://sandbox.payscribe.ng/api/v1/collections/virtual-accounts/create';
String createCardUrl = 'https://sandbox.payscribe.ng/api/v1/cards/create';

///create virtual card user
Future<void> createVirtualCardUser(String usersName, String usersPhone, String userEmail) async {
  // The URL of your deployed Cloud Function
  const cloudFunctionUrl = 'https://us-central1-polectro-60b65.cloudfunctions.net/createVirtualCardUser';

  // Request body
  Map<String, dynamic> requestBody = {
    "usersName": usersName,
    "usersPhone": usersPhone,
    "userEmail": userEmail,
  };

  try {
    // Send HTTP request to the cloud function
    final response = await http.post(
      Uri.parse(cloudFunctionUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print("Virtual card created successfully");
    } else {
      print("Failed to create virtual card: ${response.statusCode}");
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}

//upgrade customer to tier 1
Future<void> upgradeCustomer () async {
  var headers = {
    'Authorization': 'Bearer $testKeys'
  };
  var request = http.Request('PATCH', Uri.parse('https://sandbox.payscribe.ng/api/v1/customers/create/tier1'));
  request.body = '''
  {\r\n    "customer_id": "$customerID",\r\n 
     "dob": "1990-06-20",\r\n   
     "address": {\r\n        "street": "No 16, Adazi Nnukwu odeku street, victoria island",\r\n        
     "city": "Ojota",\r\n        
     "state": "Lagos",\r\n        
     "country": "NG",\r\n        
     "postal_code": "882700"\r\n    },\r\n    
     "identification_type": "BVN",\r\n    
     "identification_number": "22288771100",\r\n    
     "photo": "http://placeimg.com/640/480"\r\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }

}


// create a new card
Future<void> createVirtualCard(BuildContext context,
    String bodyMessage,
    Function () callState,
    String headerMessage) async {
  var requestBody = {
    "customerId": customerID,
    "equivalentAmount": totalFundAmount,
    "cardBrand": cardBrand,
    "topAmount": topAmount.text,
    "userEmail": userEmail, // Pass the user's email
  };

  var url = 'https://us-central1-polectro-60b65.cloudfunctions.net/createVirtualCard';

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(requestBody),
  );

  if (response.statusCode == 200) {
    if(context.mounted){
      AnimatedSnackBar(builder: (context) {
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
                      Text(headerMessage,style: GoogleFonts.inter(
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
                        child: Text(bodyMessage,
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
    }
    callState();
    print('Card details saved successfully.');
  } else {
    if(context.mounted){
      AnimatedSnackBar(builder: (context) {
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
                      Text('Error creating card',style: GoogleFonts.inter(
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
                        child: Text("Couldn't complete Operation, Try again Later!",
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
    }
    print('Failed to create virtual card: ${response.body}');
  }
}


//Get virtual account details
Future<void> getVirtualAccount() async {
  var headers = {
    'Authorization': 'Bearer ps_pk_test_Ml4v5zTgD6LDcCpx8vdZ7ycO0y3yBm'
  };
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://sandbox.payscribe.ng/api/v1/account/?username=$userEmail'));
  request.body = '''''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}


///Fetch users balance from firestore and transactions
Future<dynamic> getWalletBalanceVirtual(String userEmail, Function() callState) async {
  const String functionUrl = 'https://us-central1-polectro-60b65.cloudfunctions.net/getWalletBalance';

  try {
    // Make a GET request to the Cloud Function with the userEmail as a query parameter
    final response = await http.get(Uri.parse('$functionUrl?userEmail=$userEmail'));
    print("initial resoponse");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("tried.....getting balance");
      print(responseData);
      if (responseData['success'] == true) {
        virtualWalletBalance = responseData['balance'] ?? 0.0;
        print("tried.....setting balance");

        // Update UI or state
        callState();
        return virtualWalletBalance;
      } else {
        print('Error fetching balance: ${responseData['message']}');
        return null;
      }
    } else {
      print('Server error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching balance: $e');
    return null;
  }
}

Future<dynamic> fetchVirtualWalletDetails(String userEmail, Function() callState) async {
  final url = Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/getWalletDetails?userEmail=$userEmail');


  try {

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      virtualAccountNumber = data['virtualAccountDetails']['accountNumber'];
      virtualBankName = data['virtualAccountDetails']['bankName'];
      virtualAccountName =  data['virtualAccountDetails']['accountName'];
      return data['virtualAccountDetails'];
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error fetching wallet details: $e');
    return null;
  }
}


Future<List<Map<String, dynamic>>?> fetchWalletBalanceHistory(String userEmail, Function() callState) async {
  // Replace with your actual Cloud Function URL
  final url = Uri.parse('https://us-central1-polectro-60b65.cloudfunctions.net/getWalletBalanceHistory?userEmail=$userEmail');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> balanceHistory2 = List<Map<String, dynamic>>.from(data['balanceHistory']);
      balanceHistory = balanceHistory2;

      callState();
      return balanceHistory2;
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error fetching wallet balance history: $e');
    return null;
  }
}


/// fetch virtual cards
Future<void> fetchCardData(Function() callState) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(userEmail)
        .collection('cards')
        .get();

    List<Map<String, dynamic>> cards = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();


      cardData = cards;

      print(cardData);
      callState;

  } catch (e) {
    if (kDebugMode) {
      print('Error fetching card data: $e');
    }
  }
}

///fetch customer details

Future<void> fetchCustomerDetails (Function() callState) async {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  QuerySnapshot snapshot = await firestore.collection('users')
      .doc(userEmail)
      .collection('Customer Profile Virtual card').get();

  if (snapshot.docs.isNotEmpty){
    DocumentSnapshot snapshotDoc = snapshot.docs.first;
    customerID = snapshotDoc['customer_id'];

    if(customerID == null) {
      await createVirtualCardUser(usersName,usersPhone,userEmail!,);
    }
    else {
      //customer already exist so do nothing
    }
    print(customerID);
  }
  else {
    await createVirtualCardUser(usersName,usersPhone,userEmail!,);
  }

  
}


// Fetch card details
Future<void> fetchAndStoreCardDetails(String userEmail, String cardId) async {
  const url = 'https://us-central1-polectro-60b65.cloudfunctions.net/getStoreCardDetails';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'userEmail': userEmail,
      'cardId': cardId,
    }),
  );

  if (response.statusCode == 200) {
    print("Card details fetched and stored successfully.");
  } else {
    print("Failed to fetch card details: ${response.body}");
  }
}

