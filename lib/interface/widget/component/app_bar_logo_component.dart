import 'package:flutter/material.dart';

class AppBarLogoComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarLogoComponent({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Seed',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                color: Color.fromARGB(255, 64, 104, 25),
              ),
            ),
            TextSpan(
              text: ' By ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                color: Color.fromARGB(255, 94, 55, 31),
              ),
            ),
            TextSpan(
              text: 'Seed',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                color: Color.fromARGB(255, 34, 167, 195),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
