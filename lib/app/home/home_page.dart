import 'package:flutter/material.dart';
import 'package:inspirr/app/home/main_page.dart';
import 'package:inspirr/app/home/texts_page.dart';
import 'package:inspirr/app/home/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:inspirr/services/database.dart';

class HomePage extends StatefulWidget {

  final String uid;
  final String did;
  final String email;
  HomePage({Key key, @required this.uid, this.did, this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPage = 0;
  bool navigationBar = true;
  bool _paidUser;

  void disableNav() {
    setState(() {
      navigationBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final _pages = [
      MainPage(disableNav: disableNav, did: widget.did),
      TextsPage(did: widget.did),
      SettingsPage(did: widget.did, email: widget.email, paidUser: _paidUser),
    ];

    return Scaffold(
      body: _pages[_selectedPage],
      backgroundColor: Colors.white,// Color(0xFFf1f1f6),
      bottomNavigationBar: navigationBar ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedPage,
      onTap: (int index) async {
        if (index == 2) {
          final database = Provider.of<Database>(context, listen: false);
          final Map data = await database.getUserData();
          final bool paidUser = data['paidUser'];
          setState(() {
            _selectedPage = index;
            _paidUser = paidUser;
          });
        } else {
          setState(() {
            _selectedPage = index;
          });
        }
      },
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromRGBO(47, 46, 65, 1),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: (Container(height: 0)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: (Container(height: 0)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: (Container(height: 0)),
        ),
      ],
    );
  }
}
