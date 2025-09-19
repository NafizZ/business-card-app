
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/presentation/screens/business_detail_screen.dart';
import 'package:business_card_app/features/business_discovery/presentation/screens/business_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const BusinessListScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final business = state.extra as Business?;
            if (business == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Business not found.'),
                ),
              );
            }
            return BusinessDetailScreen(business: business);
          },
        ),
      ],
    ),
  ],
);
