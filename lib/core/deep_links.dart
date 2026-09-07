import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Receives links handed to the app by the platform (a shared URL, a `wwb://`
/// deep link) so they can open the Link screen directly. Android-only for now;
/// a no-op elsewhere.
class DeepLinks {
  DeepLinks._();
  static final instance = DeepLinks._();

  static const _channel = MethodChannel('wwb/links');

  void Function(String url)? onLink;

  void start() {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'link' && call.arguments is String) {
        _dispatch(call.arguments as String);
      }
    });
    _channel
        .invokeMethod<String?>('getInitialLink')
        .then((v) => v == null ? null : _dispatch(v))
        .catchError((_) {});
  }

  void _dispatch(String raw) {
    final url = raw.trim();
    if (url.isEmpty) return;
    onLink?.call(url);
  }
}
