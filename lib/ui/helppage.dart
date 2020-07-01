import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magnetgram/helper/helper.dart';
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        " 💡 " + Lang.get(Lang.HELP),
                        style: Styles.TABSELECTEDSTYLE,
                        textDirection: TextDirection.rtl,
                      ),
                      color: Styles.primaryColor,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      " 🚩 " +
                          Lang.get(Lang.FOLLOWING_CHATS) +
                          " (${Helper.settings['follow_score']} 💰) ",
                      style: Styles.TEXTSTYLE,
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      " 🚩 " +
                          Lang.get(Lang.ADDING_MEMBER_TO_GROUPS) +
                          " (${Helper.settings['add_score']} 💰) ",
                      style: Styles.TEXTSTYLE,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      " 🚩 " +
                          Lang.get(Lang.SEEING_VIDEO) +
                          " (${Helper.settings['see_video_score']} 💰) ",
                      style: Styles.TEXTSTYLE
                          .copyWith(fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton.icon(
                            onPressed: () async {},
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            icon: Icon(
                              Icons.videocam,
                              color: Colors.white,
                              textDirection: TextDirection.rtl,
                            ),
                            label: FittedBox(
                              child: Text(
                                Lang.get(Lang.SEEING_VIDEO) +
                                    " ( ${Helper.settings["see_video_score"]} 💰 ) ",
                                style: Styles.TABSELECTEDSTYLE,
                              ),
                            ),
//                                        textColor: Colors.white,
                            splashColor: Styles.secondaryColor,
                            color: Styles.successColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      " ⚡ " + Lang.get(Lang.BUY_COIN),
                      style: Styles.TEXTSTYLE
                          .copyWith(fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton.icon(
                            onPressed: () async {
                              if (await canLaunch(
                                  "https://telegram.me/${Variable.ADMIN_ID}")) {
                                await launch(
                                    "https://telegram.me/${Variable.ADMIN_ID}");
                              }
                            },
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            icon: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              textDirection: TextDirection.rtl,
                            ),
                            label: FittedBox(
                              child: Text(
                                Lang.get(Lang.BUY_COIN),
                                style: Styles.TABSELECTEDSTYLE,
                              ),
                            ),
//                                        textColor: Colors.white,
                            splashColor: Styles.secondaryColor,
                            color: Styles.primaryColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
