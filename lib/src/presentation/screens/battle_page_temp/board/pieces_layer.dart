import 'package:flutter/material.dart';
import 'pieces_layout.dart';

class PiecesLayer extends StatefulWidget {
  //
  final PiecesLayout layoutParams;

  const PiecesLayer(this.layoutParams, {Key? key}) : super(key: key);

  @override
  State createState() => _PiecesLayerState();
}

class _PiecesLayerState extends State<PiecesLayer> {
  //
  @override
  Widget build(BuildContext context) {
    return widget.layoutParams.buildPiecesLayout(context);
  }
}
