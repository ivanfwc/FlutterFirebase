import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'HomePage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

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

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

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
        builder: (context) => new HomePage(detailsUser: details),
      ),
    );
    return user;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Do you want to exit the App?'),
                //content: new Text('Do you want to exit the App?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    /* final String userName = "";

    return new MyInhWidget(
        userName: userName,
        child: new Scaffold(
          backgroundColor: Colors.blueGrey,
          body: new Center(
              child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GoogleSignInButton(
                    onPressed: () => _signIn(context)
                        .then((FirebaseUser user) => print(user))
                        .catchError((e) => print(e)))
              ],
            ),
          )),
        )); */

    final welcome = Padding(
      padding: EdgeInsets.all(100.0),
      child: Text(
        'Welcome',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final gSignInButton = GoogleSignInButton(
        onPressed: () => _signIn(context)
            .then((FirebaseUser user) => print(user))
            .catchError((e) => print(e)));

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[welcome, gSignInButton],
      ),
    );

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        body: body,
      ),
    );

    /* return Scaffold(
      body: body,
    ); */
  }
}

/* class MyInhWidget extends InheritedWidget {
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
} */
