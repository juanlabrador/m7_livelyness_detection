class M7AssetConstants {
  static const packageName = "m7_livelyness_detection";
  static _M7LottieAssets lottie = _M7LottieAssets();
  static _M7ImageAssets images = _M7ImageAssets();
}

class _M7ImageAssets {
  String get _initPath {
    return "src/assets";
  }

  String get mesh {
    return "$_initPath/final-mesh.png";
  }

  String get faceExample {
    return "$_initPath/face_example.png";
  }
}

class _M7LottieAssets {
  String get _initPath {
    return "src/assets/lottie";
  }

  String get livelynessStart {
    return "$_initPath/livelyness-start.json";
  }

  String get livelynessSuccess {
    return "$_initPath/livelyness-success.json";
  }

  String get stepCompleted {
    return "$_initPath/step_completed.json";
  }

  String get blink {
    return "$_initPath/blink.json";
  }

  String get smile {
    return "$_initPath/smile.json";
  }

  String get turnLeft {
    return "$_initPath/turn-left.json";
  }

  String get turnRight {
    return "$_initPath/turn-right.json";
  }
}
