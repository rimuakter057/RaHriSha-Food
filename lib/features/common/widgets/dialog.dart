import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessDialog({
  required String title,
  required String message,
  IconData icon = Icons.check_circle,
  Color iconColor = Colors.green,
  VoidCallback? onConfirm,
}) {
  Get.dialog(
    Center(
      child: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black54,
  );

  Future.delayed(const Duration(seconds: 1), () {
    if (Get.isDialogOpen == true) {
      Get.back(); // Close the dialog
      if (onConfirm != null) {
        onConfirm(); // Call the callback
      }
    }
  });
}
