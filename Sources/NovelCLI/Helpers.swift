import Foundation
import SwiftShell

func readInput() -> String {
  var string = main.stdin.readSome()?.trimmingCharacters(in: .whitespaces)
  string = string?.replacingOccurrences(of: "\n", with: "")
  return string ?? ""
}
