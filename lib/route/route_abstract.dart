import 'package:flutter/cupertino.dart';

typedef PageFuncType = Page<dynamic> Function();

/// 路由页面信息
class RoutePageInfo {
  final String location;
  final PageFuncType pageFunc;

  RoutePageInfo(this.location, this.pageFunc);
}

/// 声明路由方式
abstract class RouteAbstract {
  /// 声明路由
  Map<String, PageFuncType> routes = {};

  /// 声明匹配到路由的页面
  RoutePageInfo createUnknownPage();

  /// 获取routes
  Map<String, PageFuncType> getRoutes() {
    final RoutePageInfo unknownRoutePage = createUnknownPage();
    routes[unknownRoutePage.location] = unknownRoutePage.pageFunc;

    return routes;
  }

  /// 通过路由获取页面
  RoutePageInfo getRoutePageByRoute(String route) {
    Map<String, PageFuncType> allRoutes = getRoutes();
    if (allRoutes.containsKey(route)) {
      return RoutePageInfo(route, () => allRoutes[route]!.call());
    } else {
      return createUnknownPage();
    }
  }
}
