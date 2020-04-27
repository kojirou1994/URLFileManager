import Foundation

extension URL {

  @inlinable
  public var lastPathComponentWithoutExtension: String {
    deletingPathExtension().lastPathComponent
  }

  @inlinable
  public func replacingPathExtension(with ext: String) -> URL {
    var new = self
    new.deletePathExtension()
    new.appendPathExtension(ext)
    return new
  }

}
