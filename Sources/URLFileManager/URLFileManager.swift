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
extension URLFileManager {

  #if os(macOS)
  @inlinable
  @available(macOS 10.12, *)
  public var homeDirectoryForCurrentUser: URL {
    fileManager.homeDirectoryForCurrentUser
  }

  @inlinable
  @available(macOS 10.12, *)
  public func homeDirectory(forUser userName: String) -> URL? {
    fileManager.homeDirectory(forUser: userName)
  }
  #endif

  @inlinable
  @available(tvOS 10.0, watchOS 3.0, iOS 10.0, macOS 10.12, *)
  public var temporaryDirectory: URL {
    fileManager.temporaryDirectory
  }

}

// MARK: Locating System Directories
extension URLFileManager {

  @inlinable
  public func url(
    for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask,
    appropriateFor url: URL?, create shouldCreate: Bool
  ) throws -> URL {
    try fileManager.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
  }

  @inlinable
  public func urls(
    for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask
  ) -> [URL] {
    fileManager.urls(for: directory, in: domainMask)
  }

  #if canImport(Darwin)
  @inlinable
  public func nsOpenStepRootDirectory() -> URL {
    URL(fileURLWithPath: NSOpenStepRootDirectory(), isDirectory: true)
  }
  #endif

}

// MARK: Locating Application Group Container Directories
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension URLFileManager {

  @inlinable
  public func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
  {
    fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
  }

}
#endif

// MARK: Discovering Directory Contents
extension URLFileManager {

  @inlinable
  public func contentsOfDirectory(
    at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil,
    options mask: FileManager.DirectoryEnumerationOptions = []
  ) throws -> [URL] {
    try withAutoreleasepool {
      try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
    }
  }

  @inlinable
  public func enumerator(
    at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil,
    options mask: FileManager.DirectoryEnumerationOptions = [],
    errorHandler handler: ((URL, Error) -> Bool)? = nil
  ) -> FileManager.DirectoryEnumerator? {
    fileManager.enumerator(
      at: url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler)
  }

  @inlinable
  public func mountedVolumeURLs(
    includingResourceValuesForKeys propertyKeys: [URLResourceKey]? = nil,
    options: FileManager.VolumeEnumerationOptions = []
  ) -> [URL]? {
    fileManager.mountedVolumeURLs(includingResourceValuesForKeys: propertyKeys, options: options)
  }

  @inlinable
  public func subpathsOfDirectory(atURL url: URL) throws -> [String] {
    try fileManager.subpathsOfDirectory(atPath: url.path)
  }

}

// MARK: Creating and Deleting Items
extension URLFileManager {

  @inlinable
  public func createDirectory(
    at url: URL, withIntermediateDirectories: Bool = true,
    attributes: [FileAttributeKey: Any]? = nil
  ) throws {
    try fileManager.createDirectory(
      at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
  }

  @inlinable
  public func createFile(
    at url: URL, contents data: Data? = nil, attributes attr: [FileAttributeKey: Any]? = nil
  ) -> Bool {
    fileManager.createFile(atPath: url.path, contents: data, attributes: attr)
  }

  @inlinable
  public func removeItem(at url: URL) throws {
    try fileManager.removeItem(at: url)
  }

  #if os(macOS) || os(iOS)
  @inlinable @discardableResult
  @available(iOS 11.0, *)
  public func trashItem(at url: URL) throws -> URL {
    try autoreleasepool {
      var resultingItemURL: NSURL!
      try fileManager.trashItem(at: url, resultingItemURL: &resultingItemURL)
      return resultingItemURL as URL
    }
  }
  #endif

}

// MARK: Replacing Items
extension URLFileManager {

  @inlinable
  public func replaceItemAt(
    _ originalItemURL: URL, withItemAt newItemURL: URL, backupItemName: String? = nil,
    options: FileManager.ItemReplacementOptions = []
  ) throws -> URL? {
    try fileManager.replaceItemAt(
      originalItemURL, withItemAt: newItemURL, backupItemName: backupItemName, options: options)
  }

}

// MARK: Moving and Copying Items
extension URLFileManager {

  @inlinable
  public func copyItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.copyItem(at: srcURL, to: dstURL)
  }

  @inlinable
  public func moveItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.moveItem(at: srcURL, to: dstURL)
  }

}

// MARK: Managing iCloud-Based Items
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension URLFileManager {

  @inlinable
  public var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)? {
    fileManager.ubiquityIdentityToken
  }

  @inlinable
  public func url(forUbiquityContainerIdentifier containerIdentifier: String?) -> URL? {
    fileManager.url(forUbiquityContainerIdentifier: containerIdentifier)
  }

  @inlinable
  public func isUbiquitousItem(at url: URL) -> Bool {
    fileManager.isUbiquitousItem(at: url)
  }

  @inlinable
  public func setUbiquitous(_ flag: Bool, itemAt url: URL, destinationURL: URL) throws {
    try fileManager.setUbiquitous(flag, itemAt: url, destinationURL: destinationURL)
  }

  @inlinable
  public func startDownloadingUbiquitousItem(at url: URL) throws {
    try fileManager.startDownloadingUbiquitousItem(at: url)
  }

  @inlinable
  public func evictUbiquitousItem(at url: URL) throws {
    try fileManager.evictUbiquitousItem(at: url)
  }

  @inlinable
  public func url(
    forPublishingUbiquitousItemAt url: URL,
    expiration outDate: AutoreleasingUnsafeMutablePointer<NSDate?>?
  ) throws -> URL {
    try fileManager.url(forPublishingUbiquitousItemAt: url, expiration: outDate)
  }

}
#endif

