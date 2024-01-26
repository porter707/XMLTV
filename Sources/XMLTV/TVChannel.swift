import Foundation

public struct TVChannel: Hashable {

    public let id: String
    public let name: String?
    public let url: String?
    public let icon: String?

    public init(id: String, name: String?, url: String?, icon: String?) {
        self.id = id
        self.name = name
        self.url = url
        self.icon = icon
    }
}
