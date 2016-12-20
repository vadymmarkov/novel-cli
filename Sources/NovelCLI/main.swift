import Foundation
import Commander
import SwiftShell

let novel = Group {
  // Create new Novel project
  $0.command("new") { (name: String) in
    main.stdout.print("📖 Cloning template...")
    try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")

    main.stdout.print("📖 Building project...")
    try runAndPrint(bash: "swift build --chdir \(name)")

    main.stdout.print("📖 Copying assets...")
    try AssetTask(root: name).execute()

    main.stdout.print("📖 Would you like to configure database? Yes/No")
    let answer = readInput()

    guard answer.lowercased() == "yes" else {
      main.stdout.print("Setup completed")
      return
    }

    main.stdout.print("> PostgreSQL server address (127.0.0.1 by default)")
    let host = readInput()

    main.stdout.print("> PostgreSQL database user.")
    let user = readInput()

    main.stdout.print("> PostgreSQL database password")
    let password = readInput()

    main.stdout.print("> PostgreSQL database name.")
    let database = readInput()

    main.stdout.print("> PostgreSQL port.")
    let port = readInput()

    main.stdout.print("📖 Configuring database...")
    try DatabaseTask(root: name, host: host, user: user, password: password,
                     database: database, port: port).execute()
  }

  // Update Novel project
  $0.command("update") {
    main.stdout.print("📖 Updating Novel...")
    try runAndPrint(bash: "swift package update")

    main.stdout.print("📖 Copying assets...")
    try AssetTask(root: ".").execute()
  }
}

novel.run()
