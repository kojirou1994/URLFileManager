import Foundation

public extension URL {

    @inlinable
    var lastPathComponentWithoutExtension: String {
        deletingPathExtension().lastPathComponent
    }

    @inlinable
    func replacingPathExtension(with ext: String) -> URL {
        deletingPathExtension().appendingPathExtension(ext)
    }
    
}
