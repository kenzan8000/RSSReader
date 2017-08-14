import Cocoa
import SWXMLHash


/// MARK: - LDRRSS
struct LDRRSS: XMLIndexerDeserializable {
    /// MARK: - property
        // feed
    let title: String
    let link: URL
        // entries

    static func deserialize(_ node: XMLIndexer) throws -> LDRRSS {
        return try LDRRSS(
           title: node["rss"]["title"].value(),
           link: URL(string: node["rss"]["link"].value())!
        )
    }
}


/// MARK: - LDRRSSEntry
struct LDRRSSEntry: XMLIndexerDeserializable {

    static func deserialize(_ node: XMLIndexer) throws -> LDRRSSEntry {
        return try LDRRSSEntry(
        )
    }
}
