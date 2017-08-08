import Cocoa


/// MARK: - LDRRSSClient
class LDRRSSClient: NSObject {

    /// MARK: - property
    static let sharedInstance = LDRRSSClient()

    static let maxNumberOfXMLTask = 3
    var XMLManager: AFURLSessionManager!


    /// MARK: - init

    override init() {
        // rss client
        let configuration = URLSessionConfiguration.background(withIdentifier: LDRNSStringFromClass(LDRRSSClient.self))
        configuration.httpMaximumConnectionsPerHost = LDRRSSClient.maxNumberOfXMLTask
        self.XMLManager = AFURLSessionManager(sessionConfiguration: configuration)
        let XMLParserResponseSerializer = AFXMLParserResponseSerializer()
        XMLParserResponseSerializer.acceptableContentTypes = Set<String>(["application/atom+xml", "application/rss+xml", "text/xml", "text/html"])
        self.XMLManager.responseSerializer = XMLParserResponseSerializer
    }


    /// MARK: - destruction

    deinit {
    }


    /// MARK: - public api

    /**
     * request xmls
     *
     * @param urlStrings [String]
     */
    func requestXMLs(urlStrings: [String]) {
        for urlString in urlStrings {
            guard let url = URL(string: urlString) else { continue }
            self.XMLManager.dataTask(with: URLRequest(url: url)) { [unowned self] response, data, error in
                self.executeXMLTasks()
                guard (error == nil) else { return }

                let parser = data as! XMLParser
                parser.delegate = self
                parser.parse()
            }
        }
        self.executeXMLTasks()
    }

    /**
     * cancel all xml requests
     */
    func cancelXMLRequests() {
        DispatchQueue.main.async { [unowned self] in
            for task in self.XMLManager.tasks { task.cancel() }
        }
    }


    /// MARK: - private api

    /**
     * set current xml tasks and execute them
     */
    private func executeXMLTasks() {
        DispatchQueue.main.async { [unowned self] in
            // set concurrent tasks
            var numberOfConcurrentTasks = 0
            for task in self.XMLManager.tasks {
                if numberOfConcurrentTasks >= LDRRSSClient.maxNumberOfXMLTask { return }
                if task.state == .running { numberOfConcurrentTasks += 1 }
                else if task.state == .suspended { task.resume(); numberOfConcurrentTasks += 1 }
            }
        }
    }


}


/// MARK: - XMLParserDelegate
extension LDRRSSClient: XMLParserDelegate {

    func parserDidStartDocument(_ parser: XMLParser) {

    }

    func parserDidEndDocument(_ parser: XMLParser) {

    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        LDRLOG(elementName)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        LDRLOG(string)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        LDRLOG(elementName)
    }

}
