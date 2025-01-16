import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/keys.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Wallet/walletFunctions.dart';
import 'package:http/http.dart' as http;

class walletHistory extends StatefulWidget {
  const walletHistory({Key? key}) : super(key: key);

  @override
  State<walletHistory> createState() => _walletHistoryState();
}

var userInstance3 = FirebaseAuth.instance.currentUser;
CollectionReference subcollectionRef3 = FirebaseFirestore.instance
    .collection('wallet')
    .doc(userInstance3?.email)
    .collection('walletHistory');
String sixMonths = '';
String TodaysDate = '';

class _walletHistoryState extends State<walletHistory> {
  String getDateSixMonthsBehind() {
    DateTime currentDate = DateTime.now();
    DateTime sixMonthsBehind =
        currentDate.subtract(const Duration(days: 30 * 1));

    String formattedDate =
        "${sixMonthsBehind.year}-${sixMonthsBehind.month.toString().padLeft(2, '0')}-${sixMonthsBehind.day.toString().padLeft(2, '0')}";

    sixMonths = formattedDate;
    TodaysDate =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    print(sixMonths);
    print(TodaysDate);

    return formattedDate;
  }

  Future<List<Transaction>> fetchHistory() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer '
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.flutterwave.com/v3/payout-subaccounts/$walletAccountID/transactions?from=$sixMonths&to=$TodaysDate&currency=NGN'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var feed;
      final jsonData = jsonDecode(await response.stream.bytesToString());
      final transactionsData = jsonData['data']['transactions'];
      List<Transaction> transactions = [];
      for (var transactionData in transactionsData) {
        Transaction transaction = Transaction(
          rawtype: transactionData['type'],
          amount: transactionData['amount'].toDouble(),
          currency: transactionData['currency'],
          balanceBefore: transactionData['balance_before'].toDouble(),
          balanceAfter: transactionData['balance_after'].toDouble(),
          reference: transactionData['reference'],
          date: DateTime.parse(transactionData['date']),
          remarks: transactionData['remarks'],
          sentCurrency: transactionData['sent_currency'],
          rateUsed: transactionData['rate_used'].toDouble(),
          sentAmount: transactionData['sent_amount'].toDouble(),
          statementType: transactionData['statement_type'],
        );

        transactions.add(transaction);
      }

      return transactions;
    } else {
      throw Exception('Failed to fetch History');
    }
  }

  @override
  void initState() {
    getDateSixMonthsBehind();
    fetchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: kbackgroundColorLightMode,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: kbackgroundColorLightMode,
            elevation: 7,
            iconTheme: IconThemeData(
                color: ktextColor,
                size: 25 * MediaQuery.of(context).size.height / 768),
            title: Text('WALLET HISTORY',
                style: GoogleFonts.kadwa(
                    color: ktextColor,
                    fontSize: 15 * MediaQuery.of(context).size.height / 768,
                    fontWeight: FontWeight.w900)),
          ),
          body: FutureBuilder<List<Transaction>>(
            future: fetchHistory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Transaction transaction = snapshot.data![index];
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  transaction.type,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15 *
                                          MediaQuery.of(context).size.height /
                                          768,
                                      color: ktextColor),
                                )),
                              ],
                            ),
                            SizedBox(
                              height:
                                  10 * MediaQuery.of(context).size.height / 768,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Reference: ${transaction.reference}',
                                  style: TextStyle(
                                      fontSize: 13 *
                                          MediaQuery.of(context).size.height /
                                          768,
                                      color: ktextColor),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.all(
                            8 * MediaQuery.of(context).size.height / 768),
                        child: Text(
                          'Wallet Balance ${transaction.balanceAfter} ',
                          style: TextStyle(
                              fontSize:
                                  10 * MediaQuery.of(context).size.height / 768,
                              color: ktextColor),
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.all(
                            8 * MediaQuery.of(context).size.height / 768),
                        child: Column(
                          children: [
                            Expanded(
                                child: Text(
                              '${transaction.currency} ${transaction.amount}',
                              style: GoogleFonts.arimo(
                                fontWeight: FontWeight.w700,
                                fontSize: 13 *
                                    MediaQuery.of(context).size.height /
                                    768,
                                color: ktextColor,
                              ),
                            )),
                            SizedBox(
                              height:
                                  8 * MediaQuery.of(context).size.height / 768,
                            ),
                            Expanded(
                                child: Text(
                              transaction.date.toString(),
                              style: TextStyle(
                                  fontSize: 9 *
                                      MediaQuery.of(context).size.height /
                                      768,
                                  color: ktextColor),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error: Unable to retrieve History'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}

class Transaction {
  final String rawtype;
  final double amount;
  final String currency;
  final double balanceBefore;
  final double balanceAfter;
  final String reference;
  final DateTime date;
  final String remarks;
  final String sentCurrency;
  final double rateUsed;
  final double sentAmount;
  final String statementType;

  Transaction({
    required this.rawtype,
    required this.amount,
    required this.currency,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.reference,
    required this.date,
    required this.remarks,
    required this.sentCurrency,
    required this.rateUsed,
    required this.sentAmount,
    required this.statementType,
  });
  String get type {
    if (rawtype == "D") {
      return "debit";
    } else {
      return 'credit';
    }
    return rawtype;
  }
}
