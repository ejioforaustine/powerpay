import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/Core/Functions/Api-calls.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/createVirtualCustomer.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../../Kvirtual constant.dart';
//Fetch card Balance
Future<dynamic> fetchVirtualCardBalance ()async {

  var headers = {
    'Authorization': 'Bearer $testKeys'
  };
  var request = http.Request('GET', Uri.parse('https://sandbox.payscribe.ng/api/v1//cards/${cardData[cardIndex]['card_id']}'));
  request.body = '''''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    FirebaseFirestore SnapShot = FirebaseFirestore.instance;
    var responseBody = await response.stream.bytesToString();
    var responseJson = json.decode(responseBody);


    // Extract the necessary details from the JSON response
    var cardDetails = responseJson;
    var cardID = responseJson['card_id'];
    print(cardDetails);

    await SnapShot
        .collection('users')
        .doc(userEmail)
        .collection('cards')
        .doc(cardID).update({
      'card Balance' : cardDetails['card Balance']
    });
    print('Updated Balance');
  }
  else {
    print(response.reasonPhrase);
  }

}