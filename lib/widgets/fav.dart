import 'package:flutter/material.dart';

class FavWidget extends StatefulWidget {
  const FavWidget({Key? key}) : super(key: key);

  @override
  State<FavWidget> createState() => _FavWidgetState();
}

class _FavWidgetState extends State<FavWidget> {
  bool _isfavorite = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: fav,
        icon: (_isfavorite
            ? const Icon(
                Icons.favorite_border_sharp,
                color: Colors.white,
                size: 30,
              )
            : const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              )));
  }

  void fav() {
    setState(() {
      if (_isfavorite) {
        _isfavorite = false;
      } else {
        _isfavorite = true;
      }
    });
  }
}
