import Cocoa
import SWXMLHash


/// MARK: - Date+XMLAttributeDeserializable
extension Date: XMLAttributeDeserializable {

    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        let dateAsString = attribute.text

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        let date = dateFormatter.date(from: dateAsString)

        guard let validDate = date else {
           throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }

        return value(date: validDate)
    }

    private static func value<T>(date: Date) -> T {
        return date as! T
    }

}
