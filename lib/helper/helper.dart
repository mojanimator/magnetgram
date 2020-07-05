import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:magnetgram/helper/Bloc.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/helper/variables.dart';
import 'package:magnetgram/model/chat.dart';
import 'package:magnetgram/model/divar.dart';
import 'package:magnetgram/model/user.dart';
import 'package:magnetgram/ui/loginpage.dart';
import 'package:magnetgram/ui/myapp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsell_plus/TapsellPlusNativeBanner.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

class Helper {
  static var client = http.Client();
  static SharedPreferences localStorage;
  static int showAdTimes = 0;
  static Directory directory;
  static Map<String, dynamic> appIds;
  static String accessToken;
  static Map<String, dynamic> settings;
  static User user;
  static List<Divar> divars = List<Divar>();
  static List<Chat> chats = List<Chat>();

  static BuildContext userContext;
  static BuildContext chatContext;

  static int lastSeenVideo;

  static TapsellPlusNativeBanner nativeBanner = TapsellPlusNativeBanner();
  static bool nativaBannerError = false;

//  static MobileAdTargetingInfo targetingInfo;
//  static BannerAd bannerAd;

  static void prepare(BuildContext context) async {
    directory ??= await getExternalStorageDirectory();
    localStorage ??= await getLocalStorage();
    appIds ??= await loadAppIds(context);

    settings ??= await getSettings(context, null);
    initTapsell();
  }

  static Future<SharedPreferences> getLocalStorage() async {
    localStorage = await SharedPreferences.getInstance();
    accessToken = localStorage.getString('access_token');
//    lastSeenVideo = localStorage.getInt('last_seen_video');
    localStorage.setInt('last_seen', DateTime.now().millisecondsSinceEpoch);
//    refreshToken = localStorage.getString('refresh_token');
//    username = localStorage.getString('username');
//    name = localStorage.getString('name');
//    family = localStorage.getString('family');
//    phoneNumber = localStorage.getString('phone_number');
//    fashionImages = localStorage.getInt('fashion_images');
    return localStorage;
  }

