import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

class Constants {
  static Map<String, String> firebaseAuthExceptions = {
    "invalid-email": "Your email address appears to be malformed.",
    "email-already-in-use": "Email Already Registered",
    "wrong-password": "Your password is wrong.",
    "user-not-found": "User with this email doesn't exist.",
    "user-disabled": "User with this email has been disabled.",
    "ERROR_OPERATION_NOT_ALLOWED": "Anonymous accounts are not enabled",
    "ERROR_WEAK_PASSWORD": "Your password is too weak",
    "ERROR_INVALID_EMAIL": "Your email is invalid",
    "ERROR_EMAIL_ALREADY_IN_USE":
        "Email is already in use on different account",
    "ERROR_WRONG_PASSWORD": "Your password is wrong",
    "ERROR_USER_NOT_FOUND": "User with this email doesn't exist.",
    "network-request-failed":
        "No Internet Connection, Please make sure you have active internet Connection",
    "ERROR_INVALID_CREDENTIAL": "Your email is invalid",
    "too-many-requests": "Too many requests",
    "operation-not-allowed":
        "Signing in with Email and Password is not enabled.",
    "auth/invalid-email": "Your email address appears to be malformed.",
    "invalid-credential": "Invalid Credentials.",
    "auth/user-not-found": "User with this email doesn't exist.",
    "auth/user-disabled": "User with this email has been disabled.",
    "auth/wrong-password": "Your password is wrong.",
    "auth/weak-password": "Your password is too weak.",
    "auth/email-already-in-use": "Email Already Registered",
    "auth/operation-not-allowed": "Anonymous accounts are not enabled",
    "auth/invalid-credential": "Your email is invalid",
    "auth/invalid-verification-code": "Invalid Verification Code",
    "auth/invalid-verification-id": "Invalid Verification ID",
    "auth/credential-already-in-use": "Credential Already In Use",
    "auth/invalid-phone-number": "Invalid Phone Number",
    "auth/missing-phone-number": "Missing Phone Number",
    "auth/missing-verification-code": "Missing Verification Code",
    "auth/missing-verification-id": "Missing Verification ID",
  };

  static const String googleMapsCustomDesign = """[
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "poi.business",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        {"visibility": "off"}
      ]
    }
  ]""";

  static const List<String> locations = [
    "Paddington",
    "Inner West",
    "Darlinghurst",
    "Chippendale",
    "Greater Sydney",
    "Regional NSW",
    "Sydney CBD",
    "Sth Melbourne",
    "Richmond",
    "CBD",
    "Fitzroy",
    "Brunswick",
    "Greater Melbourne",
  ];

  static const List<String> filterBarItemsSyd = [
    "Sydney",
    "Opening Soon",
    "Featured",

    // "Current",
    "Nearby",
    "CBD",
    "Darlinghurst",
    "Paddington",
    "Chippendale",
    "Inner West",
    "Greater Sydney",
    "Regional NSW",
    // "Independent",
    "Commercial",
    "Institution",
  ];
  static const List<String> filterBarItemsMel = [
    "Melbourne",
    "Opening Soon",
    "Featured",

    // "Current",
    "Nearby",
    "CBD",
    "Sth Melbourne",
    "Richmond",
    "Fitzroy",
    "Brunswick",
    "Greater Melbourne",
    // "Independent",
    "Commercial",
    "Institution",
  ];
  static const List<String> galleryTypes = [
    "Artist Run",
    // "Independent",
    "ARI",
    "Commercial",
    "Institution",
  ];
}
