import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/helper/variables.dart';
import 'package:url_launcher/url_launcher.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

enum status { READY, LOADING, ERROR, IDLE }

class _ScorePageState extends State<ScorePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  double margin;

  int lastSeenVideo = 0;

  Duration duration;

  status videoStatus = status.IDLE;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _setDuration());
    _setDuration();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void _setDuration() {
    lastSeenVideo = Helper.localStorage.getInt('last_seen_video') ?? 0;

    int secondsFrom5Hours = 18000 -
        ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - lastSeenVideo);

    setState(() {
      if (secondsFrom5Hours > 0)
        duration = Duration(seconds: secondsFrom5Hours);
      else
        duration = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    margin = MediaQuery.of(context).size.width / 6;
    return Container(
      alignment: Alignment.center,
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
            key: _scaffoldKey,
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              " 💡 " + Lang.get(Lang.COIN_METHODS),
                              style: Styles.TABSELECTEDSTYLE,
                              textDirection: TextDirection.rtl,
                            ),
                            color: Styles.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " 🚩 " +
                                Lang.get(Lang.FOLLOWING_CHATS) +
                                " (${Helper.settings['follow_score']} 💰) ",
                            style: Styles.TEXTSTYLE
                                .copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " 🚩 " +
                                Lang.get(Lang.ADDING_MEMBER_TO_GROUPS) +
                                " (${Helper.settings['add_score']} 💰) ",
                            style: Styles.TEXTSTYLE
                                .copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " 🚩 " +
                                Lang.get(Lang.REF_SCORE) +
                                " (${Helper.settings['ref_score']} 💰) ",
                            style: Styles.TEXTSTYLE
                                .copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " 🚩 " +
                                Lang.get(Lang.SEEING_VIDEO) +
                                " (${Helper.settings['see_video_score']} 💰) ",
                            style: Styles.TEXTSTYLE
                                .copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    if (duration == null &&
                                        videoStatus != status.LOADING) {
                                      setState(() {
                                        videoStatus = status.LOADING;
                                      });
                                      Helper.requestRewardedVideo(
                                        success: () {
                                          setState(() {
                                            videoStatus = status.READY;
                                          });

                                          Helper.showRewardedVideo(
                                            //
                                            rewarded: () {
                                              Helper.localStorage.setInt(
                                                  'last_seen_video',
                                                  DateTime.now()
                                                          .millisecondsSinceEpoch ~/
                                                      1000);

                                              _setDuration();

                                              Helper.updateScore(context,
                                                  {'command': 'see_video'});

                                              Helper.showMessage(
                                                  context,
                                                  " ${Helper.settings["see_video_score"]} " +
                                                      Lang.get(
                                                          Lang.ADDED_SCORE));
                                            },
                                          );
                                        },
                                        error: () {
                                          Helper.showMessage(
                                              context,
                                              Lang.get(
                                                  Lang.ERROR_SHOW_VIDEO));
                                          setState(() {
                                            videoStatus = status.IDLE;
                                          });
                                        },
                                      );
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(vertical: 32.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  icon: Icon(
                                    duration == null
                                        ? Icons.videocam
                                        : Icons.access_time,
                                    color: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  label: videoStatus == status.LOADING
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )
                                      : FittedBox(
                                          child: Text(
                                            duration != null
                                                ? "${duration.inHours}:${duration.inMinutes.remainder(60)}"
                                                : Lang.get(
                                                        Lang.SEEING_VIDEO) +
                                                    " ( ${Helper.settings["see_video_score"]} 💰 ) ",
                                            style: Styles.TABSELECTEDSTYLE,
                                          ),
                                        ),
//                                        textColor: Colors.white,
                                  splashColor: Styles.secondaryColor,
                                  color: Styles.successColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " ⚡ " + Lang.get(Lang.BUY_COIN),
                            style: Styles.TEXTSTYLE
                                .copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    if (await canLaunch(
                                        "https://telegram.me/${Variable.ADMIN_ID}")) {
                                      await launch(
                                          "https://telegram.me/${Variable.ADMIN_ID}");
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(vertical: 32.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
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
