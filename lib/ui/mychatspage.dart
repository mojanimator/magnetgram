import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:magnetgram/extra/MyDialog.dart';
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/model/chat.dart';
import 'package:magnetgram/ui/chatcell.dart';
import 'package:magnetgram/ui/chatdetails.dart';

class MyChatsPage extends StatefulWidget {
  @override
  _MyChatsPageState createState() => _MyChatsPageState();
}

class _MyChatsPageState extends State<MyChatsPage>
    with AutomaticKeepAliveClientMixin {
  bool loading;
  ChatBloc _chatBloc;

  TextEditingController textController;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    print("my chats dispose");
    // TODO: implement dispose
    textController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print("init chat");
    super.initState();
    textController = TextEditingController();
    _chatBloc ??= BlocProvider.of<ChatBloc>(context);
    SchedulerBinding.instance.addPostFrameCallback((_) => refreshData());
  }

  @override
  Widget build(BuildContext context) {
    _chatBloc ??= BlocProvider.of<ChatBloc>(context);

    var mediaQuery = MediaQuery.of(context);
    var physicalPixelWidth =
        mediaQuery.size.width * mediaQuery.devicePixelRatio;
    int grids = physicalPixelWidth < 1200 ? 1 : 2;
    return Stack(
      children: <Widget>[
        StreamBuilder<List<Chat>>(
            stream: _chatBloc.stream,
            builder: (BuildContext appContext, AsyncSnapshot snapshot) {
//          print(bloc.stream);
              print(snapshot.connectionState.toString() + " chats");
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
//                  if (snapshot.data.length == 0) {
//                    return Center(child: CircularProgressIndicator());
//                  } else {
//                    Helper.chats.clear();
                  Helper.chats.addAll(snapshot.data);
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
//                        controller: _scrollController,
                            itemCount: Helper.chats.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _grid(Helper.chats[index]);
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
//                  }
                  break;
                default:
                  return refresher();
              }
            }),
        Positioned(
          bottom: 0,
          right: 0,
          child: Transform.scale(
            scale: grids + 1.0,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _newChat(),
              splashColor: Styles.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget refresher() {
    return Container(
        child: Center(
            child: Material(
      color: Colors.transparent,
      shadowColor: Styles.secondaryColor,
      child: IconButton(
        splashColor: Styles.secondaryColor,
        highlightColor: Styles.secondaryColor,
        padding: EdgeInsets.all(10.0),
        iconSize: MediaQuery.of(context).size.width / 6,
        icon: Icon(
          Icons.refresh,
          color: Colors.black26,
        ),
        onPressed: () async {
          refreshData();
        },
      ),
    )));
  }

  void refreshData() async {
    print("refresh");
    if (!await Helper.isNetworkConnected()) {
      Helper.showMessage(context, Lang.get(Lang.CHECK_NETWORK));
      return;
    }
    Helper.chats.clear();
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
    _chatBloc.sink.add(await Helper.getUserChats(context, null));
//    if (for_ == 'user' || for_ == null)
//      _userBloc.sink.add(await Helper.getUser(context, {'for': 'me'}));
    if (mounted)
      setState(() {
        loading = false;
      });
    else
      loading = false;
  }

  Widget _grid(Chat chat) {
    return GestureDetector(
      child: GridTile(
        child: ChatCell(chat),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          maintainState: false,
          builder: (BuildContext context) => ChatDetails(chat))),
      onLongPress: () {},
    );
  }

  _newChat() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50.0)),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "${Lang.get(Lang.REGISTER_CHAT)} ( ${Helper.settings['install_chat_score']} 💰)",
                    style:
                        Styles.TEXTSTYLE.copyWith(fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    Lang.get(Lang.INPUT_CHAT_LABEL),
                    style: Styles.TEXTSTYLE,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      maxLines: 1,
                      style: TextStyle(color: Styles.primaryColor),
                      decoration: InputDecoration(
                          labelText: Lang.get(Lang.CHAT_USERNAME),
                          hintText: "@chat_username",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)))),
                      obscureText: false,
                      controller: textController,
                    ),
                  ),

                  // modal buttons
                  Row(
                    children: <Widget>[
                      //cancel button
                      Expanded(
                        child: RaisedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10.0))),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                            textDirection: TextDirection.rtl,
                          ),
                          label: Text(
                            Lang.get(Lang.CANCEL),
                            style: Styles.TABSELECTEDSTYLE,
                          ),
                          textColor: Colors.white,
                          splashColor: Styles.secondaryColor,
                          color: Styles.cancelColor,
                        ),
                      ),
                      //accept button
                      Expanded(
                        child: RaisedButton.icon(
                          onPressed: () async {
                            _addToChats();
                          },
                          padding: EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0))),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                            textDirection: TextDirection.rtl,
                          ),
                          label: Text(
                            Lang.get(Lang.REGISTER_CHAT),
                            style: Styles.TABSELECTEDSTYLE,
                          ),
                          textColor: Colors.white,
                          splashColor: Styles.secondaryColor,
                          color: Styles.successColor,
                        ),
                      ),
                    ],
                  ),
                ]),
              );
            }),
          );
        });
  }

  void _addToChats() async {
    String res =
        await Helper.newChat(context, {'chat_username': textController.text});
    switch (res.toString()) {
      case "LOW_SCORE":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.LOW_SCORE),
              );
            });
        break;
      case "CHAT_EXISTS":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.CHAT_EXISTS),
              );
            });
        break;
      case "NOT_ADMIN_OR_CREATOR":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.NOT_ADMIN_OR_CREATOR),
              );
            });
        break;
      case "BOT_NOT_ADMIN":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.BOT_NOT_ADMIN),
              );
            });
        break;
      case "CHAT_NOT_FOUND":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.CHAT_NOT_FOUND),
              );
            });
        break;
      case "REGISTER_SUCCESS":
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialog(
                context: context,
                message: Lang.get(Lang.REGISTER_SUCCESS),
                onCancelPressed: () => Navigator.pop(context),
              );
            });
        _chatBloc.sink.add(await Helper.getUserChats(context, null));
        BlocProvider.of<UserBloc>(Helper.userContext).sink.add(
                await Helper.getUser(Helper.userContext, {
              'score':
                  (Helper.user.score - Helper.settings['install_chat_score'])
                      .toString()
            }));

        break;
    }
  }
}
