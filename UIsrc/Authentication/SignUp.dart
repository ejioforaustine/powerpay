import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:lottie/lottie.dart';
import 'package:powerpay/Core/Navigation.dart';
import 'package:powerpay/UIsrc/Authentication/Signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../FireBaseAuth/2ndAuthService.dart';
import '../../legal/TermsOfUse.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
void adddetailstoStore ()async{
  var userInstance = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('users').doc(userInstance!.email).set({
    'Email': Email.text,
    'phone': Phone.text,
    'name': name.text

  }).whenComplete(() => print('Updated')).
  catchError((error){print(error.toString());});

}

TextEditingController Email = TextEditingController();
TextEditingController Phone = TextEditingController();
TextEditingController Pass = TextEditingController();
TextEditingController name = TextEditingController();
bool isLoading6 = false;


class _SignupScreenState extends State<SignupScreen> {
  void setOnboard()async{
    // Set onboarding status as true after completion
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    print('set');
  }
  @override
  void initState() {
    super.initState();
    setOnboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          reverse: true,
          children: [Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 1),
                child: Row(
                  children: [
                    Text("let's",style: GoogleFonts.pacifico(fontSize: 60,color: Colors.black,fontWeight: FontWeight.w900) )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Row(
                  children: [
                    Text("Get ",style: GoogleFonts.pacifico(fontSize: 59,color: Colors.black,fontWeight: FontWeight.w900) ),
                    Expanded(child: Text("Started..",style: GoogleFonts.pacifico(fontSize: 59,color: Colors.amber.shade900,fontWeight: FontWeight.w900) ))
                  ],
                ),
              ),
              Lottie.asset(
                  'assets/images/117623-wind-turbines-and-solar-panels-energy.json'),
              const SizedBox(
                height: 30,
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
              ), /// EMAIL ID

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: Phone,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white)),
                      prefixIcon: const Icon(Icons.phone_android_outlined),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: "Phone",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.2),
                          borderRadius: BorderRadius.circular(20))),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ), ///Phone

              const SizedBox(
                height: 30,
              ),



              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  controller: name,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white)),
                    prefixIcon: const Icon(Icons.abc_outlined),

                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: "Name",
                    hoverColor: Colors.grey,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),///name

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  obscureText: hidePass,
                  controller: Pass,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          setState((){
                            IconCloseEyes = !IconCloseEyes;
                            hidePass = !hidePass;});

                        },
                        child:  Icon(IconCloseEyes ?Iconsax.eye: Iconsax.eye_slash )),

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
              ),/// Password

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? ",style: GoogleFonts.kadwa(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500) ),
                    GestureDetector(
                        onTap: (){
                          adddetailstoStore();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()))
                          ;},
                        child: Text("Login",style: GoogleFonts.kadwa(fontSize: 15,color: Colors.green.shade700,fontWeight: FontWeight.w700) ))
                  ],
                ),
              ),

              const SizedBox(
                height: 80,
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const termsandconditions(url: 'https://powerpay.com.ng/terms-and-conditions/'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By continuing you agree to our',
                        style: GoogleFonts.pacifico(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Terms & conditions',
                        style: GoogleFonts.pacifico(
                            fontSize: 13, fontWeight: FontWeight.w500, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,1,8,12),
                child: GestureDetector(
                  onTap: () async {

                    if(Email.text.isEmpty || Pass.text.isEmpty || Phone.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please Fill all fields');
                      print("Email and password cannot be empty");
                      return;
                    }
                    setState((){isLoading6 = true;});
                    bool res = await CustomAuthProvider().createUserWithEmail(Email.text, Pass.text);

                    if(!res) {
                      setState((){isLoading6 = false;});
                      print("signup failed");


                    }else{
                      Fluttertoast.showToast(
                           msg: 'Creating Account');
                      adddetailstoStore();
                      setState((){isLoading6 = false;});


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigatorPage()),
                      );

                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.yellow.shade900),
                    child:  isLoading6
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

                        'Continue',
                        style: GoogleFonts.kadwa(
                            fontWeight: FontWeight.w900,
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),],
        )
      ),
    );
  }
}
