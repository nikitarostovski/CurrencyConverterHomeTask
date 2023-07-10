//
//  Storage.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import Foundation

enum StorageError: Error {
    case noAccess
    case writeFailed
    case noFileFound
    case mappingFailed
}

protocol StorageProvider {
    /// Saves an encodable struct to the specified file on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - fileName: what to name the file where the struct data will be stored
    func save<T: Encodable>(_ object: T, as fileName: String) throws
    
    /// Loads a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file
    ///   - type: struct type
    /// - Returns: decoded struct
    func load<T: Decodable>(_ fileName: String, as type: T.Type) throws -> T
}

public class Storage: StorageProvider {
    private var url: URL? {
        let searchPathDirectory: FileManager.SearchPathDirectory = .cachesDirectory
        return FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first
    }
    
    init() {
        
    }
    
    /// Saves an encodable struct to the specified file on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - fileName: what to name the file where the struct data will be stored
    func save<T: Encodable>(_ object: T, as fileName: String) throws {
        guard var url = url else { throw StorageError.noAccess }
        url = url.appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            print(error)
            throw StorageError.writeFailed
        }
    }
    
    /// Loads a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file
    ///   - type: struct type
    /// - Returns: decoded struct
    func load<T: Decodable>(_ fileName: String, as type: T.Type) throws -> T {
        guard var url = url else { throw StorageError.noAccess }
        url = url.appendingPathComponent(fileName, isDirectory: false)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw StorageError.noFileFound
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                print(error)
                throw StorageError.mappingFailed
            }
        } else {
            throw StorageError.noFileFound
        }
    }
    
    /// Deletes specified file if it exists
    func delete(_ fileName: String) throws {
        guard var url = url else { throw StorageError.noAccess }
        url = url.appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    /// Returns true if file exists
    func fileExists(_ fileName: String) throws -> Bool {
        guard var url = url else { throw StorageError.noAccess }
        url = url.appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
