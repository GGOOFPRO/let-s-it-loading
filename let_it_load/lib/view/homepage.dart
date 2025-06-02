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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              RotationTransition(
                turns: loadingController.anicontroller,
                child: const CircularProgressIndicator(strokeWidth: 6.0),
              ),
              const SizedBox(height: 20),

              // Current Points Display
              Obx(
                () => Text(
                  '${loadingPoint.point.value.toStringAsFixed(1)} Points',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Upgrades Section
              buildUpgradeCard(
                title: 'Point Multiplier',
                valueDisplay: Obx(() => Text(
                  'Level: ${loadingPoint.pointMultiplyerAmount.value}',
                  style: const TextStyle(fontSize: 18),
                )),
                price: loadingPoint.pointMultiplyerPrice,
                onBuy: () {
                  loadingPoint.buyPointMultiplyer();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Point Multiplier Purchased!')),
                  );
                },
                isBuyable: (loadingPoint.point.value >= loadingPoint.pointMultiplyerPrice.value).obs,
              ),

              const SizedBox(height: 20),

              buildUpgradeCard(
                title: 'Speed Upgrade',
                valueDisplay: Obx(() => Text(
                  'Interval: ${loadingPoint.pointPerSecond.value.toStringAsFixed(0)} ms',
                  style: const TextStyle(fontSize: 18),
                )),
                price: loadingPoint.speedUpPrice,
                onBuy: () {
                  loadingPoint.buySpeedUP();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Speed Upgrade Purchased!')),
                  );
                },
                isBuyable: ((loadingPoint.point.value >= loadingPoint.speedUpPrice.value).obs),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUpgradeCard({
    required String title,
    required Widget valueDisplay,
    required RxDouble price,
    required VoidCallback onBuy,
    required RxBool isBuyable,
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            valueDisplay,
            const SizedBox(height: 12),
            FilledButton(
              onPressed: isBuyable.value ? onBuy : null,
              child: Text('Buy for ${price.value.toStringAsFixed(1)}'),
            ),
          ],
        ),
      ),
    );
  }
}
