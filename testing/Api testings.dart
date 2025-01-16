import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import 'package:powerpay/Core/Functions/keys.dart';
import 'package:powerpay/Core/Navigation.dart';
import 'package:powerpay/testing/view%20admin.dart';
import 'package:url_launcher/url_launcher.dart';


dynamic testingFeed;


/*Future<List<String>> testingApi() async {
  if (kDebugMode) {
    print('Starting to fetch all payout subaccounts...');
  }

  List<String> accountReferences = [];
  String? nextCursor;

  try {
    do {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearer'
      };

      // Construct the URL with next_cursor parameter if provided
      var url = 'https://api.flutterwave.com/v3/payout-subaccounts';
      if (nextCursor != null && nextCursor.isNotEmpty) {
        url += '?cursor=$nextCursor';
      }

      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();


        var jsonResponse = jsonDecode(responseBody);
        var data = jsonResponse['data'] as List;

        // Extract and add the account_reference from each subaccount
        accountReferences.addAll(data.map((subaccount) => subaccount['account_reference'] as String));
        print(accountReferences);
        print(accountReferences.length);

        // Update the nextCursor if it exists, otherwise set it to null to stop the loop
        nextCursor = jsonResponse['meta']?['next_cursor'];

      } else {
        print('Error: ${response.statusCode}');
        print(await response.stream.bytesToString());
        break; // Exit loop on error
      }
    } while (nextCursor != null && nextCursor.isNotEmpty);

  } catch (e) {
    print('Exception: $e');
  }

  return accountReferences;
}
*/
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Fetch account IDs from wallet details for all users
  // Fetch account IDs from wallet details for all users
  Future<List<String>> fetchAllAccountIds() async {
    List<String> allAccountIds = [];
    int maxIds = 100; // Maximum number of account IDs to fetch

    try {
      // Fetch all user documents in the users collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _firestore
          .collection('users')
          .get();

      print('Users Snapshot: ${usersSnapshot.docs.length} documents found.');

      // Iterate over each user document
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Print user document ID and data
        print('User Document ID: $userId');

        // Fetch WalletDetails sub-collection for each user
        QuerySnapshot<Map<String, dynamic>> walletDetailsSnapshot = await _firestore
            .collection('Wallet')
            .doc(userId)
            .collection('WalletDetails')
            .get();

        print('WalletDetails Snapshot for user $userId: ${walletDetailsSnapshot.docs.length} documents found.');

        // Check if walletDetailsSnapshot is empty
        if (walletDetailsSnapshot.docs.isEmpty) {

        } else {
          // Iterate over wallet documents and add Account ID to list
          for (var walletDoc in walletDetailsSnapshot.docs) {
            var accountId = walletDoc.data()['Account ID'];
            if (accountId != null) {
              print('Account ID: $accountId');
              allAccountIds.add(accountId);

              // Stop if the list has reached the maximum number of IDs
              if (allAccountIds.length >= maxIds) {
                print('Reached maximum number of Account IDs: $maxIds');

                return allAccountIds;
              }
            } else {
              print('Account ID not found for WalletDetails document: ${walletDoc.id}');
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching all account IDs: $e');
    }

    return allAccountIds;
  }


  // Define your Flutterwave API key
   const String apiUrl = 'https://api.flutterwave.com/v3/payout-subaccounts';

  Future fetchBalances(String bearerNew) async {
    Map<String, double> balances = {};


      final url = Uri.parse('$apiUrl/PSA462786F1050199974/balances');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $bearerNew',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
         print(data);
        // Adjust based on the API response structure
        double balance = 0.56;
        balance = data['data']['available_balance']?.toDouble();
        if (data['status'] == 'success') {

        }

        print('Balance for Account ID : $balance');
        balances[''] = balance;
      } else {
        print('Failed to fetch balance for Account ID PSA29A371617D1053550. Status code: ${response.statusCode}');
      }


    return balances;
  }


Future<String> saveBalancesToCsv(Map<String, double> balances) async {
  // Create CSV content
  List<List<dynamic>> rows = [];
  rows.add(['Account ID', 'Balance']); // Header

  balances.forEach((accountId, balance) {
    rows.add([accountId, balance]);
  });

  String csvData = const ListToCsvConverter().convert(rows);

  // Get the directory to save the file
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/balances.csv';

  // Write CSV content to file
  final file = File(path);
  await file.writeAsString(csvData);

  return path;
}


Future<void> openCsvFile(String filePath) async {
  final uri = Uri.file(filePath);
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    print('Could not launch $uri');
  }
}


Future<void> fetchAndDownloadBalances() async {
  // Step 1: Fetch all account IDs


  // Step 2: Fetch balances for the account IDs
 // Map<String, double> balances = await fetchBalances();

  // Step 3: Save balances to CSV
  /*if (balances.isNotEmpty) {
    String filePath = await saveBalancesToCsv(balances);
    print('CSV file saved at: $filePath');
    await openCsvFile(filePath);
  } else {
    print('No balances to save.');
  }*/
}




Future<List<String>> getAllUserEmails() async {
  List<String> emails = [];

  // Reference to your Firestore collection
  final usersRef = FirebaseFirestore.instance.collection('users');

  // Get all documents in the 'users' collection
  final QuerySnapshot usersSnapshot = await usersRef.get();

  for (var userDoc in usersSnapshot.docs) {
    // Add the document ID (which is the email) to the list
    emails.add(userDoc.id);  // userDoc.id is the email as it's used as the document ID
  }

  return emails;
}


String convertToCSV(List<String> emails) {
  List<List<String>> rows = [];

  // Add header row if needed
  rows.add(['Email']);

  for (var email in emails) {
    rows.add([email]);
  }

  String csv = const ListToCsvConverter().convert(rows);
  return csv;
}

Future<void> saveCSVFile(String csv) async {
  final directory = Directory('/storage/emulated/0/Download');
  final path = "${directory.path}/allusers2.csv";
  final file = File(path);

  await file.writeAsString(csv);
  print("CSV saved at $path");
}

void startGettingEmails () async{
    print('working');
  List<String> emails = await getAllUserEmails();
  String csv = convertToCSV(emails);
  await saveCSVFile(csv);
}




