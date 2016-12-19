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
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/vendor.css \(root)/Public/js")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/admin.css \(root)/Public/js")
  }
}

Group {
  $0.command("new") { (name: String) in
    print("Cloning template...")
    try runAndPrint(bash: "git clone https://github.com/vadymmarkov/novel-template \(name)")
    try runAndPrint(bash: "swift build --chdir \(name)")
    try AssetTask(root: name).execute()
  }

  $0.command("update") {
    print("Updating Novel")
    try runAndPrint(bash: "swift package update")
    try AssetTask(root: ".").execute()
  }
}.run()
