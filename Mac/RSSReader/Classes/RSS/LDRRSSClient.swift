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
        let XMLParserResponseSerializer = AFXMLParserResponseSerializer()
        XMLParserResponseSerializer.acceptableContentTypes = Set<String>(["application/atom+xml", "application/rss+xml", "text/xml", "text/html"])
        self.feedManager.responseSerializer = XMLParserResponseSerializer
        let url = URL(string: "https://github.com/kenzan8000.atom")!
        var request = URLRequest(url: url)
        //request.setValue("application/atom+xml", forHTTPHeaderField: "Content-Type")
        let dataTask = self.feedManager.dataTask(with: request) { response, data, error in

        }
        dataTask.resume()
    }


    /// MARK: - destruction

    deinit {
    }

}

