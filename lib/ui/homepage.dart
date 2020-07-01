import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:magnetgram/extra/MyDialog.dart';
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/user.dart';
import 'package:magnetgram/ui/divarpage.dart';
import 'package:magnetgram/ui/helppage.dart';
import 'package:magnetgram/ui/mychatspage.dart';
import 'package:magnetgram/ui/scorepage.dart';

class HomePage extends StatefulWidget {
  final BuildContext appContext;

  HomePage(this.appContext);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        WidgetsBindingObserver,
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  TransitionToImage userNetworkImage;

  User user;

  BuildContext userContext;

  BuildContext divarContext;

  @override
  bool get wantKeepAlive => true;

  Future<String> url;
  DivarBloc _divarBloc;
  UserBloc _userBloc;
  ChatBloc _chatBloc;
  bool loading = true;

  double tabHeight = kTextTabBarHeight + 30;
  TabController _tabController;

  _HomePageState();

  @override
  void initState() {
    print("init home");
    Helper.prepare(context);
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
    _divarBloc ??= DivarBloc();
    _userBloc ??= UserBloc();
    _chatBloc ??= ChatBloc();
    SchedulerBinding.instance.addPostFrameCallback((_) => refreshData());
  }

  @override
  void dispose() {
    print("dispose home");

    super.dispose();
    // this.bloc.dispose();
  }

  @override
  Widget build(BuildContext appContext) {
    super.build(context);
    _divarBloc ??= DivarBloc();
    _userBloc ??= UserBloc();
    _chatBloc ??= ChatBloc();
    var mediaQuery = MediaQuery.of(appContext);
    var physicalPixelWidth =
        mediaQuery.size.width * mediaQuery.devicePixelRatio;

    double marginTop = mediaQuery.size.height / 6;

    return Stack(
      children: <Widget>[
        //user container
        BlocProvider(
          bloc: _userBloc,
          child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.blueGrey],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 0.5),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  height: marginTop - 16.0,
                  width: double.infinity,
                  child: StreamBuilder<List<User>>(
                      stream: _userBloc.stream,
                      builder:
                          (BuildContext appContext, AsyncSnapshot snapshot) {
                        Helper.userContext = appContext;
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text(Lang.get(Lang.CHECK_NETWORK));
                          case ConnectionState.waiting:
                            return Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ));
                          case ConnectionState.done:
                            return Text(Lang.get(Lang.CHECK_NETWORK));
                          case ConnectionState.active:
                            if (snapshot.hasError || !snapshot.hasData) {
                              return refresher();
                            } else if (snapshot.data.length > 0)
                              user = snapshot.data[0];
                            Helper.user = user;

                            return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            right: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blue,
                                                  Colors.blueGrey
                                                ],
                                                begin:
                                                    FractionalOffset.topCenter,
                                                end: FractionalOffset
                                                    .bottomCenter,
                                              ),
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right: Radius.circular(
                                                          marginTop / 2))),
                                          child: Row(
                                            children: <Widget>[
                                              //username
                                              FittedBox(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 0.0),
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              right: Radius
                                                                  .circular(
                                                                      marginTop /
                                                                          2))),
                                                  child: Text(
                                                    user?.telegram_username,
                                                    style:
                                                        Styles.TABSELECTEDSTYLE,
                                                  ),
                                                ),
                                              ),
