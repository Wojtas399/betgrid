import 'package:flutter/material.dart';

class ScrollAnimatedItem extends StatefulWidget {
  final Widget child;

  const ScrollAnimatedItem({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ScrollAnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    scaleAnimation = Tween<double>(begin: 0.25, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (_, Widget? child) => Transform.scale(
        scale: scaleAnimation.value,
        child: child,
      ),
    );
  }
}
