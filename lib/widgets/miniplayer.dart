import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mixpod/screens/home.dart';
import 'package:mixpod/screens/nowplay.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../functions/functions.dart';

class MiniPlayer extends StatefulWidget {
  int index;
  List<Audio> audiosongs = [];

  MiniPlayer({Key? key, required this.index, required this.audiosongs})
      : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AssetsAudioPlayer assetsaudioplayer = AssetsAudioPlayer.withId('0');
  bool prevvisible = true;
  bool nxtvisible = true;

  bool nextDone = true;
  bool preDone = true;

  buttondesable() {
    if (widget.index == 0) {
      prevvisible = false;
    } else {
      prevvisible = true;
    }

    if (widget.index == audiosongs.length - 1) {
      nxtvisible = false;
    } else {
      nxtvisible = true;
    }
  }

  @override
  void initState() {
    log("message");
    buttondesable();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return assetsaudioplayer.builderCurrent(
        builder: (context, Playing? playing) {
      final myAudio = find(audiosongs, playing!.audio.assetAudioPath);

      return SizedBox(
          height: size.height * 0.12,
          child: ListTile(
            tileColor: const Color(0xff16213E),
            contentPadding: const EdgeInsets.only(bottom: 15, left: 5, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            leading: QueryArtworkWidget(
              id: int.parse(myAudio.metas.id!),
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(30),
              type: ArtworkType.AUDIO,
              nullArtworkWidget: ClipOval(
                child: Image.asset(
                  'assets/ArtMusicMen.jpg.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ScreenNowplay(index: widget.index, myaudiosong: audiosongs),
              ));
            },
            title: Marquee(
              text: myAudio.metas.title.toString(),
              pauseAfterRound: const Duration(seconds: 3),
              velocity: 30,
              blankSpace: 50,
              style: const TextStyle(
                  fontFamily: "poppinz",
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prevvisible
                    ? Visibility(
                        visible: prevvisible,
                        child: IconButton(
                            onPressed: () {
                              setState(() async {
                                widget.index = widget.index + 1;
                                if (widget.index != audiosongs.length - 1) {
                                  nxtvisible = true;
                                }
                                if (preDone) {
                                  preDone = false;
                                  await assetsAudioPlayer.previous();
                                  preDone = true;
                                }

                                // assetsAudioPlayer.previous();
                              });
                              addrecent(index: widget.index);
                            },
                            icon: const Icon(
                              Icons.skip_previous_sharp,
                              color: Colors.white,
                              size: 30,
                            )),
                      )
                    : const SizedBox(
                        width: 30,
                      ),
                PlayerBuilder.isPlaying(
                    player: assetsAudioPlayer,
                    builder: (context, isPlaying) {
                      return GestureDetector(
                        onTap: () async {
                          await assetsAudioPlayer.playOrPause();
                        },
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    }),
                nxtvisible
                    ? Visibility(
                        visible: nxtvisible,
                        child: IconButton(
                            onPressed: () {
                              setState(() async {
                                widget.index = widget.index + 1;
                                if (widget.index > 0) {
                                  prevvisible = true;
                                }
                                if (nextDone) {
                                  nextDone = false;
                                  await assetsAudioPlayer.next();
                                  nextDone = true;
                                }
                                // assetsAudioPlayer.next();
                              });
                              addrecent(index: widget.index);
                            },
                            icon: const Icon(
                              Icons.skip_next_sharp,
                              color: Colors.white,
                              size: 30,
                            )),
                      )
                    : const SizedBox(
                        width: 30,
                      )
              ],
            ),
          ));
    });
  }
}
