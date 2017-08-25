import Cocoa
import CloudKit


/// MARK: - LDRRSSClient
class LDRRSSClient: NSObject {

    /// MARK: - property
    static let sharedInstance = LDRRSSClient()

    static let maxNumberOfXMLTask = 3
    var XMLManager: AFURLSessionManager!
    var rssList: [LDRRSS] = []


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

                let rssParser = LDRRSSParser(xmlParser: data as! XMLParser)
                rssParser.delegate = self
                rssParser.parse()
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

    /**
     * load from cloud
     */
    private func load() {
    }

    /**
     * save on cloud
     *
     * @param rss [LDRRSS]
     */
    private func save(rss: LDRRSS) {
/*
        let feed = CKRecord(recordType: "RSSFeeds")
        feed["title"] = rss.title as NSString
        feed["link"] = rss.link.absoluteString as NSString
        if rss.subtitle != nil { feed["subtitle"] = rss.subtitle! as NSString }

        var entries: [CKRecord] = []
        for rssEntry in rss.entries {
            let entry = CKRecord(recordType: "RSSEntries")
            entry["title"] = rssEntry.title as NSString
            entry["link"] = rssEntry.link.absoluteString as NSString
            if (rssEntry.summary != nil) { entry["summary"] = rssEntry.summary! as NSString }
            entry["updated"] = rssEntry.updated as NSDate
            entries.append(entry)
        }

        let collection = CKContainer.default().publicCloudDatabase
        collection.save(feed, completionHandler: { (record: CKRecord?, error: NSError?) in
            if error != nil {
                return
            }
        } as! (CKRecord?, Error?) -> Void)
*/
    }

}


/// MARK: - LDRRSSParserDelegate
extension LDRRSSClient: LDRRSSParserDelegate {

    func parserDidEndParse(parser: LDRRSSParser) {
        if parser.rss == nil { return }

        // add new feed or update feed
        let newRss = parser.rss!
        let index = self.rssList.index(where: { (item) -> Bool in
            item.link == newRss.link
        })
        // update feed
        if (index != nil) {
            // merge new entries and unread old entries
            let oldRss = self.rssList[index!]
            var unreadEntries: [LDRRSSEntry] = []
            for oldEntry in oldRss.entries {
                let newEntries = newRss.entries.filter { $0.link == oldEntry.link }
                if newEntries.count > 0 { continue }
                unreadEntries.append(oldEntry)
            }
            unreadEntries.append(contentsOf: newRss.entries)
            self.rssList[index!] = LDRRSS(
                title: newRss.title,
                link: newRss.link,
                subtitle: newRss.subtitle,
                entries: unreadEntries
            )
        }
        // add new feed
        else { self.rssList.append(newRss) }
    }

}
