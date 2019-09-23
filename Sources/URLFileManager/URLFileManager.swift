import Foundation

public final class URLFileManager {
    
    private let fm: FileManager
    
    public init(_ fileManager: FileManager? = nil) {
        self.fm = fileManager ?? FileManager.default
    }
    
    public static let `default` = URLFileManager()
    
}

// MARK: Accessing User Directories
public extension URLFileManager {
    
    #if os(macOS)
    @available(OSX 10.12, *)
    var homeDirectoryForCurrentUser: URL {
        fm.homeDirectoryForCurrentUser
    }
    
    @available(OSX 10.12, *)
    func homeDirectory(forUser userName: String) -> URL? {
        fm.homeDirectory(forUser: userName)
    }
    #endif
    
    @available(tvOS 10.0, *)
    @available(watchOS 3.0, *)
    @available(iOS 10.0, *)
    @available(OSX 10.12, *)
    var temporaryDirectory: URL {
        fm.temporaryDirectory
    }
    
}

// MARK: Locating System Directories
public extension URLFileManager {
    
    typealias SearchPathDirectory = FileManager.SearchPathDirectory
    
    typealias SearchPathDomainMask = FileManager.SearchPathDomainMask
    
    @available(OSX 10.6, *)
    func url(for directory: SearchPathDirectory, in domain: SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL {
        try fm.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
    }
    
    @available(OSX 10.6, *)
    func urls(for directory: SearchPathDirectory, in domainMask: SearchPathDomainMask) -> [URL] {
        fm.urls(for: directory, in: domainMask)
    }
    
//    func NSSearchPathForDirectoriesInDomains(_ directory: FileManager.SearchPathDirectory, _ domainMask: FileManager.SearchPathDomainMask, _ expandTilde: Bool) -> [String]
    
//    func NSOpenStepRootDirectory() -> String
    
    
}

// MARK: Locating Application Group Container Directories
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {
    
    @available(OSX 10.8, *)
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL? {
        fm.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    }
    
}
#endif

// MARK: Discovering Directory Contents
public extension URLFileManager {
    
    typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
    
    typealias DirectoryEnumerator = FileManager.DirectoryEnumerator
    
    typealias VolumeEnumerationOptions = FileManager.VolumeEnumerationOptions
    
    @available(OSX 10.6, *)
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = []) throws -> [URL] {
        try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
    }
    
    @available(OSX 10.6, *)
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
    
    #if os(macOS) || os(iOS)
    @available(iOS 11.0, *)
    func trashItem(at url: URL) throws {
        try fm.trashItem(at: url, resultingItemURL: nil)
    }
    #endif
    
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
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {
    
    var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)? {
        fm.ubiquityIdentityToken
    }
    
    func url(forUbiquityContainerIdentifier containerIdentifier: String?) -> URL? {
        fm.url(forUbiquityContainerIdentifier: containerIdentifier)
    }
    
    func isUbiquitousItem(at url: URL) -> Bool {
        fm.isUbiquitousItem(at: url)
    }
    
    func setUbiquitous(_ flag: Bool, itemAt url: URL, destinationURL: URL) throws {
        try fm.setUbiquitous(flag, itemAt: url, destinationURL: destinationURL)
    }
    
    func startDownloadingUbiquitousItem(at url: URL) throws {
        try fm.startDownloadingUbiquitousItem(at: url)
    }
    
    func evictUbiquitousItem(at url: URL) throws {
        try fm.evictUbiquitousItem(at: url)
    }
    
    func url(forPublishingUbiquitousItemAt url: URL, expiration outDate: AutoreleasingUnsafeMutablePointer<NSDate?>?) throws -> URL {
        try fm.url(forPublishingUbiquitousItemAt: url, expiration: outDate)
    }
    
}
#endif

// MARK: Accessing File Provider Services
public extension URLFileManager {
    
    #if os(macOS) || os(iOS)
    @available(iOS 11.0, *)
    @available(OSX 10.13, *)
    func getFileProviderServicesForItem(at url: URL, completionHandler: @escaping ([NSFileProviderServiceName : NSFileProviderService]?, Error?) -> Void) {
        fm.getFileProviderServicesForItem(at: url, completionHandler: completionHandler)
    }
    #endif
    
}

// MARK: Creating Symbolic and Hard Links
public extension URLFileManager {
    
    func createSymbolicLink(at url: URL, withDestinationURL destURL: URL) throws {
        try fm.createSymbolicLink(at: url, withDestinationURL: destURL)
    }
    
    func linkItem(at srcURL: URL, to dstURL: URL) throws {
        try fm.linkItem(at: srcURL, to: dstURL)
    }
    
    func destinationOfSymbolicLink(at url: URL) throws -> String {
        try fm.destinationOfSymbolicLink(atPath: url.path)
    }
    
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

#if os(macOS)
// MARK: Unmounting Volumes
@available(OSX 10.11, *)
public extension URLFileManager {
    
    typealias UnmountOptions = FileManager.UnmountOptions
    
    func unmountVolume(at url: URL, options mask: UnmountOptions = [], completionHandler: @escaping (Error?) -> Void) {
        fm.unmountVolume(at: url, options: mask, completionHandler: completionHandler)
    }
    
}
#endif
