import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';

class FadeInRTLAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInRTLAnimation({this.delay, this.child});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 50), Tween(begin: 0.0, end: 1.0)),
      Track("scale").add(
          Duration(milliseconds: 1000), Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut)
    ]);

    return ControlledAnimation(
      curve: Curves.easeOut,
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Transform.scale(
          scale: animation["scale"],
          child: child,
          ));
  }
}