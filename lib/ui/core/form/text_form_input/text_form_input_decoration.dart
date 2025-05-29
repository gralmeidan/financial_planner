import 'package:flutter/material.dart';

class TextFormInputDecoration {}

class TextFormInputDecoratedContainer extends StatefulWidget {
  final Widget child;
  final TextFormInputDecoration? decoration;

  const TextFormInputDecoratedContainer({
    super.key,
    required this.child,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
