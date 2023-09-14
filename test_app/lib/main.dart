import 'package:dolbyio_comms_sdk_flutter_example/logger/logger_view.dart';
import 'package:dolbyio_comms_sdk_flutter_example/screens/init_sdk_screen.dart';
import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConferenceModel()),
        ChangeNotifierProvider(create: (context) => SpatialValuesModel()),
      ],
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
  final LoggerView _loggerView = LoggerView.getLoggerView();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    _loggerView.showOverlay(Navigator.of(context).overlay);
    _loggerView.log("[KB]", "test log");

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
                          settings: const RouteSettings(name: "InitSdkScreen"),
                          builder: (context) => const InitSdkScreen()));
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
