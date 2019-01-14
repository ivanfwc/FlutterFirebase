import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'LoginPage.dart'; //important fix

class HomePage extends StatelessWidget {
  static String tag = 'home-page';
  BuildContext contxt;
  final UserDetails detailsUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  HomePage({Key key, @required this.detailsUser}) : super(key: key);

  Future<void> _signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
      print("User Signed Out");
      Navigator.of(contxt)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    textStyle() {
      return new TextStyle(color: Colors.white, fontSize: 30.0);
    }

    /* return new Scaffold(
            appBar: new AppBar(
            title: new Text('Google Sign In Details'),
            automaticallyImplyLeading: false,
            ),
            body: new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
                children: <Widget>[
                new Image.network(detailsUser.photoUrl),
                new Text(
                    "Name : " + detailsUser.displayName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.2,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                new Padding(
                    padding: new EdgeInsets.all(5.0),
                ),
                new Text(
                    "Email : " + detailsUser.email,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.2,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                new Padding(
                    padding: new EdgeInsets.all(5.0),
                ),
                ],
            ),
            )); */

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                new Tab(
                  text: "First",
                ),
                new Tab(
                  text: "Second",
                ),
                new Tab(
                  text: "Third",
                ),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Container(
                color: Colors.deepOrangeAccent,
                child: new Center(
                  child: new Text(
                    "First",
                    style: textStyle(),
                  ),
                ),
              ),
              new Container(
                color: Colors.blueGrey,
                child: new Center(
                  child: new Text(
                    "Second",
                    style: textStyle(),
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new Image.network(detailsUser.photoUrl),
                    new Text(
                      "Name : " + detailsUser.displayName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1.2,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(5.0),
                    ),
                    new Text(
                      "Email : " + detailsUser.email,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1.2,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(5.0),
                    ),
                    new Builder(
                      builder: (BuildContext context) {
                        return new Material(
                          borderRadius: new BorderRadius.circular(30.0),
                          child: new Material(
                            elevation: 5.0,
                            child: new MaterialButton(
                              minWidth: 150.0,
                              onPressed: () => _signOut(),
                              child: new Text('Sign Out'),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
