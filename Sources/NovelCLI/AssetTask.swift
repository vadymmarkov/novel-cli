import Foundation
import SwiftShell

struct AssetTask: Task {

  let root: String

  func execute() throws {
    // Create public dirs if they do not already exist
    try runAndPrint(bash: "mkdir -p \(root)/Public/css")
    try runAndPrint(bash: "mkdir -p \(root)/Public/fonts")
    try runAndPrint(bash: "mkdir -p \(root)/Public/images")
    try runAndPrint(bash: "mkdir -p \(root)/Public/js")

    // Copy admin css
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/css/vendor.css \(root)/Public/css")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/css/admin.css \(root)/Public/css")

    // Copy admin js
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/vendor.js \(root)/Public/js")
    try runAndPrint(bash: "cp \(root)/Packages/Novel-*/Public/js/admin.js \(root)/Public/js")

    // Copy admin fonts
    try runAndPrint(bash: "cp -a \(root)/Packages/Novel-*/Public/fonts/. \(root)/Public/fonts")

    // Copy admin images
    try runAndPrint(bash: "cp -a \(root)/Packages/Novel-*/Public/images/. \(root)/Public/images")

    // Copy admin views
    try runAndPrint(bash: "cp -rf \(root)/Packages/Novel-*/Resources/Views/admin \(root)/Resources/Views")
  }
}
