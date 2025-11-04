import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  final double size;
  const LoadingWidget({super.key, this.color = Colors.white, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingAnimationWidget.hexagonDots(color: color, size: size));
  }
}
