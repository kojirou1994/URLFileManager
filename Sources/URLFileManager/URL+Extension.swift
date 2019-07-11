import Foundation

public extension URL {
    
    var lastPathComponentWithoutExtension: String {
        deletingPathExtension().lastPathComponent
    }
    
    func replacingPathExtension(with ext: String) -> URL {
        deletingPathExtension().appendingPathExtension(ext)
    }
    
}
