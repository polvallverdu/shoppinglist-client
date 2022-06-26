import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:stroke_text/stroke_text.dart';

class SocketStatusDisplay extends HookConsumerWidget {
  const SocketStatusDisplay({Key? key}) : super(key: key);

  final Duration duration = const Duration(seconds: 1);
  static double beginPoint = -100;
  static double endPoint = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useAnimationController(
        duration: duration,
        lowerBound: beginPoint,
        upperBound: endPoint,
        initialValue: beginPoint);
    final socketStatus = ref.watch(ClientSocket().socketStatusProvider);

    switch (socketStatus) {
      case SocketStatus.CONNECTED:
      case SocketStatus.LOGGED:
        _controller.reverse();
        break;
      default:
        _controller.forward();
        break;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _controller.value,
          left: 0,
          right: 0,
          child: Container(child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: socketStatus.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                socketStatus.message,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
