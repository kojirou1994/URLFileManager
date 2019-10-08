import Foundation

// MARK: searchEmptyDirectories
extension URLFileManager {
    private enum Parsed {
        case empty
        case onlyFiles
        case onlyDirs([URL])
        case fileAndDirs([URL])
    }
    
    private func parseDirectory(at url: URL) throws -> Parsed {
        let e = try contentsOfDirectory(at: url,
                                    includingPropertiesForKeys: [.isDirectoryKey],
                                    options: [.skipsSubdirectoryDescendants])
        var dirs = [URL]()
        var hasFile = false
        for url in e {
            if try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory! {
                dirs.append(url)
            } else if url.lastPathComponent != ".DS_Store" {
                hasFile = true
            }
        }
        if dirs.isEmpty {
            if hasFile {
                return .onlyFiles
            } else {
                return .empty
            }
        } else {
            if hasFile {
                return .fileAndDirs(dirs)
            } else {
                return .onlyDirs(dirs)
            }
        }
    }
    
    public enum EmptyDirectoryResult {
        case selfEmpty
        case subpaths([URL])
    }
    
    public func searchEmptyDirectories(in url: URL) throws -> EmptyDirectoryResult {
        var r = [URL]()
        switch try parseDirectory(at: url) {
        case .empty:
            return .selfEmpty
        case .onlyFiles:
            break
        case .onlyDirs(let dirs):
            var allEmpty = false
            for dir in dirs {
                let sub = try searchEmptyDirectories(in: dir)
                switch sub {
                case .selfEmpty:
                    r.append(dir)
                case .subpaths(let v):
                    allEmpty = false
                    r.append(contentsOf: v)
                }
            }
            if allEmpty {
                return .selfEmpty
            }
        case .fileAndDirs(let dirs):
            for dir in dirs {
                let sub = try searchEmptyDirectories(in: dir)
                switch sub {
                case .selfEmpty:
                    r.append(dir)
                case .subpaths(let v):
                    r.append(contentsOf: v)
                }
            }
        }
        return .subpaths(r)
    }
}

// MARK: Safe Move Item
extension URLFileManager {
    
    public func moveAndAutoRenameItem(at url: URL, to dstURL: URL,
                                      filenameGenerator: ((String, Int) -> String)? = nil) throws -> URL {
        let dstURL = makeUniqueFileURL(dstURL, filenameGenerator: filenameGenerator)
        
        try moveItem(at: url, to: dstURL)
        return dstURL
    }
    
    public func makeUniqueFileURL(_ url: URL,
                             filenameGenerator: ((String, Int) -> String)? = nil) -> URL {
        var dstURL = url
        let ext = url.pathExtension
        let body = url.deletingPathExtension().lastPathComponent
        var suffix = 2
        let baseURL = url.deletingLastPathComponent()
        
        while fileExistance(at: dstURL).exists {
            dstURL = baseURL
                .appendingPathComponent(filenameGenerator?(body, suffix) ?? "\(body)\(suffix)")
                .appendingPathExtension(ext)
            suffix += 1
        }
        return dstURL
    }
    
}
