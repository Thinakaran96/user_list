import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TextAnimateWidget extends StatelessWidget {
  final String? textValue;
  final WidgetTransitionEffects? effects;
  final WidgetRestingEffects? restingEffects;
  final TextStyle? textStyle;

  const TextAnimateWidget({
    super.key,
    this.textValue,
    this.effects,
    this.restingEffects, this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextAnimator(
      textValue!,
      style:textStyle ,
      incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 1500),
      ),
      atRestEffect:restingEffects,
      outgoingEffect: WidgetTransitionEffects.incomingSlideInFromTop(),
    );
  }
}
