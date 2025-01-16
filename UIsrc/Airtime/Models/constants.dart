import 'package:flutter/material.dart';

///airtime variables
var airtimeAmount;
String networkProvider = '';
var airtimePhoneNumber;
var airtimeServiceID;

//bool for circular progress bar
bool isAirtimePaid = false;
///bools
bool isNetworkSelected = false;
bool isPayWithWalletClicked = false;


///Network provider selected and unselected styles
Color gloBorderColor = Colors.black;
Color mtnBorderColor = Colors.black;
Color nineMobileBorderColor = Colors.black;
Color airtelBorderColor = Colors.black;

double mtnBorderWidth = 0.2;
double gloBorderWidth = 0.2;
double nineMobileBorderWidth = 0.2;
double airtelBorderWidth = 0.2;

///networkImage index Selector
var networkImageNumber = 0;

//Airtime function json decode variables

String airtimeBuyStatus = '';
String airtimeProductName = '';
String airtimeUniquePhoneNumber = '';
String airtimePrice = '';
String airtimeTransacDate = '';
String airtimeResponseDesc = '';
String airtimeTransacID= '';

