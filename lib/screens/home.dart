import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:mixpod/model/hivemodel.dart';
import 'package:mixpod/playList/add_to_playlist_from_home.dart';
import 'package:mixpod/screens/search.dart';
import 'package:mixpod/tabs/favourite_tab.dart';
import 'package:mixpod/tabs/playlist_tab.dart';
import 'package:mixpod/widgets/drawer.dart';
import 'package:mixpod/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../functions/functions.dart';
import '../open audio/openaudio.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({Key? key, required this.audiosongs}) : super(key: key);
  List<Audio> audiosongs = [];
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Icon myIcon = const Icon(Icons.search);

  List<dynamic>? likedsongs = [];

  List<dynamic>? recentsongsdy = [];
  List<dynamic> recents = [];

  Future<Null> refreshlist() async {
    setState(() {});
    fetchingsongs();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    databasesongs = box.get('musics');
    likedsongs = box.get("favorites");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: ScaffoldGradientBackground(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade300,
            // Color(0xff2b2b29),
            // Color(0xffdd0021),
          ],
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xff2b2b29)),
          backgroundColor: Colors.grey.shade200,
          title: GradientText("MIXPOD",
              style: const TextStyle(
                  fontFamily: "poppinz",
                  fontSize: 20,
                  letterSpacing: 5,
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
                icon: const Icon(
                  Icons.search,
                  color: Color(0xff2b2b29),
                ))
          ],
          bottom: const TabBar(
            indicatorColor: Colors.red,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.favorite, color: Color(0xff2b2b29)),
              ),
              Tab(
                icon: Icon(Icons.home, color: Color(0xff2b2b29)),
              ),
              Tab(
                icon: Icon(Icons.library_music, color: Color(0xff2b2b29)),
              ),
            ],
          ),
        ),
        drawer: const ScreenDrawer(),
        body: TabBarView(
          children: [
            const Fav_tab(),

            // Allsongs_tab---->
            widget.audiosongs.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText("No Songs,Try to Refresh it!!",
                          style: const TextStyle(
                              fontFamily: "poppinz",
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          colors: const [
                            Color(0xffdd0021),
                            Color(0xff2b2b29),
                          ]),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffdd0021),
                        ),
                        onPressed: () {
                          refreshlist();
                        },
                        child: const Text(
                          'Refresh ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "poppinz",
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: refreshlist,
                    color: Colors.red,
                    child: ListView.builder(
                      itemCount: widget.audiosongs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            showBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.blue,
                                context: context,
                                builder: (ctx) => MiniPlayer(
                                      index: index,
                                      audiosongs: audiosongs,
                                    ));

                            PlayMyAudio(
                                    index: index, allsongs: widget.audiosongs)
                                .openAsset(audios: audiosongs, index: index);

                            if (recents.length < 10) {
                              final songs =
                                  box.get("musics") as List<LocalSongs>;
                              final temp = songs.firstWhere((element) =>
                                  element.id.toString() ==
                                  widget.audiosongs[index].metas.id.toString());
                              recents = recentsongsdy!;
                              recents.add(temp);
                              box.put("recent", recents);
                            } else {
                              recents.removeAt(0);
                              box.put("recent", recents);
                            }
                          },
                          title: Text(
                            widget.audiosongs[index].metas.title.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Color(0xff2b2b29),
                                fontFamily: "poppinz",
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            widget.audiosongs[index].metas.artist.toString() ==
                                    '<unknown>'
                                ? 'unknown '
                                : widget.audiosongs[index].metas.artist
                                    .toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Color(0xff2b2b29),
                                fontFamily: "poppinz",
                                fontWeight: FontWeight.w300),
                          ),
                          leading: QueryArtworkWidget(
                            id: int.parse(
                                widget.audiosongs[index].metas.id.toString()),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipOval(
                              child: Image.asset(
                                'assets/ArtMusicMen.jpg.jpg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //Add To PlayList--->
                                              ListTile(
                                                title: GradientText(
                                                    "Add to Playlist",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontFamily: "poppinz",
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    colors: const [
                                                      Color(0xffdd0021),
                                                      Color(0xff2b2b29),
                                                    ]),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          const Color(
                                                              0xffdd0021),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20))),
                                                      context: context,
                                                      builder: (context) =>
                                                          PlaylistNow(
                                                              song: widget
                                                                      .audiosongs[
                                                                  index]));
                                                },
                                              ),
                                              //ADD TO FAVOURITES----->
                                              likedsongs!
                                                      .where((element) =>
                                                          element.id
                                                              .toString() ==
                                                          databasesongs![index]
                                                              .id
                                                              .toString())
                                                      .isEmpty
                                                  ? ListTile(
                                                      title: GradientText(
                                                          "Add to Favourite",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "poppinz",
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          colors: const [
                                                            Color(0xffdd0021),
                                                            Color(0xff2b2b29),
                                                          ]),
                                                      onTap: () async {
                                                        final songs = box
                                                                .get("musics")
                                                            as List<LocalSongs>;
                                                        final temp = songs
                                                            .firstWhere((element) =>
                                                                element.id
                                                                    .toString() ==
                                                                widget
                                                                    .audiosongs[
                                                                        index]
                                                                    .metas
                                                                    .id
                                                                    .toString());
                                                        favorites = likedsongs!;
                                                        favorites.add(temp);
                                                        box.put("favorites",
                                                            favorites);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: const Text(
                                                            "Added to Favourites",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "poppinz",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffdd0021),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ));

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  : ListTile(
                                                      title: GradientText(
                                                          "Remove from Favourites",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "poppinz",
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          colors: const [
                                                            Color(0xffdd0021),
                                                            Color(0xff2b2b29),
                                                          ]),
                                                      onTap: () async {
                                                        likedsongs?.removeWhere(
                                                            (elemet) =>
                                                                elemet.id
                                                                    .toString() ==
                                                                databasesongs![
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                        await box.put(
                                                            "favorites",
                                                            likedsongs!);
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: const Text(
                                                            "Remove from Favourites",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "poppinz",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffdd0021),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ));
                                                      },
                                                    ),
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xff2b2b29),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Playlist_tab(),
          ],
        ),
      ),
    );
  }
}
