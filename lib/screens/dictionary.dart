import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  // final String _url = "https://owlbot.info/api/v4/dictionary/";
  // final String _token = "48ac18c3b240234630a16a8920e8be34804e2f65";

  final String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";

  late StreamController _streamController;
  late Stream _stream;
  final TextEditingController _controller = TextEditingController();
  Future _search() async {
    if (_controller.text.isEmpty) {
      _streamController.add(null);
      return;
    }
    _streamController.add("waiting");

    http.Response response = await http.get(
      Uri.parse(_url + _controller.text.trim()),
      // headers: {"Authorization": "Token $_token"}
    );
    if (response.statusCode == 200) {
      _streamController.add(jsonDecode(response.body));
    }
  }

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
            padding: const EdgeInsets.only(top: 20),
            color: Colors.green,
            child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Word Here",
                  hintStyle: const TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  contentPadding: const EdgeInsets.only(left: 48),
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _search();
                      }),
                )),
          ),
          StreamBuilder(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("Enter a word"),
                );
              }

              if (snapshot.data == "waiting") {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              print("DATA: ${snapshot.data}");

              return ListBody(
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: ListTile(
                      title: Text(
                          "${"${_controller.text.trim()}(${snapshot.data[0]["meanings"]![0]["definitions"]![0]["definition"]!}"})"),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
