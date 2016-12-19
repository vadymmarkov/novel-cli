import Commander
import SwiftShell

struct AssetTask {

  func execute() throws {
    try runAndPrint(bash: "mkdir -p Public/css")
    try runAndPrint(bash: "mkdir -p Public/fonts")
    try runAndPrint(bash: "mkdir -p Public/images")
    try runAndPrint(bash: "mkdir -p Public/js")

    try runAndPrint(bash: "cp Packages/Novel-*/Public/css/vendor.css Public/css")
    try runAndPrint(bash: "cp Packages/Novel-*/Public/css/admin.css Public/css")
    try runAndPrint(bash: "cp -a Packages/Novel-*/Public/fonts/. Public/fonts")
    try runAndPrint(bash: "cp -a Packages/Novel-*/Public/images/. Public/images")
    try runAndPrint(bash: "cp Packages/Novel-*/Public/js/vendor.css Public/js")
    try runAndPrint(bash: "cp Packages/Novel-*/Public/js/admin.css Public/js")
  }
}

Group {
  $0.command("new") { (name: String) in
    print("Cloning template...")
    try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")
    try runAndPrint(bash: "cd \(name)")
    try runAndPrint(bash: "swift build")
    try AssetTask().execute()
  }

  $0.command("update") {
    print("Updating Novel")
    try runAndPrint(bash: "swift package update")
    try AssetTask().execute()
  }
}.run()
