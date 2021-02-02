import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

Widget progress({max, current}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
    child: StepProgressIndicator(
      totalSteps: max,
      currentStep: current,
      padding: 0,
      roundedEdges: Radius.circular(10),
      size: 3,
      selectedColor: Colors.green,
      unselectedColor: bgColorLight,
    ),
  );
}
