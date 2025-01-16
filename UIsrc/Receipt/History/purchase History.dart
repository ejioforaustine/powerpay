import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/UIsrc/ElectricityUi/OrderSummary.dart';
import 'package:powerpay/UIsrc/Receipt/Electricity%20Receipts/TrasactionReceipt.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';

import '../../../Core/Functions/constantvaribles.dart';
import '../../ElectricityUi/AddMeternumber.dart';
import '../Data Receipts/data_Receipt.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

var receiptProvider;
var receiptStatus;
var receiptmetername;
var receiptMeterAddress;
var receiptTransactionID;
var receiptTransactionDate;
var receiptUnitPrice;
var receiptVat;
var receiptUnit;
var receiptTotal;
var receiptMeterID;
var reciptstoken;

class _PurchaseHistoryState extends State<PurchaseHistory> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:  Icon(

                          Iconsax.arrow_left,
                          size: 40*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
                          color: ktextColor,
                        )),
                  ),
                   SizedBox(
                    width: 85*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
                  ),
                  Expanded(
                    child: Text(
                      'Purchase History',
                      style: GoogleFonts.kadwa(
                          fontWeight: FontWeight.w900,
                          color: ktextColor,
                          fontSize: 20*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height),
                    ),
                  ),
                ],
              ), //heading(buy electricity)
               SizedBox(
                height: 20*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
              ),

              //Divider-Recent Activities_
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      width: MediaQuery.of(context).size.width / 1.02,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.1)),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: subcollectionRef2.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          print(
                              'Connection state: ${snapshot.connectionState}');
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            );
                          }
                          List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          documents.sort((a, b) =>
                              b['timestamp'].compareTo(a['timestamp']));
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Build the list item widget
                              DocumentSnapshot document = documents[index];
                              String meterid = document.get('Meter No');
                              String description = document.get('meterAddress');
                              String total = document.get('total amount');
                              String date = document.get('Transaction date');
                              String product = document.get('Product Name');
                              String price4unit = document.get('unit price');
                              String unitcount = document.get('unit');
                              String metrename4rmbase =
                                  document.get('metername');
                              String transacID = document.get('TransactionID');
                              String vatrec = document.get('vat');
                              String tokcode = document.get('Token');

                              return ListTile(
                                title: Text(
                                  product,
                                  style: GoogleFonts.kadwa(
                                      fontSize: 13*MediaQuery.of(context).size.height/768,
                                      color: ktextColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          meterid,
                                          style: GoogleFonts.kadwa(
                                              fontSize: 13*MediaQuery.of(context).size.height/768,
                                              color: ktextColor,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(description,style: TextStyle(color: ktextColor),)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Text(date,style: TextStyle(color: ktextColor),)),
                                        Text(
                                          'View Receipt',
                                          style: GoogleFonts.arimo(
                                              color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  total,
                                  style: GoogleFonts.arimo(
                                      fontSize: 13*MediaQuery.of(context).size.height/768,
                                      color: ktextColor,
                                      fontWeight: FontWeight.w900),
                                ),
                                onTap: () {
                                  // Handle the item tap event
                                  productName = product;
                                  responseDescription = 'Successful';
                                  verifiedMeterName = metrename4rmbase;
                                  meterAddress = description;
                                  transactionID = transacID;
                                  transactionDate = date;
                                  unitPrice = price4unit;
                                  vat = vatrec;
                                  Units = unitcount;
                                  newTotalBedcAmount = total;
                                  uniqueMeterNum = meterid;
                                  billToken = tokcode;

                                  print(unitPrice);
                                  print(total);

                                  if (productName.toString().contains('MTN Data')||
                                      productName.toString().contains('GLO Data')||
                                      productName.toString().contains('Airtel Data')||
                                      productName.toString().contains('9mobile Data')||
                                      productName.toString().contains('MTN Airtime VTU')||
                                      productName.toString().contains('GLO Airtime VTU')||
                                      productName.toString().contains('Airtel Airtime VTU')||
                                      productName.toString().contains('9mobile Airtime VTU')
                                  )
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const DataReceipts()));
                                  }else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const Receipts()));
                                  }
                                },
                              );
                            },
                          );
                        },
                      ))),
            ],
          )
        ],
      )),
    );
  }
}
