import Foundation
import SwiftShell

protocol Task {
  func execute() throws
}

struct DatabaseTask: Task {
  let root: String
  let host: String
  let user: String
  let password: String
  let database: String
  let port: String

  var samplePath: String {
    return "\(root)/Config/postgresql-sample.json"
  }

  var destPath: String {
    return "\(root)/Config/secrets/postgresql.json"
  }

  func execute() throws {
    // Make secrets dir
    try runAndPrint(bash: "mkdir -p \(root)/Config/secrets")

    // Read sample file
    let sampleFile = try open(samplePath)
    var contents: String = sampleFile.read()

    // Configure
    contents = contents.replacingOccurrences(of: "{host}", with: host)
    contents = contents.replacingOccurrences(of: "{user}", with: user)
    contents = contents.replacingOccurrences(of: "{password}", with: password)
    contents = contents.replacingOccurrences(of: "{database}", with: database)
    contents = contents.replacingOccurrences(of: "\"{port}\"", with: port)

    // Write to dest file
    let file = try open(forWriting: destPath)
    file.print(contents)
  }
}
