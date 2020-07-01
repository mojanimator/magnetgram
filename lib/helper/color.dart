import 'dart:ui';

class MyColors {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    /* if (hexString.length == 6 || hexString.length == 7)*/
    buffer.write('ff');
    buffer.write(hexString /*.replaceFirst('#', '')*/);
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Map<String, Color> COLOR = {
    "blue": Color(0xff3490dc),
    "indigo": Color(0xff6574cd),
    "purple": Color(0xff9561e2),
    "pink": Color(0xfff66D9b),
    "red": Color(0xffe3342f),
    "orange": Color(0xfff6993f),
    "yellow": Color(0xffffed4a),
    "green": Color(0xff38c172),
    "teal": Color(0xff4dc0b5),
    "cyan": Color(0xff6cb2eb),

    "flame_start": Color(0xffff9a9e),
    "flameend": Color(0xfffad0c4),

    "peach_start": Color(0xffffecd2),
    "peach_end": Color(0xfffcb69f),

    "neva_start": Color(0xffa1c4fd),
    "neva_end": Color(0xffc2e9fb),

    "rain_start": Color(0xffcfd9df),
    "rain_end": Color(0xffe2ebf0),

    "cloud_start": Color(0xfffdfbfb),
    "cloud_end": Color(0xffebedee),

    "SaintPetersberg_start": Color(0xfff5f7fa),
    "SaintPetersberg_end": Color(0xffc3cfe2),

    "everlasting_start": Color(0xfffdfcfb),
    "everlasting_end": Color(0xffe2d1c3),

    "salad_start": Color(0xffB7F8DB),
    "salad_end": Color(0xff50A7C2),
//

//      dark: Color(0xff373737) ,
//      dark-gray: Color(0xff4a4a4a) ,
//      gray: Color(0xff7F928B)  ,
//      cream: Color(0xffC1A26A)  ,
//  dark-blue: Color(0xff015474)  ,
//  light-blue:Color(0xff028BBF)  ,
//  dark-green: Color(0xff51573C)  ,
//  light-green: Color(0xff60aa2f)  ,
//  dark-red: Color(0xff782517)  ,
//  red: Color(0xffB53029 ) ,
//  light-red: Color(0xffdb8f3c)  ,

//  primary: blue  ,
//  secondary: cream  ,
//      success: light-green  ,
//  info: gray  ;
//  dark-gray: dark-gray  ,
//  warning: light-red  ,
//  danger: red  ,
//  light: gray-100  ,
//  dark: dark  ,

//  colors: Color()  ,
//  colors: map((
//  "purple": purple,
//  "dark": dark,
//  "gray": gray,
//  "dark-gray": dark-gray,
//  "cream": cream,
//  'flame-start':flame-start,
//  "dark-blue": dark-blue,
//  "light-blue": light-blue,
//  "dark-green": dark-green,
//  "light-green": light-green,
//  "dark-red": dark-red,
//  "red": red,
//  "light-red": light-red,
//  "white": white,
//  "gray-dark": gray-800
//  ), colors),
//

//  theme-colors: Color()   ,,
//  theme-colors: map-merge((
//   "primary": primary,
//  "purple": purple,
//  "secondary": secondary,
//  "success": green,
//  "info": info,
//  "dark-gray": dark-gray,
//  "warning": warning,
//  "danger": danger,
//  "dark-red": dark-red,
//  "light-red": light-red,
//  "light": light,
//  "dark": dark,
//  "gray": gray,
//  'flame-start':flame-start,
//  'cream':cream,
//  "dark-blue":dark-blue,
//  "light-blue":light-blue,
//  "dark-green":dark-green,
//  "light-green": success,
//  ), theme-colors),

    ///
  };
}
