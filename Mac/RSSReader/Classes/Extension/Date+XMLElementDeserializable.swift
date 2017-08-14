import Cocoa
import SWXMLHash


/// MARK: - Date+XMLElementDeserializable
extension Date: XMLElementDeserializable {

    public static func deserialize(_ element: SWXMLHashXMLElement) throws -> Date {
        let dateAsString = element.text

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        let date = dateFormatter.date(from: dateAsString)

        guard let validDate = date else {
           throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }

        return value(date: validDate)
    }

    private static func value<T>(date: Date) -> T {
        return date as! T
    }
}
