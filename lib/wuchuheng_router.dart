library wuchuheng_router;

import 'package:flutter/material.dart';
import 'package:wuchuheng_router/pages/loading_page.dart';
import 'package:wuchuheng_router/services/custom_material_app.dart';

import 'pages/unknown_page.dart';
import 'route/app_route_information_parser.dart';
import 'route/app_router_delegate.dart';
import 'route/route_abstract.dart';

class HiRouter extends RouteAbstract {
  @override
  Map<String, PageFuncType> routes;

  HiRouter(this.routes);

  RoutePageInfo? currentPage;
  late Function(RoutePageInfo pageInfo) _pushPageInfoCallback;

  /// 要跳转的路由
  String? _jumpRoute;

  // 加载页面
  Widget loadingPage = const LoadingPage();

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
  RoutePageInfo registerUnknownPage = RoutePageInfo('/404', () => UnknownPage());

  @override
  RoutePageInfo createUnknownPage() {
    return registerUnknownPage;
  }

  void setPageByLocation(String location) {
    currentPage = routes.containsKey(location) ? RoutePageInfo(location, routes[location]!) : createUnknownPage();
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

  Future<RoutePageInfo> Function(RoutePageInfo pageInfo)? before;

  void setLoadingPage(Widget page) {
    loadingPage = page;
  }

  /// 构建路由route
  Widget build(
    BuildContext context, {
    required String title,
    ThemeData? theme,
    TransitionBuilder? builder,
    List<NavigatorObserver>? navigatorObservers,
  }) {
    final MaterialApp res = CustomerMaterialApp.router(
      builder: builder,
      title: title,
      theme: theme,
      routerDelegate: AppRouterDelegate(this, before, loadingPage),
      routeInformationParser: AppRouteInformationParser(this),
      navigatorObservers: navigatorObservers,
    );

    return res;
  }
}
