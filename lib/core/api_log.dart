/// A single line in the network activity log surfaced to the user.
class ApiLogEntry {
  ApiLogEntry(this.message, {this.error = false, this.done = false})
    : at = DateTime.now();

  final String message;
  final bool error;
  final bool done;
  final DateTime at;
}

/// Callback used throughout the data layer to report progress.
typedef ApiLog = void Function(String message, {bool error, bool done});
