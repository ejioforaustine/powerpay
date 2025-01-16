import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'dart:convert';
import '../createVirtualCustomer.dart';

class Transaction {
  final String transId;
  final String currency;
  final String amount;
  final String status;
  final String description;
  final String remark;
  final String createdAt;

  Transaction({
    required this.transId,
    required this.currency,
    required this.amount,
    required this.status,
    required this.description,
    required this.remark,
    required this.createdAt,
  });

  // Factory method to create a Transaction from JSON data
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transId: json['trans_id']??'',
      currency: json['currency']??'',
      amount: json['amount']??'',
      status: json['status']??'',
      description: json['description']??'',
      remark: json['remark']??'',
      createdAt: json['created_at']??'',
    );
  }
}



Future<List<Transaction>> fetchTransactions(String cardId) async {
  const url = 'https://us-central1-polectro-60b65.cloudfunctions.net/fetchTransactions';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'cardId': cardId,
    }),
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    List<Transaction> transactions = (jsonResponse['transactions'] as List)
        .map((data) => Transaction.fromJson(data))
        .toList();

    return transactions;
  } else {
    throw Exception('Failed to load transactions');
  }
}


///body
class TransactionsPage extends StatelessWidget {
  final Future<List<Transaction>> transactions;

  const TransactionsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: ktextColor,)),
        backgroundColor: kbackgroundColorLightMode,
        title:  Text('Card Transactions',style: GoogleFonts.inter(color: ktextColor,fontSize: 16/textScaleFactor),),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else
            if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }
            else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var transaction = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.payment,
                        color: transaction.status == 'success' ? Colors.green : Colors.red,
                      ),
                      title: Text('${transaction.description}',style: GoogleFonts.inter(color: ktextColor,fontSize: 10/textScaleFactor),),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${transaction.currency} ${transaction.amount}',
                              style: GoogleFonts.inter(
                                  color: ktextColor,
                                  fontSize: 10/textScaleFactor)),
                          Text('Status: ${transaction.status}'),
                          Text('Date: ${transaction.createdAt}'),
                        ],
                      ),
                      subtitle: Text('ID: ${transaction.transId}'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
