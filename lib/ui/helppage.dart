import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/helper/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  double margin;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    margin = MediaQuery.of(context).size.width / 6;
    return Container(
      padding: const EdgeInsets.all(50.0),
      margin: EdgeInsets.symmetric(horizontal: margin, vertical: 50.0),
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
      ),
      child: ScaleTransition(
          scale: scaleAnimation,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  " 💡 " + Lang.get(Lang.HELP),
                                  style: Styles.TABSELECTEDSTYLE,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                          color: Styles.primaryColor,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          " 🚩 " + Lang.get(Lang.HOW_WORKS),
                          style: Styles.TEXTSTYLE,
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "https://instagram.com/_u/develowper")) {
                                      await launch(
                                          "https://instagram.com/_u/develowper");
                                    } else {
                                      await launch(
                                          "https://instagram.com/develowper");
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  icon: Icon(
                                    Icons.phone_in_talk,
                                    color: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Lang.get(Lang.SUPPORT),
                                      style: Styles.TABSELECTEDSTYLE,
                                    ),
                                  ),
//                                        textColor: Colors.white,
                                  splashColor: Styles.secondaryColor,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "https://telegram.me/${Variable.BOT_ID}")) {
                                      await launch(
                                          "https://telegram.me/${Variable.BOT_ID}");
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  icon: Icon(
                                    Icons.android,
                                    color: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Lang.get(Lang.BOT_ENTER),
                                      style: Styles.TABSELECTEDSTYLE,
                                    ),
                                  ),
//                                        textColor: Colors.white,
                                  splashColor: Styles.secondaryColor,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "https://www.aparat.com/playlist/449893")) {
                                      await launch(
                                          "https://www.aparat.com/playlist/449893");
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  icon: Icon(
                                    Icons.live_tv,
                                    color: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Lang.get(Lang.TUTORIALS),
                                      style: Styles.TABSELECTEDSTYLE,
                                    ),
                                  ),
//                                        textColor: Colors.white,
                                  splashColor: Styles.secondaryColor,
                                  color: Colors.teal,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
