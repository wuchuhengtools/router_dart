import 'package:flutter/material.dart';

class UnknownPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const UnknownPageRender();
      },
    );
  }
}

class UnknownPageRender extends StatefulWidget {
  const UnknownPageRender({Key? key}) : super(key: key);

  @override
  State<UnknownPageRender> createState() => _UnknownPageRenderState();
}

class _UnknownPageRenderState extends State<UnknownPageRender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Unknown page.'),
        ));
  }
}
