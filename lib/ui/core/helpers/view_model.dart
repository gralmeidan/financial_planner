import 'package:flutter/material.dart';

abstract class ViewModel {
  void onInit(BuildContext context) {}
  void onDispose() {}
}

abstract class ViewModelState<W extends StatefulWidget, T extends ViewModel>
    extends State<W> {
  late final T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = createViewModel();
    viewModel.onInit(context);
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  T createViewModel();
}

class ViewModelContext<T extends ViewModel> extends InheritedWidget {
  final T viewModel;

  const ViewModelContext({
    super.key,
    required this.viewModel,
    required super.child,
  });

  @override
  bool updateShouldNotify(ViewModelContext<T> oldWidget) {
    return viewModel != oldWidget.viewModel;
  }

  static T of<T extends ViewModel>(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ViewModelContext<T>>();
    assert(scope != null, 'ViewModelContext not found in context');
    return scope!.viewModel;
  }
}
