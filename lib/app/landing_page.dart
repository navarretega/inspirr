import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          // NOT LOGGED IN
          print('AUTH - Not logged in');
          if (user == null) {
            return SignInPage.create(context);
          } else {
            // LOGGED IN AS ANON
            if (user.isAnonymous) {
              // LOGGED IN AS ANON WITH IOS
              if (Platform.isIOS) {
                print('AUTH - Logged in as ANON (IOS)');
                return FutureBuilder<IosDeviceInfo>(
                  future: _deviceInfoPlugin.iosInfo,
                  builder: (BuildContext context,
                      AsyncSnapshot<IosDeviceInfo> snapshot) {
                    if (!snapshot.hasData) {
                      return Scaffold(
                        body: Center(
                          child: SpinKitChasingDots(
                            color: Color.fromRGBO(47, 46, 65, 1),
                            size: 90.0,
                          ),
                        ),
                      );
                    } else {
                      final iosDeviceInfo = snapshot.data;
                      return Provider<Database>(
                        create: (_) => FirestoreDatabase(
                          uid: user.uid,
                          did: iosDeviceInfo.identifierForVendor,
                        ),
                        child: HomePage(
                          uid: user.uid,
                          did: iosDeviceInfo.identifierForVendor,
                        ),
                      );
                    }
                  },
                );
              } else {
                // LOGGED IN AS ANON WITH ANDROID
                print('AUTH - Logged in as ANON (Android)');
                return FutureBuilder<AndroidDeviceInfo>(
                  future: _deviceInfoPlugin.androidInfo,
                  builder: (BuildContext context,
                      AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                    if (!snapshot.hasData) {
                      return Scaffold(
                        body: Center(
                          child: SpinKitChasingDots(
                            color: Color.fromRGBO(47, 46, 65, 1),
                            size: 90.0,
                          ),
                        ),
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
              }
            } else {
              if (socialProviders.contains(user.provider)) {
                // LOGGED IN WITH GOOGLE/FACEBOOK
                print(
                    'AUTH - Logged in with social provider (${user.provider})');
                return Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  child: HomePage(uid: user.uid, email: user.email),
                );
              } else {
                if (user.isVerified) {
                  // LOGGED WITH EMAIL
                  print('AUTH - Logged in with verified email');
                  return Provider<Database>(
                    create: (_) => FirestoreDatabase(uid: user.uid),
                    child: HomePage(uid: user.uid, email: user.email),
                  );
                } else {
                  // TRIED TO LOGGED IN WITH UNVERIFIED EMAIL
                  print('AUTH - Tried to logged in with unverified email');
                  _signOut(context);
                  return SignInPage.create(context);
                }
              }
            }
          }
        } else {
          return Scaffold(
            body: Center(
              child: SpinKitChasingDots(
                color: Color.fromRGBO(47, 46, 65, 1),
                size: 90.0,
              ),
            ),
          );
        }
      },
    );
  }
}
