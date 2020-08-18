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

}
