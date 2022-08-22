import 'package:dolbyio_comms_sdk_flutter_example/example_app/join_conference_screen.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/text_form_field.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'dart:developer' as developer;

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final formKey = GlobalKey<FormState>();
  String _sdkStatus = 'Unknown';
  String _sessionStatus = 'Unknown';
  TextEditingController customerKeyTextController = new TextEditingController();
  TextEditingController customerSecretTextController = new TextEditingController();
  TextEditingController usernameTextController = TextEditingController();

  late String initializationStatus;
  bool isInitialized = false, isSessionOpen = false;
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String sessionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      if (await _dolbyioCommsSdkFlutterPlugin.session.isOpen()) {
        sessionStatus = "open";
      } else {
        sessionStatus = "closed";
      }
    } on PlatformException {
      sessionStatus =
          'Failed to check session is open. Maybe sdk is not initialized';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _sessionStatus = sessionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Sdk intialized: $_sdkStatus\nSession is open: $_sessionStatus'),
                    const SizedBox(
                      height: 24,
                    ),
                    InputTextFormField(
                      labelText: 'Customer Key',
                      controller: customerKeyTextController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InputTextFormField(
                      labelText: 'Customer Secret',
                      controller: customerSecretTextController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InputTextFormField(labelText: 'Username', controller: usernameTextController,),
                    const SizedBox(
                      height: 24,
                    ),
                    PrimaryButton(
                        widgetText: Text('Initialise'),
                        onPressed:
                          isInitialized ? null : (){ onInitialiseButtonPressed(); }
                        ),
                    PrimaryButton(
                        widgetText: Text('Open session'),
                        onPressed:
                          isSessionOpen ? null : (){ onOpenSessionButtonPressed(); }
                    ),
                    PrimaryButton(
                        widgetText: Text('Next'),
                        onPressed:(){
                          onNextButtonPressed();}
                        )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onOpenSessionButtonPressed() {
    var name = usernameTextController.text;
    var participantInfo = ParticipantInfo(name, null, null);
    _dolbyioCommsSdkFlutterPlugin.session
        .open(participantInfo)
        .then((value) => checkSessionOpenResult())
        .onError((error, stackTrace) => onError(error));
  }

  void onCloseSessionButtonPressed() {
    _dolbyioCommsSdkFlutterPlugin.session
        .close()
        .then((value) => checkSessionCloseResult())
        .onError((error, stackTrace) => onError(error));
  }

  void onInitialiseButtonPressed() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      var customerKey = customerKeyTextController.text;
      var customerSecret = customerSecretTextController.text;
      _dolbyioCommsSdkFlutterPlugin
          .initialize(customerKey, customerSecret)
          .then((value) => checkInitResult(value))
          .onError((error, stackTrace) => onError(error));
      initializationStatus = 'initialized';
    } else {
      developer.log("Cannot initialize due to error.");
    }
  }

  void onNextButtonPressed() {
    if (isInitialized && isSessionOpen) {
      Navigator.of(context)
          .push(
          MaterialPageRoute(builder: (context) => JoinConferenceScreen()));
    } else {
      developer.log("Please, initialize SDK and open session first.");
    }
  }

  void onError(Object? error) {
    developer.log("Error during session open", error: error);
  }

  void checkSessionOpenResult() async{
    developer.log("session result:");
    await initPlatformState();
    if (_sessionStatus == "open") {
      setState(() => isSessionOpen = true);
    }
  }

  void checkSessionCloseResult() {
    developer.log("session result:");
    setState(() {
      _sessionStatus = 'closed';
      _sdkStatus = 'unknown';
    });
  }

  void checkInitResult(void value) {
    developer.log("init result)");
    setState(() {
      _sdkStatus = 'initialized';
      isInitialized = true;
    });
  }
}
