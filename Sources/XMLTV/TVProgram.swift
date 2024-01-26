import Foundation

public struct TVProgram {

    public let startStr: String?
    public let stopStr: String?
    public let channel: TVChannel?
    public let channelID: String?
    public let title: String?
    public let description: String?
    public let credits: [String: String]
    public let date: String?
    public let categories: [String]
    public let country: String?
    public let episode: String?
    public let icon: String?
    public let rating: String?

    public init(start: String?,
                stop: String?,
                channel: TVChannel?,
                channelID: String?,
                title: String?,
                description: String?,
                credits: [String: String],
                date: String?,
                categories: [String],
                country: String?,
                episode: String?,
                icon: String?,
                rating: String?) {
        self.startStr = start
        self.stopStr = stop
        self.channel = channel
        self.channelID = channelID
        self.title = title
        self.description = description
        self.credits = credits
        self.date = date
        self.categories = categories
        self.country = country
        self.episode = episode
        self.icon = icon
        self.rating = rating
    }

    public var start: Date? {
        get {
            Date.parse(tvDate: self.startStr)
        }
    }
  
    public var stop: Date? {
        get {
            Date.parse(tvDate: self.stopStr)
        }
    }
}
