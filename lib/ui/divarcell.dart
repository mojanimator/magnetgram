import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/color.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/divar.dart';
import 'package:url_launcher/url_launcher.dart';

class DivarCell extends StatefulWidget {
  const DivarCell(
    this.divar,
  );

  @required
  final Divar divar;

  @override
  _DivarCellState createState() => _DivarCellState();
}

class _DivarCellState extends State<DivarCell>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  Animation<double> fadeAnimation;
  Color mainImageColor;

  bool isMember;

  AdvancedNetworkImage advanceNetWorkImage;

  String remaindedTime;

  Duration duration;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: 200 +
                Random(int.parse(widget.divar.chat_id)).nextInt(1000 - 200)));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    fadeAnimation = Tween<double>(begin: 1, end: .8).animate(scaleAnimation);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
//      else if (status == AnimationStatus.dismissed) {
//        controller.forward();
//      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    isMember =
        ["administrator", "creator", "member"].contains(widget.divar.role);
    advanceNetWorkImage =
        AdvancedNetworkImage(Helper.getChatImageLink(widget.divar.chat_id),
//        useDiskCache: true,
            disableMemoryCache: true,
            retryLimit: 2,
            useDiskCache: true,
            timeoutDuration: Duration(seconds: 3),
            fallbackAssetImage: "images/no-image.jpg");
