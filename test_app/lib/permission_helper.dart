import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static void checkPermissions({
    required List<Permission> permissions,
    void Function()? onGranted,
    void Function(List<Permission>)? onPermanentlyDenied,
    void Function(List<Permission>)? onDenied,
  }) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    var permanentlyDenied = statuses.entries
        .where((element) => element.value.isPermanentlyDenied)
        .map((e) => e.key)
        .toList();
    var denied = statuses.entries
        .where((element) => element.value.isDenied)
        .map((e) => e.key)
        .toList();

    if (statuses.values.every((element) => element.isGranted)) {
      onGranted?.call();
    } else if (permanentlyDenied.isNotEmpty) {
      onPermanentlyDenied?.call(permanentlyDenied);
    } else {
      onDenied?.call(denied);
    }
  }
}
