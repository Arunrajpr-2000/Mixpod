import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixpod/screens/home.dart';
import 'package:mixpod/screens/recent.dart';
import 'package:mixpod/screens/settings.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../functions/functions.dart';

class ScreenDrawer extends StatefulWidget {
  const ScreenDrawer({Key? key}) : super(key: key);

  @override
  State<ScreenDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<ScreenDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: double.infinity,
        color: Colors.grey.shade300,
        child: Column(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/172876e3ef491d0bd9e9de1b0ded5233-removebg-preview.png',
                      width: 60,
                      height: 60,
                    ),
                    GradientText("M I X P O D",
                        style: const TextStyle(
                            fontFamily: "poppinz",
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        colors: const [
                          Color(0xffdd0021),
                          Color(0xff2b2b29),
                        ]),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                )),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xff2b2b29),
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: Color(0xff2b2b29)),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx1) => ScreenHome(audiosongs: audiosongs)));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.recent_actors, color: Color(0xff2b2b29)),
              title: const Text(
                'Recents',
                style: TextStyle(color: Color(0xff2b2b29)),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx1) => screenRecent()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xff2b2b29)),
              title: const Text(
                'Settings',
                style: TextStyle(color: Color(0xff2b2b29)),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx1) => const ScreenSettings()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.error,
                color: Color(0xff2b2b29),
              ),
              title: const Text(
                'About',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Column(
                        children: [
                          GradientText("M I X P O D",
                              style: const TextStyle(
                                  fontFamily: "poppinz",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                              colors: const [
                                Color(0xffdd0021),
                                Color(0xff2b2b29),
                              ]),
                          const Text('1.0.0')
                        ],
                      ),
                      content: const Text(
                          'MIXPOD is designed and developed by\n ARUNRAJ'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Color(0xffdd0021),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 4,
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Version',
                    style: TextStyle(color: Color(0xff2b2b29)),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(color: Color(0xff2b2b29)),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
