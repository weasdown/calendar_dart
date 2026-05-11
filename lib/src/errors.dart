/// Simplifies throwing of [UnimplementedError]s for unimplemented methods.
class UnimplementedMethodError extends UnimplementedError {
  UnimplementedMethodError(this.className, this.methodName)
    : super('$className.$methodName() is not yet implemented.');

  final String className;
  final String methodName;
}
