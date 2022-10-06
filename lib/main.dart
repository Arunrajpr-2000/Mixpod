import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mixpod/model/box_class.dart';
import 'package:mixpod/model/hivemodel.dart';
import 'package:mixpod/screens/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocalSongsAdapter());
  await Hive.openBox<List>(boxname);
  final box = Boxes.getinstance();

  List? favoritekeys1 = box.keys.toList();
  if (!favoritekeys1.contains('favorites')) {
    List<dynamic> favoritelist = [];
    box.put('favorites', favoritelist);
  }

  List? recentkeys1 = box.keys.toList();
  if (!recentkeys1.contains('favorites')) {
    List<dynamic> recentlist = [];
    box.put('recent', recentlist);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M I X P O D',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
    );
  }
}
