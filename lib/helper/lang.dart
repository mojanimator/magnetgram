import 'package:magnetgram/helper/variables.dart';

class Lang {
  static int HELLO = 1;
  static int CHECK_NETWORK = 2;
  static int APP_NAME = 3;
  static int TELEGRAM_USERNAME_HINT = 4;
  static int PASSWORD_HINT = 5;
  static int ADD_CONFIRM = 6;
  static int ViEW = 7;
  static int DIVAR = 8;
  static int MYINFO = 9;
  static int TIMEOUT_CHAT = 10;
  static int REPEATED_ADD = 11;
  static int BOT_NOT_ADDED_OR_NOT_EXISTS = 12;
  static int BOT_NOT_ADDED = 13;
  static int ADMIN_OR_CREATOR = 14;
  static int MEMBER = 15;
  static int TELEGRAM_ERROR = 16;
  static int MIN = 17;
  static int COIN = 18;
  static int NOT_ADMIN = 19;
  static int EXISTS_IN_DIVAR = 20;
  static int EXISTS_IN_QUEUE = 21;
  static int LOW_SCORE = 22;
  static int SUCCESS_DIVAR = 23;
  static int SUCCESS_QUEUE = 24;
  static int AGREE_QUEUE = 25;
  static int ADD_TO_DIVAR = 26;
  static int CANCEL = 27;
  static int ACCEPT = 28;
  static int OK = 29;
  static int VIP_FULL = 30;
  static int VIP = 31;
  static int REFRESH_CHAT_SUCCESS = 32;
  static int CHAT_EXISTS = 33;
  static int NOT_ADMIN_OR_CREATOR = 34;
  static int BOT_NOT_ADMIN = 35;
  static int CHAT_NOT_FOUND = 36;
  static int REGISTER_SUCCESS = 37;
  static int INPUT_CHAT_LABEL = 38;
  static int CHAT_USERNAME = 39;
  static int REGISTER_CHAT = 40;
  static int LEFT_NOT_FOUND = 41;
  static int LEFT_FOUND = 42;
  static int AGREE_FIND_LEFT_USERS = 43;
  static int START = 44;
  static int LOGIN_FAIL = 45;
  static int SERVER_ERROR = 46;
  static int ERROR_SHOW_VIDEO = 47;
  static int ADDED_SCORE = 48;
  static int BUY_COIN = 49;
  static int COIN_METHODS = 50;
  static int FOLLOWING_CHATS = 51;
  static int ADDING_MEMBER_TO_GROUPS = 52;
  static int SEEING_VIDEO = 53;
  static int LOGIN = 54;
  static int REGISTER = 55;
  static int REGISTER_IS_FROM_BOT = 56;
  static int HELP = 57;
  static int REF_SCORE = 58;
  static int HOW_WORKS = 59;
  static int SUPPORT = 60;
  static int BOT_ENTER = 61;
  static int TUTORIALS = 62;

  static String get(int key) {
    return dict[Variable.LANG][key];
  }

