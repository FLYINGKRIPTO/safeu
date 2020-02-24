
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void getLocationAndSendSMS(String message, List<String> recipients) async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  String uri =
      'sms:+91 ${recipients}?body=$message,$position';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'sms:0039-222-060-888';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
//  String result  = await FlutterSmsPlugin().sendSMS(message: message + position.toString() , recipients: recipients).catchError((onError){
//    print(onError);
//  });

}
