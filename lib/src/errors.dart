/// Simplifies throwing of [UnimplementedError]s for unimplemented methods.
class UnimplementedMethodError extends UnimplementedError {
  UnimplementedMethodError(this.className, this.methodName)
    : super('$className.$methodName() method is not yet implemented.');

  final String className;
  final String methodName;
}

/// Simplifies throwing of [UnimplementedError]s for unimplemented getters.
class UnimplementedGetterError extends UnimplementedError {
  UnimplementedGetterError(this.className, this.getterName)
    : super('$className.$getterName getter is not yet implemented.');

  final String className;
  final String getterName;
}

/// Simplifies throwing of [UnimplementedError]s for unimplemented operators.
class UnimplementedOperatorError extends UnimplementedError {
  UnimplementedOperatorError(this.className, this.operatorName)
    : super('$className.$operatorName operator is not yet implemented.');

  final String className;
  final String operatorName;
}
