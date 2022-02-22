import 'package:flutter/material.dart';

import '../mq.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 4.0),
      ),
    );
  }
}
