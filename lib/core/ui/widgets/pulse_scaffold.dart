import 'package:flutter/material.dart';

class PulseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const PulseScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF242528), Color(0xFF0A0A0B)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