//                                                  coin and buttons section
                                              Expanded(
                                                child: RaisedButton(
                                                  elevation: 0,
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  splashColor:
                                                      Styles.secondaryColor,
                                                  child: Image.asset(
                                                    "images/help.png",
                                                    fit: BoxFit.contain,
                                                    height: double.infinity,
                                                  ),
                                                  onPressed: () {
                                                    _getHelpDialog();
                                                  },
                                                ),
                                              ),
                                              //coin button
                                              Expanded(
                                                child: RaisedButton(
                                                  elevation: 0,
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  splashColor:
                                                      Styles.secondaryColor,
                                                  child: Image.asset(
                                                    "images/coin-bag.png",
                                                    fit: BoxFit.contain,
                                                    height: double.infinity,
                                                  ),
                                                  onPressed: () {
                                                    _getScoreDialog();
                                                  },
                                                ),
                                              ),
                                              //penalty button
                                              Expanded(
                                                child: RaisedButton(
                                                  elevation: 0,
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  splashColor:
                                                      Styles.secondaryColor,
                                                  child: Image.asset(
                                                    "images/left-penalty.png",
                                                    fit: BoxFit.contain,
                                                    height: double.infinity,
                                                  ),
                                                  onPressed: () {
                                                    _penaltyLeftUsers();
                                                  },
                                                ),
                                              ),
                                              //score view
                                              Expanded(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      "images/coin.png",
                                                      fit: BoxFit.contain,
                                                      height: double.infinity,
                                                    ),
                                                    Text(
                                                      user?.score.toString(),
                                                      style: Styles
                                                          .TABSELECTEDSTYLE
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              shadows: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black)
                                                          ]),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      margin: EdgeInsets.only(left: 8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.blue,
                                            Colors.blueAccent
                                          ]),
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(
                                                  marginTop / 2))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            physicalPixelWidth / 5),
                                        child: TransitionToImage(
//                                    key: Key("1"),
                                          forceRebuildWidget: true,
                                          enableRefresh: true,

                                          fit: BoxFit.scaleDown,
                                          image: AdvancedNetworkImage(
                                            Helper.getUserImageLink(
                                                user?.telegram_id),
                                            retryLimit: 2,
                                            timeoutDuration:
                                                Duration(seconds: 10),
                                            printError: true,
                                          ),
                                          loadingWidgetBuilder:
                                              (_, double progress, __) =>
                                                  Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                          placeholder: Center(
                                              child: Image.asset(
                                                  "images/no-image.jpg")),
                                        ),
                                      ),
                                    ),
                                  )
                                ]);
                          default:
                            return null;
                        }
                      }))),
        ),
        //tabs container
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: marginTop),
          padding: EdgeInsets.only(left: 80.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white, Colors.white70]),
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(marginTop / 2))),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius:
                BorderRadius.horizontal(left: Radius.circular(marginTop / 2)),
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
              ),
              child: SizedBox(
                height: tabHeight,
                child: TabBar(
                  indicatorWeight: 8.0,
                  labelStyle: Styles.TABSELECTEDSTYLE,
                  unselectedLabelStyle: Styles.TABSTYLE,
                  controller: _tabController,
                  indicatorColor: Colors.white70,
//                  indicator: BoxDecoration(
//                      gradient: LinearGradient(
//                          begin: FractionalOffset(0.0, 0.7),
//                          end: FractionalOffset(0.0, 1.0),
//                          colors: [Colors.blue, Colors.white])),
                  tabs: <Widget>[
                    Tab(
                      text: Lang.get(Lang.DIVAR),
                    ),
                    Tab(
                      text: Lang.get(Lang.MYINFO),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //tabs body
        Container(
          margin: EdgeInsets.only(top: marginTop + tabHeight),
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(marginTop / 2))),
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              //divar tab
              BlocProvider(
                bloc: _divarBloc,
                child: DivarPage(),
              ),

              //my chats tab
              BlocProvider(
                bloc: _chatBloc,
                child: MyChatsPage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  void refreshData({String for_}) async {
    print("refresh");
    if (!await Helper.isNetworkConnected()) {
      Helper.showMessage(context, "Please Check Your Internet Connection");
//      _divarBloc.sink.add(await Helper.getDivar(context, null));
//      _userBloc.sink.add(await Helper.getUser(context, {'for': 'me'}));

      return;
    }
//    Helper.divars.clear();

    // print(wallpapers.length.toString() +'|'+  Variable.TOTAL_WALLPAPERS.toString());
//    if (page == 1) wallpapers.clear();
//    if (Variable.TOTAL_WALLPAPERS['1'] > 0 &&
//        wallpapers.length >= Variable.TOTAL_WALLPAPERS['1']) return;
//    print('refresh');

//    Variable.params['page'] = page.toString();
    if (mounted)
      setState(() {
        loading = true;
      });
    else
      loading = true;
//    if (for_ == 'divar' || for_ == null)
//      _divarBloc.sink.add(await Helper.getDivar(context, null));
    Helper.prepare(context);
    if (for_ == 'user' || for_ == null)
      _userBloc.sink.add(await Helper.getUser(context, {'for': 'me'}));
    if (mounted)
      setState(() {
        loading = false;
      });
    else
      loading = false;
  }

  Widget refresher() {
    return Material(
      color: Colors.transparent,
      child: Container(
          child: Center(
              child: IconButton(
        splashColor: Styles.secondaryColor,
        padding: EdgeInsets.all(10.0),
        iconSize: MediaQuery.of(context).size.width / 6,
        icon: Icon(
          Icons.refresh,
          color: Styles.secondaryColor,
        ),
        onPressed: () async {
          refreshData();
        },
      ))),
    );
  }

  void _penaltyLeftUsers() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
            context: context,
            message: Lang.get(Lang.AGREE_FIND_LEFT_USERS),
            onOkPressed: () =>
                Helper.penaltyLeftUsers(Helper.userContext, null),
            onCancelPressed: () {},
            okText: Lang.get(Lang.START),
          );
        });
  }

  void _getScoreDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return ScorePage();
        });
  }

  void _getHelpDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return HelpPage();
        });
  }
}
