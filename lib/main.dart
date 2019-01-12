import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'DetailScreen.dart';

void main() => runApp(MyApp());

class UserDetails {
  final String providerId;

  final String uid;

  final String displayName;

  final String photoUrl;

  final String email;

  final bool isAnonymous;

  final bool isEmailVerified;

  final List<UserInfoDetails> providerData;

  UserDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);
}

class UserInfoDetails {
  UserInfoDetails(
      this.providerId, this.displayName, this.email, this.photoUrl, this.uid);

  /// The provider identifier.
  final String providerId;

  /// The provider’s user ID for the user.
  final String uid;

  /// The name of the user.
  final String displayName;

  /// The URL of the user’s profile photo.
  final String photoUrl;

  /// The user’s email address.
  final String email;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    UserInfoDetails userInfo = new UserInfoDetails(
        user.providerId, user.displayName, user.email, user.photoUrl, user.uid);

    List<UserInfoDetails> providerData = new List<UserInfoDetails>();
    providerData.add(userInfo);

    UserDetails details = new UserDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);

    print("signed in : ${user.displayName}");
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
        builder: (context) => new DetailScreen(detailsUser: details),
      ),
    );
    return user;
  }

  void _signOut(BuildContext context) {
    _googleSignIn.signOut();
    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    final String userName = "";

    return new MyInhWidget(
        userName: userName,
        child: new Scaffold(
          //backgroundColor: Colors.blueGrey,
          body: new Center(
              child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GoogleSignInButton(onPressed: () => _signIn(context)
                              .then((FirebaseUser user) => print(user))
                              .catchError((e) => print(e))),
                
                new Builder(
                  builder: (BuildContext context) {
                    return new Material(
                      borderRadius: new BorderRadius.circular(30.0),
                      child: new Material(
                        elevation: 5.0,
                        child: new MaterialButton(
                          minWidth: 150.0,
                          onPressed: () => _signOut(context),
                          child: new Text('Sign Out'),
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )),
        ));
  }
}

class MyInhWidget extends InheritedWidget {
  const MyInhWidget({Key key, this.userName, Widget child})
      : super(key: key, child: child);

  final String userName;

  //const MyInhWidget(userName, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(MyInhWidget old) {
    return userName != old.userName;
  }

  static MyInhWidget of(BuildContext context) {
    // You could also just directly return the name here
    // as there's only one field
    return context.inheritFromWidgetOfExactType(MyInhWidget);
  }
}