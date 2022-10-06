import 'package:flutter/material.dart';
import 'package:mixpod/functions/functions.dart';
import 'package:mixpod/model/hivemodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/box_class.dart';

class songadd extends StatefulWidget {
  String playlistName;
  songadd({Key? key, required this.playlistName}) : super(key: key);

  @override
  _buildSheetState createState() => _buildSheetState();
}

class _buildSheetState extends State<songadd> {
  final box = Boxes.getinstance();

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() {
    databaseSong = box.get("musics") as List<LocalSongs>;
    playlistSongmodel = box.get(widget.playlistName)!.cast<LocalSongs>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: ListView.builder(
          itemCount: databaseSong.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: SizedBox(
                  height: 45,
                  width: 45,
                  child: QueryArtworkWidget(
                    id: databaseSong[index].id!,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(15),
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage("assets/ArtMusicMen.jpg.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  databaseSong[index].title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: "poppinz",
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2b2b29),
                      fontSize: 15),
                ),
                trailing: playlistSongmodel
                        .where((element) =>
                            element.id.toString() ==
                            databaseSong[index].id.toString())
                        .isEmpty
                    ? IconButton(
                        onPressed: () async {
                          playlistSongmodel.add(databaseSong[index]);
                          await box.put(widget.playlistName, playlistSongmodel);

                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xff2b2b29),
                        ))
                    : IconButton(
                        onPressed: () async {
                          playlistSongmodel.removeWhere((elemet) =>
                              elemet.id.toString() ==
                              databaseSong[index].id.toString());

                          await box.put(widget.playlistName, playlistSongmodel);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xff2b2b29),
                        )),
              ),
            );
          },
        ));
  }
}
