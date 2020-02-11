import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

enum PhoneAuthState { Started, CodeSent, CodeResent, Verified, Failed, Error, AutoRetrievalTimeOut }

class FirebasePhoneAuth {
  static var firebaseAuth;
  static var _authCredential, actualCode, phone, status;
  static StreamController<String> statusStream = StreamController();
  static StreamController<PhoneAuthState> phoneAuthState = StreamController(sync: true);
  static Stream stateStream = phoneAuthState.stream;

  static instantiate({String phoneNumber}) async {
    firebaseAuth = await FirebaseAuth.instance;
    phone = phoneNumber;
    startAuth();
  }

  static close() {
    statusStream.close();
    phoneAuthState.close();
  }

  static startAuth() {
    statusStream.stream
        .listen((String status) => debugPrint("PhoneAuth: " + status));

    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  static final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    addStatus("\nEnter the code sent to " + phone);
    addState(PhoneAuthState.CodeSent);
  };

  static final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    actualCode = verificationId;
    addStatus("\nAuto retrieval time out");
    addState(PhoneAuthState.AutoRetrievalTimeOut);
  };

  static final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    addStatus('${authException.message}');
    addState(PhoneAuthState.Error);
    if (authException.message.contains('not authorized'))
      addStatus('App not authroized');
    else if (authException.message.contains('Network'))
      addStatus('Please check your internet connection and try again');
    else
      addStatus('Something has gone wrong, please try later ' +
          authException.message);
  };

  static final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential auth) {
    addStatus('Auto retrieving verification code');

    firebaseAuth.signInWithCredential(auth).then((AuthResult value) {
      if (value.user != null) {
        addStatus(status = 'Authentication successful');
        addState(PhoneAuthState.Verified);
        onAuthenticationSuccessful(value.user);
      } else {
        addState(PhoneAuthState.Failed);
        addStatus('Invalid code/invalid authentication');
      }
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus('Something has gone wrong, please try later $error');
    });
  };

  static void signInWithPhoneNumber(String smsCode) async {
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);

    firebaseAuth
        .signInWithCredential(_authCredential)
        .then((FirebaseUser user) async {
      addStatus('Authentication successful');
      addState(PhoneAuthState.Verified);
      onAuthenticationSuccessful(user);
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus('Something has gone wrong, please try later(signInWithPhoneNumber) $error');
    });
  }

  /*
   * После успешной авторизации добавить пользователя в базу данных.
   */
  static onAuthenticationSuccessful(FirebaseUser value) {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    DatabaseReference _usersRef = _database.reference().child('users');

    // Новый пользователь
    Query _userQuery = _usersRef
        .orderByChild("userId")
        .equalTo(value.uid);

      _userQuery.once().then((DataSnapshot snapshot){
        if (snapshot.value==null) {
          _usersRef.push().set(<String, String> {
            "userId": value.uid,
            "login": value.phoneNumber,
            "name": value.phoneNumber,
          }).then((_){
            print('Transaction  committed.');
          });
        }
      });
  }

  static addState(PhoneAuthState state){
    phoneAuthState.sink.add(state);
  }

  static void addStatus(String s) {
    statusStream.sink.add(s);
  }
}
