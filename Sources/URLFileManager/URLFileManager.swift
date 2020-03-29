import Foundation

public final class URLFileManager {

    public let fileManager: FileManager

    @inlinable
    public init(_ fileManager: FileManager? = nil) {
        self.fileManager = fileManager ?? FileManager.default
    }
    
    public static let `default` = URLFileManager()
    
}

// MARK: Accessing User Directories
public extension URLFileManager {
    
    #if os(macOS)
    @inlinable
    @available(macOS 10.12, *)
    var homeDirectoryForCurrentUser: URL {
        fileManager.homeDirectoryForCurrentUser
    }

    @inlinable
    @available(macOS 10.12, *)
    func homeDirectory(forUser userName: String) -> URL? {
        fileManager.homeDirectory(forUser: userName)
    }
    #endif

    @inlinable
    @available(tvOS 10.0, watchOS 3.0, iOS 10.0, macOS 10.12, *)
    var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }
    
}

// MARK: Locating System Directories
public extension URLFileManager {

    typealias SearchPathDirectory = FileManager.SearchPathDirectory

    typealias SearchPathDomainMask = FileManager.SearchPathDomainMask

    @inlinable
    func url(for directory: SearchPathDirectory, in domain: SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL {
        try fileManager.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
    }

    @inlinable
    func urls(for directory: SearchPathDirectory, in domainMask: SearchPathDomainMask) -> [URL] {
        fileManager.urls(for: directory, in: domainMask)
    }
    
//    func NSSearchPathForDirectoriesInDomains(_ directory: FileManager.SearchPathDirectory, _ domainMask: FileManager.SearchPathDomainMask, _ expandTilde: Bool) -> [String]
    
//    func NSOpenStepRootDirectory() -> String
    
    
}

// MARK: Locating Application Group Container Directories
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {

    @inlinable
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL? {
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    }
    
}
#endif

// MARK: Discovering Directory Contents
public extension URLFileManager {
    
    typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
    
    typealias DirectoryEnumerator = FileManager.DirectoryEnumerator
    
    typealias VolumeEnumerationOptions = FileManager.VolumeEnumerationOptions

    @inlinable
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = []) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
    }
    
    @inlinable
    func enumerator(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = [], errorHandler handler: ((URL, Error) -> Bool)? = nil) -> DirectoryEnumerator? {
        fileManager.enumerator(at: url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler)
    }

    @inlinable
    func mountedVolumeURLs(includingResourceValuesForKeys propertyKeys: [URLResourceKey]? = nil, options: VolumeEnumerationOptions = []) -> [URL]? {
        fileManager.mountedVolumeURLs(includingResourceValuesForKeys: propertyKeys, options: options)
    }

    @inlinable
    func subpathsOfDirectory(atURL url: URL) throws -> [String] {
        try fileManager.subpathsOfDirectory(atPath: url.path)
    }
    
}

// MARK: Creating and Deleting Items
public extension URLFileManager {

    @inlinable
    func createDirectory(at url: URL, withIntermediateDirectories: Bool = true, attributes: [FileAttributeKey : Any]? = nil) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }

    @inlinable
    func createFile(at url: URL, contents data: Data? = nil, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        fileManager.createFile(atPath: url.path, contents: data, attributes: attr)
    }

    @inlinable
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    #if os(macOS) || os(iOS)
    @inlinable
    @available(iOS 11.0, *)
    func trashItem(at url: URL) throws {
        try fileManager.trashItem(at: url, resultingItemURL: nil)
    }
    #endif
    
}

// MARK: Replacing Items
public extension URLFileManager {
    
    typealias ItemReplacementOptions = FileManager.ItemReplacementOptions
    
    func replaceItemAt(_ originalItemURL: URL, withItemAt newItemURL: URL, backupItemName: String? = nil, options: ItemReplacementOptions = []) throws -> URL? {
        try fileManager.replaceItemAt(originalItemURL, withItemAt: newItemURL, backupItemName: backupItemName, options: options)
    }
    
}

// MARK: Moving and Copying Items
public extension URLFileManager {

    @inlinable
    func copyItem(at srcURL: URL, to dstURL: URL) throws {
        try fileManager.copyItem(at: srcURL, to: dstURL)
    }

    @inlinable
    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        try fileManager.moveItem(at: srcURL, to: dstURL)
    }
    
}

// MARK: Managing iCloud-Based Items
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {

    @inlinable
    var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)? {
        fileManager.ubiquityIdentityToken
    }

    @inlinable
    func url(forUbiquityContainerIdentifier containerIdentifier: String?) -> URL? {
        fileManager.url(forUbiquityContainerIdentifier: containerIdentifier)
    }

    @inlinable
    func isUbiquitousItem(at url: URL) -> Bool {
        fileManager.isUbiquitousItem(at: url)
    }

    @inlinable
    func setUbiquitous(_ flag: Bool, itemAt url: URL, destinationURL: URL) throws {
        try fileManager.setUbiquitous(flag, itemAt: url, destinationURL: destinationURL)
    }

    @inlinable
    func startDownloadingUbiquitousItem(at url: URL) throws {
        try fileManager.startDownloadingUbiquitousItem(at: url)
    }

    @inlinable
    func evictUbiquitousItem(at url: URL) throws {
        try fileManager.evictUbiquitousItem(at: url)
    }

    @inlinable
    func url(forPublishingUbiquitousItemAt url: URL, expiration outDate: AutoreleasingUnsafeMutablePointer<NSDate?>?) throws -> URL {
        try fileManager.url(forPublishingUbiquitousItemAt: url, expiration: outDate)
    }
    
}
#endif

