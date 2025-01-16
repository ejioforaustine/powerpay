import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../UIsrc/Authentication/SignUp.dart';


class CustomAuthProvider {


  void adddetailstoStore ()async{
    var userInstance = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(userInstance!.email).set({
      'Email': Email.text,
      'name': name.text,
      'phone' : Phone.text
    }).whenComplete(() => print('Updated')).
    catchError((error){print(error.toString());});

  }

  void addGoogleDetailsToStore ()async{
    var userInstance = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(userInstance!.email).set({
      'Email': Email.text,
      'name': name.text,
      'phone' : Phone.text
    }).whenComplete(() => print('Updated')).
    catchError((error){print(error.toString());});
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmail(String email, String password) async{
    try {

      UserCredential result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      User? user = result.user;
      if(user != null)
      { Fluttertoast.showToast(
          msg: "Login successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green.shade800,
          textColor: Colors.white,
          timeInSecForIosWeb: 1,
          fontSize: 15.0
      );
      return true;}
      else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> createUserWithEmail(String email, String password) async{
    try {


      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;
      if(user != null)
      {
        adddetailstoStore();
        Fluttertoast.showToast(
          msg: "SignUp Successfully ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green.shade800,
          textColor: Colors.white,
          fontSize: 15.0
      );
      return true;}
      else {
        return false;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString().replaceAll(RegExp(r'^.*\]'),''));
      return false;
    }
  }


  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if(account == null ) {
        return false;
      }
      UserCredential res = await _auth.signInWithCredential(GoogleAuthProvider.credential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      if(res.user == null) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      print("Error logging with google");
      return false;
    }
  }



  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<dynamic> Resetpass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Email may not be registered with us Check again");
      return false;
    }
  }


}