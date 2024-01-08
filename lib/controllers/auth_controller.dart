import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../utils/gravatar.dart';
import '../utils/snack_bar_custom.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isPasswordHidden1 = true.obs;
  final RxBool isPasswordHidden2 = true.obs;

  String usersDocFirebase = 'users';

  final RxBool isLoadingForLogin = false.obs;
  final RxBool isLoadingForSignUp = false.obs;

  final sliding = 0.obs;
  final emailControllerForLogin = TextEditingController();
  final passwordControllerForLogin = TextEditingController();
  final emailControllerForSignUp = TextEditingController();
  final nameControllerForSignUp = TextEditingController();
  final passwordControllerForSignUp = TextEditingController();
  final confirmPasswordControllerForSignUp = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
    update();
  }

  void togglePasswordVisibility1() {
    isPasswordHidden1.value = !isPasswordHidden1.value;
    update();
  }

  void togglePasswordVisibility2() {
    isPasswordHidden2.value = !isPasswordHidden2.value;
    update();
  }

  void changeSlidingValue(int index) {
    sliding.value = index;
    log(sliding.value.toString());
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  final RxBool _loggedIn = false.obs;
  final RxBool _isNewUser = false.obs;
  final _formKey = GlobalKey<FormState>().obs;
  final _formKeyLogin = GlobalKey<FormState>().obs;

  GlobalKey<FormState> get formKey => _formKey.value;
  GlobalKey<FormState> get formKeyLogin => _formKeyLogin.value;

  bool get isNewUser => _isNewUser.value;

  set isNewUser(bool value) => _isNewUser.value = value;
  String? _userRole;

  UserModel? get firestoreUserModel => firestoreUser.value;
  bool get loggedIn => _loggedIn.value;
  String? get userRole => _userRole;
  Stream<User?> get user => _auth.authStateChanges();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onReady() async {
    log(firebaseUser.string);
    ever(firebaseUser, handleAuthChanged);
    log(firebaseUser.string);
    firebaseUser.bindStream(user);
    super.onReady();
  }

  @override
  void onClose() {
    emailControllerForLogin.dispose();
    passwordControllerForLogin.dispose();
    emailControllerForSignUp.dispose();
    nameControllerForSignUp.dispose();
    passwordControllerForSignUp.dispose();
    confirmPasswordControllerForSignUp.dispose();
    super.onClose();
  }

  Stream<UserModel> streamFirestoreUser() {
    try {
      log('streamFirestoreUser() started');
      log(firebaseUser.value!.toString());
      if (firebaseUser.value != null) {
        return _db
            .doc('/$usersDocFirebase/${firebaseUser.value!.uid}')
            .snapshots()
            .map((snapshot) => UserModel.fromMap(snapshot.data()!));
      } else {
        return const Stream.empty();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void handleAuthChanged(firebaseUser) async {
    try {
      //get user data from firestore
      log('handleAuthChanged() started');
      if (firebaseUser?.uid != null) {
        firestoreUser.bindStream(streamFirestoreUser());
        if (firestoreUser.value != null) {
          _userRole = firestoreUser.value!.role;
        }
      }

      if (firebaseUser == null) {
        _loggedIn.value = false;
        update();
      } else {
        _loggedIn.value = true;
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel> getFirestoreUser() {
    try {
      return _db
          .doc('/$usersDocFirebase/${firebaseUser.value!.uid}')
          .get()
          .then((documentSnapshot) =>
              UserModel.fromMap(documentSnapshot.data()!));
    } on FirebaseException catch (e) {
      log("FirebaseException: ${e.message}");
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateUserFirestore(UserModel user, User firebaseUser) async {
    log('updateUserFirestore() started');
    bool isSuccessFull = false;
    try {
      log(user.toJson().toString());
      await _db
          .doc('/$usersDocFirebase/${firebaseUser.uid}')
          .update(user.toJson())
          .timeout(const Duration(seconds: 10), onTimeout: () {
        isSuccessFull = false;
        log('updateUserFirestore() timed out');
        return ShowSnackBar.snackError(
            title: "ERROR!", sub: "Please check your internet connection");
      });
      isSuccessFull = true;
      update();
    } on FirebaseException catch (error) {
      String errorMessage = Constants.firebaseAuthExceptions[error.code] ??
          "An undefined Error happened.";
      ShowSnackBar.snackError(title: 'ERROR!', sub: errorMessage);
      isSuccessFull = false;
    } catch (e) {
      isSuccessFull = false;
      ShowSnackBar.snackError(
          title: 'ERROR! ', sub: 'Please Contact Support for help');
      log(e.toString());
    }
    return isSuccessFull;
  }

  Future<void> _createUserFirestore(UserModel user, User firebaseUser) async {
    await _db.doc('/$usersDocFirebase/${firebaseUser.uid}').set(user.toJson());
    update();
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoadingForLogin.value = true;
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                log("Value is $value"),
                if (value.user != null)
                  {
                    isLoadingForLogin.value = false,
                    Get.offAllNamed(RouteStrings.home),
                    // ShowSnackBar.snackSuccess(
                    //     title: 'SUCCESS!', sub: 'Signed In Successfully'),
                  }
              })
          .timeout(6.seconds, onTimeout: () {
        isLoadingForLogin.value = false;
        ShowSnackBar.snackError(
            title: 'ERROR! Timed Out',
            sub: 'Check your internet connection and try again');

        // ignore: null_argument_to_non_null_type
        return Future.value(null);
      });
    } on FirebaseAuthException catch (error) {
      isLoadingForLogin.value = false;
      String errorMessage = Constants.firebaseAuthExceptions[error.code] ??
          "An undefined Error happened.";
      ShowSnackBar.snackError(title: 'ERROR!', sub: errorMessage);
      log(error.code);
    } catch (e) {
      isLoadingForLogin.value = false;
      ShowSnackBar.snackError(
          title: 'ERROR! ', sub: 'Please Contact Support for help');
      log(e.toString());
    }
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required String name}) async {
    bool isSuccessFull = false;
    try {
      isLoadingForSignUp.value = true;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        log(Gravatar(email).imageUrl(
          size: 200,
          defaultImage: GravatarImage.retro,
          rating: GravatarRating.g,
          fileExtension: true,
        ));
        final imageUrl = Gravatar(email).imageUrl(
          size: 200,
          defaultImage: GravatarImage.retro,
          rating: GravatarRating.g,
          fileExtension: true,
        );
        final UserModel user = UserModel(
          name: name,
          photoUrl: imageUrl,
          status: 'UNVERIFIED',
          userID: value.user!.uid,
          email: value.user!.email!,
          role: 'GENERAL_USER',
        );
        log(user.toJson().toString());
        await _createUserFirestore(user, value.user!);
        await value.user!.sendEmailVerification();
        isLoadingForSignUp.value = false;
        // HomePageController.to.onItemTapped(2);
        isSuccessFull = true;
        ShowSnackBar.snackSuccess(
            title: 'SUCCESS!', sub: 'Account created successfully');
        Get.back();
      });
    } on FirebaseAuthException catch (error) {
      log(error.toString());
      String errorMessage = Constants.firebaseAuthExceptions[error.code] ??
          "An undefined Error happened.";
      ShowSnackBar.snackError(title: 'ERROR!', sub: errorMessage);
      log(error.code);
      isLoadingForSignUp.value = false;
      isSuccessFull = false;

      return isSuccessFull;
    } catch (e) {
      log(e.toString());
      ShowSnackBar.snackError(
          title: 'ERROR!', sub: "Please Contact Support for help");
      isLoadingForSignUp.value = false;
      isSuccessFull = false;
      return isSuccessFull;
    }
    return isSuccessFull;
  }

  DocumentReference<Map<String, dynamic>> getDoc() {
    return _db.collection('$usersDocFirebase').doc(firebaseUser.value?.uid);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // await FacebookAuth.instance.logOut();
      ShowSnackBar.snackSuccess(
          title: 'Signed Out!', sub: 'Signed out successfully');
    } on FirebaseAuthException catch (error) {
      String errorMessage = Constants.firebaseAuthExceptions[error.code] ??
          "An undefined Error happened.";
      ShowSnackBar.snackError(title: 'ERROR!', sub: errorMessage);
      log(error.message!);
    } catch (e) {
      log(e.toString());
      ShowSnackBar.snackError(
          title: 'ERROR!', sub: "Please Contact Support for help");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ShowSnackBar.snackSuccess(
          title: 'SUCCESS!', sub: 'Password reset email sent successfully');
    } on FirebaseAuthException catch (error) {
      String errorMessage = Constants.firebaseAuthExceptions[error.code] ??
          "An undefined Error happened.";
      ShowSnackBar.snackError(title: 'ERROR!', sub: errorMessage);
      log(error.code);
    } catch (e) {
      ShowSnackBar.snackError(
          title: 'ERROR!', sub: "Please Contact Support for help");
    }
  }
}
