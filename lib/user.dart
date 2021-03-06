import 'package:teamone_social_media/helper/requests.dart';
import 'helper/constants.dart';
import 'post.dart';

class User {
  String myProfilePicture =
      Constants.sampleProfilePictureBASE64; //null protection
  String myName = ""; //Haşim Sait Göktan//null protection
  String userName; //hasimsait
  bool isFollowing;
  int followerCt;
  int followingCt;

  String email;
  bool active = true;
  bool deleted = false;
  List<Post> posts;
  User(this.userName);

  Future<User> getInfo() async {
    if (Constants.DEPLOYED) {
      print('USER.DART: requests the info of: ' + this.userName);
      User info = await Requests().getUserInfo(this.userName);
      this.myProfilePicture = info.myProfilePicture;
      this.myName = info.myName;
      this.isFollowing =
          info.isFollowing; //true if currentUser is following this user.
      this.followerCt = info.followerCt;
      this.followingCt = info.followingCt;
      this.email = info.email;
      this.active = info.active;
      this.deleted = info.deleted;
      this.posts = info.posts;
      return this;
    } else {
      this.myProfilePicture = Constants.sampleProfilePictureBASE64;
      this.myName = userName;
      this.isFollowing = true; //true if currentUser is following this user.
      this.followerCt = 100;
      this.followingCt = 99;
      return this;
    }
  }

  List<Post> getPosts() {
    //return await Requests().getPosts(userName, "posts");
    return this.posts;
  }

  Future<Map<int, Post>> getFeedItems() async {
    if (Requests.isAdmin) {
      //admin's feed is reported posts.
      return await Requests().getWaitingReportedPosts();
    } else
      return await Requests().getPosts();
  }
}
