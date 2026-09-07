import 'dart:io' show Platform;

/// Which build of WayWayBack this is, and where to point people for the others.
class AppPlatform {
  AppPlatform._();

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
  static bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  static String get current {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    return 'this device';
  }

  /// A one-liner nudging the user toward the version they don't have.
  static String get crossPromo => isMobile
      ? 'Also runs on your computer — WayWayBack has native builds for '
            'Linux, Windows and macOS.'
      : 'Also on your phone — get the Android app from F-Droid or the '
            'GitHub releases page.';

  static const releasesUrl = 'https://github.com/mkalmousli/wwb/releases/latest';
}
