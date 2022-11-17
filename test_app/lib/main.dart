import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '/widgets/primary_button.dart';
import '/screens/login_screen.dart';
import 'shared_preferences_helper.dart';
import 'widgets/spatial_extensions/spatial_values_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.load();
  runApp(
      ChangeNotifierProvider(
        create: (context) => SpatialValuesModel(),
        child: const MaterialApp(home: MyApp()),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                    widgetText: const Text('Open example app'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          settings: const RouteSettings(name: "LoginScreen"),
                          builder: (context) => const LoginScreen()));
                    }),
                PrimaryButton(
                    widgetText: const Text('Run playground'),
                    onPressed: () async {
                      runPlayground(_dolbyioCommsSdkFlutterPlugin);
                    }),
              ],
            ),
          )),
    );
  }

  void runPlayground(DolbyioCommsSdk dolbyioCommsSdkFlutterPlugin) async {
    // Add code to play with here
  }
}
