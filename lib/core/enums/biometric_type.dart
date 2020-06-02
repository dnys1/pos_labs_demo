/// The type of biometric login available to the user
enum BiometricType { Touch, Face, None }

extension BiometricTypeString on BiometricType {
  /// Returns the formatted enum string, i.e. BiometricType.Face => Face
  String get string => this.toString().split('.')[1];
}