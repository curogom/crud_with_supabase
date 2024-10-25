class CRUDException implements Exception {
  final String message;

  const CRUDException(this.message);

  @override
  String toString() => message;
}