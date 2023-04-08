import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray90014 = fromHex('#140f172a');

  static Color gray5001 = fromHex('#fcfcfc');

  static Color amber60099 = fromHex('#99f5b300');

  static Color blueA700 = fromHex('#0153ff');

  static Color greenA70001 = fromHex('#1bc256');

  static Color lightBlueA200 = fromHex('#38bdf8');

  static Color indigoA100 = fromHex('#a0acff');

  static Color amberA200 = fromHex('#ffda44');

  static Color gray50 = fromHex('#f8f9fd');

  static Color greenA700 = fromHex('#1ccd5b');

  static Color black900 = fromHex('#1d1d1f');

  static Color indigo5001 = fromHex('#e9ebff');

  static Color purpleA700 = fromHex('#9e16f2');

  static Color indigo5002 = fromHex('#ecedfd');

  static Color blueGray800 = fromHex('#334155');

  static Color deepPurpleA400 = fromHex('#6b38f4');

  static Color blue90001 = fromHex('#0033ad');

  static Color blue90002 = fromHex('#061237');

  static Color blueA7007f = fromHex('#7f0053ff');

  static Color blueA700B2 = fromHex('#b20153ff');

  static Color pink400 = fromHex('#e82c81');

  static Color redA700 = fromHex('#d80027');

  static Color gray90002 = fromHex('#061237');

  static Color blueGray200E5 = fromHex('#e5babccc');

  static Color blueGray5000a = fromHex('#0a64748a');

  static Color blue900 = fromHex('#0052b4');

  static Color blueGray100 = fromHex('#cbd5e1');

  static Color blueGray300 = fromHex('#94a3b8');

  static Color indigo50 = fromHex('#e2e8f0');

  static Color blue500 = fromHex('#18a0fb');

  static Color amber600 = fromHex('#f5b300');

  static Color gray900 = fromHex('#0f172a');

  static Color blueGray500 = fromHex('#64748b');

  static Color blueGray5000c = fromHex('#0c64748a');

  static Color gray90001 = fromHex('#262626');

  static Color blueGray9007f = fromHex('#7f002148');

  static Color blueA70099 = fromHex('#990153ff');

  static Color blue50 = fromHex('#eaf1ff');

  static Color gray100 = fromHex('#f1f5f9');

  static Color gray200 = fromHex('#E9EBFF');

  static Color indigoA10001 = fromHex('#887ef9');

  static Color whiteA70000 = fromHex('#00ffffff');

  static Color blueGray100E5 = fromHex('#e5cccccc');

  static Color bluegray400 = fromHex('#888888');

  static Color whiteA70001 = fromHex('#fefefd');

  static Color greenA700A0 = fromHex('#a01ccd5b');

  static Color blue100 = fromHex('#c7ccff');

  static Color whiteA700 = fromHex('#f5f5f7');

  static Color gray9001401 = fromHex('#140e172a');

  static Color redA20099 = fromHex('#99ff595e');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
