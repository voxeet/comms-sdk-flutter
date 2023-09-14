import 'dart:developer' as developer;
import 'package:dolbyio_comms_sdk_flutter_example/screens/login_screen.dart';

import 'join_screen.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/circular_progress_indicator.dart';
import '/widgets/dolby_title.dart';
import '/widgets/input_text_field.dart';
import '/widgets/primary_button.dart';
import '/widgets/text_form_field.dart';
import '../shared_preferences_helper.dart';

class InitSdkScreen extends StatelessWidget {
  const InitSdkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(color: Colors.deepPurple),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
              InitSdkScreenContent()
            ],
          ),
        ),
      ),
    );
  }
}

class InitSdkScreenContent extends StatefulWidget {
  const InitSdkScreenContent({Key? key}) : super(key: key);

  @override
  State<InitSdkScreenContent> createState() => _InitSdkScreenContentState();
}

class _InitSdkScreenContentState extends State<InitSdkScreenContent> {
  final formKey = GlobalKey<FormState>();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  TextEditingController accessTokenTextController = TextEditingController();
  late String _accessToken;
  bool isSessionOpen = false, loginInProgress = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSessionStatus() async {
    await _dolbyioCommsSdkFlutterPlugin.session.isOpen().then((isOpen) {
      if (isOpen) {
        isSessionOpen = true;
      } else {
        isSessionOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        InputTextFormField(
                            labelText: 'Access token',
                            controller: accessTokenTextController,
                            focusColor: Colors.deepPurple),
                        const SizedBox(height: 16),
                      ],
                    )),
                const SizedBox(height: 16),
                PrimaryButton(
                  color: Colors.deepPurple,
                  widgetText: loginInProgress
                      ? const WhiteCircularProgressIndicator()
                      : const Text('Initialize'),
                  onPressed: () {
                    onLoginButtonPressed();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLoginButtonPressed() async {
    setState(() => loginInProgress = true);
    try {
      final isValidForm = formKey.currentState!.validate();
      if (isValidForm) {
        await initializeSdk();
        saveToSharedPreferences();
          navigateToLoginScreen();
      }
    } catch (e) {
      onError('Error: ', e);
    } finally {
      setState(() => loginInProgress = false);
    }
  }

  Future<void> initializeSdk() async {
    _accessToken = accessTokenTextController.text;
    await _dolbyioCommsSdkFlutterPlugin.initializeToken(
        _accessToken, () => getRefreshToken());
  }

  void navigateToLoginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: "LoginScreen"),
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<String?> getRefreshToken() async {
    return _accessToken;
  }

  void initSharedPreferences() {
    accessTokenTextController.text = SharedPreferencesHelper().accessToken;
  }

  void saveToSharedPreferences() {
    SharedPreferencesHelper().accessToken = _accessToken;
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
