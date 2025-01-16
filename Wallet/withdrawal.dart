import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/UIKonstant/KUiComponents.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}
class _WithdrawalPageState extends State<WithdrawalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColorLightMode,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColorLightMode,
        elevation: 7,
        iconTheme:   IconThemeData(color: ktextColor, size: 30),
        title: Text('WITHDRAWAL',
            style: GoogleFonts.kadwa(
                color: ktextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              40, 0, 40, 8 * MediaQuery.of(context).size.height / 768),
          child: GestureDetector(
            onTap: (){
            },
            child: Container(
              height: MediaQuery.of(context).size.height/5,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        8 * MediaQuery.of(context).size.height / 768),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Note:',
                          style: GoogleFonts.arimo(
                              color: Colors.grey.shade700,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.017,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(
                        8 * MediaQuery.of(context).size.height / 768),
                    child: Text(
                      'To withdraw money back to your local account from your wallet, please contact us'
                          ' at Customercare@powerpay.com.ng or message us on whatsapp: +234 8119543742,'
                          ' to assist you with this',
                      style: GoogleFonts.arimo(
                          color: Colors.grey.shade700,
                          fontSize: MediaQuery.of(context).size.height * 0.016,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
