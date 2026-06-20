import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Paid {
  static const MethodChannel _channel = MethodChannel('com.ihongwu/paid');

  static Future<String?> getPAID() async {
    try {

      if(Platform.isAndroid){
        return '';
      }


      final Map<dynamic, dynamic>? rawData = await _channel.invokeMethod('getRawPaidFields');
      if (rawData == null) return '';

      String initTime = rawData['initTime'] ?? '';
      String updateTime = rawData['updateTime'] ?? '';
      String bootTime = rawData['bootTime'] ?? '';
      // print('#################### initTime: $initTime');
      // print('#################### updateTime: $updateTime');
      // print('#################### md5Boot: $bootTime');
      if (initTime.isEmpty || updateTime.isEmpty || bootTime.isEmpty) {
        return '';
      }

      String md5Init = md5.convert(utf8.encode(initTime)).toString();
      String md5Update = md5.convert(utf8.encode(updateTime)).toString();
      String md5Boot = md5.convert(utf8.encode(bootTime)).toString();

      return "$md5Init-$md5Update-$md5Boot";
    } catch (e) {
      print("Error generating PAID: $e");
      return '';
    }
  }
}
