class AudioCaptureOptions {
  AudioCaptureMode mode;
  NoiseReduction? noiseReduction;

  AudioCaptureOptions(this.mode, this.noiseReduction);

  Map<String, Object?> toJson() => {
    "mode": mode.encode(),
    "noiseReduction": noiseReduction?.encode()
  };
}

enum AudioCaptureMode {
  standard('standard'),

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

enum NoiseReduction {
  high('high'),

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

