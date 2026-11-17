import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const packageFile = path.join(root, "package.json");
const pubspecFile = path.join(root, "packages/flutter/pubspec.yaml");
const rootChangelogFile = path.join(root, "CHANGELOG.md");
const flutterChangelogFile = path.join(root, "packages/flutter/CHANGELOG.md");

const version = JSON.parse(readFileSync(packageFile, "utf8")).version;
if (!/^\d+\.\d+\.\d+(?:-beta\.\d+)?$/.test(version)) {
  throw new Error(`Invalid upstream Coolicons version: ${version}`);
}

const pubspec = readFileSync(pubspecFile, "utf8");
if (!/^version:\s*[^\n]+/m.test(pubspec)) {
  throw new Error("packages/flutter/pubspec.yaml has no version field");
}
writeFileSync(
  pubspecFile,
  pubspec.replace(/^version:\s*[^\n]+/m, "version: " + version),
);

const rootChangelog = readFileSync(rootChangelogFile, "utf8");
const heading = `\n## ${version}\n`;
const start = rootChangelog.indexOf(heading);
if (start < 0) {
  throw new Error(`Root CHANGELOG.md has no section for upstream version ${version}`);
}
const end = rootChangelog.indexOf("\n## ", start + 1);
const upstreamEntry = rootChangelog.slice(
  start + 1,
  end < 0 ? undefined : end + 1,
).trimEnd();

let flutterChangelog = readFileSync(flutterChangelogFile, "utf8");
if (!flutterChangelog.startsWith("# Changelog\n")) {
  throw new Error("packages/flutter/CHANGELOG.md must start with # Changelog");
}
if (!flutterChangelog.includes(heading)) {
  flutterChangelog = flutterChangelog.replace(
    "# Changelog\n",
    "# Changelog\n\n" + upstreamEntry +
      "\n\n- Flutter icon catalog synchronized with upstream Coolicons " + version + ".\n",
  );
  writeFileSync(flutterChangelogFile, flutterChangelog);
}

console.log(`Synchronized coolicons_flutter to upstream Coolicons ${version}.`);
