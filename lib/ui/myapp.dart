import 'package:flutter/material.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/ui/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  Future<void> a = Helper.getToken();
//  final store = Store(commander,
//      initialState: AppState(Variable.COMMAND_REFRESH_SCHOOLS));
  BuildContext appContext;

  SharedPreferences localStorage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  var schoolsBuilder = Helper.createRows();

  @override
  Widget build(BuildContext context) {
    appContext = context;

//    DivarBloc bloc;
//    bloc ??= DivarBloc();

    return Scaffold(
//
//      drawer: Drawer(
//        body: StoreConnector(
//          converter: (store) => store.state.command,
//          builder: (context, commander) => HomePage(),
//        ),
      body: FutureBuilder(
        future: Helper.getLocalStorage(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('connection none'));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active: //is for stream not feature
              return Center(child: Text('active'));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ));
              } else {
                localStorage = snapshot.data;

                if (localStorage.getString('access_token') != null) {
                  //user is logged in

                  return HomePage(appContext);
                } else {
                  return LoginPage();
                }
              }
              break;
            default:
              return null;
          }
        },
      ),
    );
  }
}
