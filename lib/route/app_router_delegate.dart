import 'package:flutter/material.dart';

import '../wuchuheng_router.dart';
import 'route_abstract.dart';

class AppRouterDelegate extends RouterDelegate<WuchuhengRouter>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<WuchuhengRouter> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  Map<num, String> pageTrackIndexMapRoute = {};

  List<Page<dynamic>> pageTrack = [];
  RoutePageInfo? pushPageInfo;

  /// 替换当前最新的页面
  RoutePageInfo? replaceCurrentPageInfo;

  final WuchuhengRouter appRoutePath;

  Future<RoutePageInfo> Function(RoutePageInfo pageInfo)? before;

  AppRouterDelegate(this.appRoutePath, this.before) : navigatorKey = GlobalKey<NavigatorState>() {
    appRoutePath.registerPushCallback((RoutePageInfo pageInfo) {
      pushPageInfo = pageInfo;
      notifyListeners();
    });
  }

  @override
  WuchuhengRouter get currentConfiguration {
    return appRoutePath;
  }

  /// 入栈并登记页面的路由
  registerTrackIndex(RoutePageInfo page) {
    pageTrack = [...pageTrack, page.pageFunc()];
    pageTrackIndexMapRoute[pageTrack.length - 1] = page.path;
  }

  bool handlePopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  static Future<RoutePageInfo>? firstTimeBeforeCall;
  static double _callBeforeCount = 0;

  beforeCallback() {
    return FutureBuilder(
      future: firstTimeBeforeCall,
      builder: (BuildContext context, AsyncSnapshot<RoutePageInfo> snapshot) {
        appRoutePath.loadingHook.set(snapshot.connectionState == ConnectionState.done);
        if (snapshot.connectionState == ConnectionState.done) {
          replaceCurrentPageInfo = snapshot.data;
          return build2(context);
        } else {
          if (_callBeforeCount < 2) {
            _callBeforeCount++;
            return appRoutePath.initLoadingPage;
          } else {
            return Navigator(
              key: navigatorKey,
              pages: pageTrack,
              onPopPage: handlePopPage,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (pageTrack.isEmpty) {
      var defaultPage = appRoutePath.currentPage!;
      registerTrackIndex(defaultPage);
    }
    // 入栈新路由
    if (pushPageInfo != null) {
      registerTrackIndex(pushPageInfo!);
      pushPageInfo = null;
    }
    // 回调路由守卫
    if (before != null) {
      String currentRoute = pageTrackIndexMapRoute[pageTrack.length - 1]!;
      firstTimeBeforeCall = before!(appRoutePath.getRoutePageByRoute(currentRoute));
      return beforeCallback();
    }
    return build2(context);
  }

  Widget build2(BuildContext context) {
    // 通过AppRoute before hook更换当前最新的页面
    if (replaceCurrentPageInfo != null) {
      pageTrack.removeLast();
      registerTrackIndex(replaceCurrentPageInfo!);
      replaceCurrentPageInfo = null;
    }
    // 浏览器url跳转处理
    if (appRoutePath.getJumpRoute() != null) {
      String jumpRoute = appRoutePath.getJumpRoute()!;
      var currentPageIndex = pageTrack.length - 1;
      var currentRoute = pageTrackIndexMapRoute[currentPageIndex];
      pushNewRoute(String route) {
        final newPage = appRoutePath.getRoutePageByRoute(route);
        registerTrackIndex(newPage);
      }

      // 大于路栈大于1，则当前的系统提供的url可能是回退或前进
      if (pageTrack.length > 1) {
        String preRoute = pageTrackIndexMapRoute[pageTrack.length - 2]!;
        // 判定为回退操作路由
        if (preRoute == currentRoute) {
          pageTrack = pageTrack.sublist(0, preRoute.length - 2);
        } else {
          pushNewRoute(jumpRoute);
        }
        // 即不是前进或后退，又不是一样的路由，那主判定新页面路由
      } else if (currentRoute != jumpRoute) {
        pushNewRoute(jumpRoute);
      }
      appRoutePath.cleanJumpRoute();
    }

    return Navigator(
      key: navigatorKey,
      pages: pageTrack,
      onPopPage: handlePopPage,
    );
  }

  // 系统路由改变回调，如浏览器url改变
  @override
  Future<void> setNewRoutePath(WuchuhengRouter path) async {
    print(path);
    return;
  }
}
