/// An annotation that defines the class/interface as a marker class/interface.
/// This means it does not have any functionality, but is used by another class to produce functionality.
class _Marker {
  const _Marker();
}

const Object marker = _Marker();