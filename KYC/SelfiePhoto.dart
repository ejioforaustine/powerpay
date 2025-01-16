import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:powerpay/Core/Functions/constantvaribles.dart';
import 'package:powerpay/UIsrc/home/Home.dart';
import 'package:powerpay/Virtual%20Card/UI/virtual%20card%20Home.dart';

class SelfiePhoto extends StatefulWidget {
  const SelfiePhoto({super.key});

  @override
  _SelfiePhotoState createState() => _SelfiePhotoState();
}

class _SelfiePhotoState extends State<SelfiePhoto> {

  // Function to update submitted status after KYC documents are submitted
  Future<void> updateSubmittedStatus(String email) async {
    // Sanitize the email to use it as a Firestore document ID
    String sanitizedEmail = email.replaceAll('.', '_');

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

    // Update the 'submitted_status' field to true
    await userDocRef.update({
      'submitted_status': true, // Set Submitted status to true
      'submitted_at': FieldValue.serverTimestamp(), // Optionally, add a timestamp for when the submission was made
    });

    print('Submitted status updated for user $sanitizedEmail.');
  }


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
  String buttonMessage = 'Take a Selfie';

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
      Reference ref = storage.ref().child('KYC/$userEmail/selfiePhoto/${DateTime.now().millisecondsSinceEpoch}.png');
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
      await updateSubmittedStatus(userEmail!);
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
        title: const Text('Upload a Selfie'),
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
        
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 32,bottom: 32,left: 32,right: 32),
                child: Container(
        
        
        
                  decoration: BoxDecoration(
        
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text('Tips:')),
                        Text('1: Make sure the captured image is HD clear before upload'),
                        Text('2: Take Photo in a good lighting environment.'),
                        Text('3: You must show your complete facial feature'),
                        Text('4: Your photo must match the photo on your ID'),
        
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
        
            //selfie button
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
                        if(buttonMessage == 'Take a Selfie')
                        {_captureAndUploadImage(callState);}
                        else if (buttonMessage == 'Uploading...'){}
                        else {
                          submittedStatus = true;
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                          }
        
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
