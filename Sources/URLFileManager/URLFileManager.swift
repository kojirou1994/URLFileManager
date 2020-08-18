import Foundation

public final class URLFileManager {

  public let fileManager: FileManager

  public init(_ fileManager: FileManager? = nil) {
    self.fileManager = fileManager ?? FileManager.default
  }

  public static let `default` = URLFileManager()

}

// MARK: Accessing User Directories
public extension URLFileManager {

  #if os(macOS)
  @available(macOS 10.12, *)
  var homeDirectoryForCurrentUser: URL {
    fileManager.homeDirectoryForCurrentUser
  }

  @available(macOS 10.12, *)
  func homeDirectory(forUser userName: String) -> URL? {
    fileManager.homeDirectory(forUser: userName)
  }
  #endif

  @available(tvOS 10.0, watchOS 3.0, iOS 10.0, macOS 10.12, *)
  var temporaryDirectory: URL {
    fileManager.temporaryDirectory
  }

}

// MARK: Locating System Directories
public extension URLFileManager {

  func url(
    for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask,
    appropriateFor url: URL?, create shouldCreate: Bool
  ) throws -> URL {
    try fileManager.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
  }

  func urls(
    for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask
  ) -> [URL] {
    fileManager.urls(for: directory, in: domainMask)
  }

  #if canImport(Darwin)
  func nsOpenStepRootDirectory() -> URL {
    URL(fileURLWithPath: NSOpenStepRootDirectory(), isDirectory: true)
  }
  #endif

}

// MARK: Locating Application Group Container Directories
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {

  func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
  {
    fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
  }

}
#endif

// MARK: Discovering Directory Contents
public extension URLFileManager {

  func contentsOfDirectory(
    at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil,
    options mask: FileManager.DirectoryEnumerationOptions = []
  ) throws -> [URL] {
    try withAutoreleasepool {
      try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
    }
  }

  func enumerator(
    at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil,
    options mask: FileManager.DirectoryEnumerationOptions = [],
    errorHandler handler: ((URL, Error) -> Bool)? = nil
  ) -> FileManager.DirectoryEnumerator? {
    fileManager.enumerator(
      at: url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler)
  }

  func mountedVolumeURLs(
    includingResourceValuesForKeys propertyKeys: [URLResourceKey]? = nil,
    options: FileManager.VolumeEnumerationOptions = []
  ) -> [URL]? {
    fileManager.mountedVolumeURLs(includingResourceValuesForKeys: propertyKeys, options: options)
  }

  func subpathsOfDirectory(atURL url: URL) throws -> [String] {
    try fileManager.subpathsOfDirectory(atPath: url.path)
  }

}

// MARK: Creating and Deleting Items
public extension URLFileManager {

  func createDirectory(
    at url: URL, withIntermediateDirectories: Bool = true,
    attributes: [FileAttributeKey: Any]? = nil
  ) throws {
    try fileManager.createDirectory(
      at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
  }

  func createFile(
    at url: URL, contents data: Data? = nil, attributes attr: [FileAttributeKey: Any]? = nil
  ) -> Bool {
    fileManager.createFile(atPath: url.path, contents: data, attributes: attr)
  }

  func removeItem(at url: URL) throws {
    try fileManager.removeItem(at: url)
  }

  #if os(macOS) || os(iOS)
  @inlinable @discardableResult
  @available(iOS 11.0, *)
  func trashItem(at url: URL) throws -> URL {
    try autoreleasepool {
      var resultingItemURL: NSURL!
      try fileManager.trashItem(at: url, resultingItemURL: &resultingItemURL)
      return resultingItemURL as URL
    }
  }
  #endif

}

// MARK: Replacing Items
public extension URLFileManager {

  func replaceItemAt(
    _ originalItemURL: URL, withItemAt newItemURL: URL, backupItemName: String? = nil,
    options: FileManager.ItemReplacementOptions = []
  ) throws -> URL? {
    try fileManager.replaceItemAt(
      originalItemURL, withItemAt: newItemURL, backupItemName: backupItemName, options: options)
  }

}

// MARK: Moving and Copying Items
public extension URLFileManager {

  func copyItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.copyItem(at: srcURL, to: dstURL)
  }

  func moveItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.moveItem(at: srcURL, to: dstURL)
  }

}

// MARK: Managing iCloud-Based Items
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
public extension URLFileManager {

