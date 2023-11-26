class PikafishConfig {
  static final PikafishConfig _singleton = PikafishConfig._();
  factory PikafishConfig() {
    return _singleton;
  }
  PikafishConfig._();

  int timeLimit = 3; // second
  bool ponder = false;
  int threads = 1;
  int level = 20;
  int hashSize = 16;

  hashSizePlus() {
    var hs = hashSize;
    if (hs < 16) {
      hs++;
    } else if (hs < 256) {
      hs += 16;
      hs = hs ~/ 16 * 16;
    } else {
      hs += 256;
      hs = hs ~/ 256 * 256;
    }
    if (hs >= 4 * 1024) hs = 4 * 1024;
    hashSize = hs;
  }

  hashSizeReduce() {
    var hs = hashSize;
    if (hs <= 16) {
      hs--;
    } else if (hs <= 256) {
      hs -= 16;
      hs = hs ~/ 16 * 16;
    } else {
      hs -= 256;
      hs = hs ~/ 256 * 256;
    }
    if (hs < 1) hs = 1;
    hashSize = hs;
  }
}
