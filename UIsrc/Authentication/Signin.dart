import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freerasp/freerasp.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:lottie/lottie.dart';
import 'package:powerpay/UIsrc/Authentication/ResetPassword.dart';

import 'package:powerpay/UIsrc/Authentication/SignUp.dart';

import '../../FireBaseAuth/2ndAuthService.dart';
import '../../Core/Navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController Email = TextEditingController();
TextEditingController Phone = TextEditingController();
TextEditingController Pass = TextEditingController();
bool hidePass = false;
bool IconCloseEyes = false;
bool isLoading5 = false;

class _LoginScreenState extends State<LoginScreen> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView(
        reverse: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 100, 1),
                    child: Row(
                      children: [
                        Text("Sign in",
                            style: GoogleFonts.pacifico(
                                fontSize: 45,
                                color: Colors.black,
                                fontWeight: FontWeight.w900)),
                        Expanded(
                          child: SizedBox(
                            height: 170,
                            width: 170,
                            child: Lottie.asset(
                                'assets/images/142662-chameleon-changing-colour.json'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 120, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("to ",
                            style: GoogleFonts.pacifico(
                                fontSize: 45,
                                color: Colors.black,
                                fontWeight: FontWeight.w900)),
                        Text("continue..",
                            style: GoogleFonts.pacifico(
                                fontSize: 45,
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.w900))
                      ],
                    ),
                  ),
                ],
              ), //changing chameleon

              const SizedBox(
                height: 40,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: Email,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white)),
                      prefixIcon: const Icon(Icons.alternate_email_sharp),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: "Email ID",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.2),
                          borderRadius: BorderRadius.circular(20))),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ), // EMAIL ID

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  obscureText: hidePass,
                  cursorColor: Colors.black,
                  controller: Pass,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            IconCloseEyes = !IconCloseEyes;
                            hidePass = !hidePass;
                          });
                        },
                        child: Icon(
                            IconCloseEyes ? Iconsax.eye : Iconsax.eye_slash)),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: "Password",
                    hoverColor: Colors.grey,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ), //Password

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Forgotpasspage()));
                        },
                        child: Text("Forgot Password?",
                            style: GoogleFonts.kadwa(
                                fontSize: 15,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w700)))
                  ],
                ),
              ), // forgot password

              const SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    if (Email.text.isEmpty || Pass.text.isEmpty) {
                      Fluttertoast.showToast(
                           msg: 'Please fill all fields');
                      print("Email and password cannot be empty");
                      return;
                    }
                    setState(() {
                      isLoading5 = true;
                    });
                    bool res = await CustomAuthProvider()
                        .signInWithEmail(Email.text, Pass.text);

                    if (!res) {
                      setState(() {
                        isLoading5 = false;
                      });
                      print("Login failed");
                      Fluttertoast.showToast(
                           msg: 'One or more information is incorrect');
                    } else {
                      setState(() {
                        isLoading5 = false;
                      });
                      Phoenix.rebirth(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigatorPage()));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.yellow.shade900),
                    child: isLoading5
                        ? const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'Log in',
                              style: GoogleFonts.kadwa(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),


              SizedBox(
                width: MediaQuery.of(context).size.width / 1.35,
                child: const Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
                    Text('OR'),
                    Expanded(
                        child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: GoogleFonts.kadwa(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: Text("Register",
                            style: GoogleFonts.kadwa(
                                fontSize: 15,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w700)))
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
