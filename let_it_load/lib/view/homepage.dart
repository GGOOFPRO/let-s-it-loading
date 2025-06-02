import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:let_it_load/controller/loading_controller.dart';

class HomePage extends StatelessWidget {
  final LoadingController loadingController = Get.put(LoadingController());
  final LoadingPoint loadingPoint = Get.put(LoadingPoint());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Let It Load')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: loadingController.anicontroller,
              child: CircularProgressIndicator(strokeWidth: 6.0),
            ),
            SizedBox(height: 20),
            Obx(
              () => Text(
                loadingPoint.point.value.toStringAsFixed(1),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Obx(
              () => Text(
                'Multiplier: ${loadingPoint.pointMultiplyerAmount.value} | Interval: ${loadingPoint.pointPerSecond.value} ms',
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Obx(
                      () => FilledButton(
                        onPressed:
                            loadingPoint.point.value >=
                                    loadingPoint.pointMultiplyerPrice.value
                                ? () {
                                  loadingPoint.buyPointMultiplyer();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Point Multiplier Purchased!',
                                      ),
                                    ),
                                  );
                                }
                                : null,
                        child: Text(
                          'Buy Point Multiplier: ${loadingPoint.pointMultiplyerPrice.value.toStringAsFixed(1)}',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Obx(
                      () => FilledButton(
                        onPressed:
                            loadingPoint.point.value >=
                                    loadingPoint.speedUpPrice.value
                                ? () {
                                  loadingPoint.buySpeedUP();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Point Speed Up Purchased!',
                                      ),
                                    ),
                                  );
                                }
                                : null,
                        child: Text(
                          'Buy Point Multiplier: ${loadingPoint.speedUpPrice.value.toStringAsFixed(1)}',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
