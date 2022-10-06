import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mixpod/functions/functions.dart';
import 'package:mixpod/model/hivemodel.dart';
import 'package:mixpod/open%20audio/openaudio.dart';
import 'package:mixpod/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../functions/functions.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<LocalSongs> songsdb = [];
  List<Audio> songall = [];
  String search = '';

  getSongs() {
    songsdb = box.get("musics") as List<LocalSongs>;

    for (var element in songsdb) {
      songall.add(
        Audio.file(
          element.uri.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    }
  }

  Future<String> debounce() async {
    return "Waited 1";
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    List<Audio> searchresult = songall
        .where((element) =>
            element.metas.title!.toLowerCase().startsWith(search.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Container(
              child: TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff2b2b29), width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff2b2b29), width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red[500],
                          )),
                      hintText: 'search a song',
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.white)),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          search.isNotEmpty
              ? searchresult.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: searchresult.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: debounce(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      showBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                          ),
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.8),
                                          context: context,
                                          builder: (ctx) => MiniPlayer(
                                                index: index,
                                                audiosongs: searchresult,
                                              ));
                                      PlayMyAudio(
                                              index: index,
                                              allsongs: searchresult)
                                          .openAsset(
                                              audios: audiosongs, index: index);
                                    },
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
                                          id: int.parse(
                                              searchresult[index].metas.id!),
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: ClipOval(
                                            child: Image.asset(
                                              'assets/ArtMusicMen.jpg.jpg',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      title: Text(
                                        searchresult[index].metas.title!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: "poppinz",
                                            color: Color(0xff2b2b29),
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        searchresult[index].metas.artist!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: "poppinz",
                                            color: Color(0xff2b2b29),
                                            fontSize: 15),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              });
                        },
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(30),
                      child: GradientText("No Result Found",
                          style: const TextStyle(
                              fontFamily: "poppinz",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          colors: const [
                            Color(0xffdd0021),
                            Color(0xff2b2b29),
                          ]),
                    )
              : const SizedBox()
        ],
      )),
    );
  }
}
