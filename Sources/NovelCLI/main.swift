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
  }
}

struct DatabaseTask {
  let root: String
  let host: String
  let user: String
  let password: String
  let database: String
  let port: Int

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
    contents = contents.replacingOccurrences(of: "\"{port}\"", with: "\(port)")

    let file = try open(forWriting: destPath)
    file.print(contents)
  }
}

let newCommand = command(
  Option("name", "blog", description: "Your app's name."),
  Option("host", "127.0.0.1", description: "PostgreSQL server address."),
  Option("user", "postgres", description: "PostgreSQL db user."),
  Option("password", "", description: "PostgreSQL db password."),
  Option("database", "blog", description: "PostgreSQL database name."),
  Option("port", 5432, description: "The TCP port of web server.")
) { name, host, user, password, database, port in
  print("Cloning template...")
  try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")
  try runAndPrint(bash: "swift build --chdir \(name)")

  print("Copying assets...")
  try AssetTask(root: name).execute()

  print("Configuring database...")
  try DatabaseTask(root: name, host: host, user: user, password: password,
                   database: database, port: port).execute()
}

let main = Group {
  $0.addCommand("new", newCommand)

  $0.command("update") {
    print("Updating Novel")
    try runAndPrint(bash: "swift package update")
    try AssetTask(root: ".").execute()
  }
}

main.run()
