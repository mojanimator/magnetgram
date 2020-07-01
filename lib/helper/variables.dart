class Variable {
  static String LANG = "fa";
  static String DOMAIN = "https://vartashop.ir/magnetgram/"

      /*"http://10.0.3.2:8000/"*/;

  static String APIDOMAIN = /*"http://moj-raj.ir/"*/ "${DOMAIN}api/";

  static String LINK_ADD_TO_DIVAR = "${APIDOMAIN}addtodivar";
  static String LINK_GET_DIVAR = "${APIDOMAIN}getdivar";
  static String LINK_GET_USER = "${APIDOMAIN}getuser";
  static String LINK_IMAGES = "${DOMAIN}storage";
  static String LINK_REFRESH = "${APIDOMAIN}refreshinfo";
  static String LINK_CHECK_UPDATE = "${APIDOMAIN}checkupdate";
  static String LINK_CHECK_USER_JOINED = "${APIDOMAIN}checkuserjoined";
  static String LINK_VIEW_CHAT = "${APIDOMAIN}viewchat";
  static String LINK_NEW_CHAT = "${APIDOMAIN}newchat";
  static String LINK_GET_SETTINGS = "${APIDOMAIN}getsettings";
  static String LINK_GET_USER_CHATS = "${APIDOMAIN}getuserchats";
  static String LINK_REFRESH_CHAT = "${APIDOMAIN}refreshchat";
  static String LINK_UPDATE_SCORE = "${APIDOMAIN}updatescore";
  static String LINK_PENALTY = "${APIDOMAIN}penalty";

  static String LOGIN = "${APIDOMAIN}login";
  static String LOGOUT = "${APIDOMAIN}logout";

  static String COMMAND_REFRESH_DIVAR = "REFRESH_DIVAR";
  static String COMMAND_INSTALL_CHAT = "install_chat";
  static String COMMAND_FOLLOW_CHAT = "follow_chat";
  static String ADMIN_ID = "develowper";
  static String BOT_ID = "magnetgrambot";

  static Map<String, String> ERROR = {
    "DISCONNECTED": "اتصال برقرار نیست",
  };
}

enum Commands { RefreshWallpapers }