  static Future<bool> isNetworkConnected() async {
//    print("isNetworkConnected");
    var connectivityResult = await (Connectivity().checkConnectivity());

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
//        initAdmob();
      }
    });
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  static login(context, username, password) {
    return client.post(Variable.LOGIN, headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + accessToken
    }, body: {
      'username': username,
      'password': password,
    }).then((http.Response response) {
      var parsedJson = json.decode(response.body);

      if (parsedJson['access_token'] != null) {
        localStorage.setString('access_token', parsedJson['access_token']);
//        print(parsedJson['access_token']);
      }
      if (parsedJson['refresh_token'] != null) {
        localStorage.setString('refresh_token', parsedJson['refresh_token']);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }).catchError((e) {
//      print("login error");
      print(e);
      showMessage(context, Lang.get(Lang.LOGIN_FAIL));
    });
  }

  static logout(context) {
    return client.post(Variable.LOGOUT, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    }, body: {}).then((http.Response response) {
      // print(response.body);

      var parsedJson = json.decode(response.body);
//      print('logout');

      //status 400=user not found
      //status 200=successfull logout
      if (parsedJson['status'] != null &&
              (parsedJson['status'] == 200 || parsedJson['status'] == 400) ||
          (parsedJson['message'] != null &&
              parsedJson['message'].contains('Unauthenticated'))) {
        localStorage.setString('access_token', null);
        localStorage.setString('refresh_token', null);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        showMessage(context, 'خطایی رخ داد  ');
      }
    }).catchError((e) {
      showMessage(context, e.toString());
      print(e.toString());
//      print(e);
    });
  }

  static Future<void> updateScore(context, Map<String, String> params) async {
    try {
      Uri uri = Uri.parse(Variable.LINK_UPDATE_SCORE);
      final newURI =
          params != null ? uri.replace(queryParameters: params) : uri;
      if (accessToken != '')
        return client.post(
          newURI,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }
          if (response.statusCode != 200) return null;
          try {
            int.parse(response.body);
            BlocProvider.of<UserBloc>(Helper.userContext).sink.add(
                await Helper.getUser(
                    Helper.userContext, {'score': response.body}));
          } catch (e) {
            showMessage(context, e.toString());
            return null;
//      throw Exception(e.toString());
          }
        }, onError: (e) {
          return null;
        });
    } catch (e) {
//      showMessage(context, e.toString());
//      print("error in my helper  $e.toString()");
      return null;
//      throw Exception(e.toString());
    }
  }

  static Future<String> checkAndSetUpdates() async {
    try {
      // if (accessToken != '')
      if (localStorage == null) await getLocalStorage();
      int lastSeen = localStorage.getInt('last_seen') ?? 0;
      return client.get(
        Variable.LINK_CHECK_UPDATE,
        headers: {"Content-Type": "application/json"},
      ).then((http.Response response) async {
        String updateMessage = response.body;
//        print(localFashionImages.toString() + "," + fashionImages.toString());
        if (updateMessage != null) {
          return updateMessage; //first time that app starts not show notification
        }
        return null;
      }, onError: (e) {
        return null;
      });
    } catch (e) {
//      showMessage(context, e.toString());
//      print("error in my helper  $e.toString()");
      return null;
//      throw Exception(e.toString());
    }
  }

  static Future<void> penaltyLeftUsers(
      context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_PENALTY);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }
          if (response.statusCode != 200) return null;

          if (response.body == "0")
            showMessage(context, Lang.get(Lang.LEFT_NOT_FOUND));
          else
            showMessage(
                context, " ${response.body} " + Lang.get(Lang.LEFT_FOUND));
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<String> newChat(context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_NEW_CHAT);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }
          if (response.statusCode != 200) return null;
          return response.body;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<Map<String, dynamic>> addToDivar(
      context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_ADD_TO_DIVAR);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }

          if (response.statusCode != 200) return null;
          var parsedJson = json.decode(response.body);
//          print(response.body);
          return parsedJson;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getSettings(
      context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_GET_SETTINGS);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.get(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }

          if (response.statusCode != 200) return null;
          var parsedJson = json.decode(response.body);
//          print(response.body);
          return parsedJson;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch getSettings");
//        print("$e");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<List<Chat>> getUserChats(
      context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_GET_USER_CHATS);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.get(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          List<Chat> chats = List<Chat>();
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }

          if (response.statusCode != 200) return null;
          var parsedJson = json.decode(response.body);
//            print(response.body);
          for (final tmp in parsedJson) {
//            print(tmp['is_vip']);
            Chat c = Chat.fromJson(tmp);
            chats.add(c);
          }
          return chats;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<Chat> refreshChat(context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_REFRESH_CHAT);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }

          if (response.statusCode != 200) return null;
          var parsedJson = json.decode(response.body);
//          print(response.body);

