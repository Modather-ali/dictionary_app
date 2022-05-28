import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:your_dictionary/Model/model.dart';

import '../Services/service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  // final String _url = "https://owlbot.info/api/v4/dictionary/";
  // final String _token = "48ac18c3b240234630a16a8920e8be34804e2f65";

  final String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  // final String _url = "https://libretranslate.com/?source=en&target=ar&q=";
  // final String _url = "https://translate.terraprint.co/?source=en&target=ar&q=";

  late StreamController _streamController;
  late Stream _stream;
  final TextEditingController _controller = TextEditingController();

  DictionaryModel _dictionaryModel = DictionaryModel();
  final DictionaryService _dictionaryService = DictionaryService();
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
      // print(response);
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
                        await _search();
                      }),
                ),
                onChanged: (text) async {
                  await _search();
                  // _dictionaryService.getMeaning(word: _controller.text);
                },
              ),
            ),
          ),
          StreamBuilder(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("Enter a word"),
                );
              }
              _dictionaryModel = snapshot.data!;

              print("DATA: ${snapshot.data}");

              return ListBody(
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: ListTile(
                      title: Text(
                        _dictionaryModel.origin.toString(),
                      ),
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
