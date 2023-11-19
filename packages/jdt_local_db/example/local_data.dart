import 'package:jdt_local_db/jdt_local_db.dart';
import 'local_data_item.dart';

class LocalData {
  void workDirectlyWithDb() {
    LocalDb().load();
    // get
    String appVersion = LocalDb().get("app_version", "1.0.1");
    print("App version: $appVersion");

    // set
    LocalDb().set("app_version", "1.0.2");

    // save to persistent storage
    LocalDb().save();

    // listen Data set change
    LocalDb().dataSetChangeNotifier.stream.listen((key) {
      print("Key change: $key");
    });
  }

  void workWithDataItems() {
    var appVersion = LocalDataItem("app_version", "1.0.1");
    print("App version: ${appVersion.value}");
    appVersion.value = "1.0.2";
  }
}
