
import 'package:auto_route/auto_route.dart';
import 'package:tezda_task/screens/splash_screen.dart';

part 'route.gr.dart';
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}