// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:mixpod/screens/nowplay.dart';
// import 'package:mixpod/widgets/drawer.dart';

// import 'package:on_audio_query/on_audio_query.dart';

// import '../functions/functions.dart';

// import '../open audio/openaudio.dart';

// class ScreenFavourite extends StatefulWidget {
//   const ScreenFavourite({Key? key}) : super(key: key);

//   @override
//   State<ScreenFavourite> createState() => _ScreenFavouriteState();
// }

// class _ScreenFavouriteState extends State<ScreenFavourite> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff091127),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff091127),
//         title: const Text('Favourites'),
//         centerTitle: true,
//         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
//       ),
//       drawer: ScreenDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: ValueListenableBuilder(
//             valueListenable: box.listenable(),
//             builder: (context, Boxes, _) {
//               final likedsongs = box.get("favorites");
//               if (likedsongs == null || likedsongs.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No Favourites',
//                     style: TextStyle(
//                         fontFamily: "poppinz",
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white),
//                   ),
//                 );
//               } else {
//                 return ListView.builder(
//                   itemBuilder: (context, index) => GestureDetector(
//                     onTap: () {
//                       for (var element in likedsongs) {
//                         PlayLikedSong.add(
//                           Audio.file(
//                             element.uri!,
//                             metas: Metas(
//                               title: element.title,
//                               id: element.id.toString(),
//                               artist: element.artist,
//                             ),
//                           ),
//                         );
//                       }
//                       PlayMyAudio(allsongs: PlayLikedSong, index: index)
//                           .openAsset(index: index, audios: PlayLikedSong);

//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ScreenNowplay(
//                                     index: index,
//                                     myaudiosong: PlayLikedSong,
//                                   )));
//                     },
//                     child: ListTile(
//                       leading: QueryArtworkWidget(
//                           id: likedsongs[index].id,
//                           type: ArtworkType.AUDIO,
//                           nullArtworkWidget: ClipOval(
//                             child: Image.asset(
//                               'assets/ArtMusicMen.jpg.jpg',
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.cover,
//                             ),
//                           )),
//                       trailing: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             likedsongs.removeAt(index);
//                             box.put("favorites", likedsongs);
//                           });
//                         },
//                         icon: const Icon(Icons.close, color: Colors.white),
//                       ),
//                       title: Text(
//                         likedsongs[index].title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         likedsongs[index].artist == '<unknown>'
//                             ? 'unknown Artist'
//                             : likedsongs[index].artist,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   itemCount: likedsongs.length,
//                 );
//               }
//             }),
//       ),
//     );
//   }
// }
