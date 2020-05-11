import 'dart:convert';
import 'dart:math';

import 'package:borrowinomobileapp/views/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:borrowinomobileapp/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home.dart';
import '../Home.dart';
import '../Login.dart';
import 'package:http/http.dart' as http;

import 'SettingsPage.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => new _MyProfileState();

}

class _MyProfileState extends State<MyProfile> {

  String currentProfilePic = " ";
  void switchAccounts() {
    String picBackup = currentProfilePic;

  }


  //profile details ,,,,,,
  String name;
  String email;
  @override
  void initState(){
    _loadUserData();
    super.initState();
  }

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if(user != null) {
      setState(() {
        name = user['name'];
        email = user['email'];
      });
    }
  }

  //End profile details ,,,,,,

  //API for offers.......
  Future <Offer> _fetchOffers() async {
    final response = await http.get('http://10.0.2.2:8000/api/offer?page=7');

    //var jsonData =jsonDecode(res.body).cast<String,dynamic>();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Offer.fromJson(jsonResponse[0]);
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

   // List<Offer>offers=[];
   // for (var u in jsonData){
     //  Offer offer=Offer(u['title'],u['description'],u['location']);
     //// Offer offer=Offer(u['title'].toString(),u['description'].toString(),u['location'].toString());
     // offers.add(offer);
   // }
  //  print(offers);
  //  return offers;

  //End API for offers.......



  //Page Design.........
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(title: new Text("Offers"), backgroundColor: Color(0xff21254A),),

        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail:Text(email),
                accountName: new Text('Hi, $name'),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(currentProfilePic),
                  ),
                  onTap: () => print("This is your current account."),
                ),
                otherAccountsPictures: <Widget>[

                ],
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new NetworkImage("https://picsum.photos/200?random"),

                        fit: BoxFit.fill
                    )
                ),
              ),
              new ListTile(
                  title: new Text("Place Offer"),
                  trailing: new Icon(Icons.local_offer),
                  onTap: () {
                    Navigator.of(context).pop();
                   // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page(Home())));
                  }
              ),

              new ListTile(
                  title: new Text("Message"),
                  trailing: new Icon(Icons.message),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(
                            builder: (context) => Chat()));
                    // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page(Login())));
                  }
              ),
              new ListTile(
                  title: new Text("Settings"),
                  trailing: new Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(
                            builder: (context) => Home()));
                    // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page(Login())));
                  }
              ),
              new Divider(),
              new ListTile(
                title: new Text("Log out"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () =>  logout(context),
              ),
            ],
          ),
        ),
        body:new Scaffold( //getting list of offers here...

          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: new Text("ss",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(

            child: FutureBuilder(
              future: _fetchOffers(),
              builder:(BuildContext x,AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      child: Center(
                        child: Text("Loacding..."),
                      )
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int data) {
                      return ListTile(
                        title: Text(snapshot.data["title"]),
                      );
                    },
                  );
                }
              },
            ),
          ),


        )
    );
  }
}

//class offers for API
class Offer{
  //final int id;
  // final DateTime created_at;
  // final DateTime updated_at;
  final String title;
  final String description;
  final String location;
  // final double price;
  // final int owner;

  Offer({this.title,this.description,this.location});
  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        title: json['title'],
        description: json['description'],
        location: json['location'],
    );
  }


}


//logout method
void logout(context) async{
  // logout from the server ...
  // var res = await CallApi().getData('logout');
  // var body = json.decode(res.body);
  //  if(body['success']){
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.remove('user');
  localStorage.remove('token');
  Navigator.push(context,
      new MaterialPageRoute(
          builder: (context) => Login()));
  //Navigator.pop(context);
}


