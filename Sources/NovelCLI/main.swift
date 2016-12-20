import Foundation
import Commander
import SwiftShell

let novel = Group {
  // Create new project
  $0.command("new", description: "Create new Novel-based project") { (name: String) in
    print("📖  Cloning template...")
    try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")

    print("📖  Building project...")
    try runAndPrint(bash: "swift build --chdir \(name)")

    print("📖  Copying assets...")
    try AssetTask(root: name).execute()

    print("📖  Would you like to configure database? Yes/No")
    let answer = readInput()

    guard answer.lowercased() == "yes" else {
      print("📖  Setup completed")
      return
    }

    print("> PostgreSQL server address")
    let host = readInput()

    print("> PostgreSQL database user.")
    let user = readInput()

    print("> PostgreSQL database password")
    let password = readInput()

    print("> PostgreSQL database name.")
    let database = readInput()

    print("> PostgreSQL port.")
    let port = readInput()

    print("📖  Configuring database...")
    try DatabaseTask(root: name, host: host, user: user, password: password,
                     database: database, port: port).execute()

    print("📖  Setup completed")
  }

  // Update project
  $0.command("update", description: "Update existing Novel-based project") {
    print("📖  Updating Novel...")
    try runAndPrint(bash: "swift package update")

    print("📖  Copying assets...")
    try AssetTask(root: ".").execute()

    print("📖  Update completed")
  }
}

novel.run()
