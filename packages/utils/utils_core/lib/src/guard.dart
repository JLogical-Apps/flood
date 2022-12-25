T? guard<T>(T Function() getter) {
  try {
    return getter();
  } catch (e) {
    return null;
  }
}
