import 'package:flutter/cupertino.dart';

import '../hi_router.dart';

class AppRouteInformationParser extends RouteInformationParser<HiRouter> {
  final HiRouter appRoutePath;

  AppRouteInformationParser(this.appRoutePath);

  /// app首次启动时，解析浏览器的url
  @override
  Future<HiRouter> parseRouteInformation(
      RouteInformation routeInformation) async {
    String location = routeInformation.location!;
    // 应用已经启动，正进行路由跳转
    if (appRoutePath.currentPage != null) {
      appRoutePath.setJumpRoute(location);
    }
    // 首次通过路由进入应用
    appRoutePath.setPageByLocation(location);

    return appRoutePath;
  }

  @override
  RouteInformation restoreRouteInformation(HiRouter path) {
    String location = appRoutePath.currentPage!.location;
    return RouteInformation(location: location);
  }
}
