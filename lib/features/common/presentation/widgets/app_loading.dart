import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showAppLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: Colors.white,
        size: 50,
      ),
    ),
  );
}
