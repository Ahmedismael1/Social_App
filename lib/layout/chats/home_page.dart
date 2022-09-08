import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudRecordListView extends StatefulWidget {
  final List<Reference> references;
  const CloudRecordListView({
    Key key,
     this.references,
  }) : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool isPlaying;
   AudioPlayer audioPlayer;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('kkkkkkkkkk'),
            trailing: IconButton(
              icon: selectedIndex == index
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
              onPressed: () => _onListTileButtonPressed(index),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    audioPlayer.play(DeviceFileSource('https://firebasestorage.googleapis.com/v0/b/social-a1f14.appspot.com/o/upload-voice-firebase%2F1661872124806.aac?alt=media&token=a2690a47-eb52-402d-8c8c-90d65cc747e6'));

    audioPlayer.onPlayerComplete.listen((duration) {
      setState(() {
        selectedIndex = -1;
      });
    });
  }
}