// MARK: Accessing File Provider Services
extension URLFileManager {

  #if os(macOS) || os(iOS)
  @inlinable
  @available(iOS 11.0, macOS 10.13, *)
  public func getFileProviderServicesForItem(
    at url: URL,
    completionHandler: @escaping ([NSFileProviderServiceName: NSFileProviderService]?, Error?) ->
    Void
  ) {
    fileManager.getFileProviderServicesForItem(at: url, completionHandler: completionHandler)
  }
  #endif

}

// MARK: Creating Symbolic and Hard Links
extension URLFileManager {

  @inlinable
  public func createSymbolicLink(at url: URL, withDestinationURL destURL: URL) throws {
    try fileManager.createSymbolicLink(at: url, withDestinationURL: destURL)
  }

  @inlinable
  public func linkItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.linkItem(at: srcURL, to: dstURL)
  }

  @inlinable
  public func destinationOfSymbolicLink(at url: URL) throws -> String {
    try fileManager.destinationOfSymbolicLink(atPath: url.path)
  }

}

// MARK: Determining Access to Files
extension URLFileManager {

  public enum FileExistance {
    case none
    case file
    case directory

    public var exists: Bool {
      self != .none
    }
  }

  public func fileExistance(at url: URL) -> FileExistance {
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
  public func isReadableFile(at url: URL) -> Bool {
    fileManager.isReadableFile(atPath: url.path)
  }

  @inlinable
  public func isWritableFile(at url: URL) -> Bool {
    fileManager.isWritableFile(atPath: url.path)
  }

  @inlinable
  public func isExecutableFile(at url: URL) -> Bool {
    fileManager.isExecutableFile(atPath: url.path)
  }

  @inlinable
  public func isDeletableFile(at url: URL) -> Bool {
    fileManager.isDeletableFile(atPath: url.path)
  }

}

// MARK: Getting and Setting Attributes
extension URLFileManager {

  @inlinable
  public func componentsToDisplay(forURL url: URL) -> [String]? {
    fileManager.componentsToDisplay(forPath: url.path)
  }

  @inlinable
  public func displayName(atURL url: URL) -> String {
    fileManager.displayName(atPath: url.path)
  }

  @inlinable
  public func attributesOfItem(atURL url: URL) throws -> [FileAttributeKey: Any] {
    try fileManager.attributesOfItem(atPath: url.path)
  }

  @inlinable
  public func attributesOfFileSystem(forURL url: URL) throws -> [FileAttributeKey: Any] {
    try fileManager.attributesOfFileSystem(forPath: url.path)
  }

  @inlinable
  public func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtURL url: URL) throws {
    try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
  }

}

// MARK: Getting and Comparing File Contents
extension URLFileManager {

  @inlinable
  public func contents(atURL url: URL) -> Data? {
    withAutoreleasepool {
      fileManager.contents(atPath: url.path)
    }
  }

  @inlinable
  public func contentsEqual(atURL url1: URL, andURL url2: URL) -> Bool {
    fileManager.contentsEqual(atPath: url1.path, andPath: url2.path)
  }

}

// MARK: Getting the Relationship Between Items
extension URLFileManager {

  @inlinable
  public func getRelationship(ofDirectoryAt directoryURL: URL, toItemAt otherURL: URL) throws
    -> FileManager.URLRelationship
  {
    var re = FileManager.URLRelationship.other
    try fileManager.getRelationship(&re, ofDirectoryAt: directoryURL, toItemAt: otherURL)
    return re
  }

  @inlinable
  public func getRelationship(
    of directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask,
    toItemAt url: URL
  ) throws -> FileManager.URLRelationship {
    var re = FileManager.URLRelationship.other
    try fileManager.getRelationship(&re, of: directory, in: domainMask, toItemAt: url)
    return re
  }

}

// MARK: Converting File Paths to Strings
extension URLFileManager {

  @inlinable
  public func fileSystemRepresentation(withURL url: URL) -> UnsafePointer<Int8> {
    fileManager.fileSystemRepresentation(withPath: url.path)
  }

  @inlinable
  public func string(withFileSystemRepresentation str: UnsafePointer<Int8>, length len: Int)
    -> String
  {
    fileManager.string(withFileSystemRepresentation: str, length: len)
  }

}

// MARK: Managing the Current Directory
extension URLFileManager {

  @inlinable
  public func changeCurrentDirectory(_ url: URL) -> Bool {
    fileManager.changeCurrentDirectoryPath(url.path)
  }

  @inlinable
  public var currentDirectory: URL {
    .init(fileURLWithPath: fileManager.currentDirectoryPath)
  }

}

#if os(macOS)
// MARK: Unmounting Volumes
@available(macOS 10.11, *)
extension URLFileManager {

  @inlinable
  public func unmountVolume(
    at url: URL, options mask: FileManager.UnmountOptions = [],
    completionHandler: @escaping (Error?) -> Void
  ) {
    fileManager.unmountVolume(at: url, options: mask, completionHandler: completionHandler)
  }

}
#endif

@inline(__always)
@inlinable
func withAutoreleasepool<Result>(invoking body: () throws -> Result) rethrows -> Result {
  #if !canImport(Darwin)
  return try body()
  #else
  return try autoreleasepool(invoking: body)
  #endif
}
