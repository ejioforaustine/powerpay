import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:powerpay/UIsrc/Airtime/airtime/airtimePage.dart';
import 'package:powerpay/UIsrc/ElectricityUi/AddMeternumber.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:powerpay/UIsrc/Receipt/Data%20Receipts/data_Receipt.dart';
import 'package:powerpay/UIsrc/popupModels/modelPopup.dart';
import 'package:powerpay/UIsrc/settings/EditProfile.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';
import 'package:powerpay/Wallet/walletFunctions.dart';

import '../../Core/Functions/constantvaribles.dart';
import '../../Core/Functions/keys.dart';
import '../DataUi/data.dart';
import '../NotificationUi/NotificationScreen.dart';
import '../ElectricityUi/OrderSummary.dart';
import '../Receipt/Electricity Receipts/TrasactionReceipt.dart';
import '../../Core/UpdateRequired.dart';
import '../../Wallet/walletFace.dart';
import '../contact/Contact us.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var usersName;
var usersPhone;
var Size;
var notificationTitleMessage;
var notificationBodyMessage;
bool walletCreated = false;
bool loadindingBalance = true;

double _currentVersionCode = 0;
final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

bool passNotification = false;
FlutterLocalNotificationsPlugin flutternotificationplugin =
    FlutterLocalNotificationsPlugin();

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      criticalAlert: false,
      sound: true,
      carPlay: false,
      provisional: false,
      badge: true);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('permission granted');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('Ony provisional');
  } else {
    print('User denied permission');
  }
}

Future<dynamic> getNamefromDatabase(VoidCallback setStateCallback) async {
  try {
    dynamic datas;
    var userInstance = FirebaseAuth.instance.currentUser;

    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(userInstance!.email);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) {
      datas = snapshot.data();
    });
    usersName = datas['name'];
    if (kDebugMode) {
      print(usersName);
    }
    if (kDebugMode) {
      print(datas['name']);
    }
    setStateCallback();

    return datas;
  } catch (e) {
    if (kDebugMode) {
      print('Your May be Unstable');
    }
    Fluttertoast.showToast(msg: 'Your Internet Maybe slow');
  }
}

Future<dynamic> getPhonefromDatabase() async {
  try {
    dynamic datas;
    var userInstance = FirebaseAuth.instance.currentUser;

    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(userInstance!.email);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) {
      datas = snapshot.data();
    });
    usersPhone = datas['phone'];
    if (kDebugMode) {
      print(usersName);
    }
    if (kDebugMode) {
      print(datas['phone']);
    }

    return datas;
  } catch (e) {
    print('Your May be Unstable');
    Fluttertoast.showToast(msg: 'Your Internet Maybe slow');
  }
}

