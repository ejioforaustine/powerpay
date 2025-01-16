import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:powerpay/UIsrc/ElectricityUi/AddMeternumber.dart';
import 'package:powerpay/UIsrc/home/Home.dart';

import '../../Core/Functions/constantvaribles.dart';
import '../Authentication/Signin.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Iconsax.arrow_left,
                      size: 40,
                    )),
              ),
              const SizedBox(
                width: 120,
              ),
              Expanded(
                child: Text(
                  'Profile',
                  style: GoogleFonts.kadwa(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 25),
                ),
              ),
            ],
          ),

          ///profile Data
          ///Name
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 0, 2),
            child: Text(
              'Name',
              style: GoogleFonts.kadwa(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white)),
                prefixIcon:  Icon(Icons.lock,color: Colors.grey.shade200,),

                fillColor: Colors.grey.shade200,
                filled: true,
                labelText: usersName,
                hoverColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.2),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),

          ///Email

          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 0, 2),
            child: Text(
              'Email:',
              style: GoogleFonts.kadwa(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white)),
                prefixIcon:  Icon(Icons.lock,color: Colors.grey.shade200,),

                fillColor: Colors.grey.shade200,
                filled: true,
                labelText: userEmail.toString(),
                hoverColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.2),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),

          ///phone

          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 0, 2),
            child: Text(
              'Phone:',
              style: GoogleFonts.kadwa(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white)),
                prefixIcon:  Icon(Icons.lock,color: Colors.grey.shade200,),

                fillColor: Colors.grey.shade200,
                filled: true,
                labelText: usersPhone,
                hoverColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.2),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          ///Delete Account

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: (){
                Fluttertoast.showToast( msg: 'Long press to Delete');},
              onLongPress: ()async{
                try {
                  Fluttertoast.showToast( msg: 'Deleting');
                  await userInstance?.delete();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));}catch(e){}



              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red.shade700),
                child: Center(
                  child: Text(
                    'Delete Account',
                    style: GoogleFonts.kadwa(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
