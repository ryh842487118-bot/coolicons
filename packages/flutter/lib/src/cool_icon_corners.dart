/// Corner treatments provided as separate SVG artwork by Coolicons.
enum CoolIconCorners {
  /// Sharp corners.
  sharp,

  /// Regular corners.
  regular,

  /// Rounded corners.
  round,
}

/// Backwards-compatible alias. Prefer [CoolIconCorners] in new code.
@Deprecated('Use CoolIconCorners instead.')
typedef CoolIconRadius = CoolIconCorners;
