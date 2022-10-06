import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixpod/functions/functions.dart';
import 'package:mixpod/widgets/drawer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

bool temp = true;

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool islight = true;

  static bool toggleNotification({required bool isNotificationOn}) {
    isNotificationOn
        ? assetsAudioPlayer.showNotification = true
        : assetsAudioPlayer.showNotification = false;
    assetsAudioPlayer.showNotification ? temp = true : temp = false;

    return temp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
        backgroundColor: Colors.grey.shade200,
        title: GradientText("Settings",
            style: const TextStyle(
                fontFamily: "poppinz",
                fontSize: 20,
                fontWeight: FontWeight.w500),
            colors: const [
              Color(0xffdd0021),
              Color(0xff2b2b29),
            ]),
        centerTitle: true,
      ),
      drawer: const ScreenDrawer(),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: Color(0xff2b2b29),
            ),
            title: const Text(
              'Notification',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
            trailing: Switch(
                activeColor: const Color(0xffdd0021),
                value: islight,
                onChanged: (value) {
                  bool temp = value;
                  temp = toggleNotification(isNotificationOn: value);
                  setState(() {
                    islight = temp;
                  });
                }),
          ),
          const ListTile(
            leading: Icon(
              Icons.share,
              color: Color(0xff2b2b29),
            ),
            title: Text(
              'Share',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.lock,
              color: Color(0xff2b2b29),
            ),
            title: Text(
              'Privacy policy',
              style: TextStyle(
                color: Color(0xff2b2b29),
              ),
            ),
          ),
          ListTile(
              leading: const Icon(
                Icons.gavel,
                color: Color(0xff2b2b29),
              ),
              title: const Text(
                'Terms & conditions',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const LicensePage(
                    applicationName: 'M I X P O D',
                    applicationVersion: '1.0.0',
                  );
                }));
              }),
          ListTile(
            leading: const Icon(
              Icons.error_outline,
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
                        'MIXPOD is a offline music player created by Arun Raj P R'),
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
          SizedBox(
            height: size.width * 0.5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Version',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              ),
              Text(
                '1.0.0',
                style: TextStyle(
                  color: Color(0xff2b2b29),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
