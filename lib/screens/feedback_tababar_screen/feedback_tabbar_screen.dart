import 'package:flutter/material.dart';

class FeedbackTabbar extends StatefulWidget {
  const FeedbackTabbar({Key? key}) : super(key: key);

  @override
  State<FeedbackTabbar> createState() => _FeedbackTabbarState();
}

class _FeedbackTabbarState extends State<FeedbackTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.flight)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_car)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: const [
            Icon(Icons.flight, size: 350),
            Icon(Icons.directions_transit, size: 350),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }
}
