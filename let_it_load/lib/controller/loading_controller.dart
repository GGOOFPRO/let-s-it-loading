import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

  void updateAnimationSpeed() {
    anicontroller.duration = Duration(
      milliseconds: controller.pointPerSecondAnimation.value,
    );
    anicontroller
      ..reset()
      ..repeat();
  }
}

class LoadingPoint extends GetxController {
  final box = GetStorage();

  var point = 0.0.obs;
  var pointMultiplyer = 1.0.obs;
  var pointMultiplyerPrice = 20.0.obs;
  var pointMultiplyerAmount = 1.obs;

  var speedUpPrice = 50.0.obs;
  var pointPerSecond = 1000.obs;
  var pointPerSecondAnimation = 2000.obs;

  @override
  void onInit() {
    super.onInit();
    loadProgress();
    pointUp();
  }

  void loadProgress() {
    point.value = box.read('point') ?? 0.0;
    pointMultiplyer.value = box.read('multiplier') ?? 1.0;
    pointMultiplyerAmount.value = pointMultiplyer.value.toInt();
    pointMultiplyerPrice.value = box.read('multiplierPrice') ?? 20.0;
    speedUpPrice.value = box.read('speedUpPrice') ?? 50.0;
    pointPerSecond.value = box.read('pointPerSecond') ?? 1000;
    pointPerSecondAnimation.value = pointPerSecond.value * 2;
  }

  void saveProgress() {
    box.write('point', point.value);
    box.write('multiplier', pointMultiplyer.value);
    box.write('multiplierPrice', pointMultiplyerPrice.value);
    box.write('speedUpPrice', speedUpPrice.value);
    box.write('pointPerSecond', pointPerSecond.value);
  }

  Future<void> pointUp() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: pointPerSecond.value));
      point.value += pointMultiplyer.value;
      saveProgress(); // Auto-save
    }
  }

  void buyPointMultiplyer() {
    if (point.value >= pointMultiplyerPrice.value) {
      point.value -= pointMultiplyerPrice.value;
      pointMultiplyerAmount.value += 1;
      pointMultiplyer.value += 1;

      double scale = 1.5 - (0.05 * (pointMultiplyer.value - 1));
      scale = scale.clamp(1.1, 1.5);
      double spike = Random().nextDouble() * 0.5 + 1.0;
      pointMultiplyerPrice.value *= scale * spike;
      pointMultiplyerPrice.value = double.parse(pointMultiplyerPrice.value.toStringAsFixed(2));

      saveProgress();
    }
  }

  void buySpeedUP() {
    if (point.value >= speedUpPrice.value) {
      point.value -= speedUpPrice.value;

      pointPerSecond.value = max(100, pointPerSecond.value - 2);
      pointPerSecondAnimation.value = max(200, pointPerSecondAnimation.value - 4);

      double spike = Random().nextDouble() * 0.5 + 1.0;
      speedUpPrice.value *= spike;
      speedUpPrice.value = double.parse(speedUpPrice.value.toStringAsFixed(2));

      Get.find<LoadingController>().updateAnimationSpeed();
      saveProgress();
    }
  }
}
