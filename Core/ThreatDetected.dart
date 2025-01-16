import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


String threatReason = '';

class ThreatPage extends StatefulWidget {
  const ThreatPage({Key? key}) : super(key: key);

  @override
  State<ThreatPage> createState() => _UpdatesNewVersionState();
}

class _UpdatesNewVersionState extends State<ThreatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 7,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        title: Text('Unauthorized ENV Mode detected!',
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
                threatReason,
                style: GoogleFonts.arimo(fontWeight: FontWeight.w900,fontSize: 13),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
