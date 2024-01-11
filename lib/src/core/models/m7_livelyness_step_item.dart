import 'package:m7_livelyness_detection/index.dart';

class M7LivelynessStepItem {
  //enum
  final M7LivelynessStep step;
  final double? thresholdToCheck;
  final bool isCompleted;
  final Color? detectionColor;

  M7LivelynessStepItem({
    required this.step,
    this.thresholdToCheck,
    required this.isCompleted,
    this.detectionColor,
  });

  M7LivelynessStepItem copyWith({
    M7LivelynessStep? step,
    String? title,
    double? thresholdToCheck,
    bool? isCompleted,
    Color? detectionColor,
  }) {
    return M7LivelynessStepItem(
      step: step ?? this.step,
      thresholdToCheck: thresholdToCheck ?? this.thresholdToCheck,
      isCompleted: isCompleted ?? this.isCompleted,
      detectionColor: detectionColor ?? this.detectionColor,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'step': step.index});
    if (thresholdToCheck != null) {
      result.addAll({'thresholdToCheck': thresholdToCheck});
    }
    result.addAll({'isCompleted': isCompleted});
    if (detectionColor != null) {
      result.addAll({'detectionColor': detectionColor!.value});
    }

    return result;
  }

  factory M7LivelynessStepItem.fromMap(Map<String, dynamic> map) {
    return M7LivelynessStepItem(
      step: M7LivelynessStep.values[map['step'] ?? 0],
      thresholdToCheck: map['thresholdToCheck']?.toDouble(),
      isCompleted: map['isCompleted'] ?? false,
      detectionColor:
      map['detectionColor'] != null ? Color(map['detectionColor']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory M7LivelynessStepItem.fromJson(String source) =>
      M7LivelynessStepItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'M7LivelynessStepItem(step: $step, thresholdToCheck: $thresholdToCheck, isCompleted: $isCompleted, detectionColor: $detectionColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is M7LivelynessStepItem &&
        other.step == step &&
        other.thresholdToCheck == thresholdToCheck &&
        other.isCompleted == isCompleted &&
        other.detectionColor == detectionColor;
  }

  @override
  int get hashCode {
    return step.hashCode ^
    thresholdToCheck.hashCode ^
    isCompleted.hashCode ^
    detectionColor.hashCode;
  }
}