//            print(tmp['is_vip']);
          return Chat.fromJson(parsedJson);
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<List<Divar>> getDivar(
      context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        List<Divar> divars = List<Divar>();
        bool needRefresh = false;
        Uri uri = Uri.parse(Variable.LINK_GET_DIVAR);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);
        if (params != null && params['for'] == 'timer') {
//          divars = List.of(Helper.divars);
          int tmp;
          int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          for (int i = 0; i < Helper.divars.length; i++) {
            tmp = Helper.divars[i].expire_time - 60;
            Helper.divars[i].expire_time = tmp;

            if (tmp - now > 0) divars.add(Helper.divars[i]);
//            else {
//              needRefresh = true;
//              break;
//            }
          }

//          if (!needRefresh) {
          Helper.divars.clear();
          return Future.delayed(const Duration(milliseconds: 1), () {
            return divars;
          });
//          } else {
//            Future.delayed(const Duration(milliseconds: 1), () async {
//              BlocProvider.of<DivarBloc>(context)
//                  .sink
//                  .add(await getDivar(context, null));
//            });
//
//            return null;
//          }
        }

        return client.get(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
//            print('null');
            return null;
          }
          try {
            if (response.statusCode != 200) return null;
            var parsedJson = json.decode(response.body);
            for (final tmp in parsedJson) {
              Divar d = Divar.fromJson(tmp);
              divars.add(d);
            }

            return divars;
          } catch (e) {
//            print("catch $e");
            showMessage(context, Lang.get(Lang.CHECK_NETWORK));
            return null;
          }
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch $e");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<List<User>> getUser(
      BuildContext context, Map<String, String> params) {
    if (accessToken != '')
      try {
        if (params['score'] != null) {
          List<User> users = List<User>();
          Helper.user.score = int.parse(params['score']);
          users.add(Helper.user);
          return Future.delayed(const Duration(milliseconds: 1), () {
            return users;
          });
        }
        Uri uri = Uri.parse(Variable.LINK_GET_USER);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.get(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          List<User> users = List<User>();
          if (response.statusCode == 401) {
            logout(context);
            return null;
          }
//          print(response);
          if (response.statusCode != 200) return null;

          var parsedJson = json.decode(response.body);

          for (final tmp in parsedJson) {
            User u = User.fromJson(tmp);
            users.add(u);
          }
          return users;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<String> checkUserJoined(
      BuildContext context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_CHECK_USER_JOINED);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
            return null;
          }
//          print(response.body);
          if (response.statusCode != 200) return null;
          return response.body;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<String> viewChat(
      BuildContext context, Map<String, String> params) async {
    if (accessToken != '')
      try {
        Uri uri = Uri.parse(Variable.LINK_VIEW_CHAT);
        final newURI =
            params != null ? uri.replace(queryParameters: params) : uri;
//        print(accessToken);

        return client.post(
          newURI,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + accessToken
          },
        ).then((http.Response response) async {
          if (response.statusCode == 401) {
            logout(context);
            return null;
          }
//          print(response.body);
          if (response.statusCode != 200) return null;
          return response.body;
        }, onError: (e) {
          showMessage(context, Lang.get(Lang.CHECK_NETWORK));
//          print("onError" + e.toString());
          return null;
        });
      } catch (e) {
//        print("catch $e");
        showMessage(context, Lang.get(Lang.CHECK_NETWORK));
        return null;
      }
    else {
      //token not found ,move to login page
      logout(context);
//      print('null');
      return null;
    }
  }

  static Future<void> saveWallpaper(
      BuildContext context, Uint8List bytes, String path) async {
    try {
      final myImagePath = '${directory.path}/Fashion_Wallpapers';

      if (!File("$myImagePath/$path").existsSync()) {
        if (!Directory(myImagePath).existsSync())
          await new Directory(myImagePath).create();
//        var request = await HttpClient()
//            .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
//        var response = await request.close();
//        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
/*var file = */
        new File("$myImagePath/$path")..writeAsBytesSync(bytes);
      }
      showMessage(
          context, "  Wallpaper Saved To $myImagePath/$path Successfully !");
    } on PlatformException catch (e) {
      Navigator.pop(context);
    } catch (e) {
//      print('error: $e');
    }
  }

  static void showMessage(context, message) {
    if (context == null) return;
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Styles.TABSELECTEDSTYLE,
        textDirection: TextDirection.rtl,
      ),
      backgroundColor: Styles.primaryColor,
      action: SnackBarAction(
        label: 'X',
        textColor: Colors.yellow,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

//  static BannerAd createBannerAd() {
//    return BannerAd(
//      adUnitId: appIds["BANNER_UNIT_TEST"].toString(),
//      size: AdSize.fullBanner,
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
////        print("BannerAd event $event");
//      },
//    );
//  }

//  static InterstitialAd createInterstitialAd() {
//    return InterstitialAd(
//      adUnitId: appIds["INTERSTITIAL_UNIT_TEST"].toString(),
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
////        print("InterstitialAd event $event");
//      },
//    );
//  }

//  static void initAdmob() async {
//    FirebaseAdMob.instance
//        .initialize(appId: appIds["APP_ID"].toString())
//        .then((onValue) {
//      targetingInfo = MobileAdTargetingInfo(
//        keywords: <String>['telegram', 'follower', 'instagram'],
////        contentUrl: 'https://flutter.io',
////    birthday: DateTime.now(),
////        childDirected: false,
////    designedForFamilies: false,
////    gender: MobileAdGender.unknown,
//        // or MobileAdGender.female, MobileAdGender.unknown
//        // Android emulators are considered test devices
//        testDevices: <String>[],
//      );
//
//      RewardedVideoAd.instance.load(
//          adUnitId: appIds["REWARDED_UNIT_TEST"].toString(),
//          targetingInfo: targetingInfo);
//
//      bannerAd = createBannerAd();
//      bannerAd
//        ..load()
//        ..show(
//          anchorOffset: 0.0,
//          horizontalCenterOffset: 0.0,
//          anchorType: AnchorType.bottom,
//        );
//    });
//  }

//  static void loadRewardedVideo() {
//    RewardedVideoAd.instance
//        .load(
//            adUnitId: appIds["REWARDED_UNIT_TEST"].toString(),
//            targetingInfo: targetingInfo)
//        .then((onValue) {});
//  }

//  static void showRewardedVideo() {
//    RewardedVideoAd.instance.show().then((onValue) {}, onError: (e) {
//      loadRewardedVideo();
//    });
//  }

  static Future<Map<String, dynamic>> loadAppIds(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("ids.json");
    return json.decode(data);
  }

  static String getUserImageLink(String chat_id) {
    return Variable.LINK_IMAGES + "/users/$chat_id.jpg";
  }

  static String getChatImageLink(String chat_id) {
    return Variable.LINK_IMAGES + "/chats/$chat_id.jpg";
  }

  //ADVS Section
  static void initTapsell() async {
//    await TapsellPlus.initialize(appIds['TAPSELL_KEY_TEST']);
    TapsellPlus.initialize(appIds["TAPSELL_KEY"].toString());

//    Future.delayed(Duration(seconds: 10), () {
//      Helper.requestNativeBanner();
//    });

//    while (nativeBanner == null)
//      try {
//        print("test" + nativeBanner);
//        sleep(const Duration(seconds: 1));
//        Helper.requestNativeBanner();
//      } catch (e) {
//        continue;
//      }
  }

  static void requestNativeBanner({
    @required Function response,
    @required Function error,
  }) {
    TapsellPlus.requestNativeBanner(appIds["TAPSELL_NATIVE_BANNER"], (res) {
      response(res);
    }, (zoneId, errorMessage) {
      error(zoneId, errorMessage);
    });
  }

  static void clickNativeAdv() {
    TapsellPlus.nativeBannerAdClicked(
        appIds["TAPSELL_NATIVE_BANNER"], Helper.nativeBanner.adId);
  }

  static void requestRewardedVideo(
      {@required VoidCallback success, @required VoidCallback error}) {
    TapsellPlus.requestRewardedVideo(
        appIds["TAPSELL_REWARDED_VIDEO"].toString(),
        (zoneId) => success() /*(zoneId)*/,
        (zoneId, errorMessage) => error() /*(zoneId, errorMessage)*/);
  }

  static void showRewardedVideo({@required VoidCallback rewarded}) {
    TapsellPlus.showAd(appIds["TAPSELL_REWARDED_VIDEO"].toString(),
        opened: (zoneId) => opened(zoneId),
        closed: (zoneId) => closed(zoneId),
        error: (zoneId, errorMessage) => error(zoneId, errorMessage),
        rewarded: (zoneId) => rewarded()); /*(zoneId)*/
  }

  static error(zoneId, errorMessage) {
    print('error caught: zone_id = $zoneId, message = $errorMessage');
  }

  static opened(zoneId) {
    print("opened: zone_id = $zoneId");
  }

  static closed(zoneId) {
    print("closed: zone_id = $zoneId");
  }
}

class TelegramException implements Exception {
  TelegramException();
}
