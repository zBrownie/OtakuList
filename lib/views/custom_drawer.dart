import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(4, 12, 4, 4),
          child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection('animes').getDocuments(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFf06428)),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data.documents.map((docs) {
                    return ListTile(
                      title: Text(docs.data['title'] ?? 'Error nome'),
                      leading: Container(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: docs.data['img'] ??
                              'https://zenit.org/wp-content/uploads/2018/05/no-image-icon.png',
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4.0),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.of(context).pop();
                        _bottomSheet(context, docs);
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ],
    ));
  }

  _bottomSheet(BuildContext context, DocumentSnapshot doc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xFFf7b091),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22),
                      topRight: const Radius.circular(22))),
              child: ListView(
                padding: EdgeInsets.all(14.0),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(4, 6, 46, 6),
                        child: Image.network(
                          doc.data['img'] ??
                              'https://zenit.org/wp-content/uploads/2018/05/no-image-icon.png',
                          height: 120,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text('Crunchyroll'),
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              elevation: 4.0,
                              onPressed: () {
                                return launch(doc.data['link']);
                              },
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              child: Text('Outros'),
                              color: Colors.orangeAccent,
                              textColor: Colors.white,
                              elevation: 4.0,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      Text(
                        doc.data['desc'],
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
