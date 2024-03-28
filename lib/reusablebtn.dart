import 'package:flutter/material.dart';

class ResuableButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  const ResuableButton({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.purple,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
