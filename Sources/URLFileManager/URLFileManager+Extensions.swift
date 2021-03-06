import Foundation

// MARK: searchEmptyDirectories
extension URLFileManager {
  private enum ParsedDirectoryContent {
    case empty
    case onlyFiles
    case onlyDirs(dirs: [URL])
    case fileAndDirs(dirs: [URL])
  }

  private func parseDirectory(at url: URL, ignoreHiddenFile: Bool) throws -> ParsedDirectoryContent
  {
    let allContents = try contentsOfDirectory(
      at: url,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: ignoreHiddenFile ? [.skipsHiddenFiles] : [])
    var dirs = [URL]()
    var hasFile = false
    for url in allContents {
      if try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory! {
        dirs.append(url)
      } else {
        hasFile = true
      }
    }
    if dirs.isEmpty {
      return hasFile ? .onlyFiles : .empty
    } else {
      return hasFile ? .fileAndDirs(dirs: dirs) : .onlyDirs(dirs: dirs)
    }
  }

  public struct EmptyDirectoryResult {
    public let subDirectories: [URL]
    public let isEmptyRootDir: Bool
  }

  public func searchEmptyDirectories(in url: URL, ignoreHiddenFile: Bool) throws
    -> EmptyDirectoryResult
  {
    var emptyDirectories = [URL]()
    switch try parseDirectory(at: url, ignoreHiddenFile: ignoreHiddenFile) {
    case .empty:
      return .init(subDirectories: [], isEmptyRootDir: true)
    case .onlyFiles:
      break
    case .onlyDirs(let dirs):
      var allEmpty = true
      for dir in dirs {
        let subResult = try searchEmptyDirectories(in: dir, ignoreHiddenFile: ignoreHiddenFile)
        if subResult.isEmptyRootDir {
          emptyDirectories.append(dir)
        } else {
          allEmpty = false
          emptyDirectories.append(contentsOf: subResult.subDirectories)
        }
      }
      if allEmpty {
        return .init(subDirectories: dirs, isEmptyRootDir: true)
      }
    case .fileAndDirs(let dirs):
      for dir in dirs {
        let subResult = try searchEmptyDirectories(in: dir, ignoreHiddenFile: ignoreHiddenFile)
        if subResult.isEmptyRootDir {
          emptyDirectories.append(dir)
        } else {
          emptyDirectories.append(contentsOf: subResult.subDirectories)
        }
      }
    }
    return .init(subDirectories: emptyDirectories, isEmptyRootDir: false)
  }
}

// MARK: Safe Move Item
extension URLFileManager {

  public func moveAndAutoRenameItem(
    at url: URL, to dstURL: URL,
    filenameGenerator: ((String, Int) -> String)? = nil
  ) throws -> URL {
    let dstURL = makeUniqueFileURL(dstURL, filenameGenerator: filenameGenerator)

    try moveItem(at: url, to: dstURL)
    return dstURL
  }

  public func makeUniqueFileURL(
    _ url: URL,
    filenameGenerator: ((String, Int) -> String)? = nil
  ) -> URL {
    var dstURL = url
    let ext = url.pathExtension
    let body = url.deletingPathExtension().lastPathComponent
    var suffix = 2
    let baseURL = url.deletingLastPathComponent()

    while fileExistance(at: dstURL).exists {
      dstURL =
        baseURL
        .appendingPathComponent(filenameGenerator?(body, suffix) ?? "\(body)\(suffix)")
        .appendingPathExtension(ext)
      suffix += 1
    }
    return dstURL
  }

}

// MARK: BATCH WORKING
extension URLFileManager {

  private static let keys: Set<URLResourceKey> = [
    .isDirectoryKey, .isRegularFileKey, .isSymbolicLinkKey,
  ]

  private static let keysArray = Array(keys)

  /// symbolic is treat as normal file
  public func forEachContent(
    in url: URL, handleFile: Bool = true, handleDirectory: Bool = true,
    skipHiddenFiles: Bool = false,
    body: (URL) throws -> Void
  ) rethrows -> Bool {
    guard let values = try? url.resourceValues(forKeys: Self.keys) else {
      return false
    }
    if (values.isRegularFile! || values.isSymbolicLink!) && handleFile {
      try withAutoreleasepool { try body(url) }
    } else if values.isDirectory! {
      guard let enumerator = self.enumerator(
              at: url,
              includingPropertiesForKeys: Self.keysArray,
              options: skipHiddenFiles ? .skipsHiddenFiles : []) else {
        return false
      }

      #if canImport(Darwin)
      var iterator = enumerator.makeIterator()
      #else
      let iterator = enumerator.makeIterator()
      #endif
      while let content = withAutoreleasepool(invoking: { iterator.next() as? URL }) {
        guard let contentValues = try? content.resourceValues(forKeys: Self.keys) else {
          continue
        }
        if ((contentValues.isRegularFile! || contentValues.isSymbolicLink!) && handleFile)
          || (contentValues.isDirectory! && handleDirectory) {
          try withAutoreleasepool { try body(content) }
        }
      }
      if handleDirectory {
        try withAutoreleasepool { try body(url) }
      }
    } else {
      return false
    }
    return true
  }

}

// MARK: Convenience functions
extension URLFileManager {

  @available(iOS 11.0, *)
  public func deleteItem(at url: URL, trashIfAvailable: Bool) throws {
    #if os(macOS) || os(iOS)
    if trashIfAvailable {
      try trashItem(at: url)
    } else {
      try removeItem(at: url)
    }
    #else
    try removeItem(at: url)
    #endif
  }

  public func copyItem(at srcURL: URL, toDirectory directoryURL: URL) throws {
    let dstURL = directoryURL.appendingPathComponent(srcURL.lastPathComponent)
    try fileManager.copyItem(at: srcURL, to: dstURL)
  }

  public func moveItem(at srcURL: URL, toDirectory directoryURL: URL) throws {
    let dstURL = directoryURL.appendingPathComponent(srcURL.lastPathComponent)
    try fileManager.moveItem(at: srcURL, to: dstURL)
  }

}
