import Cocoa


/// MARK: - ViewController
class ViewController: NSViewController {

    /// MARK: - property
    override var representedObject: Any? {
        didSet {
        }
    }

    /// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        LDRRSSClient.sharedInstance.requestXMLs(urlStrings: ["https://kenzan8000.org/blog/feed/"])
    }

}