Future<dynamic> getServiceKData() async {
  try {
    dynamic data;
    final DocumentReference document = FirebaseFirestore.instance
        .collection("key")
        .doc('8DiPEdo3NChKmE9imhnV');
    await document.get().then<dynamic>((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    ApiKey = data['apkey'];
    bearer = data['Bearer'];
    SecretKey = data['secret'];
    return data;
  } catch (e) {
    print('Your May be Unstable');
    Fluttertoast.showToast(msg: 'Your Internet Maybe slow');
  }
}

Future<dynamic> getWavyKData() async {
  try {
    dynamic data;
    var userInstance = FirebaseAuth.instance.currentUser;

    final DocumentReference document = FirebaseFirestore.instance
        .collection("key")
        .doc(userInstance?.tenantId);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    ApiKey = data['Bearer'];
    SecretKey = data['secret'];
    if (kDebugMode) {
      print({'$ApiKey,hello $SecretKey'});
    }
    return data;
  } catch (e) {
    print('Your May be Unstable');
    Fluttertoast.showToast(msg: 'Your Internet Maybe slow');
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///Firebase Messaging
  var myToken;
  void getToken() async {
    FirebaseMessaging.instance.getToken().then((token) => {
          setState(() {
            myToken = token;
            if (kDebugMode) {
              print('this is the generated Token $myToken');
            }
            saveTokentoFireStore();
          })
        });
  }

  void saveTokentoFireStore() async {
    var userinstans = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('UserToken')
        .doc(userinstans!.email)
        .set({
      'Token': myToken,
    });
  }

  initialiseInfo() {
    var androidInitialise =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitialise = const DarwinInitializationSettings();
    var InitializationsSettings =
        InitializationSettings(android: androidInitialise, iOS: iosInitialise);
    flutternotificationplugin.initialize(InitializationsSettings,
        onDidReceiveNotificationResponse: (payload) async {
      try {} catch (e) {
        print('caught');
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".....Onmessage is working......");
      print(
          "onMessages: ${message.notification?.title}/${message.notification?.body}");

      notificationTitleMessage = message.notification?.title;
      notificationBodyMessage = message.notification?.body;

      setState(() {
        passNotification = true;
      });

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformchannelspecifics =
          AndroidNotificationDetails('PowerPay', 'Bill',
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails platformchannelSpecifics = NotificationDetails(
        android: androidPlatformchannelspecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutternotificationplugin.show(0, message.notification?.title,
          message.notification?.body, platformchannelSpecifics,
          payload: message.data['body']);
    });
  }

  ///End Of firebase messaging

  void animateTopupContainer() {
    Future.delayed(const Duration(milliseconds: 600))
        .then((value) => setState(() {
              _width2 = MediaQuery.of(context).size.width / 1.04;
              _height2 = 200.0;
            }));
  }

  late double _width2;
  double _height2 = 200;
  var maxLenght = 8;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _width2 = MediaQuery.of(context).size.width / 1.2;
  }

  Future<void> checkForUpdates() async {
    PackageInfo packageInfo = PackageInfo(
      appName: '',
      buildNumber: '',
      packageName: '',
      version: '4.3',
    );
    _currentVersionCode = double.parse(packageInfo.version);
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      final defaults = <String, dynamic>{
        'force_update_required': true,
        'min_version_code': _currentVersionCode,
      };
      await remoteConfig.setDefaults(defaults);
      await remoteConfig.fetch();
      await remoteConfig.activate();
      if (kDebugMode) {
        print(remoteConfig.getValue('min_version_code').asDouble());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing remote config: $e');
      }
    }
  } // Check for updates with version number

  bool isUpdateRequired() {
    final forceUpdate = remoteConfig.getBool('force_update_required');
    final minVersionCode = remoteConfig.getValue('min_version_code').asDouble();
    if (kDebugMode) {
      print(minVersionCode);
    }

    if (minVersionCode > _currentVersionCode) {
      return true;
    }
    return false;
  }

  //format balance into currency
  String formatCurrency(double amount) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_NG', name: 'NGN');
    return currencyFormatter.format(amount);
  }

  ///bool if update is required

  Future<void> _refreshSliderData() async {
    setState(() {
      loadindingBalance = true;
      print('okay....');
    });

    await fetchBalance();
    setState(() {
      loadindingBalance = false;
      print('yeah....');
    });
  }

  @override
  void initState() {
    getServiceKData();
    getToken();
    animateTopupContainer();
    checkForUpdates();
    requestPermission();
    initialiseInfo();
    getCurrentuserEmail();
    fetchDataFromSubcollection(() {
      setState(() {});
    });
    refreshBalance(() {
      setState(() {});
    });
    visibility();
    getNamefromDatabase(() {
      setState(() {});
    });
    getPhonefromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSizeH = MediaQuery.of(context).size.height;
    var screenSizeW = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: kbackgroundColorLightMode,
          statusBarIconBrightness: StatusIcon),
      child: Scaffold(
        backgroundColor: kbackgroundColorLightMode,
        body: RefreshIndicator(
          onRefresh: _refreshSliderData,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 1.05,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const editProfile()));
                                },
                                child: Icon(
                                  Iconsax.profile_circle,
                                  size: 35 * screenSizeH / 768,
                                  color: ktextColor,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello,',
                                    style: TextStyle(
                                      color: ktextColor,
                                    ),
                                  ),
                                  Text(
                                    (usersName ?? '').substring(
                                        0,
                                        (usersName?.length ?? 0) > maxLenght
                                            ? maxLenght
                                            : (usersName?.length ?? 0)),
                                    style: GoogleFonts.pacifico(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17 *
                                          MediaQuery.of(context).size.height /
                                          768,
                                      color: ktextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Alerts(
                                                    messageTitle:
                                                        notificationTitleMessage,
                                                    messageBody:
                                                        notificationBodyMessage,
                                                  )));
                                    },
                                    child: Icon(
                                      Iconsax.notification,
                                      size: 30 *
                                          MediaQuery.of(context).size.height /
                                          768,
                                      color: ktextColor,
                                    ),
                                  ),
                                  Visibility(
                                    visible: passNotification,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 15,
                                        minHeight: 15,
                                      ),
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              768,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ), // Profile and notification container

                  SizedBox(
                    height: 10 * MediaQuery.of(context).size.height / 768,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      height: _height2,
                      width: _width2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kbalanceContainerColor,
                      ),
                      duration: const Duration(milliseconds: 550),
                      curve: Curves.easeInCubic,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      " Balance",
                                      style: GoogleFonts.arimo(
                                          fontWeight: FontWeight.w800,
                                          color: kotherBalanceComponent,
                                          fontSize: 14 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              768),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15,bottom: 15,right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: loadindingBalance
                                        ? const Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                              color: Colors.white,
                                                                                        ),
                                            ))
                                        : Text(
                                             formatCurrency((walletBalance??0.00).toDouble()),
                                            style: GoogleFonts.arimo(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                fontSize: 35),
                                          ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const walletTestface()));
                                    },
                                    child: Icon(
                                      Iconsax.add_circle,
                                      color: kotherBalanceComponent,
                                      size: 30 *
                                          MediaQuery.of(context).size.height /
                                          768,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const walletTestface()));
                                },
                                child: Container(
                                  height: 29 *
                                      MediaQuery.of(context).size.height /
                                      768,
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          kbalanceContainerFundButtonColorLightMode),
                                  child: Center(
                                    child: Text(
                                      'Fund Wallet',
                                      style: GoogleFonts.kadwa(
                                          fontWeight: FontWeight.w700,
                                          color: kbalanceContainerColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), //wallet top up Container

                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.0,
                        right: screenSizeW * 16 / screenSizeW,
                        top: 0,
                        bottom: 15),
                    child: IntrinsicHeight(
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSizeW * 0.04,
                                          right: screenSizeW * 0.04,
                                          top: screenSizeH * 0.025,
                                          bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isUpdateRequired()) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UpdatesNewVersion(),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MeterNumber(),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: screenSizeH * 0.055,
                                          width: screenSizeW * 0.15,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  kbackgroundFunctionButtonColor),
                                          child: Center(
                                            child: Icon(
                                              Icons.electric_bolt,
                                              color: Colors.black,
                                              size: screenSizeH * 0.03,
                                            )
                                                .animate(
                                                    onPlay: (controller) =>
                                                        controller.loop(
                                                            count: 1))
                                                .scale(
                                                    duration: 4.seconds,
                                                    curve: Curves.bounceInOut)

                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Buy Electricity',
                                      style: GoogleFonts.inter(
                                          fontSize: screenSizeH * 0.015,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSizeW * 0.04,
                                          right: screenSizeW * 0.04,
                                          top: screenSizeH * 0.025,
                                          bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isUpdateRequired()) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UpdatesNewVersion(),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const airtimePage()));
                                          }
                                        },
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: screenSizeH * 0.055,
                                          width: screenSizeW * 0.15,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  kbackgroundFunctionButtonColor),
                                          child: Center(
                                              child: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                            size: screenSizeH * 0.03,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Airtime',
                                      style: GoogleFonts.inter(
                                          fontSize: screenSizeH * 0.015,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSizeW * 0.04,
                                          right: screenSizeW * 0.04,
                                          top: screenSizeH * 0.025,
                                          bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isUpdateRequired()) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UpdatesNewVersion(),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InternetDataPage()));
                                          }
                                        },
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: screenSizeH * 0.055,
                                          width: screenSizeW * 0.15,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  kbackgroundFunctionButtonColor),
                                          child: Center(
                                              child: Icon(
                                            Icons.cell_tower,
                                            color: Colors.black,
                                            size: screenSizeH * 0.03,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Internet',
                                      style: GoogleFonts.inter(
                                          fontSize: screenSizeH * 0.015,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSizeW * 0.04,
                                          right: screenSizeW * 0.04,
                                          top: screenSizeH * 0.025,
                                          bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          PopUps.morePopUp(context);

                                          /*showToast("Coming Soon, Stay Tuned!",
                                        context: context,
                                        position: const StyledToastPosition(align: Alignment.center));*/
                                        },
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: screenSizeH * 0.055,
                                          width: screenSizeW * 0.15,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  kbackgroundFunctionButtonColor),
                                          child: Center(
                                              child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.black,
                                            size: screenSizeH * 0.03,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'More',
                                      style: GoogleFonts.inter(
                                          fontSize: screenSizeH * 0.015,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ), //Home button Function Container

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )),
                        Text(
                          'Recent Activties',
                          style: GoogleFonts.kadwa(
                              fontWeight: FontWeight.w700,
                              color: ktextColor,
                              fontSize: 10 *
                                  MediaQuery.of(context).size.height /
                                  768),
                        ),
                        const Expanded(
                            child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )),
                      ],
                    ),
                  ), //Divider-Recent Activities_

                  SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                              return Center(
                                child: SizedBox(
                                    height: 30 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    width: 30 *
                                        MediaQuery.of(context).size.height /
                                        768,
                                    child: const CircularProgressIndicator()),
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
                                String? meterid = document.get('Meter No');
                                String? description =
                                    document.get('meterAddress');
                                String? total = document.get('total amount');
                                String? date = document.get('Transaction date');
                                String? product = document.get('Product Name');
                                String? price4unit = document.get('unit price');
                                String? unitcount = document.get('unit');
                                String? metrename4rmbase =
                                    document.get('metername');
                                String? transacID =
                                    document.get('TransactionID');
                                String? vatrec = document.get('vat');
                                String? tokcode = document.get('Token');
                                try {tempRequestID = document.get('requestID');
                                print(tempRequestID);
                                }
                                catch(e){

                                  print(e);
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          product! != 'null' ? product:'Failed' ,
                                          style: GoogleFonts.kadwa(
                                            fontSize: 11 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                768,
                                            fontWeight: FontWeight.w600,
                                            color: ktextColor,
                                          ),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  meterid! != 'null' ? meterid:'',
                                                  style: GoogleFonts.kadwa(
                                                      fontSize: 11 *
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          768,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          kotherTextcolorGrey),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(date! != 'null'? date: '',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          color: ktextColor,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 11 *
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              768,
                                                        ))),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              total!,
                                              style: GoogleFonts.arimo(
                                                  fontSize: 11 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      768,
                                                  fontWeight: FontWeight.w500,
                                                  color: ktextColor),
                                            ),
                                            Text(
                                              'View Receipt',
                                              style: GoogleFonts.arimo(
                                                  color: Colors.red,
                                                  fontSize: 11 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      768),
                                            )
                                          ],
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
                                          try{requestID = document.get('requestID');}catch(e){requestID='';}
                                          print(requestID);

                                          if (productName
                                                  .toString()
                                                  .contains('MTN Data') ||
                                              productName
                                                  .toString()
                                                  .contains('GLO Data') ||
                                              productName
                                                  .toString()
                                                  .contains('Airtel Data') ||
                                              productName
                                                  .toString()
                                                  .contains('9mobile Data') ||
                                              productName.toString().contains(
                                                  'MTN Airtime VTU') ||
                                              productName.toString().contains(
                                                  'GLO Airtime VTU') ||
                                              productName.toString().contains(
                                                  'Airtel Airtime VTU') ||
                                              productName.toString().contains(
                                                  '9mobile Airtime VTU')) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DataReceipts()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Receipts()));
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Divider(
                                          thickness: 0.2,
                                          color: kotherTextcolorGrey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )),
                  ) //Recent Activity Container
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ktextColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.headset_mic_outlined,color: kbackgroundColorLightMode,),

            ],
          ),
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=> const ContactUs()));
          },),
      ),
    );
  }
}
