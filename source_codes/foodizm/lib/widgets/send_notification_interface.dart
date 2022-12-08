import 'dart:convert';

import 'package:get/get.dart';

class SendNotificationInterface extends GetConnect {
  sendNotification(String? title, String? body, String deviceId, String key) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer " +
            "AAAAy-TnkMg:APA91bFBXzR_veW_hWFKwNOIjnMVxiNg7KjYgzNFoPTFynQBH091j8TZKJIVbFf3oeLrKnt_OIt51obiUq80X6-Py0k7r8RdrSNZulFN3yTP-rTty8CEeSVX__a7-Bu3Q1D30rcsJkL4",
        "Content-Type": "application/json"
      };
      Map<dynamic, dynamic> data = {
        "to": deviceId,
        "collapse_key": key,
        "priority": "high",
        "sound": "default",
        "notification": {"title": title, "body": body}
      };
      print(jsonEncode(data));
      var response = await post("https://fcm.googleapis.com/fcm/send", jsonEncode(data), headers: headers);
      print("Status Code : " + response.statusCode.toString() + " body : " + response.bodyString!);
    } catch (e) {
      print(e);
    }
  }
}
