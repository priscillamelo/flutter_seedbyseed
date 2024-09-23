import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/interface/widget/component/floating_button_component.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const /* Scaffold(
      floatingActionButton: FloatingButtonSmallComponent(),
    ); */

        Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingButtonLargeComponent(),
          SizedBox(
            height: 16,
          ),
          Text("Iniciar Teste de Germinação"),
        ],
      ),
    );
  }
}
