import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:magnetgram/model/chat.dart';
import 'package:magnetgram/model/divar.dart';
import 'package:magnetgram/model/user.dart';
import 'package:rxdart/rxdart.dart';

class DivarBloc implements BlocBase {
  //sink = input   stream=output
  final _divarStreamController = BehaviorSubject<List<Divar>>();

//  final _wallpaperStreamController = StreamController<List<Wallpaper>>();

  // final StreamController<List<Wallpaper>> _wallpaperStreamController =
  //     StreamController<List<Wallpaper>>();

  Sink<List<Divar>> get sink => _divarStreamController.sink;

  Stream<List<Divar>> get stream => _divarStreamController.stream;

//  final schoolsSubject = BehaviorSubject<List<Wallpaper>>();

  DivarBloc() {
    print("DivarBloc listen");

//    _wallpaperStreamController.close();
//    _wallpaperStreamController.stream.listen(null);
  }

  void onData(String event) {}

  @override
  void dispose() {
    _divarStreamController.close();
    print("closed DivarBloc");
  }

  void _handleCommand(String event) {
//    sink.add("2");
  }
}

class UserBloc implements BlocBase {
  final _userStreamController = BehaviorSubject<List<User>>();

  Sink<List<User>> get sink => _userStreamController.sink;

  Stream<List<User>> get stream => _userStreamController.stream;

  UserBloc() {
    print("UserBloc listen");
  }

  void onData(String event) {}

  @override
  void dispose() {
    _userStreamController.close();
    print("closed UserBloc");
  }

  void _handleCommand(String event) {
//    sink.add("2");
  }
}

class ChatBloc implements BlocBase {
  final _chatStreamController = BehaviorSubject<List<Chat>>();

  Sink<List<Chat>> get sink => _chatStreamController.sink;

  Stream<List<Chat>> get stream => _chatStreamController.stream;

  ChatBloc() {
    print("UserBloc listen");
  }

  void onData(String event) {}

  @override
  void dispose() {
    _chatStreamController.close();
    print("closed ChatBloc");
  }

  void _handleCommand(String event) {
//    sink.add("2");
  }
}

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

// 1
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvider({Key key, @required this.bloc, @required this.child})
      : super(key: key);

  // 2
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _providerType<BlocProvider<T>>();
    final BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  // 3
  static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  // 4
  @override
  Widget build(BuildContext context) => widget.child;

  // 5
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

//class BlocProvider<T extends BlocBase> extends StatefulWidget {
//  BlocProvider({
//    Key key,
//    @required this.child,
//    @required this.bloc,
//  }) : super(key: key);
//
//  final Widget child;
//  final T bloc;
//
//  @override
//  _BlocProviderState<T> createState() => _BlocProviderState<T>();
//
//  static T of<T extends BlocBase>(BuildContext context) {
//    final type = _typeOf<_BlocProviderInherited<T>>();
//    _BlocProviderInherited<T> provider =
//        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
//    return provider?.bloc;
//  }
//}
//
//class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
//  @override
//  void dispose() {
//    widget.bloc?.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new _BlocProviderInherited<T>(
//      bloc: widget.bloc,
//      child: widget.child,
//    );
//  }
//}
//
//class _BlocProviderInherited<T> extends InheritedWidget {
//  _BlocProviderInherited({
//    Key key,
//    @required Widget child,
//    @required this.bloc,
//  }) : super(key: key, child: child);
//
//  final T bloc;
//
//  @override
//  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
//}
