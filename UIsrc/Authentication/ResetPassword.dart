import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/UIsrc/Authentication/Signin.dart';

import '../../FireBaseAuth/2ndAuthService.dart';




class Forgotpasspage extends StatefulWidget {
  const Forgotpasspage({Key? key}) : super(key: key);

  @override
  State<Forgotpasspage> createState() => _ForgotpasspageState();
}

class _ForgotpasspageState extends State<Forgotpasspage> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:  SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0.5),statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.19,
            width: MediaQuery.of(context).size.height / 2.3,
            decoration: (BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(0, 0, 0, 16),
                boxShadow:  const [
                  BoxShadow(color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 3,

                    offset: Offset(4, 6),

                  ),



                ]
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 40),
                  child: Row(
                    children: [
                      Text(
                        'Reset Password',
                        style: GoogleFonts.kadwa(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 40),
                  child: Row(
                    children: [
                      Text(
                        'Your Registered Email:',
                        style: GoogleFonts.kadwa(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ), //Email
                SizedBox(
                    width: MediaQuery.of(context).size.height / 2.6,
                    height: 45,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )),





                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: GestureDetector(
                    onTap: () async {

                      if(email.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please provide your Email!! ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 13.0
                        );
                        print("Email");
                        return;
                      }
                      bool res = await CustomAuthProvider().Resetpass(email.text);
                      if(!res) {
                        print("Reset failed");
                        Fluttertoast.showToast(
                            msg: "Password reset failed - Please contact support",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 13.0
                        );

                      }else{
                        Fluttertoast.showToast(
                            msg: "Password reset sent, Check your email to reset password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green.shade800,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );

                      }
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Reset Password',
                          style: GoogleFonts.kadwa(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ), //Reset password button

                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ? ',
                        style: GoogleFonts.kadwa(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w200),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child: Text(
                          'Log in  ',
                          style: GoogleFonts.kadwa(
                              color: Colors.blue.shade800,
                              fontSize: 15,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ],
                  ),
                ), // already have an account
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Ip adress: 198.647.358',
                        style: GoogleFonts.kadwa(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
