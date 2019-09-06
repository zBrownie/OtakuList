import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;
  FirebaseUser user;
  Map<String, dynamic> dataUser = Map();

  bool isLoading = false;

  loadingScreenON(){
    isLoading = true;
    notifyListeners();
  }


  loadingScreenOFF(){
    isLoading = true;
    notifyListeners();
  }
  UserModel.fromMap(DocumentSnapshot snapshot) {
    this.dataUser = snapshot.data;
  }

  UserModel() {
    _auth.onAuthStateChanged.listen((newUser) {
      this.user = newUser;
      notifyListeners();
    });
  }

  Future<UserModel> getUserData() {
    _store
        .collection('usuarios')
        .document(user.uid)
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot));
  }

  Future<FirebaseUser> getUserLogged() {
    return _auth.currentUser();
  }

  Stream<UserModel> userData() {
    return _store
        .collection('usuarios')
        .document(user.uid)
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot));
  }

  Future<void> signInFirebaseAuth({@required email, @required password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('###   ERROR LOGIN AUTH $e     ###');
    }
  }

  Future<void> signUpFirebaseAuth({@required email, @required password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception('###    ERRO REGISTER AUTH $e    ###');
    }
  }

  Future<void> signOutFirebaseAuth() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('###    ERRO SIGNOUT AUTH $e    ###');
    }
  }

}