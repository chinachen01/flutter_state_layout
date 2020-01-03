import 'dart:async';

import 'package:flutter/material.dart';

class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child:
          SizedBox(width: 40, height: 40, child: CircularProgressIndicator()),
    ));
  }
}

class EmptyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Text('-暂无数据-'),
    ));
  }
}

class ErrorLayout extends StatelessWidget {
  final String errorInfo;
  final VoidCallback onError;
  ErrorLayout({this.errorInfo = '出错了!', this.onError});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: GestureDetector(
          onTap: onError,
          child: Text(errorInfo ?? '出错了!'),
        ),
      ),
    );
  }
}

typedef SucViewBuilder<T> = Widget Function(T data);
typedef FutureFuc<T> = Future<T> Function();

class StateLayout<T> extends StatefulWidget {
  StateLayout({@required this.future, @required this.builder, this.contoller});
  final FutureFuc<T> future;
  final SucViewBuilder<T> builder;

  final StateLayoutContoller contoller;

  @override
  _StateLayoutState createState() => _StateLayoutState<T>();
}

class StateLayoutContoller {
  Function refresh;
  void callRefresh() {
    refresh();
  }
}

class _StateLayoutState<T> extends State<StateLayout<T>> {
  Future _future;
  @override
  void initState() {
    super.initState();
    _future = widget.future();
    if (widget.contoller != null) {
      widget.contoller.refresh = _refresh;
    }
  }

  _refresh() {
    setState(() {
      _future = widget.future();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasError) {
            final error = snap.error;
            return ErrorLayout(
              onError: onError,
              errorInfo: (error is Exception) ? error.toString() : null,
            );
          } else if (snap.hasData && snap.data != null) {
            return widget.builder(snap.data);
          } else {
            return EmptyLayout();
          }
        } else if (snap.connectionState == ConnectionState.waiting) {
          return LoadingLayout();
        } else {
          return ErrorLayout(
            onError: onError,
          );
        }
      },
    );
  }

  void onError() {
    setState(() {
      _future = widget.future();
    });
  }
}