//    setMainColor(widget.divar.chat_id);

    mainImageColor = widget.divar.chat_main_color != null
        ? MyColors.fromHex(widget.divar.chat_main_color)
        : Styles.primaryColor;
    duration = Duration(
        seconds: widget.divar.expire_time -
            DateTime.now().millisecondsSinceEpoch ~/ 1000);
    remaindedTime = "${duration.inHours}:${duration.inMinutes.remainder(60)}";
    return ScaleTransition(
      scale: fadeAnimation,
      child: Card(
        color: widget.divar.is_vip
            ? Styles.vipColor.withOpacity(.1)
            : Colors.white,
        borderOnForeground: true,
        shadowColor: widget.divar.is_vip
            ? Styles.vipColor.withOpacity(.1)
            : Colors.white,

        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//      color: Colors.black /*MyTheme.COLOR['blue']*/,
        child: Stack(
          alignment: Alignment.topCenter,
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
            Positioned(
              left: -4,
              top: -4,
              child: widget.divar.is_vip
                  ? FloatingActionButton(
                      heroTag: "fimage${widget.divar.id}",
                      backgroundColor: Styles.vipColor,
                      mini: true,
                      child: Image.asset("images/pin.png"),
                      onPressed: () => null,
                    )
                  : SizedBox.shrink(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Hero(
                      tag: "image${widget.divar.id}",
                      child: Container(
//                        height: physicalPixelWidth / 18,

                          margin: EdgeInsets.only(top: 1.0, left: 4, right: 4),
//                    padding: EdgeInsets.all(16.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0x33A6A6A6)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: TransitionToImage(
                              key: Key("1"),
                              enableRefresh: true,
                              fit: BoxFit.scaleDown,
                              image: advanceNetWorkImage,
                              loadingWidgetBuilder: (_, double progress, __) =>
                                  Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              placeholder: Center(
                                  child: Image.asset("images/no-image.jpg")),
                            ),
                          ))),
                ),
                Expanded(
                  flex: 1,
                  child: MyFitBox(
                    margin: 8.0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Styles.primaryColor,
//                        border: Border.all(color: Styles.secondaryColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        remaindedTime,
                        textAlign: TextAlign.center,
                        style: Styles.BUTTONSTYLE,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MyFitBox(
                    margin: 8.0,
                    child: Text(
                      widget.divar.chat_title,
                      textAlign: TextAlign.center,
                      style: Styles.TEXTSTYLE,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                //buttons
                Expanded(
                  flex: 2,
                  child: MyFitBox2(
                    margin: 4.0,
                    child: MyButtons(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget MyFitBox({@required child, margin = 0.0}) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: double.infinity),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: FittedBox(fit: BoxFit.fitWidth, child: child)));
  }

  Widget MyFitBox2({@required child, margin = 0.0}) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: FittedBox(fit: BoxFit.fitWidth, child: child)));
  }

  setMainColor(String chat_id) async {
//    final PaletteGenerator generator =
//        await PaletteGenerator.fromImageProvider(advanceNetWorkImage);
    if (mounted)
      setState(() {
//        mainImageColor = generator.lightVibrantColor?.color != null
//            ? generator.lightVibrantColor.color
//            : generator.lightMutedColor != null
//                ? generator.lightMutedColor?.color
//                : PaletteColor(Colors.blue, 1);
        mainImageColor = Colors.blue;
      });
  }

  Widget MyButtons() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            onPressed: () async {
              String res = await Helper.viewChat(context, {
                'chat_id': widget.divar.chat_id,
              });
              print(res.toString());
              switch (res) {
                case "VIEW":
                  if (await canLaunch(
                      "https://telegram.me/${widget.divar.chat_username.replaceAll("@", "")}")) {
                    await launch(
                        "https://telegram.me/${widget.divar.chat_username.replaceAll("@", "")}");
                  }
                  break;
                case "BOT_NOT_ADDED":
                  Helper.showMessage(context, Lang.get(Lang.BOT_NOT_ADDED));
                  _refreshData(context);
                  break;
                case "TIMEOUT_CHAT":
                  Helper.showMessage(context, Lang.get(Lang.TIMEOUT_CHAT));
                  Helper.getDivar(context, null);
                  break;
                case "TELEGRAM_ERROR":
                  Helper.showMessage(context, Lang.get(Lang.TELEGRAM_ERROR));

                  break;
                default:
                  Helper.showMessage(context, res.toString());
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
              textDirection: TextDirection.ltr,
            ),
            textColor: Colors.white,
            splashColor: Styles.secondaryColor,
            color: Styles.successColor,
          ),
          SizedBox(
            width: 5.0,
          ),
          RaisedButton(
            onPressed: !isMember
                ? () async {
                    String res = await Helper.checkUserJoined(context, {
                      'chat_id': widget.divar.chat_id,
                      'last_score': Helper.user?.score.toString(),
                      'chat_username': widget.divar.chat_username,
                      'chat_type': widget.divar.chat_type,
                    });
                    print(res);
                    switch (res) {
                      case "ADMIN_OR_CREATOR":
                        Helper.showMessage(
                            context, Lang.get(Lang.ADMIN_OR_CREATOR));
                        setState(() {
                          isMember = true;
                        });
                        break;
                      case "TIMEOUT_CHAT":
                        Helper.showMessage(
                            context, Lang.get(Lang.TIMEOUT_CHAT));
                        Helper.getDivar(context, null);
                        break;
                      case "BOT_NOT_ADDED_OR_NOT_EXISTS":
                        Helper.showMessage(context,
                            Lang.get(Lang.BOT_NOT_ADDED_OR_NOT_EXISTS));
                        _refreshData(context);
                        break;
                      case "REPEATED_ADD":
                        Helper.showMessage(
                            context, Lang.get(Lang.REPEATED_ADD));
                        setState(() {
                          isMember = true;
                        });
                        break;
                      case "TELEGRAM_ERROR":
                        Helper.showMessage(
                            context, Lang.get(Lang.TELEGRAM_ERROR));

                        break;
                      case "MEMBER":
                        Helper.showMessage(context, Lang.get(Lang.MEMBER));
                        _refreshData(context);

                        break;

                      default:
                        setState(() {
                          isMember = true;
                        });
                        break;
                    }
                  }
                : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Icon(
              !isMember ? Icons.person_add : Icons.check,
              color: Colors.white,
            ),
            textColor: Colors.white,
            splashColor: Styles.secondaryColor,
            color: Styles.primaryColor,
          ),
        ],
      ),
    );
  }

  void _refreshData(context) async {
    Helper.divars.clear();
    BlocProvider.of<DivarBloc>(context)
        .sink
        .add(await Helper.getDivar(context, null));
//    BlocProvider.of<UserBloc>(context)
//        .sink
//        .add(await Helper.getUser(context, {'for': 'me'}));
  }
}
