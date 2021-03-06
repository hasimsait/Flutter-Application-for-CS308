import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'helper/session.dart';

/*I created this class to cache profile pictures in the session but users can change their profile pictures, we would need a "profile picture has changed flag" or something for it to work properly therefore I will not use this class.*/
class ProfilePicture {
  //PickedFile image;
  String userID;

  ProfilePicture(this.userID);

  Future<Image> get({String image}) async {
    //todo find a way to keep it refreshable and cached, currently each call creates a new instance which calls .getInfo which calls it with a downloaded image
    dynamic profilePicture = await FlutterSession().get('pp' + userID);
    //we could define a profile class in session manager but I'm not sure what we would cache, therefore I wil not.
    if (image != null) {
      print("writing to sesion");
      Session profilePicture = Session(data: image);
      await FlutterSession().set('pp' + userID, profilePicture);
      return Image.memory(base64Decode(image));
    } else {
      print("loading from session");
      return Image.memory(base64Decode(profilePicture['data']));
    }
  }
}
