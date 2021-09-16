import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List users = [];
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
    this.fetchUser();
  }
  fetchUser() async{
    setState(() {
      isLoading = true;
    });
    var url = "https://randomuser.me/api/?results=100";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var items = json.decode(response.body)['results'];
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Api Data")),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    if(users.contains(null) || users.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: users.length,
        itemBuilder: (context, index){
      return getCard(users[index]);
    });
  }
  Widget getCard(item){
    var fullName = item['name']['title']+""+item['name']['first']+""+item['name']['last'];
    var email = item['email'];
    var profileUrl = item['picture']['large'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                  height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(60/2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(profileUrl.toString()
                    )
                  )
                ),
              ),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(fullName.toString(), style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                  SizedBox(height: 10,),
                  Text(email.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                  ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
