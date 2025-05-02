class Version {
  final int major;
  final int minor;
  final int patch;

  const Version({
    required this.major,
    required this.minor,
    required this.patch,
  });

  factory Version.fromString(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw const FormatException(
        'Version string must be in format "major.minor.patch"',
      );
    }

    return Version(
      major: int.parse(parts[0]),
      minor: int.parse(parts[1]),
      patch: int.parse(parts[2]),
    );
  }

  @override
  String toString() => '$major.$minor.$patch';

  bool isNewerThan(Version other) {
    if (major != other.major) return major > other.major;
    if (minor != other.minor) return minor > other.minor;
    return patch > other.patch;
  }
}
