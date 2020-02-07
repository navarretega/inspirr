import 'package:flutter/material.dart';
import 'package:inspirr/app/home/home_page.dart';
import 'package:inspirr/app/sign_in/sign_in_page.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/services/database.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  DeviceInfoPlugin _deviceInfoPlugin;
  final List socialProviders = ['facebook.com', 'google.com'];

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _deviceInfoPlugin = DeviceInfoPlugin();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            if (user.isAnonymous) {
              // TODO: IOS MISSING !!!
              return FutureBuilder<AndroidDeviceInfo>(
                future: _deviceInfoPlugin.androidInfo,
                builder: (BuildContext context,
                    AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final androidDeviceInfo = snapshot.data;
                    return Provider<Database>(
                      create: (_) => FirestoreDatabase(
                        uid: user.uid,
                        did: androidDeviceInfo.androidId,
                      ),
                      child: HomePage(
                        uid: user.uid,
                        did: androidDeviceInfo.androidId,
                      ),
                    );
                  }
                },
              );
            } else {
              if (socialProviders.contains(user.provider)) {
                return Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  child: HomePage(uid: user.uid, email: user.email),
                );
              } else {
                if (user.isVerified) {
                  return Provider<Database>(
                    create: (_) => FirestoreDatabase(uid: user.uid),
                    child: HomePage(uid: user.uid, email: user.email),
                  );
                } else {
                  _signOut(context);
                  return SignInPage.create(context);
                }
              }
            }
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
