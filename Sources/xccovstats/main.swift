import Core

do {
  let app = App(arguments: Array(CommandLine.arguments.dropFirst()))
  try app.run()
}
catch {
  print("An unhandled error occurred: \(error)")
}
