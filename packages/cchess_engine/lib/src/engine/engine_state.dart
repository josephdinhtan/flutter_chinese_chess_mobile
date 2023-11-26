enum EngineState {
  free,
  ready,
  searching,
  pondering,
  hinting;

  @override
  String toString() {
    switch (this) {
      case EngineState.free:
        return 'free';
      case EngineState.ready:
        return 'ready';
      case EngineState.searching:
        return 'searching';
      case EngineState.pondering:
        return 'pondering';
      case EngineState.hinting:
        return 'hinting';
    }
  }
}
