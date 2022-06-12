library easy_router;

import 'package:easy_router/route/route_abstract.dart';
import 'package:flutter/material.dart';

import 'pages/unknown_page.dart';
import 'route/app_route_information_parser.dart';
import 'route/app_router_delegate.dart';

class EasyRoute extends RouteAbstract {
  @override
  Map<String, PageFuncType> routes;

  EasyRoute(this.routes);

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

  /// 注册声明匹配的路由
  RoutePageInfo registerUnknownPage =
      RoutePageInfo('/404', () => UnknownPage());

  @override
  RoutePageInfo createUnknownPage() {
    return registerUnknownPage;
  }

  void setPageByLocation(String location) {
    currentPage = routes.containsKey(location)
        ? RoutePageInfo(location, routes[location]!)
        : createUnknownPage();
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

  RoutePageInfo Function(RoutePageInfo pageInfo)? before;

  /// 构建路由route
  Widget build(BuildContext context, String title) {
    print("build");
    return MaterialApp.router(
      title: title,
      routerDelegate: AppRouterDelegate(this, before),
      routeInformationParser: AppRouteInformationParser(this),
    );
  }
}
