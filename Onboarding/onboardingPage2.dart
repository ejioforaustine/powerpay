import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:powerpay/KYC/SelfiePhoto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UIsrc/Authentication/SignUp.dart';

class Onboardingpage2 extends StatefulWidget {
  const Onboardingpage2({super.key});

  @override
  State<Onboardingpage2> createState() => _Onboardingpage2State();
}

class _Onboardingpage2State extends State<Onboardingpage2> {
  dynamic circleColor = Colors.deepOrange.shade100 ;

  @override
  void dispose ()async{
    super.dispose();
    // Set onboarding status as true after completion
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    print('set');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const Spacer(),
          RichText(
            text: TextSpan(
                children: [
                 TextSpan(text: 'Introducing,',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 20)),

                ]
            ),

          ),

          RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: '"PowerPay Virtual Card"',style: GoogleFonts.pacifico(color: Colors.amber.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                ]
            ),

          ),
          const SizedBox(height: 30,),


          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [

                //virtual card
                Hero(
                  tag: 'hero-virtual',
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 50,right: 50),
                    child: Container(
                      height: 300,
                      width: 350,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),

                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          'assets/Onboarding assets/holding-glasses.jpg',
                          fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                ),

                //Onboarding description
                Positioned(
                  left: 0,
                  bottom: 20,
                  child: Padding(
                    padding:  const EdgeInsets.all(8.0),
                    child: Container(
                        height: 70,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),

                            gradient: const LinearGradient(colors:[Colors.purple,Colors.deepPurple])

                        ),
                        child: Center(
                          child: Text('Virtual cards ',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),),
                        )
                    ),
                  ),
                )
                    .animate()
                    .slideX(
                    delay: const Duration(milliseconds: 1500),
                    duration: const Duration(milliseconds: 500)).slideY(),
              ],
            ),
          ),*/

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
                duration: 1.seconds,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor
            ),
            child: LottieBuilder.asset('assets/lottiefiles/Animation - 1723246626438 (1).json',reverse: true,)),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: 'Make ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                      TextSpan(text: 'International Payment',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 25)),

                    ]
                ),

              )
            ],
          ),
          IntrinsicHeight(
            child: Animate(
              // Animate the entire sequence of animations
              onPlay: (controller) => controller
                  .repeat(reverse: false),
              delay: 2.seconds,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    delay: 1.seconds,

                    onPlay: (value){setState(() {
                      circleColor = Colors.green.shade100;
                    });},
                    effects: [
                      SlideEffect(
                          begin:  Offset.zero,
                          end: Offset(0,1),
                          duration: 3.seconds,
                          curve: Curves.bounceOut

                      ),

                    ],
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: '  ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                            TextSpan(text: '"Seamlessly"',style: GoogleFonts.inter(color: Colors.amber.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                          ]
                      ),

                    ),
                  )
                      .crossfade(builder: (context) => Animate(
                    delay: 4.seconds,
                    onPlay: (value){setState(() {
                      circleColor = Colors.red.shade200;
                    });},
                    effects: [
                      SlideEffect(
                          begin: Offset.zero,
                          end: const Offset(0,1),
                          duration: 3.seconds,
                          curve: Curves.bounceOut

                      ),

                    ],
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: '  ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                            TextSpan(text: '"Securely"',style: GoogleFonts.inter(color: Colors.green.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                          ]
                      ),

                    ),
                  )
                      .crossfade(builder: (context) => Animate(
                    onPlay: (value){setState(() {
                      circleColor = Colors.purple.shade100;
                    });},
                    delay: 7.seconds,
                    effects: [
                      SlideEffect(
                          begin: Offset.zero,
                          end: const Offset(0,1),
                          curve: Curves.bounceOut,
                          duration: 3.seconds ),

                    ],
                    child:RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: ' ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                            TextSpan(text: '"Cheaper"',style: GoogleFonts.inter(color: Colors.red.shade600,fontWeight: FontWeight.w900,fontSize: 30)),

                          ]
                      ),

                    ),
                  )
                      .crossfade(builder: (context) => Animate(delay: 11.seconds,
                    effects: [
                      const SlideEffect(begin: Offset.zero, end: Offset(0,0)),

                    ],
                    child:RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: ' ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                            TextSpan(text: '"Seamless"',style: GoogleFonts.inter(color: Colors.deepPurple,fontWeight: FontWeight.w900,fontSize: 30)),

                          ]
                      ),

                    ),
                  )

                  )

                  ))




                ],
              ),
            ),
          ),


          // Let's get started button
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 32.0,top: 64,right: 32),
                  child: MaterialButton(
                    height: 50,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.black),
                    ),
                    color: Colors.black,
                    child: Text("Let's get you Onboard",style: GoogleFonts.inter(fontWeight: FontWeight.w900,color: Colors.white),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                    }, ),
                ),
              ),
            ],
          ),

          const Spacer(),
          //version
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Version : 3.7.0+43 ',style: GoogleFonts.inter()),
            ),
          ),



        ],
      ),
    );
  }
}
