import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget? child;

  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || child == null) return child ?? const SizedBox.shrink();

    return Container(
      color: const Color(0xFF15161A),
      alignment: Alignment.center,
      child: Container(
        width: 390,
        height: 844,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(46),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 50, offset: const Offset(0, 24)),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SizedBox.expand(child: child),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 14),
                width: 120,
                height: 28,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
