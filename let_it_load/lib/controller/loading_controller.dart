import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController anicontroller;

  final LoadingPoint controller = Get.put(LoadingPoint());

  @override
  void onInit() {
    super.onInit();
    anicontroller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: controller.pointPerSecondAnimation.value,
      ),
    )..repeat();
  }
}

class LoadingPoint extends GetxController {
  var point = 0.0.obs;

  /////////////////////////////////////////////////
  var pointMultiplyer = 1.0.obs;
  var pointMultiplyerPrice = 20.0.obs;
  var pointMultiplyerBuyable = false.obs;
  var pointMultiplyerAmount = 1.obs;

  /////////////////////////////////////////////////
  var speedUpBuyable = false.obs;
  var speedUpPrice = 50.00.obs;
  var pointPerSecond = 1000.obs;
  var pointPerSecondAnimation = 2000.obs;
  var speedUpAmount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pointUp();
  }

  Future<void> pointUp() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: pointPerSecond.value));
      point.value += 1.0 * pointMultiplyer.value;
    }
  }

  void buyPointMultiplyer() {
    if (point.value >= pointMultiplyerPrice.value) {
      pointMultiplyerBuyable.value = true;
      point.value -= pointMultiplyerPrice.value;
      pointMultiplyerAmount.value += 1;

      pointMultiplyer.value += 1.0;

      double scale = 1.5 - (0.05 * (pointMultiplyer.value - 1));
      scale = scale.clamp(1.1, 1.5);
      double spike = Random().nextDouble() * 0.5 + 1.0;
      pointMultiplyerPrice.value *= spike;

      pointMultiplyerPrice.value *= scale;
      pointMultiplyerPrice.value = double.parse(
        pointMultiplyerPrice.value.toStringAsFixed(2),
      );
    } else {
      pointMultiplyerBuyable.value = false;
    }
  }

  void buySpeedUP() {
    if (point.value >= speedUpPrice.value) {
      speedUpBuyable.value = true;
      point.value -= speedUpPrice.value;

      pointPerSecond.value -= 2;
      pointPerSecondAnimation.value -= 4;

      double spike = Random().nextDouble() * 0.5 + 1.0;
      speedUpPrice.value *= spike;

      speedUpPrice.value = double.parse(speedUpPrice.value.toStringAsFixed(2));
    }
  }
}
