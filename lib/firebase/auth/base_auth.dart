import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

// Абстрактный класс авторизации
abstract class BaseAuth {
  // Авторизация по номеру телефона
//  signInPhone(String phone);
  // Авторизация по email
  Future <String> signInEmail();

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();
}



// Класс авторизации
class Auth implements BaseAuth {
  var _phone, _verificationId, _authCredential;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static StreamController<String> _statusStream = StreamController();
//  static StreamController<PhoneAuthState> _phoneAuthState = StreamController(sync: true);

  static Stream streamStatus = _statusStream.stream;
//  static Stream streamPhoneAuthState = _phoneAuthState.stream;

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<String> signInEmail() {
    // TODO: implement signInEmail
    return null;
  }

//  @override
//  signInPhone(String phone) {
//    print(phone);
//    _phone = phone;
//    _firebaseAuth.verifyPhoneNumber(
//        phoneNumber: phone,
//        timeout: Duration(seconds: 60),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: verificationFailed,
//        codeSent: codeSent,
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
//    );
//  }
  // Успешная проверка
//  Future<String> verificationCompleted(AuthCredential auth) async {
//    addStatus('Auto retrieving verification code');
//
//    _firebaseAuth.signInWithCredential(auth).then((AuthResult value) {
//      if (value.user != null) {
//        addStatus('Authentication successful');
//        addState(PhoneAuthState.Verified);
////        onAuthenticationSuccessful();
//      } else {
//        addState(PhoneAuthState.Failed);
//        addStatus('Invalid code/invalid authentication');
//      }
//    }).catchError((error) {
//      addState(PhoneAuthState.Error);
//      addStatus('Something has gone wrong, please try later $error');
//    });
//  }
//  // Отлов ошибки проверки
//  Future<String> verificationFailed(AuthException authException) async {
//    addStatus('${authException.message}');
//    addState(PhoneAuthState.Error);
//    if (authException.message.contains('not authorized'))
//      addStatus('App not authroized');
//    else if (authException.message.contains('Network'))
//      addStatus('Please check your internet connection and try again');
//    else
//      addStatus('Something has gone wrong, please try later ' +
//          authException.message);
//  }
//  // Отправка сообщения
//  Future<String> codeSent(String verificationId, [int forceResendingToken]) async {
//    _verificationId = verificationId;
//    addStatus("\nEnter the code sent to " + _phone);
//    addState(PhoneAuthState.CodeSent);
//  }
//  // ???
//  Future<String> codeAutoRetrievalTimeout(String verificationId) {
//    _verificationId = verificationId;
//    addStatus("\nAuto retrieval time out");
//    addState(PhoneAuthState.AutoRetrievalTimeOut);
//  }

//  void signInWithPhoneNumber(String smsCode) {
//    _authCredential = PhoneAuthProvider
//        .getCredential(verificationId: _verificationId, smsCode: smsCode);
//
//    _firebaseAuth
//        .signInWithCredential(_authCredential);
////        .then((FirebaseUser user) async {
////      addStatus('Authentication successful');
////      addState(PhoneAuthState.Verified);
////      onAuthenticationSuccessful();
////    }).catchError((error) {
////      addState(PhoneAuthState.Error);
////      addStatus('Something has gone wrong, please try later(signInWithPhoneNumber) $error');
////    });
//  }



  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

//  static addState(PhoneAuthState state){
//    _phoneAuthState.add(state);
//  }
//  static void addStatus(String s) {
//    _statusStream.add(s);
//  }
}