import 'package:flutter/material.dart';

import 'translator.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
          ),
          title: const Text("My Dictionary"),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              text: "Translator",
            ),
            Tab(
              text: "Your Space",
            ),
          ]),
        ),
        body: TabBarView(children: [
          const TranslatorScreen(),
          Container(
            color: Colors.red,
          )
        ]),
      ),
    );
  }
}
