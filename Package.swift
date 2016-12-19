import PackageDescription

let package = Package(
  name: "NovelCLI",
  dependencies: [
    .Package(url: "https://github.com/kylef/Commander", majorVersion: 0, minor: 6),
    .Package(url: "https://github.com/kareman/SwiftShell.git", "3.0.0-beta")
  ]
)
