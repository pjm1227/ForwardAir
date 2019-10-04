import 'package:url_launcher/url_launcher.dart';

//This class to make a call and send a mail

class CallsAndMailService {

   Future<bool> call(String number) async{
    bool isSuccess = false;
    isSuccess =  await launch("tel:$number");
    return isSuccess;
  }

  void sendEmail(String email,String subject) async {
    String url = Uri.encodeFull("mailto:$email?subject=$subject");
    if (await canLaunch(url)) {
       await launch(url);
    } else {
       print ('Could not launch $url');
    }
  }
}