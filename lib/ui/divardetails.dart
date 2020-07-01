import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:magnetgram/extra/MyPainter.dart';
import 'package:magnetgram/extra/loaders.dart';
import 'package:magnetgram/helper/color.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/divar.dart';
import 'package:url_launcher/url_launcher.dart';

class DivarDetails extends StatefulWidget {
  final Divar divar;

  DivarDetails(this.divar);

  @override
  _DivarDetailsState createState() => _DivarDetailsState();
}

class _DivarDetailsState extends State<DivarDetails>
    with AutomaticKeepAliveClientMixin {
  TransitionToImage transition;

  AdvancedNetworkImage advancedNetworkImage;
  Color mainImageColor;
  CustomPaint myPaint = CustomPaint(
    painter: MyPainter(),
    willChange: true,
    size: Size(0, 0),
  );

  @override
  bool get wantKeepAlive => false;

  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init details");
    mainImageColor = widget.divar.chat_main_color != null
        ? MyColors.fromHex(widget.divar.chat_main_color)
        : Styles.primaryColor;
//    precacheImage(advancedNetworkImage, context);
  }

  @override
  void dispose() async {
    super.dispose();
    print("details dispose");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (BuildContext context) {
//        print("build");
        return Card(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(color: mainImageColor),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      color: widget.divar.is_vip
                          ? Styles.vipColor.withOpacity(.1)
                          : Colors.white,
                    ),
                    flex: 2,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 3,
//                    padding: EdgeInsets.all(16.0),

                      child: Hero(
                          tag: "image${widget.divar.id}",
                          child: //
                              ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: TransitionToImage(
                              key: Key("1"),
                              duration: Duration(seconds: 0),
                              longPressForceRefresh: true,
                              enableRefresh: true,
                              image: AdvancedNetworkImage(
                                Helper.getChatImageLink(widget.divar.chat_id),
                                timeoutDuration: Duration(seconds: 30),
                                cacheRule: CacheRule(
                                    maxAge: const Duration(days: 7),
                                    storeDirectory:
                                        StoreDirectoryType.temporary),
                              ),
                              loadingWidgetBuilder: (_, double progress, __) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Visibility(
                                      child: /*Loader(),*/
                                          Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.8),
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        child: Text(
                                          (progress * 100).toStringAsFixed(0) +
                                              "%",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      visible: progress > 0.1,
                                    ),
                                    Visibility(
                                      child: /*Loader(),*/
                                          Container(
                                              alignment: Alignment.center,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(.8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0)),
                                              child: Loader()),
                                      visible: progress <= 0.1,
                                    ),
                                  ],
                                );
                              },
                              placeholder: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 100.0),
                                  ),
//                          Text("No Image Available!",
//                              style: TextStyle(
//                                  color: Colors.red,
//                                  fontWeight: FontWeight.bold)),
                                  Center(
                                    child: Icon(
                                      Icons.refresh,
                                      size: 100.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          )),
                    ),
                  ),
                  Text(
                    widget.divar.chat_title,
                    textAlign: TextAlign.center,
                    style: Styles.TEXTSTYLE,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: widget.divar.chat_description,
                          style: Styles.TEXTSTYLE,
                          linkStyle: TextStyle(color: Styles.cancelColor),
                          options: LinkifyOptions(humanize: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 48,
                  child: Container(
                    color: Colors.black26.withOpacity(0.5),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(1000.0),
                                //Something large to ensure a circle
                                onTap: () => Navigator.of(context).pop(),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }
}
