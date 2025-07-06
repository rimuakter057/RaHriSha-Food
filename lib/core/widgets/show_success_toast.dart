import 'package:flutter/material.dart';

void showSuccessToast({

  required BuildContext context,
  required IconData icon,
  required String title,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,size: 48,color: Colors.green,),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

          ],
        ),
      ),
    ),
  );
}
