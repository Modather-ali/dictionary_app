import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";

  final TextEditingController _controller = TextEditingController();

  AudioPlayer? audioPlayer;

  Future _search() async {
    http.Response response = await http.get(
      Uri.parse(_url + _controller.text.trim()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  void playAudio(String music) {
    audioPlayer!.stop();

    audioPlayer!.play(music);
  }

  @override
  void initState() {
    setState(() {
      audioPlayer = AudioPlayer();
    });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            color: Colors.green,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search Word ",
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.green.shade800,
                      ),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          setState(() {});
                        }
                      }),
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: _search(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                      color: Colors.black,
                      indent: 15,
                      endIndent: 15,
                    ),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return ListTile(
                          title: Text(
                              "${data["word"]}  ${data["phonetics"][index]["text"]}"),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data["meanings"]![0]["definitions"][0]
                                      ["definition"]
                                  .toString()),
                              const SizedBox(
                                height: 7,
                              ),
                              if (data["meanings"]![0]["definitions"][0]
                                      ["example"] !=
                                  null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "example",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(data["meanings"]![0]["definitions"][0]
                                            ["example"]
                                        .toString()),
                                  ],
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              final path =
                                  data["phonetics"][index]["audio"].toString();

                              playAudio(path);
                            },
                            icon: const Icon(Icons.hearing),
                          ));
                    },
                  );
                } else {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text('Search for something'),
                  ));
                }
              })
        ],
      ),
    );
  }
}
