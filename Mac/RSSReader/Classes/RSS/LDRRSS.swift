import Cocoa
import SWXMLHash


/// MARK: - LDRRSS
struct LDRRSS: XMLIndexerDeserializable {
    /// MARK: - property
        // feed
    let title: String
    let link: URL
    let description: String?
        // entries

    static func deserialize(_ node: XMLIndexer) throws -> LDRRSS {
        // RSS 1.0
        do {
            return try LDRRSS(
                title: node["rdf:RDF"]["channel"]["title"].value(),
                link: URL(string: node["rdf:RDF"]["channel"]["link"].value())!,
                description: node["rdf:RDF"]["channel"]["description"].value()
            )
        }
        catch { }
        // RSS 2.0
        do {
             return try LDRRSS(
                title: node["rss"]["channel"]["title"].value(),
                link: URL(string: node["rss"]["channel"]["link"].value())!,
                description: node["rss"]["channel"]["description"].value()
             )
        }
        catch { }
        // Atom
        return try LDRRSS(
            title: node["feed"]["title"].value(),
            link: URL(string: node["feed"]["link"].value(ofAttribute: "alternate"))!,
            description: node["feed"]["subtitle"].value()
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
