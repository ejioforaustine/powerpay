import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/UIsrc/ElectricityUi/OrderSummary.dart';
import 'package:powerpay/UIsrc/contact/Contact%20us.dart';

class DataReceipts extends StatefulWidget {
  const DataReceipts({super.key});

  @override
  State<DataReceipts> createState() => _DataReceiptsState();
}

class _DataReceiptsState extends State<DataReceipts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: ktextColor,
            )),
        backgroundColor: kbackgroundColorLightMode,
        title: Text(
          'RECEIPTS',
          style: GoogleFonts.lato(
              fontSize: 17, color: ktextColor, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(

        children: [
          //Data receipt Container
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16,top: 16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border:  Border.symmetric(horizontal: BorderSide(color: Colors.green.shade800,width: 5))),
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: kbackgroundColorLightMode,
                      child: ListTile(
                        title: Text(
                          productName.toString(),
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                        trailing: Text(
                          uniqueMeterNum.toString(),
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: kbackgroundColorLightMode,
                      child: ListTile(
                        title: Text(
                          'Date of Transaction',
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                        trailing: Text(
                          transactionDate.toString(),
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: kbackgroundColorLightMode,
                      child: ListTile(
                        title: Text(
                          'Transaction Status',
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                        trailing: IntrinsicWidth(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.green.shade900,
                                ),
                                height: 20,
                                child: Center(
                                    child: Text(
                                  '   $responseDescription   ',
                                  style: GoogleFonts.lato(
                                      color: Colors.green.shade300),
                                )))),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: kbackgroundColorLightMode,
                      child: ListTile(
                        title: Text(
                          'Transaction ID',
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                        trailing: Text(
                          transactionID.toString(),
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: verifiedMeterName.toString().isNotEmpty,
                      child: Card(
                        elevation: 0,
                        color: kbackgroundColorLightMode,
                        child: ListTile(
                          title: Text(
                            'Data Package',
                            style: GoogleFonts.lato(color: ktextColor),
                          ),
                          trailing: Text(
                            verifiedMeterName.toString(),
                            style: GoogleFonts.lato(color: ktextColor),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: kbackgroundColorLightMode,
                      child: ListTile(
                        title: Text(
                          'Amount',
                          style: GoogleFonts.lato(color: ktextColor),
                        ),
                        trailing: Text(
                          newTotalBedcAmount.toString(),
                          style: GoogleFonts.inter(color: ktextColor,fontWeight: FontWeight.w800,fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20,left: 16,right: 16,bottom: 16),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUs()));
                        },
                        child: Container(
                          height: 50,
                          decoration:  BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8)),
                                          child: Center(
                        child: Text('Need help?',style: GoogleFonts.lato(color: Colors.white),),
                                          ),
                                        ),
                      ),
                    )),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Container(
                          height: 50,
                          decoration:  BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text('Close',style: GoogleFonts.lato(color: Colors.black),),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),//Actions Buttons
        ],
      ),
    );
  }
}
