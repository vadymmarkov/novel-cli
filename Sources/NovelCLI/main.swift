import Foundation
import Commander
import SwiftShell

struct AssetTask {

  let root: String

  func execute() throws {
    try runAndPrint(bash: "mkdir -p \(root)/Public/css")
    try runAndPrint(bash: "mkdir -p \(root)/Public/fonts")
    try runAndPrint(bash: "mkdir -p \(root)/Public/images")
    try runAndPrint(bash: "mkdir -p \(root)/Public/js")

    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/css/vendor.css \(root)/Public/css")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/css/admin.css \(root)/Public/css")
    try runAndPrint(bash: "cp -a \(root)/Packages/Novel-*/Public/fonts/. \(root)/Public/fonts")
    try runAndPrint(bash: "cp -a \(root)/Packages/Novel-*/Public/images/. \(root)/Public/images")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/vendor.js \(root)/Public/js")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/admin.js \(root)/Public/js")

    try runAndPrint(bash: "cp -rf \(root)/Packages/Novel-*/Resources/Views/admin \(root)/Resources/Views")
  }
}

struct DatabaseTask {
  let root: String
  let host: String
  let user: String
  let password: String
  let database: String
  let port: String

  func execute() throws {
    let samplePath = "\(root)/Config/postgresql-sample.json"
    let destPath = "\(root)/Config/secrets/postgresql.json"

    try runAndPrint(bash: "mkdir -p \(root)/Config/secrets")

    let sampleFile = try open(samplePath)
    var contents: String = sampleFile.read()
    contents = contents.replacingOccurrences(of: "{host}", with: host)
    contents = contents.replacingOccurrences(of: "{user}", with: user)
    contents = contents.replacingOccurrences(of: "{password}", with: password)
    contents = contents.replacingOccurrences(of: "{database}", with: database)
    contents = contents.replacingOccurrences(of: "\"{port}\"", with: port)

    let file = try open(forWriting: destPath)
    file.print(contents)
  }
}

func readInput() -> String {
  var string = main.stdin.readSome()?.trimmingCharacters(in: .whitespaces)
  string = string?.replacingOccurrences(of: "\n", with: "")
  return string ?? ""
}

let novel = Group {
  $0.command("new") { (name: String) in
    main.stdout.print("Cloning template...")
    try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")
    try runAndPrint(bash: "swift build --chdir \(name)")

    main.stdout.print("Copying assets...")
    try AssetTask(root: name).execute()

    main.stdout.print("Would you like to configure database? Yes/No")
    let answer = readInput()

    guard answer.lowercased() == "yes" else {
      main.stdout.print("Setup completed")
      return
    }

    main.stdout.print("PostgreSQL server address (127.0.0.1 by default)")
    let host = readInput()

    main.stdout.print("PostgreSQL database user.")
    let user = readInput()

    main.stdout.print("PostgreSQL database password")
    let password = readInput()

    main.stdout.print("PostgreSQL database name.")
    let database = readInput()

    main.stdout.print("PostgreSQL port.")
    let port = readInput()

    main.stdout.print("Configuring database...")
    try DatabaseTask(root: name, host: host, user: user, password: password,
                     database: database, port: port).execute()
  }

  $0.command("update") {
    main.stdout.print("Updating Novel")
    try runAndPrint(bash: "swift package update")
    try AssetTask(root: ".").execute()
  }
}

novel.run()
