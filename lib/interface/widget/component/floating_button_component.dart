import 'package:flutter/material.dart';
import 'package:flutter_seedbyseed/infra/route/routes.dart';

class FloatingButtonLargeComponent extends StatelessWidget {
  const FloatingButtonLargeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () => Navigator.pushNamed(context, PageRoutes.kADD_GERMINATIONTEST),
      child: const Icon(
        Icons.add,
        size: 64,
      ),
    );
  }
}

class FloatingButtonSmallComponent extends StatelessWidget {
  const FloatingButtonSmallComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Iniciar Teste de Germinação",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () {
        Navigator.pushNamed(context, PageRoutes.kADD_GERMINATIONTEST);
      },
      child: const Icon(
        Icons.add,
        size: 36,
      ),
    );
  }
}
