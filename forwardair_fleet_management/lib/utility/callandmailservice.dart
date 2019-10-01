import 'package:url_launcher/url_launcher.dart';

//This class to make a call and send a mail

class CallsAndMailService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email,String subject) async {
    String url = Uri.encodeFull("mailto:$email?subject=$subject");
    if (await canLaunch(url)) {
       await launch(url);
    } else {
       print ('Could not launch $url');
    }
  }
}