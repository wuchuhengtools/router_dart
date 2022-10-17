import 'package:flutter/cupertino.dart';
import 'package:wuchuheng_router/exceptions/not_found_exception.dart';

typedef PageFuncType = Page<dynamic> Function();

/// 路由页面信息
class RoutePageInfo {
  final String path;
  final PageFuncType pageFunc;

  RoutePageInfo(this.path, this.pageFunc);
}

/// 声明路由方式
abstract class RouteAbstract {
  /// 声明路由
  List<RoutePageInfo> routes = [];

  /// 声明匹配到路由的页面
  RoutePageInfo createUnknownPage();

  /// 获取routes
  List<RoutePageInfo> getRoutes() {
    final RoutePageInfo unknownRoutePage = createUnknownPage();

    return routes;
  }

  /// 通过路由获取页面
  RoutePageInfo getRoutePageByRoute(String path) {
    List<RoutePageInfo> allRoutes = getRoutes();
    for (var element in routes) {
      if (element.path == path) {
        return element;
      }
    }
    throw NotFoundException();
  }
}
