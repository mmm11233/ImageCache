import Foundation
import UIKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private let fileManager = FileManager.default
    private let tempDirectory = NSTemporaryDirectory()
    
    private init() {}
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let filePath = cachePath(for: url)
        
        if fileManager.fileExists(atPath: filePath.path) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: filePath),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                try? data.write(to: filePath)
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
    
    func cachePath(for url: URL) -> URL {
        let fileName = url.lastPathComponent
        return URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
    }
    
    func clearCache() {
        do {
            let tempContents = try fileManager.contentsOfDirectory(atPath: tempDirectory)
            for file in tempContents {
                let filePath = URL(fileURLWithPath: tempDirectory).appendingPathComponent(file)
                try fileManager.removeItem(at: filePath)
            }
            print("cleared")
        } catch {
            print("Failed to clear: \(error)")
        }
    }
}

