import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class termsandconditions extends StatefulWidget {
   const termsandconditions({Key? key, required this.url}) : super(key: key);

   final String url;

  @override
  State<termsandconditions> createState() => _termsandconditionsState();
}

class _termsandconditionsState extends State<termsandconditions> {
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 7,

        iconTheme: const IconThemeData(color: Colors.black,size: 30),
        title:  Text('TERMS & CONDITIONS',style: GoogleFonts.kadwa(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900)),


      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
