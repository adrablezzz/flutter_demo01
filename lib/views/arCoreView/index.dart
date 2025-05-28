import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';


class ARCoreView extends StatefulWidget {
  const ARCoreView({super.key});

  @override
  State<ARCoreView> createState() => _ARCoreViewState();
}

class _ARCoreViewState extends State<ARCoreView> {
  late ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // 创建一个红色立方体
    final material = ArCoreMaterial(color: Color.fromRGBO(255, 0, 0, 1));
    final cube = ArCoreCube(
      materials: [material],
      size: Vector3(0.2, 0.2, 0.2),
    );

    // 将立方体放在屏幕正前方大约0.5米处
    final node = ArCoreNode(
      shape: cube,
      position: Vector3(0, 0, -0.5),
    );

    arCoreController.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ARCore Flutter Plugin Demo')),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
