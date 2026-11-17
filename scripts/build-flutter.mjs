import { mkdirSync, rmSync, writeFileSync } from "node:fs";
import path from "node:path";
import { loadIcons, root, serializeSvg, VARIANTS } from "./icons.mjs";

const packageRoot = path.join(root, "packages", "flutter");
const generatedRoot = path.join(packageRoot, "lib", "src", "generated");
const iconOutput = path.join(generatedRoot, "icons");

const dartKeywords = new Set([
  "assert", "break", "case", "catch", "class", "const", "continue", "default",
  "do", "else", "enum", "extends", "false", "final", "finally", "for", "if",
  "in", "is", "new", "null", "rethrow", "return", "super", "switch", "this",
  "throw", "true", "try", "var", "void", "while", "with", "abstract", "as",
  "async", "await", "covariant", "deferred", "dynamic", "export", "extension",
  "external", "factory", "Function", "get", "implements", "import", "interface",
  "late", "library", "mixin", "operator", "part", "required", "set", "static",
  "typedef", "yield", "all", "names",
]);

function dartIdentifier(name) {
  const parts = name.split("-");
  let identifier = parts[0] + parts.slice(1).map((part) =>
    part.charAt(0).toUpperCase() + part.slice(1),
  ).join("");
  if (dartKeywords.has(identifier)) identifier += "Icon";
  return identifier;
}

function dartString(value) {
  return JSON.stringify(value)
    .replace(/\u2028/g, "\\u2028")
    .replace(/\u2029/g, "\\u2029");
}

const { manifest, icons } = loadIcons();
const identifiers = new Map();

for (const icon of icons) {
  const identifier = dartIdentifier(icon.name);
  const previous = identifiers.get(identifier);
  if (previous) {
    throw new Error(`Dart identifier collision: ${previous} and ${icon.name} -> ${identifier}`);
  }
  identifiers.set(identifier, icon.name);
}

rmSync(generatedRoot, { recursive: true, force: true });
mkdirSync(iconOutput, { recursive: true });

const canonicalIcons = icons.filter((icon) => !icon.aliasOf);
for (const icon of canonicalIcons) {
  const identifier = dartIdentifier(icon.name);
  const variants = VARIANTS.map((variant) => {
    const svg = serializeSvg(icon.files[variant].nodes);
    return `    ${dartString(variant)}: ${dartString(svg)},`;
  }).join("\n");

  const source = `// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: icons/svg/<style>/<radius>/${icon.name}.svg
// Upstream: https://github.com/krystonschwarze/coolicons
// Regenerate with: node scripts/build-flutter.mjs

import '../../cool_icon_data.dart';

const CoolIconData ${identifier} = CoolIconData(
  name: ${dartString(icon.name)},
  variants: <String, String>{
${variants}
  },
);
`;
  writeFileSync(path.join(iconOutput, `${icon.name}.dart`), source);
}

const importTargets = new Set();
for (const icon of icons) {
  importTargets.add(icon.aliasOf ?? icon.name);
}

const imports = [...importTargets].map((name) => {
  const identifier = dartIdentifier(name);
  return `import 'icons/${name}.dart' as _${identifier};`;
}).join("\n");

const fields = icons.map((icon) => {
  const identifier = dartIdentifier(icon.name);
  const target = dartIdentifier(icon.aliasOf ?? icon.name);
  return `  /// Upstream icon name: ${icon.name}.
  static const CoolIconData ${identifier} = _${target}.${target};`;
}).join("\n\n");

const allEntries = icons.map((icon) =>
  `    ${dartString(icon.name)}: ${dartIdentifier(icon.name)},`,
).join("\n");

const names = icons.map((icon) => `    ${dartString(icon.name)},`).join("\n");

const indexSource = `// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: icons/manifest.json and icons/svg/
// Upstream: https://github.com/krystonschwarze/coolicons
// Upstream manifest version: ${manifest.format}; source commit: ${manifest.source.commit}; manifest hash: ${manifest.hash}
// Regenerate with: node scripts/build-flutter.mjs

import '../cool_icon_data.dart';

${imports}

/// Generated constants for the complete upstream Coolicons catalog.
abstract final class CoolIcons {
${fields}

  /// All icons keyed by their original upstream kebab-case names.
  ///
  /// Referencing this map exposes the full catalog for icon browsers and search.
  static const Map<String, CoolIconData> all = <String, CoolIconData>{
${allEntries}
  };

  /// All upstream icon names, including aliases.
  static const List<String> names = <String>[
${names}
  ];
}
`;

writeFileSync(path.join(generatedRoot, "cool_icons.dart"), indexSource);

console.log(
  `Generated ${icons.length} icon names (${canonicalIcons.length} unique SVG sets, ${VARIANTS.length} variants each) into ${path.relative(root, generatedRoot)}.`,
);
