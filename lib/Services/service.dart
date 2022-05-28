import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Model/model.dart';

class DictionaryService {
  final String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  late StreamController _streamController;

 getMeaning({String? word}) async {
    final url = "$_url/$word";
    try {
      final req = await http.get(Uri.parse(url));

      print(req.statusCode);
      if (req.statusCode == 200) {
        print(req.body);
        _streamController.add(jsonDecode(req.body));
      }
    } on SocketException catch (stocket) {
      print("Error: $stocket");
    }
    return _streamController.stream;
  }
}
