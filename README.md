## what is wuchuheng_router.

The system's navigator page management and the system's routing are not unified, while easy_router unifies the two, and manages the application interface entirely by way of routing.

## Features

## install 
``` bash
 $ flutter pub add wuchuheng_router
```

# Manage the page by routing.

## Usage

```dart
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
  {
    '/': () => HomePage(),
  },
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
```

## Additional information
