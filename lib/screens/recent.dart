import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mixpod/open%20audio/openaudio.dart';
import 'package:mixpod/screens/search.dart';
import 'package:mixpod/widgets/drawer.dart';
import 'package:mixpod/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../functions/functions.dart';

class screenRecent extends StatefulWidget {
  screenRecent({Key? key}) : super(key: key);

  @override
  State<screenRecent> createState() => _screenRecentState();
}

class _screenRecentState extends State<screenRecent> {
  List<Audio> recentAudlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
        backgroundColor: Colors.grey.shade200,
        title: GradientText("Recently Played",
            style: const TextStyle(
                fontFamily: "poppinz",
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w500),
            colors: const [
              Color(0xffdd0021),
              Color(0xff2b2b29),
            ]),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: const ScreenDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Boxes, _) {
              final recentsongs = box.get("recent");
              if (recentsongs == recentsongs?.isEmpty) {
                return Center(
                  child: GradientText("No Recents",
                      style: const TextStyle(
                          fontFamily: "poppinz",
                          fontSize: 18,
                          letterSpacing: 1,
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
                            for (var element in recentsongs!) {
                              recentAudlist.add(
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
                            PlayMyAudio(allsongs: recentAudlist, index: index)
                                .openAsset(index: index, audios: recentAudlist);

                            showBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                backgroundColor:
                                    Colors.blueGrey.withOpacity(0.8),
                                context: context,
                                builder: (ctx) => MiniPlayer(
                                      index: index,
                                      audiosongs: recentAudlist,
                                    ));
                          },
                          child: ListTile(
                            leading: QueryArtworkWidget(
                                id: recentsongs![index].id,
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
                                  recentsongs.removeAt(index);
                                  box.put("recent", recentsongs);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                    "Removed From Recents",
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
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Color(0xffdd0021),
                              ),
                            ),
                            title: Text(
                              recentsongs[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff2b2b29),
                              ),
                            ),
                            subtitle: Text(
                              recentsongs[index].artist == '<unknown>'
                                  ? 'unknown Artist'
                                  : recentsongs[index].artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff2b2b29),
                              ),
                            ),
                          ),
                        ),
                    itemCount: recentsongs!.length);
              }
            }),
      ),
    );
  }
}
