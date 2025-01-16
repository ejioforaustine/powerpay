import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:powerpay/KYC/SelfiePhoto.dart';

import '../Core/Functions/constantvaribles.dart';
import '../Onboarding/onboardingpage.dart';
import 'BVN.dart';

class ValidIdUplaod extends StatefulWidget {
  const ValidIdUplaod({super.key});

  @override
  State<ValidIdUplaod> createState() => _ValidIdUplaodState();
}

class _ValidIdUplaodState extends State<ValidIdUplaod> {
  @override
  //initialized camera
  final ImagePicker _picker = ImagePicker();

  //progress variable
  dynamic uploadProgress = 0;
  bool uploading = true;

  //setState as parameter
  void callState (){
    setState(() {});
  }

  //button Text Variable
  /// warning !...Don't change default content as it's used in code logic below
  String buttonMessage = 'Upload ID Document';

  @override
  void initState(){
    super.initState();
    uploading = false;
  }

  @override
  void dispose (){
    uploading = false;
    super.dispose();
  }

  Future<void> _captureAndUploadImage(Function() callState) async {
    // Capture image from the camera

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    print('reached here 1');
    File file = File(image.path);

    print('reached here 2');

    try {
      print('trying to store');
      // Create a reference to the Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://polectro-60b65.appspot.com');
      Reference ref = storage.ref().child('KYC/$userEmail/ID/${DateTime.now().millisecondsSinceEpoch}.png');
      print('trying to store 2');
      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Optionally, you can use the `snapshot` to check upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred / snapshot.totalBytes * 100}%');
        uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        uploading = true;
        buttonMessage = 'Uploading...';
        callState();
      });

      // Get the download URL
      String downloadURL = await (await uploadTask).ref.getDownloadURL();
      buttonMessage = 'Next';
      callState();

      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Upload a Valid ID'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(top:64, left: 32, right: 32),
              child: Container(
                height: 200,

                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey.shade50
                ),
                child: uploading == false ?
                LottieBuilder.asset('assets/lottiefiles/Animation - 1723246626438 (1).json') :
                Center(
                  child: Text('${uploadProgress.toStringAsFixed(0)}%',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 30
                    ),

                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 32,bottom: 32,left: 32,right: 32),
              child: Container(
                decoration: BoxDecoration(

                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child:  Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text('Tips:')),
                      RichText(text: TextSpan(children: [
                        TextSpan(text: '1: Accepted ID type -', style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                        TextSpan(text: "  NIN (National Identification Number) ",
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.green))
                      ])),
                      const SizedBox(height: 4,),
                      Text('2: Make sure the captured image is HD clear before upload', style: GoogleFonts.inter(

                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                      const SizedBox(height: 4,),
                      const Text('3: Take Photo in a good lighting enviroment.'),
                      const SizedBox(height: 4,),
                      const Text('4: You must capture all corners of your ID (do not crop or edit)'),
                      const SizedBox(height: 4,),
                      const Text('5: Your photo ID must match your selfie photo'),

                    ],
                  ),
                ),
              ),
            ),


            //upload ID button
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
                      onPressed: () {
                        if(buttonMessage == 'Upload ID Document')
                        {_captureAndUploadImage(callState);}
                        else if (buttonMessage == 'Uploading...'){}
                        else {Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelfiePhoto()));}

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
