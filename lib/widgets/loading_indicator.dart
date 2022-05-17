import 'package:flutter/material.dart';
import 'package:laboratoire_app/utilities/color.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(iconsColor),
        ),
        height: 20.0,
        width: 20.0,
      ),
    );
  }
}
