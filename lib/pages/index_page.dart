import 'package:flutter/material.dart';
import '../components/top_bar.dart';
import '../components/bottom_nav.dart';
import '../components/dashboard.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(),
      body: Dashboard(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
