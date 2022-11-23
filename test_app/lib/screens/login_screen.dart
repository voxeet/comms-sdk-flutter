import 'dart:developer' as developer;
import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
import 'package:provider/provider.dart';
import 'join_screen.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/circular_progress_indicator.dart';
import '/widgets/dolby_title.dart';
import '/widgets/input_text_field.dart';
import '/widgets/primary_button.dart';
import '/widgets/text_form_field.dart';
import '../shared_preferences_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
              LoginScreenContent()
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({Key? key}) : super(key: key);

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final formKey = GlobalKey<FormState>();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  TextEditingController accessTokenTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController externalIdTextController = TextEditingController();
  late String _accessToken;
  late String _username;
  late String? _externalId;
  bool isSessionOpen = false, loginInProgress = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    initSessionStatus();
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
                        InputTextFormField(
                            labelText: 'Username',
                            controller: usernameTextController,
                            focusColor: Colors.deepPurple),
                      ],
                    )),
                const SizedBox(height: 16),
                InputTextField(
                  labelText: 'External ID (optional)',
                  controller: externalIdTextController,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  color: Colors.deepPurple,
                  widgetText: loginInProgress
                      ? const WhiteCircularProgressIndicator()
                      : const Text('Login'),
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
        await openSession();
        await initSessionStatus();
        saveToSharedPreferences();
        if (isSessionOpen) {
          navigateToJoinConference();
        }
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

  Future<void> openSession() async {
    _username = usernameTextController.text;
    _externalId = externalIdTextController.text;

    Provider.of<ConferenceModel>(context, listen: false).username = _username;
    Provider.of<ConferenceModel>(context, listen: false).externalId =
        _externalId;

    var participantInfo = ParticipantInfo(_username, null, _externalId);
    await _dolbyioCommsSdkFlutterPlugin.session.open(participantInfo);
  }

  void navigateToJoinConference() {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: "JoinConferenceScreen"),
        builder: (context) => const JoinConference(),
      ),
    );
  }

  Future<String?> getRefreshToken() async {
    return _accessToken;
  }

  void initSharedPreferences() {
    accessTokenTextController.text = SharedPreferencesHelper().accessToken;
    usernameTextController.text = SharedPreferencesHelper().username;
  }

  void saveToSharedPreferences() {
    SharedPreferencesHelper().accessToken = _accessToken;
    SharedPreferencesHelper().username = _username;
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
