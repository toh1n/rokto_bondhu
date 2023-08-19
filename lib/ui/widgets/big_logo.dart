import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';

class BigLogo extends StatelessWidget {
  const BigLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Text(
        "Rokto Bondhu" ,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * .1,
            fontWeight: FontWeight.bold,
          color: ColorManager.red
        ),
      ),
    );
  }
}
