import Cocoa
import Foundation

class MusicMonitor {
    let outputFile = "/tmp/music_info.txt"
    var lastInfo: [AnyHashable: Any] = [:]
    
    init() {
        // 监听通知
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(musicChanged),
            name: NSNotification.Name("com.apple.Music.playerInfo"),
            object: nil
        )
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(musicChanged),
            name: NSNotification.Name("com.apple.iTunes.playerInfo"),
            object: nil
        )
        
        print("Music monitor started - writing to \(outputFile)")
    }
    
    @objc func musicChanged(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        
        let title = info["Name" as AnyHashable] as? String ?? ""
        let artist = info["Artist" as AnyHashable] as? String ?? ""
        let album = info["Album" as AnyHashable] as? String ?? ""
        let state = info["Player State" as AnyHashable] as? String ?? ""
        
        // 写入文件
        let content = """
        title:\(title)
        artist:\(artist)
        album:\(album)
        state:\(state)
        timestamp:\(Date())
        """
        
        do {
            try content.write(toFile: outputFile, atomically: true, encoding: .utf8)
            print("Updated: \(title) - \(artist)")
        } catch {
            print("Error writing file: \(error)")
        }
    }
}

let monitor = MusicMonitor()
RunLoop.current.run()

