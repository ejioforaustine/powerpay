import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/KYC/ID%20card.dart';

import 'SelfiePhoto.dart';

class BVNandNINDetails extends StatefulWidget {
  const BVNandNINDetails({super.key});

  @override
  State<BVNandNINDetails> createState() => _BVNandNINDetailsState();
}

class _BVNandNINDetailsState extends State<BVNandNINDetails> {

  String buttonMessage = 'Submit';

  final TextEditingController _controller = TextEditingController();
  final TextEditingController bvnController = TextEditingController();
  final TextEditingController ninController = TextEditingController();


  // Function to update Fire store document with BVN and NIN
  Future<void> updateBVNandNIN(String email) async {
    // Sanitize the email to use it as a Firestore document ID
    String sanitizedEmail = email.replaceAll('.', '_');

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

    // Get BVN and NIN values from the TextEditingControllers
    String bvn = bvnController.text.trim();
    String nin = ninController.text.trim();
    String birthdate = _controller.text;

    // Update the Fire store document with BVN and NIN
    await userDocRef.update({
      'BVN': bvn, // Set BVN field
      'NIN': nin, // Set NIN field
      'Date of Birth': birthdate,
    });

    print('BVN and NIN updated for user $sanitizedEmail.');
  }

  void _formatDate() {
    String text = _controller.text;
    String formattedText = _formatText(text);

    if (text != formattedText) {
      print('formatted');
      print(text);
      // Update the text and cursor position
      _controller.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: formattedText.length),
        ),
      );
      print(formattedText);
    }


  }

  String _formatText(String text) {
    // Remove non-digit characters
    String digits = text.replaceAll(RegExp(r'\D'), '');

    // Ensure the year part is always 4 digits
    if (digits.length > 8) {
      digits = digits.substring(0, 8) + digits.substring(8).padLeft(4, '0');
    }



    // Format the text as dd/MM/yyyy
    String day = digits.isNotEmpty ? digits.substring(0, 2) : '';
    String month = digits.length >= 3 ? digits.substring(2, 4) : '';
    String year = digits.length >= 5 ? digits.substring(4, 8) : '';

    print('$day date in days');

    return '${day.isNotEmpty ? '$day/' : ''}${month.isNotEmpty ? '$month/' : ''}${year}';
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_formatDate);

  }

  @override
  void dispose() {
    _controller.removeListener(_formatDate);
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,left: 24, bottom: 0),
            child: Row(
              children: [
                Text(
                  'Hi,',
                  style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: Row(
              children: [
                Text(
                  'Additional details are needed,',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 32,right: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'In order to comply with regulatory framework, we need KYC details to continue.',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TextFields
          ///BVN
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: bvnController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                  prefixIcon: const Icon(Icons.numbers_sharp),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  labelText: "Enter BVN",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(20))),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30,),

          ///Date on birth
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: TextFormField(
              cursorColor: Colors.black,
              controller: _controller,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                  prefixIcon: const Icon(Icons.date_range),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  labelText: "Date of Birth (dd/mm/yyyy)",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(20))),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30,),
          ///NIN

          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: TextFormField(
              cursorColor: Colors.black,
              controller: ninController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                  prefixIcon: const Icon(Icons.numbers_rounded),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  labelText: "NIN NUMBER",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(20))),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),


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
                    child: Text(buttonMessage,style: GoogleFonts.inter(fontWeight: FontWeight.w900,color: Colors.white),),
                    onPressed: () async {
                       if (_controller.text.length <10 ){
                         // Create the SnackBar
                         const snackBar = SnackBar(
                           elevation: 10,
                           backgroundColor: Colors.red,
                           content: Text('Invalid date of birth'),
                         );
                         // Use ScaffoldMessenger to show the SnackBar
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       }
                       //Nin
                       else if (ninController.text.length <11 || ninController.text.length >11) {
                         // Create the SnackBar
                         const snackBar = SnackBar(
                           elevation: 10,
                           backgroundColor: Colors.red,
                           content: Text('Invalid NIN number'),
                         );
                         // Use ScaffoldMessenger to show the SnackBar
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       }
                       //bvn
                       else if (bvnController.text.length <11 || bvnController.text.length >11) {
                         // Create the SnackBar
                         const snackBar = SnackBar(
                           elevation: 10,
                           backgroundColor: Colors.red,
                           content: Text('Invalid BVN number'),
                         );
                         // Use ScaffoldMessenger to show the SnackBar
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       }

                       else {

                         setState(() {
                           buttonMessage = 'Submitting...';
                         });
                         await updateBVNandNIN(userEmail!);
                         setState(() {
                           buttonMessage = 'Submitted';
                         });
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const ValidIdUplaod()));
                       }


                    }, ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}


