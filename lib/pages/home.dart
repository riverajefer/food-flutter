import 'package:flutter/material.dart';
import 'package:food/pages/proteinas.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HOME'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProteinaPage()),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text('Proteinas'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Más'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Más más'),
              ),
            ],
          ),
        ));
  }
}
