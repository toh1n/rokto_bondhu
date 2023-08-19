import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';

class MyButton extends StatelessWidget {
  final bool visible;
  final VoidCallback voidCallback;
  final String text;
  const MyButton({super.key, required this.visible,required this.voidCallback, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        width: double.infinity,
        child: Visibility(
          visible: visible == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.red,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(16),
              elevation: 5
            ),
              onPressed: voidCallback,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ),
        ),
      ),
    );
  }
}