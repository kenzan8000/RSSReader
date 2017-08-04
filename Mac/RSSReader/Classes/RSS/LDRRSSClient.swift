import Cocoa


/// MARK: - LDRRSSClient
class LDRRSSClient: NSObject {

    /// MARK: - property
    static let sharedInstance = LDRRSSClient()
    var feedManager: AFURLSessionManager!


    /// MARK: - init

    override init() {
        let configuration = URLSessionConfiguration.background(withIdentifier: LDRNSStringFromClass(LDRRSSClient.self))
        configuration.httpMaximumConnectionsPerHost = 1;
        self.feedManager = AFURLSessionManager(sessionConfiguration: configuration)
        let url = URL(string: "https://github.com/kenzan8000.atom")!
        let dataTask = self.feedManager.dataTask(with: URLRequest(url: url)) { response, data, error in
            LDRLOG("test")
        }
        dataTask.resume()
    }


    /// MARK: - destruction

    deinit {
    }

}

