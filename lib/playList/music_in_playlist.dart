import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mixpod/functions/functions.dart';
import 'package:mixpod/model/box_class.dart';
import 'package:mixpod/playList/add_song_in_playlist.dart';
import 'package:mixpod/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../open audio/openaudio.dart';

class InsideList extends StatefulWidget {
  String playlistName;

  InsideList({Key? key, required this.playlistName}) : super(key: key);

  @override
  State<InsideList> createState() => _InsideListState();
}

class _InsideListState extends State<InsideList> {
  final box = Boxes.getinstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
        backgroundColor: Colors.grey.shade200,
        elevation: 5,
        title: GradientText(widget.playlistName,
            style: const TextStyle(
                fontFamily: "poppinz",
                fontSize: 18,
                fontWeight: FontWeight.w500),
            colors: const [
              Color(0xffdd0021),
              Color(0xff2b2b29),
            ]),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.grey.shade300,
                    context: context,
                    builder: (context) {
                      return songadd(
                        playlistName: widget.playlistName,
                      );
                    });
              },
              icon: const Icon(
                Icons.playlist_add,
                color: Color(0xff2b2b29),
                size: 30,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, boxes, _) {
                    final playlistSongs = box.get(widget.playlistName)!;
                    return playlistSongs.isEmpty
                        ? SizedBox(
                            child: Center(
                              child: GradientText("No Songs Here",
                                  style: const TextStyle(
                                      fontFamily: "poppinz",
                                      fontSize: 13,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500),
                                  colors: const [
                                    Color(0xffdd0021),
                                    Color(0xff2b2b29),
                                  ]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: playlistSongs.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                for (var element in playlistSongs) {
                                  playlistsplay.add(Audio.file(element.uri!,
                                      metas: Metas(
                                        title: element.title,
                                        id: element.id.toString(),
                                        artist: element.artist,
                                      )));
                                }

                                PlayMyAudio(
                                        allsongs: playlistsplay, index: index)
                                    .openAsset(
                                        index: index, audios: playlistsplay);

                                showBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    backgroundColor:
                                        Colors.blueGrey.withOpacity(0.8),
                                    context: context,
                                    builder: (ctx) => MiniPlayer(
                                          index: index,
                                          audiosongs: playlistsplay,
                                        ));
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QueryArtworkWidget(
                                    id: playlistSongs[index].id!,
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(15),
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      height: 47,
                                      width: 47,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/ArtMusicMen.jpg.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  playlistSongs[index].title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "poppinz",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Color(0xff2b2b29),
                                  ),
                                ),
                                subtitle: Text(
                                  playlistSongs[index].artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "poppinz",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff2b2b29),
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      playlistSongs.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                        "Removed From Playlist",
                                        style: TextStyle(
                                          fontFamily: "poppinz",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: const Color(0xffdd0021),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xffdd0021),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
