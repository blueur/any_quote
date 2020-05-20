import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateButton<T> extends StatefulWidget {
  final Future<T> Function() update;
  final void Function(BuildContext context, T element) onFinish;

  const UpdateButton({@required this.update, this.onFinish});

  @override
  State<StatefulWidget> createState() => _UpdateButtonState(update, onFinish);
}

class _UpdateButtonState<T> extends State<UpdateButton<T>> {
  final Future<T> Function() update;
  final void Function(BuildContext context, T element) onFinish;
  bool _isUpdating = false;

  _UpdateButtonState(this.update, this.onFinish);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_isUpdating) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: RefreshProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).backgroundColor),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              setState(() {
                _isUpdating = true;
              });
              update().then((t) {
                setState(() {
                  _isUpdating = false;
                });
                onFinish?.call(context, t);
              });
            },
          );
        }
      },
    );
  }
}
