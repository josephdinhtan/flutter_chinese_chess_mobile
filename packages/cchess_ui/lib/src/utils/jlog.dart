import 'dart:developer';

class Jlog {
  static void i(String tag, String message) {
    log("[INFO] $message", name: tag);
  }

  static void d(String tag, String message) {
    log("[DEBUG] $message", name: tag);
  }

  static void e(String tag, String message) {
    log("[ERROR] $message", name: tag);
  }
}
