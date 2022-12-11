import 'package:flutter/material.dart';

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key? key,
    required this.alive,
    required this.child,
  }) : super(key: key);
  final bool alive;
  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => widget.alive;
}
