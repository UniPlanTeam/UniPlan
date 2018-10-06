///Login for FireBase login
///@author Praneet Singh
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class FireBaseLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
    
    Future<FirebaseUser> signInGoogleUser() async {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;

        _user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      print("User Name : ${_user.displayName}");
     return _user;
    }
  ///User can sign in with email and password
    Future<FirebaseUser> signEmailIn(String email, String password) async {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('signInEmail succeeded: $user');
     return user;
    }
    
    ///User can create a new account
  Future<FirebaseUser> createEmailUser(String email, String password) async {
   FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('signInEmail succeeded: $user');
     return user;
  }

  ///User can reset password through email varification
  Future<void> sendPasswordResetEmail(String email) async {
     return _auth.sendPasswordResetEmail(email: email);
  }
    Future<FirebaseUser> signOutUser() async{
      await _auth.signOut();
      await _googleSignIn.signOut();
      print("User Signed out");
    }

}