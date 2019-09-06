import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:otakolist_app/views/custom_drawer.dart';
import 'package:otakolist_app/views/login_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt-BR';
  }

  Widget _backGround() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 240, 100, 40),
        Color.fromARGB(255, 243, 131, 83),
      ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
    );
  }

  _whatIsToDay() {
    initializeDateFormatting();
    return DateFormat.EEEE().format(DateTime.now());
  }

  /*_dateFormat() {
     initializeDateFormatting();
      return DateFormat.MMMd().format(DateTime.now());
    
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animes de Hoje'),
        centerTitle: true,
        backgroundColor: Color(0xFFf06428),
        elevation: 0.0,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage())),
          )
        ],*/
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          _backGround(),
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection('animes')
                .where('pos', isEqualTo: DateTime.now().weekday)
                .where('streaming', isEqualTo: 1)
                .getDocuments(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none ||
                  !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('Sem Animes'),
                );
              } else {
                return StaggeredGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  staggeredTiles:
                      snapshot.data.documents.map((DocumentSnapshot doc) {
                    return StaggeredTile.count(doc.data['x'], doc.data['y']);
                  }).toList(),
                  children: snapshot.data.documents.map((DocumentSnapshot doc) {
                    return GestureDetector(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc.data['img'],
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        _bottomSheet(context, doc);
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
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
