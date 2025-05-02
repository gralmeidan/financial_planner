import 'package:flutter/material.dart';

import '../../data/models/schema.dart';
import '../../utils/formatting.dart';
import '../core/core.dart';

class ExpenseCard extends StatefulWidget {
  final FinancialRecord data;
  final int _indent;

  const ExpenseCard({super.key, required this.data}) : _indent = 0;

  const ExpenseCard._sub({required this.data, required int indent})
    : _indent = indent;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard>
    with TickerProviderStateMixin {
  late final controller = AnimatedCollapsableController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  double total = 0;

  void _calcTotal() {
    if (widget.data.children.isNotEmpty) {
      for (var element in widget.data.children) {
        total += element.amount ?? 0;
      }

      return;
    }

    total = widget.data.amount ?? 0;
  }

  @override
  void initState() {
    _calcTotal();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExpenseCard oldWidget) {
    if (oldWidget.data != widget.data) {
      _calcTotal();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);
    final indented = padding.add(EdgeInsets.only(left: widget._indent * 16));

    if (widget.data.children.isEmpty) {
      return ListTile(
        title: Text(total.toCurrency),
        subtitle: Text(widget.data.name),
        contentPadding: indented,
      );
    }

    return Column(
      children: [
        ListTile(
          title: Text(total.toCurrency),
          subtitle: Text(widget.data.name),
          contentPadding: indented,
          trailing: AnimatedChevron(
            controller: controller.chevron,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onTap: () {
            if (controller.size.isCompleted) {
              controller.size.reverse();
              controller.chevron.reverse();
            } else {
              controller.size.forward();
              controller.chevron.forward();
            }
          },
        ),
        AnimatedCollapsableClip(
          controller: controller.size,
          child: Column(
            children: [
              for (var element in widget.data.children)
                ExpenseCard._sub(data: element, indent: widget._indent + 1),
            ],
          ),
        ),
      ],
    );
  }
}
