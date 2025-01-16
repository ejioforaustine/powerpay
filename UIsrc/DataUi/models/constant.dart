import 'package:flutter/material.dart';

///data variables
int dataAmount = 0;
String dataNetworkProvider = 'MTN';


///bool s data
bool isDataNetworkSelected = false;


///Network provider selected and unselected styles
Color dataGloBorderColor = Colors.black;
Color dataMtnBorderColor = Colors.black;
Color dataNineMobileBorderColor = Colors.black;
Color dataAirtelBorderColor = Colors.black;

double dataMtnBorderWidth = 0.2;
double dataGloBorderWidth = 0.2;
double dataNineMobileBorderWidth = 0.2;
double dataAirtelBorderWidth = 0.2;

///Service variations ID
String dataServiceID = 'mtn-data';

//isDataBundle Loaded? bool
bool isDataBundleLoaded = true;

//Selected Bundle for transaction variable
String selectedBundleVariationCode = '';
String selectedBundlePackageName = '';
double selectedBundlePackageAmount = 0;
double discountAmountData = 0;
String formattedAmountValue = '';
String dataPhoneNUmber = '';

//processing Bool
bool processingDataBool = true;
bool isPayDataButtonClicked = false;