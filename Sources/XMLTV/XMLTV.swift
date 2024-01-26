import Foundation
import LightXMLParser

private extension XML {
    func children(name: String) -> [XML] {
        return children.filter { $0.name == name }
    }
}

public typealias ChannelID = String

public class XMLTV {
    private let PROGRAM_KEY = "programme"
    private let CHANNEL_KEY = "channel"

    private let xml: XML
    private var data: [TVChannel: [TVProgram]] = [:]
    private var channels: [String: TVChannel]?
    private var programs: [String: [TVProgram]]?

    public init(data: Data) throws {
        xml = try XML(data: data)
    }

    public init(url: String) throws {
        let data = try Data(contentsOf: URL(string: url)!)
        xml = try XML(data: data)
    }

    public func getChannels() -> [TVChannel] {
        if channels == nil {
            let xmlChannels = xml.children(name: CHANNEL_KEY)
            let parsedChannels: [TVChannel] = xmlChannels.compactMap { parseChannel($0) }
            var result = [String: TVChannel]()

            parsedChannels.forEach { channel in
                result[channel.id] = channel
            }

            channels = result
        }

        if let chans = channels {
            return chans.compactMap { $0.value }
        } else {
            return []
        }
    }

    // getPrograms returns a dictionary of [Channel-id -> [TVProgram]]
    public func getPrograms() -> [ChannelID: [TVProgram]] {
        // make sure the channels cache is primed
        // let channels = getChannels()
        if programs == nil {
            let xmlPrograms = xml.children(name: PROGRAM_KEY)
            let programs = xmlPrograms.map { parseProgram(channel: nil,
                                                          program: $0) }

            self.programs = Dictionary(grouping: programs, by: { $0.channelID! })
        }

        return programs ?? [:]
    }

    public func getPrograms(channel: TVChannel) -> [TVProgram] {
        let programs = getPrograms()
        return programs[channel.id] ?? []
    }

    private func parseChannel(_ channel: XML) -> TVChannel? {
        if let id = channel.attributes["id"] {
            let name = channel.children(name: "display-name").first?.value
            let url = channel.children(name: "url").first?.value
            let iconSrc = channel.children(name: "icon").first?.attributes["src"]
            return TVChannel(id: id, name: name, url: url, icon: iconSrc)
        }
        return nil
    }

    private func parseProgram(channel: TVChannel?, program: XML) -> TVProgram {
        let startDate = program.attributes["start"]
        let stopDate = program.attributes["stop"]
        let title = program.children(name: "title").first?.value
        let description = program.children(name: "desc").first?.value
        let channelID = program.attributes["channel"]
        let icon = program.children(name: "icon").first?.attributes["src"]
        let rating = program.children(name: "star-rating").first?.children(name: "value").first?.value
        let date = program.children(name: "date").first?.value
        let episode = program.children(name: "episode-num").first?.value
        let categories = program.children(name: "category").map { $0.value }
        let country = program.children(name: "country").first?.value
        let credits = program.children(name: "credits").first?.children.reduce([String: String]()) { dict, credit -> [String: String] in
            var dict = dict
            dict[credit.name] = credit.value
            return dict
        } ?? [:]

        return TVProgram(start: startDate,
                         stop: stopDate,
                         channel: channel,
                         channelID: channelID,
                         title: title,
                         description: description,
                         credits: credits,
                         date: date,
                         categories: categories,
                         country: country,
                         episode: episode,
                         icon: icon,
                         rating: rating)
    }
}