// MARK: Accessing File Provider Services
public extension URLFileManager {
    
    #if os(macOS) || os(iOS)
    @inlinable
    @available(iOS 11.0, macOS 10.13, *)
    func getFileProviderServicesForItem(at url: URL, completionHandler: @escaping ([NSFileProviderServiceName : NSFileProviderService]?, Error?) -> Void) {
        fileManager.getFileProviderServicesForItem(at: url, completionHandler: completionHandler)
    }
    #endif
    
}

// MARK: Creating Symbolic and Hard Links
public extension URLFileManager {

    @inlinable
    func createSymbolicLink(at url: URL, withDestinationURL destURL: URL) throws {
        try fileManager.createSymbolicLink(at: url, withDestinationURL: destURL)
    }

    @inlinable
    func linkItem(at srcURL: URL, to dstURL: URL) throws {
        try fileManager.linkItem(at: srcURL, to: dstURL)
    }

    @inlinable
    func destinationOfSymbolicLink(at url: URL) throws -> String {
        try fileManager.destinationOfSymbolicLink(atPath: url.path)
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
        let fileExists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
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

    @inlinable
    func isReadableFile(at url: URL) -> Bool {
        fileManager.isReadableFile(atPath: url.path)
    }

    @inlinable
    func isWritableFile(at url: URL) -> Bool {
        fileManager.isWritableFile(atPath: url.path)
    }

    @inlinable
    func isExecutableFile(at url: URL) -> Bool {
        fileManager.isExecutableFile(atPath: url.path)
    }

    @inlinable
    func isDeletableFile(at url: URL) -> Bool {
        fileManager.isDeletableFile(atPath: url.path)
    }
    
}

// MARK: Getting and Setting Attributes
public extension URLFileManager {

    @inlinable
    func componentsToDisplay(forURL url: URL) -> [String]? {
        fileManager.componentsToDisplay(forPath: url.path)
    }

    @inlinable
    func displayName(atURL url: URL) -> String {
        fileManager.displayName(atPath: url.path)
    }

    @inlinable
    func attributesOfItem(atURL url: URL) throws -> [FileAttributeKey : Any] {
        try fileManager.attributesOfItem(atPath: url.path)
    }

    @inlinable
    func attributesOfFileSystem(forURL url: URL) throws -> [FileAttributeKey : Any] {
        try fileManager.attributesOfFileSystem(forPath: url.path)
    }

    @inlinable
    func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtURL url: URL) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
    }
    
}

// MARK: Getting and Comparing File Contents
public extension URLFileManager {

    @inlinable
    func contents(atURL url: URL) -> Data? {
        fileManager.contents(atPath: url.path)
    }

    @inlinable
    func contentsEqual(atURL url1: URL, andURL url2: URL) -> Bool {
        fileManager.contentsEqual(atPath: url1.path, andPath: url2.path)
    }
    
}

// MARK: Getting the Relationship Between Items
public extension URLFileManager {
    
    typealias URLRelationship = FileManager.URLRelationship

    @inlinable
    func getRelationship(ofDirectoryAt directoryURL: URL, toItemAt otherURL: URL) throws -> URLRelationship {
        var re = URLRelationship.other
        try fileManager.getRelationship(&re, ofDirectoryAt: directoryURL, toItemAt: otherURL)
        return re
    }

    @inlinable
    func getRelationship(of directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask, toItemAt url: URL) throws -> URLRelationship {
        var re = URLRelationship.other
        try fileManager.getRelationship(&re, of: directory, in: domainMask, toItemAt: url)
        return re
    }
    
}

// MARK: Converting File Paths to Strings
public extension URLFileManager {

    @inlinable
    func fileSystemRepresentation(withURL url: URL) -> UnsafePointer<Int8> {
        fileManager.fileSystemRepresentation(withPath: url.path)
    }

    @inlinable
    func string(withFileSystemRepresentation str: UnsafePointer<Int8>, length len: Int) -> String {
        fileManager.string(withFileSystemRepresentation: str, length: len)
    }
    
}

// MARK: Managing the Current Directory
public extension URLFileManager {

    @inlinable
    func changeCurrentDirectory(_ url: URL) -> Bool {
        fileManager.changeCurrentDirectoryPath(url.path)
    }

    @inlinable
    var currentDirectory: URL {
        .init(fileURLWithPath: fileManager.currentDirectoryPath)
    }
    
}

#if os(macOS)
// MARK: Unmounting Volumes
@available(macOS 10.11, *)
public extension URLFileManager {
    
    typealias UnmountOptions = FileManager.UnmountOptions

    @inlinable
    func unmountVolume(at url: URL, options mask: UnmountOptions = [], completionHandler: @escaping (Error?) -> Void) {
        fileManager.unmountVolume(at: url, options: mask, completionHandler: completionHandler)
    }
    
}
#endif
