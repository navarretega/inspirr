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

  bool _isAnon;
  int _freeTexts;
  int _paidTexts;

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
      SettingsPage(did: widget.did, email: widget.email, freeTexts: _freeTexts, paidTexts: _paidTexts),
    ];

    return Scaffold(
      body: _pages[_selectedPage],
      backgroundColor: Colors.white,// Color(0xFFf1f1f6),
      bottomNavigationBar: navigationBar ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildBottomNavigationBar() {

    if (widget.did == null) {
      _isAnon = false;
    } else {
      _isAnon = true;
    }

    return BottomNavigationBar(
      currentIndex: _selectedPage,
      onTap: (int index) async {
        if (index == 2) {
          final database = Provider.of<Database>(context, listen: false);
          final Map data = await database.getUserData(_isAnon);
          final int freeTexts = data['freeTexts'];
          final int paidTexts = data['paidTexts'];
          setState(() {
            _selectedPage = index;
            _freeTexts = freeTexts;
            _paidTexts = paidTexts;
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
