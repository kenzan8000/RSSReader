import Cocoa


/// MARK: - LDRRSSParserDelegate
@objc protocol LDRRSSParserDelegate {

    /**
     * called when parse ended
     * @param parser [LDRRSSParser]
     */
    func parserDidEndParse(parser: LDRRSSParser)

}


/// MARK: - LDRRSSParser
class LDRRSSParser: NSObject {

    /// MARK: - property
    weak var delegate: AnyObject?
    var xmlParser: XMLParser!


    /// MARK: - init

    init(xmlParser: XMLParser) {
        self.xmlParser = xmlParser
    }


    /// MARK: - destruction

    deinit {
    }


    /// MARK: - public api

    /**
     * parse
     */
    func parse() {
        self.xmlParser.delegate = self
        self.xmlParser.parse()
    }


    /// MARK: - private api

}


/// MARK: - XMLParserDelegate
extension LDRRSSParser: XMLParserDelegate {

    func parserDidStartDocument(_ parser: XMLParser) {

    }

    func parserDidEndDocument(_ parser: XMLParser) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(LDRRSSParserDelegate.parserDidEndParse)) {
            (self.delegate as! LDRRSSParserDelegate).parserDidEndParse(parser: self)
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        LDRLOG("<\(elementName)>")
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        LDRLOG(string)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        LDRLOG("</\(elementName)>")
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(LDRRSSParserDelegate.parserDidEndParse)) {
            (self.delegate as! LDRRSSParserDelegate).parserDidEndParse(parser: self)
        }
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(LDRRSSParserDelegate.parserDidEndParse)) {
            (self.delegate as! LDRRSSParserDelegate).parserDidEndParse(parser: self)
        }
    }

}
