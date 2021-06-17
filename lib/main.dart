import 'dart:convert';

import 'package:api_app_example/models/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Album>> fetchAlbums() async {
    var uri = 'https://jsonplaceholder.typicode.com/albums/1/photos';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List responseJson = jsonDecode(response.body);
      List<Album> albums = responseJson.map((e) => Album.fromJson(e)).toList();
      return albums;
    } else {
      throw Exception('Failed to load Album Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Working with APIs'),
      ),
      body: FutureBuilder<List<Album>>(
        future: fetchAlbums().catchError((error) {
          print('$error');
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Album> albums = snapshot.data!;
            return new ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Image.network(albums[index].thumbnailUrl),
                      title: Text(albums[index].id.toString()),
                      subtitle: Text(albums[index].title),
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                  ],
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
