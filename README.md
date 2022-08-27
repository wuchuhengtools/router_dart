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
import 'package:wuchuheng_router/wuchuheng_router.dart';
import 'package:wuchuheng_router/route/route_abstract.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return _HomePageState();
      },
    );
  }
}

class _HomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {
                  print("Jump to login page.");
                  RoutePath.getAppPathInstance().push('/login');
                },
                child: Text("login page"),
              ),
            ],
          ),
        ));
  }
}

class LoginPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return _LoginPageState();
      },
    );
  }
}

class _LoginPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text("Login page."),
          TextButton(
              onPressed: () {
                RoutePath.getAppPathInstance().push('/34343');
              },
              child: Text("404"))
        ],
      )),
    );
  }
}

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

class RoutePath {
  static HiRouter? _appRoutePathInstance;

  static HiRouter getAppPathInstance() {
    _appRoutePathInstance ??= HiRouter({
      '/': () => HomePage(),
      '/login': () => LoginPage(),
    });
    // 声明未匹配的到路由时，展示的路由
    _appRoutePathInstance!.registerUnknownPage =
        RoutePageInfo('/404', () => UnknownPage());
    // 路由守卫
    _appRoutePathInstance!.before = (RoutePageInfo pageInfo) async {
      return pageInfo;
    };

    return _appRoutePathInstance!;
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RoutePath.getAppPathInstance().build(context, 'App title.');
  }
}
```

## Additional information
