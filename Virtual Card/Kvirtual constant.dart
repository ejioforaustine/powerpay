import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic virtualWalletBalance;
dynamic virtualAccountNumber;
dynamic virtualBankName;
dynamic virtualAccountName;
List<Map<String, dynamic>> balanceHistory = [];
List<Map<String, dynamic>> cardData = [];
dynamic cardNumber;
dynamic cardBrand;
dynamic cvv;
dynamic cardAddress;
dynamic postal;
dynamic city;
dynamic country;
int cardIndex = 0;

//customer variables
dynamic customerID;

//loading Variables
bool isCompleted = false;

//conversion rate
dynamic dollarRate;
dynamic nairaRate;
dynamic profitRate = 1.2; ///remote config
dynamic profitRateWithdraw;
double totalFundAmount = 0;

// freeze and unfreeze variable
dynamic actionId;
bool isFrozen = false;

//Top up variables
TextEditingController topAmount =  TextEditingController();
TextEditingController withdrawCardAmount =  TextEditingController();


//Bank List
List<dynamic> bankList = [];
List<Map<String, dynamic>> banksVirtual =[];
dynamic selectedBank;
dynamic selectedBankCode;
TextEditingController accountNumber =  TextEditingController();
TextEditingController withdrawVirtualAmount =  TextEditingController();
dynamic accountVirtualName;
Map<String, String> bankMap = {};

//bool loading & preventing race condition
bool kCreatingCardUser = true;
bool kCreatingCard = true;
bool kFundingCard = true;
bool kWithdrawCard = true;
bool kPin = true;



dynamic screenWidth;
dynamic textScaleFactor;
Color kBoxShadow = Colors.grey;

//security Question varible
dynamic question1;