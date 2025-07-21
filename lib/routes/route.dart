
import 'package:auto_route/auto_route.dart';
import 'package:tezda_task/screens/splash_screen.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  // RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute, initial: true),
  ];
}