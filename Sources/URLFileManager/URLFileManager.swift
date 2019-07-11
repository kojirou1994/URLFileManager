import Foundation

public final class URLFileManager {
    
    private let fm: FileManager
    
    public init(_ fileManager: FileManager? = nil) {
        self.fm = fileManager ?? FileManager.default
    }
    
}

// MARK: Accessing User Directories
public extension URLFileManager {
}
// MARK: Locating System Directories
public extension URLFileManager {
}
// MARK: Locating Application Group Container Directories
public extension URLFileManager {
}

// MARK: Discovering Directory Contents
public extension URLFileManager {
    
    typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
    
    typealias DirectoryEnumerator = FileManager.DirectoryEnumerator
    
    typealias VolumeEnumerationOptions = FileManager.VolumeEnumerationOptions
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = []) throws -> [URL] {
        try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
    }
    
    func enumerator(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = [], errorHandler handler: ((URL, Error) -> Bool)? = nil) -> DirectoryEnumerator? {
        fm.enumerator(at: url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler)
    }
    
    func mountedVolumeURLs(includingResourceValuesForKeys propertyKeys: [URLResourceKey]? = nil, options: VolumeEnumerationOptions = []) -> [URL]? {
        fm.mountedVolumeURLs(includingResourceValuesForKeys: propertyKeys, options: options)
    }
    
    func subpathsOfDirectory(atURL url: URL) throws -> [String] {
        try fm.subpathsOfDirectory(atPath: url.path)
    }
    
}

// MARK: Creating and Deleting Items
public extension URLFileManager {
    
    func createDirectory(at url: URL, withIntermediateDirectories: Bool = true, attributes: [FileAttributeKey : Any]? = nil) throws {
        try fm.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
    
    func createFile(at url: URL, contents data: Data? = nil, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        fm.createFile(atPath: url.path, contents: data, attributes: attr)
    }
    
    func removeItem(at url: URL) throws {
        try fm.removeItem(at: url)
    }
    
    func trashItem(at url: URL) throws {
        try fm.trashItem(at: url, resultingItemURL: nil)
    }
    
}

// MARK: Replacing Items
public extension URLFileManager {
    
    typealias ItemReplacementOptions = FileManager.ItemReplacementOptions
    
    func replaceItemAt(_ originalItemURL: URL, withItemAt newItemURL: URL, backupItemName: String? = nil, options: ItemReplacementOptions = []) throws -> URL? {
        try fm.replaceItemAt(originalItemURL, withItemAt: newItemURL, backupItemName: backupItemName, options: options)
    }
}

// MARK: Moving and Copying Items
public extension URLFileManager {
    
    func copyItem(at srcURL: URL, to dstURL: URL) throws {
        try fm.copyItem(at: srcURL, to: dstURL)
    }
    
    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        try fm.moveItem(at: srcURL, to: dstURL)
    }
    
}

// MARK: Managing iCloud-Based Items
public extension URLFileManager {
}

// MARK: Accessing File Provider Services
public extension URLFileManager {
}

// MARK: Creating Symbolic and Hard Links
public extension URLFileManager {
}

// MARK: Determining Access to Files
public extension URLFileManager {
    
    enum FileExistance {
        case none
        case file
        case directory
        
        public var exists: Bool {
            self != .none
        }
    }
    
    func fileExistance(at url: URL) -> FileExistance {
        var isDirectory: ObjCBool = false
        let fileExists = fm.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if fileExists {
            if isDirectory.boolValue {
                return .directory
            } else {
                return .file
            }
        } else {
            return .none
        }
    }
    
    func isReadableFile(at url: URL) -> Bool {
        fm.isReadableFile(atPath: url.path)
    }
    
    func isWritableFile(at url: URL) -> Bool {
        fm.isWritableFile(atPath: url.path)
    }
    
    func isExecutableFile(at url: URL) -> Bool {
        fm.isExecutableFile(atPath: url.path)
    }
    
    func isDeletableFile(at url: URL) -> Bool {
        fm.isDeletableFile(atPath: url.path)
    }
    
}

// MARK: Getting and Setting Attributes
public extension URLFileManager {
    
    func componentsToDisplay(forURL url: URL) -> [String]? {
        fm.componentsToDisplay(forPath: url.path)
    }
    
    func displayName(atURL url: URL) -> String {
        fm.displayName(atPath: url.path)
    }
    
    func attributesOfItem(atURL url: URL) throws -> [FileAttributeKey : Any] {
        try fm.attributesOfItem(atPath: url.path)
    }
    
    func attributesOfFileSystem(forURL url: URL) throws -> [FileAttributeKey : Any] {
        try fm.attributesOfFileSystem(forPath: url.path)
    }
    
    func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtURL url: URL) throws {
        try fm.setAttributes(attributes, ofItemAtPath: url.path)
    }
    
}

// MARK: Getting and Comparing File Contents
public extension URLFileManager {
    
    func contents(atURL url: URL) -> Data? {
        fm.contents(atPath: url.path)
    }
    
    func contentsEqual(atURL url1: URL, andURL url2: URL) -> Bool {
        fm.contentsEqual(atPath: url1.path, andPath: url2.path)
    }
    
}

// MARK: Getting the Relationship Between Items
public extension URLFileManager {
    
    typealias URLRelationship = FileManager.URLRelationship
    
    func getRelationship(ofDirectoryAt directoryURL: URL, toItemAt otherURL: URL) throws -> URLRelationship {
        var re = URLRelationship.other
        try fm.getRelationship(&re, ofDirectoryAt: directoryURL, toItemAt: otherURL)
        return re
    }
    
    func getRelationship(of directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask, toItemAt url: URL) throws -> URLRelationship {
        var re = URLRelationship.other
        try fm.getRelationship(&re, of: directory, in: domainMask, toItemAt: url)
        return re
    }
    
}

// MARK: Converting File Paths to Strings
public extension URLFileManager {
    
    func fileSystemRepresentation(withURL url: URL) -> UnsafePointer<Int8> {
        fm.fileSystemRepresentation(withPath: url.path)
    }
    
    func string(withFileSystemRepresentation str: UnsafePointer<Int8>, length len: Int) -> String {
        fm.string(withFileSystemRepresentation: str, length: len)
    }
    
}

// MARK: Managing the Current Directory
public extension URLFileManager {
    
    func changeCurrentDirectory(_ url: URL) -> Bool {
        fm.changeCurrentDirectoryPath(url.path)
    }
    
    var currentDirectory: URL {
        .init(fileURLWithPath: fm.currentDirectoryPath)
    }
    
}

// MARK: Unmounting Volumes
@available(OSX 10.11, *)
public extension URLFileManager {
    
    typealias UnmountOptions = FileManager.UnmountOptions
    
    func unmountVolume(at url: URL, options mask: UnmountOptions = [], completionHandler: @escaping (Error?) -> Void) {
        fm.unmountVolume(at: url, options: mask, completionHandler: completionHandler)
    }
    
}



// MARK:
public extension URLFileManager {
}
