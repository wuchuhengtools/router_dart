import 'package:flutter/material.dart';
import 'package:wuchuheng_router/route/route_abstract.dart';
import 'package:wuchuheng_router/wuchuheng_router.dart';

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) => const _HomePage(),
      );
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Text('home page');
}

final WuchuhengRouter route = WuchuhengRouter(
  [
    RoutePageInfo('/', () => HomePage()),
  ],
  before: (RoutePageInfo pageInfo) async => pageInfo,
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return route.build(context, title: 'snotes');
  }
}

void main() async {
  runApp(const App());
}
