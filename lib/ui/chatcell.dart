import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:magnetgram/extra/MyDialog.dart';
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/color.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/chat.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatCell extends StatefulWidget {
  const ChatCell(
    this.chat,
  );

  @required
  final Chat chat;

  @override
  _ChatCellState createState() => _ChatCellState();
}

class _ChatCellState extends State<ChatCell>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  Color mainImageColor;

  bool isMember = false;

  AdvancedNetworkImage advanceNetWorkImage;

  Chat _chat;

  String remaindedTime;

  String _timerHours;
  bool vipEnable = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _chat = widget.chat;

    advanceNetWorkImage = AdvancedNetworkImage(
        Helper.getChatImageLink(_chat.chat_id),
        useDiskCache: true,
        retryLimit: 2,
        timeoutDuration: Duration(seconds: 3),
        fallbackAssetImage: "images/no-image.jpg");
//    setMainColor(_chat.chat_id);
    mainImageColor = _chat.chat_main_color != null
        ? MyColors.fromHex(_chat.chat_main_color)
        : Styles.primaryColor;
    Duration duration = Duration(
        seconds:
            _chat.expire_time - DateTime.now().millisecondsSinceEpoch ~/ 1000);
    remaindedTime = "${duration.inHours}:${duration.inMinutes.remainder(60)}";

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Card(
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
                    color: Colors.white,
                  ),
                  flex: 2,
                )
              ],
            ),
            Positioned(
              left: 4,
              child: FloatingActionButton(
                heroTag: "fimagechat${_chat.id}",
                backgroundColor: Colors.white,
                foregroundColor: Styles.secondaryColor,
                mini: true,
                child: Icon(Icons.refresh),
                onPressed: () => _refreshData('refresh_chat', _chat.chat_id),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Hero(
                    tag: "imagechat${_chat.id}",
                    child: Container(
                        margin: EdgeInsets.only(top: 8.0, left: 80, right: 80),
//                    padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          _chat.chat_title,
                          textAlign: TextAlign.center,
                          style: Styles.TEXTSTYLE,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          _chat.chat_description,
                          textAlign: TextAlign.center,
                          style: Styles.TEXTSTYLE,
//                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MyButtons(),
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
            child: FittedBox(fit: BoxFit.contain, child: child)));
  }

  Widget MyFitBox2({@required child, margin = 0.0}) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: FittedBox(fit: BoxFit.fitWidth, child: child)));
  }

  setMainColor(String chat_id) async {
    final PaletteGenerator generator =
        await PaletteGenerator.fromImageProvider(advanceNetWorkImage);
    if (mounted)
      setState(() {
        mainImageColor = generator.lightVibrantColor?.color != null
            ? generator.lightVibrantColor.color
            : generator.lightMutedColor != null
                ? generator.lightMutedColor?.color
                : PaletteColor(Colors.blue, 1);
      });
  }

  Widget MyButtons() {
    return Column(
      children: <Widget>[
        //view button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: RaisedButton.icon(
                    onPressed: () async {
                      if (await canLaunch(
                          "https://telegram.me/${_chat.chat_username.replaceAll("@", "")}")) {
                        await launch(
                            "https://telegram.me/${_chat.chat_username.replaceAll("@", "")}");
                      }
                    },
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      textDirection: TextDirection.rtl,
                    ),
                    label: Text(
                      Lang.get(Lang.ViEW),
                      style: Styles.TABSELECTEDSTYLE,
                    ),
                    textColor: Colors.white,
                    splashColor: Styles.secondaryColor,
                    color: Styles.successColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // add to divar or timer|pin
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _chat.expire_time <= 0
                      ? RaisedButton.icon(
                          onPressed: () async {
                            setState(() {
                              _timerHours = Helper.settings['divar_scores'][
                                      Helper.settings['divar_scores'].keys
                                          .toList()[0]]
                                  .toString();
                            });
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50.0)),
                                      ),
                                      child: Column(
                                          //radio buttons
                                          mainAxisSize: MainAxisSize.min,
                                          children: Helper
                                                  .settings['divar_scores'].keys
                                                  .map<Widget>((min) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: Ink(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _timerHours = min;
                                                        });
                                                      },
                                                      splashColor:
                                                          Styles.secondaryColor,
                                                      highlightColor:
                                                          Styles.secondaryColor,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            " $min ${Lang.get(Lang.MIN)}   ${Helper.settings['divar_scores'][min]}   💰 ",
                                                            style: Styles
                                                                .TEXTSTYLE,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                          Radio(
                                                            activeColor: Styles
                                                                .secondaryColor,
                                                            value: min,
                                                            groupValue:
                                                                _timerHours,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _timerHours =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList() +
                                              // modal buttons
                                              [
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Ink(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          vipEnable =
                                                              !vipEnable;
                                                        });
                                                      },
                                                      splashColor:
                                                          Styles.secondaryColor,
                                                      highlightColor:
                                                          Styles.secondaryColor,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            "${Lang.get(Lang.VIP)}   ${Helper.settings['vip_score']}   💰 ",
                                                            style: Styles
                                                                .TEXTSTYLE,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          ),
                                                          Container(
                                                            child: Image.asset(vipEnable
                                                                ? "images/pin.png"
                                                                : "images/pin-disable.png"),
                                                            height: 80,
                                                            width: 80,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        16.0,
                                                                    horizontal:
                                                                        8.0),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    //cancel button
                                                    Expanded(
                                                      child: RaisedButton.icon(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .horizontal(
                                                                    left: Radius
                                                                        .circular(
                                                                            10.0))),
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                        label: Text(
                                                          Lang.get(Lang.CANCEL),
                                                          style: Styles
                                                              .TABSELECTEDSTYLE,
                                                        ),
                                                        textColor: Colors.white,
                                                        splashColor: Styles
                                                            .secondaryColor,
                                                        color:
                                                            Styles.cancelColor,
                                                      ),
                                                    ),
                                                    //accept button
                                                    Expanded(
                                                      child: RaisedButton.icon(
                                                        onPressed: () async {
                                                          _addToDivar(false);
                                                        },
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .horizontal(
                                                                    right: Radius
                                                                        .circular(
                                                                            10.0))),
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                        label: Text(
                                                          Lang.get(Lang
                                                              .ADD_TO_DIVAR),
                                                          style: Styles
                                                              .TABSELECTEDSTYLE,
                                                        ),
                                                        textColor: Colors.white,
                                                        splashColor: Styles
                                                            .secondaryColor,
                                                        color:
                                                            Styles.successColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                    );
                                  });
                                });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            Lang.get(Lang.DIVAR),
                            style: Styles.TABSELECTEDSTYLE,
                          ),
                          textColor: Colors.white,
                          splashColor: Styles.secondaryColor,
                          color: Styles.primaryColor,
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Image.asset(_chat.in_ == 'd'
                                ? "images/stopwatch.png"
                                : "images/queue.png"),
                            Expanded(
                              child: Center(
                                child: Text(
                                  remaindedTime,
                                  style: Styles.TEXTSTYLE,
                                ),
                              ),
                            ),
                            _chat.is_vip
                                ? Image.asset("images/pin.png")
                                : SizedBox(
                                    width: 1,
                                  ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _refreshData(String what, data) async {
    switch (what) {
      case "score":
        BlocProvider.of<UserBloc>(Helper.userContext).sink.add(
            await Helper.getUser(
                Helper.userContext, {'score': data.toString()}));
        break;
      case "refresh_chat":
        Chat chat = await Helper.refreshChat(context, {'chat_id': data});
        if (chat != null) {
          setState(() {
            _chat = chat;
//            _chat.chat_id = chat.chat_id;
//            _chat.chat_title = chat.chat_title;
//            _chat.chat_username = chat.chat_username;
//            _chat.chat_description = chat.chat_description;
          });
          Helper.showMessage(context, Lang.get(Lang.REFRESH_CHAT_SUCCESS));
        }

        break;
    }

//    BlocProvider.of<DivarBloc>(context)
//        .sink
//        .add(await Helper.getDivar(context, null));
//    BlocProvider.of<UserBloc>(context)
//        .sink
//        .add(await Helper.getUser(context, {'for': 'me'}));
  }

  void _addToDivar(bool agree_queue) async {
    Map<String, dynamic> res = await Helper.addToDivar(context, {
      'chat_id': _chat.chat_id,
      'time': _timerHours,
      'is_vip': vipEnable ? "1" : null,
      'agree_queue': agree_queue ? "1" : null,
    });

    switch (res['res']) {
      case "LOW_SCORE":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.LOW_SCORE),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "NOT_ADMIN":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.NOT_ADMIN),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "EXISTS_IN_DIVAR":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.EXISTS_IN_DIVAR),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "EXISTS_IN_QUEUE":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.EXISTS_IN_QUEUE),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "SUCCESS_DIVAR":
        setState(() {
          _chat.is_vip = res['is_vip'];
          _chat.expire_time = res['expire_time'];
          _chat.in_ = 'd';
          Duration duration = Duration(
              seconds: _chat.expire_time -
                  DateTime.now().millisecondsSinceEpoch ~/ 1000);
          remaindedTime =
              "${duration.inHours}:${duration.inMinutes.remainder(60)}";
        });
        _refreshData('score', res['score']);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.SUCCESS_DIVAR),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "SUCCESS_QUEUE":
        setState(() {
          Helper.user.score = res['score'];
          _chat.is_vip = res['is_vip'];
          _chat.expire_time = res['expire_time'];
          _chat.in_ = 'q';
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.SUCCESS_QUEUE),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        break;
      case "AGREE_QUEUE":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.AGREE_QUEUE),
                onOkPressed: () => _addToDivar(true),
                onCancelPressed: () => Navigator.pop(context),
                okText: Lang.get(Lang.ACCEPT),
              );
            });
        break;
    }
  }
}
