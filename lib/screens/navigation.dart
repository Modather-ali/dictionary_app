import 'package:flutter/material.dart';

import 'dictionary.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
          ),
          title: const TabBar(tabs: [
            Tab(
              text: "Translator",
            ),
            Tab(
              text: "Your Space",
            ),
          ]),
          centerTitle: true,
          // bottom:
        ),
        body: TabBarView(children: [
          // const TranslatorScreen(),
          const DictionaryScreen(),
          Container(
            color: Colors.red,
          )
        ]),
      ),
    );
  }
}
