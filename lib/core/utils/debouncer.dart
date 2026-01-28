import 'dart:async';

/// A debouncer utility for search and other inputs
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  /// Run the callback after the delay
  void run(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Cancel any pending callback
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if there's a pending callback
  bool get isPending => _timer?.isActive ?? false;

  /// Dispose the debouncer
  void dispose() {
    cancel();
  }
}

/// Extension to make debouncing easier with async functions
extension DebouncerAsync on Debouncer {
  /// Run an async callback after the delay
  void runAsync(Future<void> Function() callback) {
    run(() => callback());
  }
}
