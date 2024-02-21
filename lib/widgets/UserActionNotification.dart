import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shoppinglistclient/net/socket.dart';
import 'package:stroke_text/stroke_text.dart';
import '../consts.dart';

class UserActionNotification extends HookConsumerWidget {
  UserActionNotification({Key? key}) : super(key: key);

  final Duration duration = const Duration(seconds: 1);
  static double beginPoint = -100;
  static double endPoint = 0;

  UserActionNotificationData last =
      UserActionNotificationData(EUserAction.ADD_ITEM, ["null", "null"]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useAnimationController(
        duration: duration,
        lowerBound: beginPoint,
        upperBound: endPoint,
        initialValue: beginPoint);
    final userActions = ref.watch(ClientSocket().userActionNotifier);
    if (userActions.isEmpty) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Container(child: child),
          );
        },
        child: Text(""),
      );
    }

    final action = userActions.last;

    if (action != last) {
      last = action;
      _controller.repeat(reverse: true);
    }

    var text = action.action.message;
    for (var i = 0; i < action.args.length; i++) {
      text = text.replaceAll("%${i + 1}", action.args[i]);
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
        child: Card(
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ConstColors.notification,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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
