/// The AudioCaptureModeOptions model allows selecting the preferred audio capture mode and additional options for the preferred mode.
///
/// This model is available in SDK 3.7 and later.
///
/// {@category Models}
class AudioCaptureOptions {
  /// The preferred audio mode for capturing the local participant's audio.
  AudioCaptureMode mode;

  /// The preferred level of noise reduction. This property is supported only in the Standard mode.
  NoiseReduction? noiseReduction;

  /// The preferred voice modification effect that you can use to change the local participant's voice in real time. This property is supported only in the Standard mode in SDK 3.10 and later.
  VoiceFont voiceFont;

  AudioCaptureOptions(this.mode, this.noiseReduction,
      {this.voiceFont = VoiceFont.none});

  Map<String, Object?> toJson() => {
        "mode": mode.encode(),
        "noiseReduction": noiseReduction?.encode(),
        "voiceFont": voiceFont.encode()
      };
}

/// The AudioCaptureMode model allows selecting the preferred mode for capturing the local participant's audio.
///
/// This model is available in SDK 3.7 and later.
///
/// {@category Models}
enum AudioCaptureMode {
  /// The default mode aimed at enhancing speech to create a conversation-focused conference environment. This mode optimizes captured audio for speech by aggressively removing non-speech content, such as background noise.
  standard('standard'),

  /// Disables audio processing to allow transmitting non-voice audio to a conference.
  unprocessed('unprocessed');

  final String _value;

  const AudioCaptureMode(this._value);

  static AudioCaptureMode decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return AudioCaptureMode.values.firstWhere(
      (element) => element._value == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}

/// The NoiseReductionLevel model allows selecting the preferred level of noise reduction.
///
/// This model is available in SDK 3.7 and later.
///
/// {@category Models}
enum NoiseReduction {
  /// The default level that removes all background sounds to improve voice quality. Use this mode if you want to send only voice to a conference.
  high('high'),

  /// Removes stationary background sounds, such as the sound of a computer fan, air conditioning, or microphone hum, from audio transmitted to a conference. In this mode, non-stationary sounds are transmitted to give participants full context of other participants' environments and create a more realistic audio experience. If you want to send only voice to a conference, use the [High](#high) level.
  low('low');

  final String _value;

  const NoiseReduction(this._value);

  static NoiseReduction? decode(String? value) {
    return value != null
        ? NoiseReduction.values.firstWhere(
            (element) => element._value == value.toLowerCase(),
            orElse: () => throw Exception("Invalid enum name"),
          )
        : null;
  }

  String encode() {
    return _value;
  }
}

/// The VoiceFont model gathers the possible voice modification effects that you can use to change the local participant's voice in real time. The model is supported only in SDK 3.9 and later.
/// <br><br>
/// The following table lists audio samples for each available voice font:
///
/// <table>
///     <tbody>
///         <tr style="height:60px">
///             <th align='center' width=20%><b>Voice font</b></th>
///             <th align='center' width=40%><b>Example 1</b></th>
///             <th align='center' width=40%><b>Example 2</b></th>
///         </tr>
///         <tr>
///             <td><code>none</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/original_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/original_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///           <td><code>abyss</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/abyss_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/abyss_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>amRadio</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/amradio_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/amradio_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>brokenRobot</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/broken_robot_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/broken_robot_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>darkModulation</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/dark_modulation_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/dark_modulation_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>feminine</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/feminine_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/feminine_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>helium</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/helium_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/helium_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>interference</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/interference_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/interference_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>masculine</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/masculine_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/masculine_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>nervousRobot</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/nervous_robot_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/nervous_robot_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>starshipCaptain</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/starship_captain_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/starship_captain_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>swarm</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/swarm_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/swarm_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///         <tr>
///             <td><code>wobble</code></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/wobble_male.wav" >Sorry, your browser does not support the audio element.</audio></td>
///             <td><audio controls preload="auto"><source src="https://dolbyio.s3.us-west-1.amazonaws.com/public/voice-fonts/skywalker/wobble_female.wav" >Sorry, your browser does not support the audio element.</audio></td>
///         </tr>
///     </tbody>
/// </table>
enum VoiceFont {
  none("none"),
  masculine("masculine"),
  feminine("feminine"),
  helium("helium"),
  darkModulation("dark_modulation"),
  brokenRobot("broken_robot"),
  interference("interference"),
  abyss("abyss"),
  wobble("wobble"),
  starshipCaptain("starship_captain"),
  nervousRobot("nervous_robot"),
  swarm("swarm"),
  amRadio("am_radio");

  final String _value;

  const VoiceFont(this._value);

  String encode() {
    return _value;
  }

  static VoiceFont decode(String? value) {
    return value != null
        ? VoiceFont.values.firstWhere(
            (element) => element._value == value.toLowerCase(),
            orElse: () => throw Exception("Invalid enum name"),
          )
        : VoiceFont.none;
  }
}

/// The AudioPreviewStatus model gathers all possible statuses of audio samples recording for audio preview.
///
/// This model is available in SDK 3.10 and later.
enum AudioPreviewStatus {
  /// There is no recording available.
  noRecordingAvailable("NoRecordingAvailable"),

  /// The recording is available.
  recordingAvailable("RecordingAvailable"),

  /// Recording is in progress.
  recording('Recording'),

  /// The recording is played.
  playing('Playing'),

  /// The audio session configuration is restarted; there are no recording in the memory.
  released('Released');

  final String _value;

  const AudioPreviewStatus(this._value);

  String encode() {
    return _value;
  }

  static AudioPreviewStatus decode(String? value) {
    return AudioPreviewStatus.values.firstWhere(
      (element) => element._value == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}
