import Cocoa
import SWXMLHash


/// MARK: - LDRRSS
struct LDRRSS: XMLIndexerDeserializable {
    /// MARK: - property
    let title: String
    let link: URL
    let subtitle: String?
    let entries: [LDRRSSEntry]

    static func deserialize(_ node: XMLIndexer) throws -> LDRRSS {
        var entries: [LDRRSSEntry] = []
        // RSS 1.0
        do {
             for item in node["rdf:RDF"]["item"].all { entries.append(try item.value()) }
            return try LDRRSS(
                title: node["rdf:RDF"]["channel"]["title"].value(),
                link: URL(string: node["rdf:RDF"]["channel"]["link"].value())!,
                subtitle: node["rdf:RDF"]["channel"]["description"].value(),
                entries: node["rdf:RDF"].value()
            )
        }
        catch { }
        // RSS 2.0
        do {
             for item in node["rss"]["channel"]["item"].all { entries.append(try item.value()) }
             return try LDRRSS(
                title: node["rss"]["channel"]["title"].value(),
                link: URL(string: node["rss"]["channel"]["link"].value())!,
                subtitle: node["rss"]["channel"]["description"].value(),
                entries: entries
             )
        }
        catch { }
        // Atom
        for item in node["feed"]["entry"].all { entries.append(try item.value()) }
        return try LDRRSS(
            title: node["feed"]["title"].value(),
            link: URL(string: node["feed"]["link"].value(ofAttribute: "alternate"))!,
            subtitle: node["feed"]["subtitle"].value(),
            entries: entries
        )
    }
}


/// MARK: - LDRRSSEntry
struct LDRRSSEntry: XMLIndexerDeserializable {
    /// MARK: - property
    let title: String
    let link: URL
    let summary: String?
    let updated: Date

    static func deserialize(_ node: XMLIndexer) throws -> LDRRSSEntry {
        // RSS 1.0
        do {
            return try LDRRSSEntry(
                title: node["title"].value(),
                link: URL(string: node["link"].value())!,
                summary: node["description"].value(),
                updated: node["dc"].value(ofAttribute: "date")
            )
        }
        catch { }
        // RSS 2.0
        do {
            return try LDRRSSEntry(
                title: node["title"].value(),
                link: URL(string: node["link"].value())!,
                summary: node["description"].value(),
                updated: node["pubDate"].value()
            )
        }
        catch { }
        // Atom
        return try LDRRSSEntry(
            title: node["title"].value(),
            link: URL(string: node["link"].value(ofAttribute: "alternate"))!,
            summary: node["summary"].value(),
            updated: node["updated"].value()
        )
    }
}