  var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)? {
    fileManager.ubiquityIdentityToken
  }

  func url(forUbiquityContainerIdentifier containerIdentifier: String?) -> URL? {
    fileManager.url(forUbiquityContainerIdentifier: containerIdentifier)
  }

  func isUbiquitousItem(at url: URL) -> Bool {
    fileManager.isUbiquitousItem(at: url)
  }

  func setUbiquitous(_ flag: Bool, itemAt url: URL, destinationURL: URL) throws {
    try fileManager.setUbiquitous(flag, itemAt: url, destinationURL: destinationURL)
  }

  func startDownloadingUbiquitousItem(at url: URL) throws {
    try fileManager.startDownloadingUbiquitousItem(at: url)
  }

  func evictUbiquitousItem(at url: URL) throws {
    try fileManager.evictUbiquitousItem(at: url)
  }

  func url(
    forPublishingUbiquitousItemAt url: URL,
    expiration outDate: AutoreleasingUnsafeMutablePointer<NSDate?>?
  ) throws -> URL {
    try fileManager.url(forPublishingUbiquitousItemAt: url, expiration: outDate)
  }

}
#endif

// MARK: Accessing File Provider Services
public extension URLFileManager {

  #if os(macOS) || os(iOS)
  @available(iOS 11.0, macOS 10.13, *)
  func getFileProviderServicesForItem(
    at url: URL,
    completionHandler: @escaping ([NSFileProviderServiceName: NSFileProviderService]?, Error?) ->
      Void
  ) {
    fileManager.getFileProviderServicesForItem(at: url, completionHandler: completionHandler)
  }
  #endif

}

// MARK: Creating Symbolic and Hard Links
public extension URLFileManager {

  func createSymbolicLink(at url: URL, withDestinationURL destURL: URL) throws {
    try fileManager.createSymbolicLink(at: url, withDestinationURL: destURL)
  }

  func linkItem(at srcURL: URL, to dstURL: URL) throws {
    try fileManager.linkItem(at: srcURL, to: dstURL)
  }

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

  func isReadableFile(at url: URL) -> Bool {
    fileManager.isReadableFile(atPath: url.path)
  }

  func isWritableFile(at url: URL) -> Bool {
    fileManager.isWritableFile(atPath: url.path)
  }

  func isExecutableFile(at url: URL) -> Bool {
    fileManager.isExecutableFile(atPath: url.path)
  }

  func isDeletableFile(at url: URL) -> Bool {
    fileManager.isDeletableFile(atPath: url.path)
  }

}

// MARK: Getting and Setting Attributes
public extension URLFileManager {

  func componentsToDisplay(forURL url: URL) -> [String]? {
    fileManager.componentsToDisplay(forPath: url.path)
  }

  func displayName(atURL url: URL) -> String {
    fileManager.displayName(atPath: url.path)
  }

  func attributesOfItem(atURL url: URL) throws -> [FileAttributeKey: Any] {
    try fileManager.attributesOfItem(atPath: url.path)
  }

  func attributesOfFileSystem(forURL url: URL) throws -> [FileAttributeKey: Any] {
    try fileManager.attributesOfFileSystem(forPath: url.path)
  }

  func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtURL url: URL) throws {
    try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
  }

}

// MARK: Getting and Comparing File Contents
public extension URLFileManager {

  func contents(atURL url: URL) -> Data? {
    withAutoreleasepool {
      fileManager.contents(atPath: url.path)
    }
  }

  func contentsEqual(atURL url1: URL, andURL url2: URL) -> Bool {
    fileManager.contentsEqual(atPath: url1.path, andPath: url2.path)
  }

}

// MARK: Getting the Relationship Between Items
extension URLFileManager {

  public func getRelationship(ofDirectoryAt directoryURL: URL, toItemAt otherURL: URL) throws
  -> FileManager.URLRelationship
  {
    var re = FileManager.URLRelationship.other
    try fileManager.getRelationship(&re, ofDirectoryAt: directoryURL, toItemAt: otherURL)
    return re
  }

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
public extension URLFileManager {

  func fileSystemRepresentation(withURL url: URL) -> UnsafePointer<Int8> {
    fileManager.fileSystemRepresentation(withPath: url.path)
  }

  func string(withFileSystemRepresentation str: UnsafePointer<Int8>, length len: Int)
  -> String
  {
    fileManager.string(withFileSystemRepresentation: str, length: len)
  }

}

// MARK: Managing the Current Directory
public extension URLFileManager {

  func changeCurrentDirectory(_ url: URL) -> Bool {
    fileManager.changeCurrentDirectoryPath(url.path)
  }

  var currentDirectory: URL {
    .init(fileURLWithPath: fileManager.currentDirectoryPath)
  }

}

#if os(macOS)
// MARK: Unmounting Volumes
@available(macOS 10.11, *)
public extension URLFileManager {

  func unmountVolume(
    at url: URL, options mask: FileManager.UnmountOptions = [],
    completionHandler: @escaping (Error?) -> Void
  ) {
    fileManager.unmountVolume(at: url, options: mask, completionHandler: completionHandler)
  }

}
#endif

@inline(__always)
func withAutoreleasepool<Result>(invoking body: () throws -> Result) rethrows -> Result {
  #if !canImport(Darwin)
  return try body()
  #else
  return try autoreleasepool(invoking: body)
  #endif
}
