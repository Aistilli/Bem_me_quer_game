import 'package:go_router/go_router.dart';
import 'models/flower_type.dart';
import 'pages/home_page.dart';
import 'pages/game_page.dart';

/// GoRouter configuration for app navigation
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const HomePage()),
      ),
      GoRoute(
        path: AppRoutes.game,
        name: 'game',
        builder: (context, state) {
          final flowerId = state.uri.queryParameters['flower'];
          final flowerType = FlowerType.values.firstWhere(
            (e) => e.id == flowerId,
            orElse: () => FlowerType.daisy,
          );
          return GamePage(flowerType: flowerType);
        },
      ),
    ],
  );
}

/// Route path constants
class AppRoutes {
  static const String home = '/';
  static const String game = '/game';
}
