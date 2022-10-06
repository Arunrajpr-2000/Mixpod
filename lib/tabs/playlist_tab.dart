import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mixpod/functions/functions.dart';
import 'package:mixpod/model/hivemodel.dart';
import 'package:mixpod/playList/music_in_playlist.dart';
import 'package:mixpod/widgets/edit_playlist.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Playlist_tab extends StatefulWidget {
  Playlist_tab({Key? key}) : super(key: key);

  @override
  State<Playlist_tab> createState() => _Playlist_tabState();
}

class _Playlist_tabState extends State<Playlist_tab> {
  late TextEditingController controller;

  String? title;
  final formkey = GlobalKey<FormState>();

  final existingPlaylist = SnackBar(
    content: const Text(
      "Playlist name already exist",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: const Color(0xffdd0021),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.grey.withOpacity(0.5),
              title: const Text(
                ' Create New Playlists',
                style: TextStyle(
                    fontFamily: "poppinz",
                    color: Color(0xff2b2b29),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              leading: const Icon(
                Icons.add,
                color: Color(0xff2b2b29),
                size: 30,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return Dialog(
                        backgroundColor: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: SizedBox(
                            width: 300,
                            height: 165,
                            child: Column(
                              children: [
                                Form(
                                  key: formkey,
                                  child: TextFormField(
                                    controller: controller,
                                    style: const TextStyle(
                                      color: Color(0xff2b2b29),
                                    ),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Create a Playlist',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff2b2b29),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      title = value.trim();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            submit();
                                          },
                                          child: const Text(
                                            'Create',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          const SizedBox(
            height: 27,
          ),
          ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, boxes, _) {
                playlists = box.keys.toList();

                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InsideList(
                                      playlistName: playlists[index],
                                    )),
                          );
                        },
                        child: playlists[index] != "musics" &&
                                playlists[index] != "favorites" &&
                                playlists[index] != "recent"
                            ? libraryList(
                                child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3, bottom: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.grey.withOpacity(0.5),
                                leading: const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                    'assets/Dynamic-Palette-Knife-Portraits-Beautifully-Balance-Order-with-Chaos_1.png',
                                  ),
                                ),
                                title: GradientText(playlists[index].toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: "poppinz",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    colors: const [
                                      Color(0xffdd0021),
                                      Color(0xff2b2b29),
                                    ]),
                                subtitle: Text(
                                  '${listLength(listName: playlists[index]).toString()} Songs',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Color(0xff2b2b29),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return editplaylist(
                                                  playlistNameForEdit:
                                                      playlists[index],
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Color(0xff2b2b29),
                                        )),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color(0xffdd0021),
                                        ),
                                        onPressed: () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                title: const Text(
                                                    'Do you want to delete'),
                                                content: const Text(
                                                    'It will be deleted from your Playlist'),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    onPressed: () {
                                                      box.delete(
                                                          playlists[index]);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: const Text(
                                                          "Deleted Successfully",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
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

                                                      setState(() {
                                                        playlists =
                                                            box.keys.toList();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffdd0021),
                                                      ),
                                                    ),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffdd0021),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                  ],
                                ),
                              ))
                            : Container()));
              }),
        ],
      ),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
      child: child,
    );
  }

  void submit() {
    playlistName = controller.text;
    List<LocalSongs> librayry = [];
    List? excistingName = [];
    if (playlists.isNotEmpty) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' &&
        excistingName.isEmpty &&
        formkey.currentState!.validate()) {
      box.put(playlistName, librayry);
      Navigator.of(context).pop();
      setState(() {
        playlists = box.keys.toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(existingPlaylist);
    }

    controller.clear();
  }
}

int listLength({required listName}) {
  final g = box.get(listName)!;
  return g.length;
}
