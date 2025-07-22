
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:tezda_task/screens/splash_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/profile_screen.dart';

part 'route.gr.dart';
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ProductListRoute.page),
    AutoRoute(page: ProductDetailRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: EditProfileRoute.page)
  ];
}