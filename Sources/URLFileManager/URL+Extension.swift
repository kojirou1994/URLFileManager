import Foundation

extension URL {

  public var lastPathComponentWithoutExtension: String {
    deletingPathExtension().lastPathComponent
  }
  
  public func replacingPathExtension(with ext: String) -> URL {
    var new = self
    new.deletePathExtension()
    new.appendPathExtension(ext)
    return new
  }

  public func replacingMainFilename(with filename: String) -> URL {
    var new = self
    new.deleteLastPathComponent()
    new.appendPathComponent(filename)
    new.appendPathExtension(pathExtension)
    return new
  }

  public func relativePath(to baseURL: URL, caseSensitive: Bool = false, separator: String = "/") -> String? {
    func equal(_ l: String, _ r: String) -> Bool {
      if _slowPath(caseSensitive) {
        return l == r
      } else {
        return l.caseInsensitiveCompare(r) == .orderedSame
      }
    }

    let baseComponents = baseURL.pathComponents
    let longComponents = self.pathComponents
    if baseComponents.count > longComponents.count {
      return nil
    }
    for index in baseComponents.indices {
      if !equal(baseComponents[index], longComponents[index]) {
        return nil
      }
    }

    return longComponents.dropFirst(baseComponents.count).joined(separator: separator)
  }

}
