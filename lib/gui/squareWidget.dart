// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:new_tictacto/game/square.dart';

class SquareWidget extends StatefulWidget {
  final Square square;
  final bool visibleShips;

  const SquareWidget({
    Key? key,
    required this.square,
    required this.visibleShips,
  }) : super(key: key);

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  Color determineColor() {
    switch (widget.square.status) {
      case SquareStatus.empty:
        return Colors.grey;
      case SquareStatus.ship:
        return widget.visibleShips ? Colors.green : Colors.grey;
      case SquareStatus.hit:
        return Colors.orange;
      case SquareStatus.miss:
        return Colors.blue;
      case SquareStatus.sunk:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  void _handleTap() {
    setState(() {
      widget.square.bombSquare();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 30,
        height: 30,
        color: determineColor(),
      ),
    );
  }
}
