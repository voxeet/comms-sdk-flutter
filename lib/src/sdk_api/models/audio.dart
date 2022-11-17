/// The AudioCaptureModeOptions model allows selecting the preferred audio capture mode and the preferred noise reduction level.
/// 
/// This model is available in SDK 3.7 and later.
///
/// {@category Models}
class AudioCaptureOptions {
  /// The preferred audio mode that allows enabling and disabling audio processing.
  AudioCaptureMode mode;
  /// The preferred level of noise reduction.
  NoiseReduction? noiseReduction;

  AudioCaptureOptions(this.mode, this.noiseReduction);

  Map<String, Object?> toJson() =>
      {"mode": mode.encode(), "noiseReduction": noiseReduction?.encode()};
}

/// The AudioCaptureMode model allows selecting the preferred mode for capturing the local participant's audio.
///
/// This model is available in SDK 3.7 and later.
///
/// {@category Models}
enum AudioCaptureMode {
  /// Optimizes captured audio for speech by aggressively removing non-speech content, such as background noise. This mode additionally enhances speech perceptibility to create a conversation-focused conference environment.
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
  /// Removes all background sounds to improve voice quality. Use this mode if you want to send only voice to a conference.
  high('high'),

  /// Removes stationary background sounds, such as the sound of a computer fan, air conditioning, or microphone hum, from audio transmitted to a conference. In this mode, non-stationary sounds are transmitted to give participants full context of other participants' environments and create a more realistic audio experience. If you want to send only voice to a conference, use the [High](#high) level.
  low('low');

  final String _value;

  const NoiseReduction(this._value);

  static NoiseReduction decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return NoiseReduction.values.firstWhere(
      (element) => element._value == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}
