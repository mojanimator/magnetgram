import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/divar.dart';
import 'package:magnetgram/ui/divarcell.dart';
import 'package:magnetgram/ui/divardetails.dart';

class DivarPage extends StatefulWidget {
  @override
  _DivarPageState createState() => _DivarPageState();
}

class _DivarPageState extends State<DivarPage>
    with AutomaticKeepAliveClientMixin {
  bool loading;
  DivarBloc _divarBloc;
  Timer _timer;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    print("init divar");
    super.initState();
    _divarBloc ??= BlocProvider.of<DivarBloc>(context);
    SchedulerBinding.instance.addPostFrameCallback((_) => refreshData());

    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _setDuration());
  }

  @override
  Widget build(BuildContext context) {
    _divarBloc ??= BlocProvider.of<DivarBloc>(context);

    var mediaQuery = MediaQuery.of(context);
    var physicalPixelWidth =
        mediaQuery.size.width * mediaQuery.devicePixelRatio;
    int grids = physicalPixelWidth < 1200 ? 3 : 4;
    return StreamBuilder<List<Divar>>(
        stream: _divarBloc.stream,
        builder: (BuildContext appContext, AsyncSnapshot snapshot) {
//          print(bloc.stream);
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text(Lang.get(Lang.CHECK_NETWORK));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return refresher();
            case ConnectionState.active:
              if (snapshot.hasError) {
                return refresher();
              }
              if (!snapshot.hasData) {
                return refresher();
              }
//              if (snapshot.data.length == 0) {
//                return refresher();
////                return Center(child: CircularProgressIndicator());
//              } else {
//              Helper.divars.clear();
              Helper.divars.addAll(snapshot.data);
              snapshot.data.clear();
//                print(snapshot.data);
              return RefreshIndicator(
                onRefresh: () async {
                  refreshData();
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.builder(
                        addAutomaticKeepAlives: true,
//                        controller: _scrollController,
                        itemCount: Helper.divars.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _grid(Helper.divars[index]);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: /* (orientation==Orientation.portrait)?2:*/ grids,
                            childAspectRatio: .8),
                      ),
                    ),
                    Visibility(
                      visible: false /*loading*/,
                      child: CupertinoActivityIndicator(),
                    )
                  ],
                ),
              );
//              }
              break;
            default:
              return refresher();
          }
        });
  }

  Widget refresher() {
    return Material(
      color: Colors.transparent,
      shadowColor: Styles.secondaryColor,
      child: Container(
          child: Center(
              child: IconButton(
        splashColor: Styles.secondaryColor,
        highlightColor: Styles.secondaryColor,
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

  void refreshData({String data}) async {
    print("refresh");
    if (!await Helper.isNetworkConnected()) {
      Helper.showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//      _divarBloc.sink.add(await Helper.getDivar(context, null));
//      _userBloc.sink.add(await Helper.getUser(context, {'for': 'me'}));

      return;
    }

    if (data == null) {
      Helper.divars.clear();
      Helper.prepare(context);

      BlocProvider.of<UserBloc>(Helper.userContext)
          .sink
          .add(await Helper.getUser(context, {'for': 'me'}));
    }

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

    _divarBloc.sink.add(await Helper.getDivar(context, {'for': data}));
//    if (for_ == 'user' || for_ == null)
//      _userBloc.sink.add(await Helper.getUser(context, {'for': 'me'}));
    if (mounted)
      setState(() {
        loading = false;
      });
    else
      loading = false;
  }

  Widget _grid(Divar divar) {
    return GestureDetector(
      child: GridTile(
        child: DivarCell(divar),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          maintainState: false,
          builder: (BuildContext context) => DivarDetails(divar))),
      onLongPress: () {},
    );
  }

  _setDuration() {
    refreshData(data: 'timer');
  }
}
