import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mixpod/widgets/miniplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../functions/functions.dart';

import '../open audio/openaudio.dart';

class Fav_tab extends StatefulWidget {
  const Fav_tab({Key? key}) : super(key: key);

  @override
  State<Fav_tab> createState() => _Fav_tabState();
}

class _Fav_tabState extends State<Fav_tab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Boxes, _) {
            final likedsongs = box.get("favorites");
            if (likedsongs == null || likedsongs.isEmpty) {
              return Center(
                child: GradientText("No Favourites",
                    style: const TextStyle(
                        fontFamily: "poppinz",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    colors: const [
                      Color(0xffdd0021),
                      Color(0xff2b2b29),
                    ]),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    for (var element in likedsongs) {
                      PlayLikedSong.add(
                        Audio.file(
                          element.uri!,
                          metas: Metas(
                            title: element.title,
                            id: element.id.toString(),
                            artist: element.artist,
                          ),
                        ),
                      );
                    }
                    PlayMyAudio(allsongs: PlayLikedSong, index: index)
                        .openAsset(index: index, audios: PlayLikedSong);

                    showBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                        backgroundColor: Colors.blueGrey.withOpacity(0.8),
                        context: context,
                        builder: (ctx) => MiniPlayer(
                              index: index,
                              audiosongs: PlayLikedSong,
                            ));
                  },
                  child: ListTile(
                    leading: QueryArtworkWidget(
                        id: likedsongs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipOval(
                          child: Image.asset(
                            'assets/ArtMusicMen.jpg.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          likedsongs.removeAt(index);
                          box.put("favorites", likedsongs);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                            "Removed From Favourites",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: const Color(0xffdd0021),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      icon: const Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Text(
                      likedsongs[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xff2b2b29),
                          fontFamily: "poppinz",
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      likedsongs[index].artist == '<unknown>'
                          ? 'unknown'
                          : likedsongs[index].artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xff2b2b29),
                          fontFamily: "poppinz",
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                itemCount: likedsongs.length,
              );
            }
          }),
    );
  }
}
