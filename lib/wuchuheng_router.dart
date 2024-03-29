library wuchuheng_router;

import 'package:flutter/material.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_router/exceptions/not_found_exception.dart';
import 'package:wuchuheng_router/pages/loading_page.dart';
import 'package:wuchuheng_router/services/custom_material_app.dart';

import 'route/app_route_information_parser.dart';
import 'route/app_router_delegate.dart';
import 'route/route_abstract.dart';

export 'package:wuchuheng_router/route/route_abstract.dart';

class WuchuhengRouter extends RouteAbstract {
  @override
  List<RoutePageInfo> routes;

  @override
  Hook<bool> loadingHook = Hook(false);

  // 加载页面
  Future<RoutePageInfo> Function(RoutePageInfo pageInfo)? before;

  late AppRouterDelegate appRouterDelegate;
  final Widget initLoadingPage;

  WuchuhengRouter(
    this.routes, {
    this.before,
    this.initLoadingPage = const LoadingPage(),
  }) {
    appRouterDelegate = AppRouterDelegate(this, before);
  }

  RoutePageInfo? currentPage;
  late Function(RoutePageInfo pageInfo) _pushPageInfoCallback;

  /// 要跳转的路由
  String? _jumpRoute;

  void setJumpRoute(String newJumpRoute) {
    _jumpRoute = newJumpRoute;
  }

  void cleanJumpRoute() {
    _jumpRoute = null;
  }

  String? getJumpRoute() {
    if (_jumpRoute != null) {
      return _jumpRoute;
    }
    return null;
  }

  void setPageByPath(String path) {
    for (var element in routes) {
      if (element.path == path) {
        currentPage = element;
        return;
      }
    }
    throw NotFoundException();
  }

  /// 注册路由导航回调
  void registerPushCallback(Null Function(RoutePageInfo pageInfo) callback) {
    _pushPageInfoCallback = callback;
  }

  /// 路由跳转
  void push(String route) {
    RoutePageInfo pageInfo = getRoutePageByRoute(route);
    currentPage = pageInfo;
    _pushPageInfoCallback(pageInfo);
  }

  /// 路由回跳
  Future<void> pop(BuildContext context) async {
    appRouterDelegate.pageTrack.removeLast();
    String currentRoute = appRouterDelegate.pageTrackIndexMapRoute[appRouterDelegate.pageTrack.length - 1]!;
    var currentPage = appRouterDelegate.appRoutePath.getRoutePageByRoute(currentRoute);
    // 处理返回hook的返回页面是否与当前页面不同，不同则进行替换
    if (before != null) {
      final newPage = await before!(currentPage);
      if (newPage.path == currentPage.path) {
        appRouterDelegate.appRoutePath.currentPage = currentPage;
      } else {
        appRouterDelegate.appRoutePath.currentPage = newPage;
        appRouterDelegate.replaceCurrentPageInfo = newPage;
      }
    } else {
      appRouterDelegate.appRoutePath.currentPage = currentPage;
    }
    Navigator.pop(context);
  }

  /// 构建路由route
  Widget build(
    BuildContext context, {
    required String title,
    ThemeData? theme,
    TransitionBuilder? builder,
    List<NavigatorObserver>? navigatorObservers,
    bool debugShowCheckedModeBanner = false,
  }) {
    appRouterDelegate = AppRouterDelegate(this, before);
    final MaterialApp res = CustomerMaterialApp.router(
      builder: builder,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      title: title,
      theme: theme,
      routerDelegate: appRouterDelegate,
      routeInformationParser: AppRouteInformationParser(this),
      navigatorObservers: navigatorObservers,
    );

    return res;
  }
}
