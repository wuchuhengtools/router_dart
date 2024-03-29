import 'package:flutter/cupertino.dart';

import '../wuchuheng_router.dart';

class AppRouteInformationParser extends RouteInformationParser<WuchuhengRouter> {
  final WuchuhengRouter appRoutePath;

  AppRouteInformationParser(this.appRoutePath);

  /// app首次启动时，解析浏览器的url
  @override
  Future<WuchuhengRouter> parseRouteInformation(RouteInformation routeInformation) async {
    String location = routeInformation.location!;
    // 应用已经启动，正进行路由跳转
    if (appRoutePath.currentPage != null) {
      // appRoutePath.setJumpRoute(location);
    }
    // 首次通过路由进入应用
    appRoutePath.setPageByPath(location);

    return appRoutePath;
  }

  @override
  RouteInformation restoreRouteInformation(WuchuhengRouter path) {
    String location = appRoutePath.currentPage!.path;
    return RouteInformation(location: location);
  }
}
