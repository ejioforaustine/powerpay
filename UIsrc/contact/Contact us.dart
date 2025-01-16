import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../UIKonstant/KUiComponents.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  void messageOnWhatsapp (String adminPhone) async{
    final Uri whatsappUrl = Uri.parse('https://wa.me/$adminPhone');
    if(await canLaunchUrl(whatsappUrl)){
      await launchUrl(whatsappUrl);
      
    }else{
      context.mounted ?ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red.shade800,
          content:
          const Center(child: Text("Could not open whatsapp, please try saving our contact and contacting us directly."))),
    ): null;}
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: kbackgroundColorLightMode,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: kbackgroundColorLightMode,
            elevation: 7*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
            leading: GestureDetector(
                onTap: (){
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child:  Icon(Icons.arrow_back_ios_new, color: ktextColor,size: 20*MediaQuery.of(context).size.height/768,)),
            iconTheme:  IconThemeData(color: ktextColor,size: 20*MediaQuery.of(context).size.height/768),
            title:  Text('CONTACT US',style: GoogleFonts.kadwa(color: ktextColor,fontSize: 15*MediaQuery.of(context).size.height/768

                ,fontWeight: FontWeight.w700)),


          ),
          body: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Expanded(
                        child: Text(
                          "",
                          style: GoogleFonts.kadwa(
                              fontWeight: FontWeight.w900,
                              color: ktextColor,
                              fontSize: 13*MediaQuery.of(context).size.height/768),
                        ),
                      ),
                    ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: (){
                        messageOnWhatsapp('08119543742');
                      },
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.grey.withOpacity(0.1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                                Padding(
                                 padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8,right: 0),
                                 child: FaIcon(FontAwesomeIcons.whatsapp,size: 30,color: Colors.grey.shade700,)
                               ),
                              Expanded(
                                child: Text(
                                  '',
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 10*MediaQuery.of(context).size.height/768),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  '+234 8119543742',
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w500,
                                      color: ktextColor,
                                      fontSize: 10*MediaQuery.of(context).size.height/768),
                                ),
                              ),

                               Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 4),
                                child: GestureDetector(
                                    onTap: (){
                                      FlutterClipboard.copy('08119543742');
                                    },
                                    child: const FaIcon(FontAwesomeIcons.copy,size: 20,color: Colors.green,)),
                              ),

                               Padding(
                                padding: const EdgeInsets.only(left: 12.0,right: 16),
                                child: GestureDetector(
                                    onTap: (){messageOnWhatsapp('08119543742');},
                                    child: const FaIcon(FontAwesomeIcons.paperPlane,size: 20,color: Colors.deepOrange,)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(

                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.grey.withOpacity(0.1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                               Padding(
                                  padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8,right: 0),
                                  child: FaIcon(FontAwesomeIcons.phone,size: 25,color: Colors.grey.shade700,)
                              ),
                              Expanded(
                                child: Text(
                                  '',
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 10*MediaQuery.of(context).size.height/768),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  '+234 8119543742',
                                  style: GoogleFonts.kadwa(
                                      fontWeight: FontWeight.w500,
                                      color: ktextColor,
                                      fontSize: 10*MediaQuery.of(context).size.height/768),
                                ),
                              ),
                               Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 16),
                                child: GestureDetector(
                                    onTap: (){FlutterClipboard.copy('08119543742');},
                                    child: const FaIcon(FontAwesomeIcons.copy,size: 20,color: Colors.green,)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 80*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey.withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Icon(
                                Icons.mail,
                                color: Colors.grey,
                                size: 25*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
                            ),
                             ),
                            Expanded(
                              child: Text(
                                '',
                                style: GoogleFonts.kadwa(
                                    fontWeight: FontWeight.w700,
                                    color: ktextColor,
                                    fontSize: 10*MediaQuery.of(context).size.height/768),
                              ),
                            ),
                            SelectableText(
                              'Customercare@powerpay.com.ng',
                              style: GoogleFonts.kadwa(
                                  fontWeight: FontWeight.w500,
                                  color: ktextColor,
                                  fontSize: 10*MediaQuery.of(context).size.height/768),
                            ),

                             Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 16),
                              child: GestureDetector(
                                  onTap: (){
                                    FlutterClipboard.copy('Customercare@powerpay.com.ng');
                                  },
                                  child: const FaIcon(FontAwesomeIcons.copy,size: 20,color: Colors.green,)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 80*MediaQuery.of(context).size.height/MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.grey.withOpacity(0.1)),
                      child: Padding(
                        padding:  EdgeInsets.all(8*MediaQuery.of(context).size.height/768),
                        child: Row(
                          children: [
                             Icon(
                              Icons.facebook_sharp,
                              color: Colors.grey,
                              size: 25*MediaQuery.of(context).size.height/768,
                            ),
                            Expanded(
                              child: Text(
                                ' Instagram',
                                style: GoogleFonts.kadwa(
                                    fontWeight: FontWeight.w700,
                                    color: ktextColor,
                                    fontSize: 10*MediaQuery.of(context).size.height/768),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SelectableText(
                                '@OfficialPowerpay',
                                style: GoogleFonts.kadwa(
                                    fontWeight: FontWeight.w500,
                                    color: ktextColor,
                                    fontSize: 10*MediaQuery.of(context).size.height/768),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
