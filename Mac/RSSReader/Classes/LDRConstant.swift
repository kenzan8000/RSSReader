/// MARK: - User Defaults

struct LDRUserDefaults {
}


/// MARK: - NotificationCenter

struct LDRNotificationCenter {
}


///// MARK: - Error
//enum LDRError: Error {
//}


/// MARK: - function

/**
 * display log
 *
 * @param body log
 */
func LDRLOG(_ body: Any) {
#if DEBUG
    print(body)
#endif
}

/**
 * return class name
 *
 * @param classType classType
 * @return class name
 */
func LDRNSStringFromClass(_ classType: AnyClass) -> String {
    let classString = NSStringFromClass(classType)
    let range = classString.range(of: ".")
    return classString.substring(from: range!.upperBound)
}
