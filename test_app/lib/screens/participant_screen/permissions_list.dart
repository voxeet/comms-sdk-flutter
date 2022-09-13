import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';

typedef Permissions = void Function(List<ConferencePermission> permissions);

class PermissionsList extends StatefulWidget {
  final Permissions permissionsCallback;

  const PermissionsList({Key? key, required this.permissionsCallback}) : super(key: key);


  @override
  State<PermissionsList> createState() => PermissionsListState();
}

class PermissionsListState extends State<PermissionsList> {
  List<ConferencePermission> permissionsList = ConferencePermission.values;
  List<ConferencePermission> selectedPermissionsList = [];
  List<bool> checkBoxValueList = List<bool>.filled(12, false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: ListView.builder(
        itemCount: permissionsList.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            title: Text(permissionsList[index].encode()),
            value: checkBoxValueList[index],
            onChanged: (bool? value) {
              if(selectedPermissionsList.contains(permissionsList[index])) {
                setState(() => selectedPermissionsList.remove(permissionsList[index]));
              } else {
                setState(() => selectedPermissionsList.add(permissionsList[index]));
              }
              setState(() {
                checkBoxValueList[index] = value!;
                widget.permissionsCallback(selectedPermissionsList);
              });
            },
          );
        },
      ),
    );
  }
}
