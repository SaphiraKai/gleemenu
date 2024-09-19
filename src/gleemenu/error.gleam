pub type Error {
  InvalidResponse(expected: String, found: String)
  ParsingFailed(expected: String, found: String)
  CommandFailed(code: Int, stderr: String)
}

pub fn command_failed(error: #(Int, String)) -> Error {
  CommandFailed(code: error.0, stderr: error.1)
}
