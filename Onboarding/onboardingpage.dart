
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:powerpay/Onboarding/onboardingPage2.dart';

import '../UIsrc/Authentication/SignUp.dart';
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {



  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              //bill payments
              /*Padding(
                padding: const EdgeInsets.only(top:32, left: 32,right: 32,bottom: 32),
                child: Stack(
                  children: [

                    //image
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Container(
                        height: 220,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'assets/Onboarding assets/newlady.jpg',
                            fit: BoxFit.cover,),
                        ),
                      ),
                    ),

                    //Onboarding description
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 70,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red.shade900

                            ),
                            child: Center(
                              child: Text('Bill Payments',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),),
                            )
                        ),
                      ),
                    ).animate().slideY(
                        delay: const Duration(seconds: 1),
                        duration: const Duration(seconds: 1)),


                  ],
                ),
              ),

              //virtual card
              Padding(
                padding: const EdgeInsets.only(left: 32,right: 32,top: 32,bottom: 16),
                child: Hero(
                  tag: 'hero-virtual',
                  child: Stack(
                    children: [

                      //image
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Container(
                          height: 200,
                          width: 400,
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

                      //Onboarding description
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 70,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),

                                gradient: LinearGradient(colors:[Colors.purple,Colors.deepPurple])

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
                ),
              ),*/

              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: 'Hi,',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 20)),

                          ]
                      ),

                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: 'Welcome Aboard "',style: GoogleFonts.pacifico(color: Colors.amber.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                          ]
                      ),

                    ),
                  ],
                ),
              ),

              LottieBuilder.asset('assets/lottiefiles/Animation - 1723245761729.json',reverse: true,),
              //onboarding description
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: 'make ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20)),
                            TextSpan(text: ' Bill Payments ',style: GoogleFonts.pacifico(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 25)),

                          ]
                      ),

                    )
                  ],
                ),
              ),

              Animate(
                // Animate the entire sequence of animations
                onPlay: (controller) => controller
                  .repeat(reverse: false),
                delay: 2.seconds,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Animate(
                      delay: 1.seconds,
                      effects: [
                          SlideEffect(
                              begin:  Offset.zero,
                              end: Offset(0,1),
                              duration: 2.seconds,
                            curve: Curves.bounceOut

                          ),

                      ],
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: '  ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                              TextSpan(text: '"Practical"',style: GoogleFonts.inter(color: Colors.amber.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                            ]
                        ),

                      ),
                    )
                        .crossfade(builder: (context) => Animate(
                      delay: 4.seconds,
                      effects: [
                         SlideEffect(
                             begin: Offset.zero,
                             end: const Offset(0,1),
                             duration: 2.seconds,
                             curve: Curves.bounceOut

                         ),

                      ],
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: '  ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                              TextSpan(text: '"Easier"',style: GoogleFonts.inter(color: Colors.green.shade900,fontWeight: FontWeight.w900,fontSize: 30)),

                            ]
                        ),

                      ),
                    )
                           .crossfade(builder: (context) => Animate(delay: 7.seconds,
                      effects: [
                         SlideEffect(
                            begin: Offset.zero,
                            end: const Offset(0,1),
                            curve: Curves.bounceOut,
                            duration: 2.seconds ),

                      ],
                      child:RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: ' ',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17)),
                              TextSpan(text: '"Faster"',style: GoogleFonts.inter(color: Colors.red.shade600,fontWeight: FontWeight.w900,fontSize: 30)),

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
                                       TextSpan(text: '"Seamless"',style: GoogleFonts.inter(color: Colors.red.shade600,fontWeight: FontWeight.w900,fontSize: 30)),

                                     ]
                                 ),

                               ),
                             )

                    )

                    ))




                  ],
                ),
              ),



              // Next Button
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
                        child: Text('NEXT',style: GoogleFonts.inter(fontWeight: FontWeight.w900,color: Colors.white),),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Onboardingpage2()));
                        }, ),
                    ),
                  ),
                ],
              ),

              //skip button
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0,top: 24,right: 32),
                      child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Colors.black),
                        ),

                        child: Text('SKIP',style: GoogleFonts.inter(fontWeight: FontWeight.w900,color: Colors.black),),
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));

                        }, ),
                    ),
                  ),
                ],
              )


            ],
          ),
        ),

      ),
    );
  }
}


