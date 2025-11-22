import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'pages/index_page.dart';
import 'pages/camera_page.dart';
import 'pages/processing_page.dart';
import 'pages/results_page.dart';
import 'pages/records_page.dart';
import 'pages/show_records_page.dart';
import 'pages/profile_page.dart';
import 'pages/upload_page.dart';

void main() {
  runApp(const FaceMarkApp());
}

class FaceMarkApp extends StatelessWidget {
  const FaceMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FaceMark AI - Smart Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A4FB8),
        scaffoldBackgroundColor: const Color(0xFFF7F9FB),
        fontFamily: 'System',
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const IndexPage(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraPage(),
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) => const UploadPage(),
    ),
    GoRoute(
      path: '/processing',
      builder: (context, state) => const ProcessingPage(),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => const ResultsPage(),
    ),
    GoRoute(
      path: '/records',
      builder: (context, state) => const RecordsPage(),
    ),
    GoRoute(
      path: '/show-records',
      builder: (context, state) => const ShowRecordsPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
