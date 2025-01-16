import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Virtual%20Card/Api%20Functions/conversion/conversion.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import '../../UIKonstant/KUiComponents.dart';
import '../Api Functions/withdraw_to_bank/withdrawtoBank.dart';

class WithdrawToBank extends StatefulWidget {
  const WithdrawToBank({super.key});

  @override
  State<WithdrawToBank> createState() => _WithdrawToBankState();
}

class _WithdrawToBankState extends State<WithdrawToBank> {
  bool _isLoading = false;
  TextEditingController withdrawAmount2Bank = TextEditingController();
  void callState(){
    setState(() {
    });
  }

  @override
  void initState(){
    super.initState();
    getVirtualBanks(callState);
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    return  Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        backgroundColor: kbackgroundColorLightMode,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: ktextColor,)),
        title: Text('Withdraw',style: GoogleFonts.inter(color: ktextColor),),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              //drop down card selection
              Padding(
                padding: const EdgeInsets.only(top: 50,left: 24,right: 24),
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(

                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),

                    ),
                    // Add more decoration..
                  ),
                  hint:  Text(
                    'Select Bank',
                    style: TextStyle(
                        color: ktextColor,
                        fontSize: 12/textScaleFactor),
                  ),
                  items: bankMap.keys
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style:  TextStyle(
                        color: ktextColor,
                        fontSize: 12/textScaleFactor,
                      ),
                    ),
                  ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select Bank';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //Do something when selected item is changed.
                    setState(() {
                      selectedBank = value; // Update the selected bank
                      selectedBankCode = bankMap[value]; // Get associated code
                    });
                    print('Selected Bank: $selectedBank, Code: $selectedBankCode');
                  },
                  onSaved: (value) {
                    selectedBank = value;
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData:  IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: ktextColor,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: kbackgroundColorLightMode,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              //account number
              Padding(
                padding: const EdgeInsets.only(top: 32,left: 24,right: 24),
                child: TextFormField(
                  controller: accountNumber,
                  onChanged: (value){
                    accountLookUp();
                    setState((){});
                  },
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Colors.grey, width: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16)),
                    fillColor: kbackgroundColorLightMode,
                    suffixIcon: Icon(
                      Icons.numbers_outlined,
                      size: 14,
                      color: ktextColor.withOpacity(0.5),
                    ),
                    labelText: 'Account Number',
                    labelStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.normal, color: ktextColor),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              ),

              //Amount to withdraw
              Padding(
                padding: const EdgeInsets.only(top: 32,left: 24,right: 24),
                child: TextFormField(
                  controller: withdrawAmount2Bank,
                  onChanged: (value){
                    accountLookUp();
                    setState((){});
                  },
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w900, color: ktextColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Colors.grey, width: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16)),
                    fillColor: kbackgroundColorLightMode,
                    suffixIcon: Icon(
                      Icons.numbers_outlined,
                      size: 14,
                      color: ktextColor.withOpacity(0.5),
                    ),
                    labelText: 'Amount',
                    labelStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.normal, color: ktextColor),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 24,right: 24),
                child: Row(
                  children: [
                    Text(accountVirtualName??'',style: GoogleFonts.inter(color: Colors.grey,fontSize: 12),),

                  ],),
              ),


              ///close
              Padding(
                padding: const EdgeInsets.only(top:40,bottom: 32),
                child: GestureDetector(

                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                     await transferFunds(context,accountNumber.text,withdrawAmount2Bank.text,selectedBankCode);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.amber.shade500,
                    ),

                    child: Center(
                      child: _isLoading ?
                      const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(color: Colors.black,)):
                      Text('Withdraw',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
