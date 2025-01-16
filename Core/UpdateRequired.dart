import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatesNewVersion extends StatefulWidget {
  const UpdatesNewVersion({Key? key}) : super(key: key);

  @override
  State<UpdatesNewVersion> createState() => _UpdatesNewVersionState();
}

class _UpdatesNewVersionState extends State<UpdatesNewVersion> {
  void openPlayStore () async{
    final Uri playStoreLink = Uri.parse('https://play.google.com/store/apps/details?id=com.polectro.polectro');
    if(await canLaunchUrl(playStoreLink)){
      await launchUrl(playStoreLink);

    }else{
      context.mounted ?ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red.shade800,
            content:
            const Center(child: Text("Could not open Google Play store, Please head over to your Play store and Update - CIAO."))),
      ): null;}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 7,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        title: Text('NEW UPDATE!',
            style: GoogleFonts.kadwa(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 170,
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                      'assets/images/142662-chameleon-changing-colour.json',animate: true),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'A NEW UPDATE IS REQUIRED TO CONTINUE, UPDATE FROM PLAYSTORE.',
                style: GoogleFonts.arimo(fontWeight: FontWeight.w900,fontSize: 13),

              ),
            ),
            const SizedBox(height: 20,),
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
                      child: Text('Update',style: GoogleFonts.inter(fontWeight: FontWeight.w900,color: Colors.white),),
                      onPressed: () async {
                       openPlayStore();
                      }, ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