  static Map<String, Map<int, String>> dict = {
    "fa": {
      HELLO: "سلام",
      MIN: "دقیقه",
      COIN: "سکه",
      CHECK_NETWORK: "اتصال اینترنت خود را بررسی کرده و مجدد تلاش کنید.",
      APP_NAME: "مگنت گرام",
      TELEGRAM_USERNAME_HINT: "نام کاربری تلگرام (@...)",
      PASSWORD_HINT: "رمز عبور",
      ADD_CONFIRM: "عضویت",
      ViEW: "نمایش",
      DIVAR: "دیوار",
      MYINFO: "گروه/کانال من",
      TIMEOUT_CHAT: "زمان نمایش گروه/کانال به پایان رسیده است !",
      REPEATED_ADD: "شما یک بار از طریق ربات عضو این کانال/گروه شده اید !",
      BOT_NOT_ADDED_OR_NOT_EXISTS:
          "شما هنوز عضو این کانال/گروه نشده اید و یا ربات در این کانال/گروه وجود ندارد !",
      BOT_NOT_ADDED: "ربات در این کانال/گروه وجود ندارد !",
      ADMIN_OR_CREATOR: "شما مدیر کانال/گروه هستید !",
      MEMBER: "تبریک! با موفقیت عضو کانال/گروه شدید و سکه به شما افزوده شد !",
      TELEGRAM_ERROR: "سرور تلگرام هم اکنون پاسخگو نیست !",
      NOT_ADMIN: "شما و ربات باید ادمین این کانال/گروه باشید !",
      LOW_SCORE: "سکه کافی ندارید !",
      EXISTS_IN_DIVAR: "این گروه/کانال از قبل در دیوار وجود دارد !",
      EXISTS_IN_QUEUE: "این گروه/کانال از قبل در صف وجود دارد !",
      SUCCESS_DIVAR: "با موفقیت به دیوار اضافه شد !",
      SUCCESS_QUEUE: "با موفقیت در صف قرار گرفت !",
      AGREE_QUEUE:
          "دیوار هم اکنون پر است. گروه/کانال شما به صف دیوار اضافه خواهد شد و پس از خالی شدن دیوار، به آن اضافه خواهد شد.آیا موافقید؟",
      ADD_TO_DIVAR: "درج در دیوار",
      CANCEL: "لغو",
      ACCEPT: "تایید",
      OK: "باشه",
      VIP_FULL:
          "سنجاق های دیوار پر هستند.\n می توانید حالت سنجاق را بردارید و یا در صف قرار دهید",
      VIP: "سنجاق به بالای دیوار",
      REFRESH_CHAT_SUCCESS: "گروه/کانال با موفقیت بروزرسانی شد!",
      CHAT_EXISTS: "گروه/کانال از قبل ثبت شده است !",
      NOT_ADMIN_OR_CREATOR:
          "فقط مدیر یا سازنده گروه/کانال می تواند آن را ثبت کند !",
      BOT_NOT_ADMIN: "ربات باید ادمین گروه/کانال باشد !",
      CHAT_NOT_FOUND: "گروه/کانال یافت نشد و یا ربات ادمین آن نیست !",
      REGISTER_SUCCESS: "گروه/کانال با موفقیت ثبت شد !",
      INPUT_CHAT_LABEL:
          "ابتدا ربات را ادمین گروه/کانال خود کرده و نام کاربری گروه/کانال خود را اینجا وارد کنید !",
      CHAT_USERNAME: "نام کاربری گروه/کانال",
      REGISTER_CHAT: "ثبت گروه/کانال",
      LEFT_NOT_FOUND: "کاربر خارج شده ای یافت نشد",
      LEFT_FOUND: "کاربر خارج شده جریمه شدند",
      AGREE_FIND_LEFT_USERS:
          "کاربران لفت داده از گروه/کانال های شما شناسایی و جریمه خواهند شد",
      START: "شروع",
      LOGIN_FAIL: "نام کاربری یا گذرواژه نادرست است",
      SERVER_ERROR: "خطای سرور",
      ERROR_SHOW_VIDEO: "مشکلی در دریافت ویدیو پیش آمد. لطفا مجدد تلاش نمایید",
      ADDED_SCORE: "سکه به شما افزوده شد!",
      BUY_COIN: "خرید سکه دلخواه",
      COIN_METHODS: "روش های دریافت سکه",
      FOLLOWING_CHATS: "فالو کردن گروه/کانال های دیوار",
      ADDING_MEMBER_TO_GROUPS: "اد زدن به گروه ها",
      SEEING_VIDEO: "تماشای ویدیو",
      LOGIN: "ورود",
      REGISTER: "ثبت نام",
      REGISTER_IS_FROM_BOT: "گزینه ثبت نام✅ را در ربات تلگرام انتخاب نمایید",
      HELP: "راهنما",
      REF_SCORE: "اشتراک بنر تبلیغاتی و گرفتن زیرمجموعه",
      HOW_WORKS: "مگنت گرام چیست؟\n"
          "برای دیده شدن کانال و گروه خود می توانید آن را در"
          "دیوار مگنت گرام قرار دهید. برای این کار نیاز به سکه دارید"
          "که می توانید با فالو کردن گروه ها و کانال های موجود در دیوار"
          "بدست آورید.\nاین چرخه برای همه تکرار خواهد شد."
          "\nهمچنین می توانید افراد لفت داده را با دکمه قرمز کنار سکه جریمه کنید.",
      SUPPORT: "پشتیبانی",
      BOT_ENTER: "ورود به ربات",
      TUTORIALS: "آموزش ها",
    },
    "en": {
      HELLO: "Hello",
      MIN: "Minute",
      COIN: "Coin",
      CHECK_NETWORK: "Check Your Internet Connection And Try Again.",
      APP_NAME: "Magnet Gram",
      TELEGRAM_USERNAME_HINT: "Your Telegram Username (@...)",
      PASSWORD_HINT: "Password",
      ADD_CONFIRM: "Add",
      ViEW: "View",
      DIVAR: "Wall",
      MYINFO: "My Group/Channel",
      TIMEOUT_CHAT: "Chat Has Expired From Wall !",
      REPEATED_ADD: "You Joined To This Chat  With Bot One Time Before!",
      BOT_NOT_ADDED_OR_NOT_EXISTS:
          "You Not Joined To This Chat Yet Or Bot Is Not In Chat !",
      BOT_NOT_ADDED: "Bot Is Not In Chat !",
      ADMIN_OR_CREATOR: "You Are Admin Of This Chat !",
      MEMBER:
          "Congradulation ! You Are Now A Memer Of This Chat And Get The Coins !",
      TELEGRAM_ERROR: "Telegram Servers Not Responding Now !",
      NOT_ADMIN: "You And Bot Must Be  Admin Of The Chat !",
      LOW_SCORE: "Your Need More Coins!",
      EXISTS_IN_DIVAR: "Your Chat Exists In Wall !",
      EXISTS_IN_QUEUE: "Your Chat Exists In Queue !",
      SUCCESS_DIVAR: "Successfully Added To Wall!",
      SUCCESS_QUEUE: "Successfully Added To Queue!",
      AGREE_QUEUE:
          "The Wall Is Full Now. Your Chat Will Be Added To Queue And  Goes To Wall Soon. Do You Agree?",
      ADD_TO_DIVAR: "Add To Wall",
      CANCEL: "Cancel",
      ACCEPT: "Accept",
      OK: "Ok",
      VIP_FULL:
          "Wall Pins Are Full. You Can Remove Pin Mode Or Add Your Chat To The Queue",
      VIP: "Pin To Top",
      REFRESH_CHAT_SUCCESS: "Chat Updated Successfully !",
      CHAT_EXISTS: "Chat Already Exists !",
      NOT_ADMIN_OR_CREATOR: "You Are Not Creator Or Admin Of The Chat !",
      BOT_NOT_ADMIN: "Bot Must Be Admin Of The Chat !",
      CHAT_NOT_FOUND: "Chat Not Found Or Bot Is Not Admin Of The Chat",
      REGISTER_SUCCESS: "Chat Registered Successfully",
      INPUT_CHAT_LABEL:
          "Please Set The Bot in Your Chat As Admin And Insert Your Chat Username Here",
      CHAT_USERNAME: "Chat Username",
      REGISTER_CHAT: "Register Chat",
      LEFT_NOT_FOUND: "Not Any Left User Found !",
      LEFT_FOUND: "Left Users Found !",
      AGREE_FIND_LEFT_USERS: "Users That Left Your Chats Will Be Penalized ! ",
      START: "Start",
      LOGIN_FAIL: "Incorrect Username Or Password",
      SERVER_ERROR: "Server Error",
      ERROR_SHOW_VIDEO:
          "Some Problem Occurred During Downloading Video. Please Retry Again",
      ADDED_SCORE: "Coins Added To Your Coins !",
      BUY_COIN: "Buy Custom Coin",
      COIN_METHODS: "Getting Coins Methods",
      FOLLOWING_CHATS: "Following Chats",
      ADDING_MEMBER_TO_GROUPS: "Add Member To Groups",
      SEEING_VIDEO: "Watch Video",
      LOGIN: "Login",
      REGISTER: "Register",
      REGISTER_IS_FROM_BOT: "Please Select Register✅ In Telegram Bot",
      HELP: "Help",
      REF_SCORE: "Share Advertisement Banner And Get Referral Member",
      HOW_WORKS: "What is Magnet Gram ? \n "
          "For Increase Your Telegram Chats You Can Register It \n"
          "In Magnet Gram Wall. For Doing It You Need Coins.\n"
          "You Can Get Coins With Following Chats In The Wall.\n"
          "This Process Repeats For Every Chats In The Wall.\n"
          "Also You Can Penalise Left Members With Red Button Beside Coins Button",
      SUPPORT: "Support",
      BOT_ENTER: "Bot",
      TUTORIALS: "Tutorials",
    }
  };
}
