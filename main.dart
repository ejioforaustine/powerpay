import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freerasp/freerasp.dart';
import 'package:powerpay/Core/Navigation.dart';
import 'package:powerpay/UIsrc/Authentication/Signin.dart';
import 'package:powerpay/Virtual%20Card/Kvirtual%20constant.dart';
import 'dart:io';



import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FireBaseAuth/Authentication.dart';
import 'Core/Functions/constantvaribles.dart';
import 'Onboarding/onboardingpage.dart';
import 'UIsrc/Authentication/SignUp.dart';

var isDarkMode;



Future<void> main() async {

  // Signing hash of your app
  String base64Hash = hashConverter.fromSha256toBase64('66:AD:46:4B:41:61:78:BD:47:CF:EC:DF:3F:50:33:21:A9:39:1D:D8:6D:4E:B3:81:13:51:6B:E9:8B:F6:51:#');

  WidgetsFlutterBinding.ensureInitialized();

  plugin.initialize(publicKey: publicKey);

  // create configuration for freeRASP
  final config = TalsecConfig(
    /// For Android
      androidConfig: AndroidConfig(
        packageName: 'com.powerpay.powerpay',
        signingCertHashes: [
          base64Hash
        ],
        supportedStores: [''],
      ), watcherMail: 'support@powerpay.com.ng',
      isProd: true,

  );


  // Setting up callbacks
  final callback = ThreatCallback(
      onAppIntegrity: () => {
      Fluttertoast.showToast(msg: ''),

      },
      onObfuscationIssues: () => {
        Fluttertoast.showToast(msg: 'Obsfucation issue'),
        exit(0),

      },
      onDebug: () => {
        Fluttertoast.showToast(msg: 'Debugging is On!'),
        exit(0),

      },
      onDeviceBinding: () => {
        Fluttertoast.showToast(msg: 'Device Binding Detected'),
        exit(0),
      },
      onDeviceID: () => {
        Fluttertoast.showToast(msg: 'On Device ID '),
        exit(0),

      },
      onHooks: () => {
        Fluttertoast.showToast(msg: 'Hooks'),
        exit(0),

      },
      onPasscode: () => {
        Fluttertoast.showToast(msg: 'On Passcode'),
        exit(0),

      },
      onPrivilegedAccess: () => {
        Fluttertoast.showToast(msg: 'Priviledged Access'),
        exit(0),

      },
      onSecureHardwareNotAvailable: () => {
        Fluttertoast.showToast(msg: 'Hardware issue'),

      },
      onSimulator: () => Fluttertoast.showToast(msg: 'Simulator issue'),
      onUnofficialStore: () => Fluttertoast.showToast(msg: 'Not real store'),
  );

  // Attaching listener
  Talsec.instance.attachListener(callback);

  // start freeRASP
 /* await Talsec.instance.start(config);*/

  await Firebase.initializeApp(

      options: const FirebaseOptions(

          apiKey: '########',
          appId: '#########',
          messagingSenderId: '########',
          projectId: '##############',

      )

  );


  await FirebaseMessaging.instance.getInitialMessage();

  await checkOnboardingStatus();


  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  static const black = MaterialColor(0xFF000000, {
    50: Color(0xFFECEFF1),
    100: Color(0xFFCFD8DC),
    200: Color(0xFFB0BEC5),
    300: Color(0xFF90A4AE),
    400: Color(0xFF78909C),
    500: Color(0xFF607D8B),
    600: Color(0xFF546E7A),
    700: Color(0xFF455A64),
    800: Color(0xFF37474F),
    900: Color(0xFF263238),
  });
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PowerPay',
      theme: ThemeData(
        primarySwatch: black,
      ),
      home: const MyHomePage(title: 'Sign IN page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
dynamic hasSeenOnboard;
checkOnboardingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  hasSeenOnboard = prefs.getBool('hasSeenOnboarding') ?? false;

}

class _MyHomePageState extends State<MyHomePage> {
  static const black = MaterialColor(0xFF000000, {
    50: Color(0xFFECEFF1),
    100: Color(0xFFCFD8DC),
    200: Color(0xFFB0BEC5),
    300: Color(0xFF90A4AE),
    400: Color(0xFF78909C),
    500: Color(0xFF607D8B),
    600: Color(0xFF546E7A),
    700: Color(0xFF455A64),
    800: Color(0xFF37474F),
    900: Color(0xFF263238),
  });


  @override
  void initState(){
    super.initState();
    checkOnboardingStatus();

  }
  @override
  Widget build(BuildContext context) {
    textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(providers: [

      Provider<AuthenticationService>(create: (_)=> AuthenticationService(FirebaseAuth.instance)),

      StreamProvider(create: (context)=> context.read<AuthenticationService>().authStateChanges, initialData: null,),

      ChangeNotifierProvider(create: (_) => AppStateNotifier(),)

    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PowerPay',
        theme: ThemeData(
          primarySwatch: black,
          useMaterial3: true,
        ),
        home: const AuthenticationWrapper(),
      )

      ,);
  }
}



class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final firebaseuser = context.watch<User?>();

    if (firebaseuser != null){
      return  const NavigatorPage();
    }

      if (hasSeenOnboard) {
      return const SignupScreen();
    }

      return const OnboardingPage();

  }
}
