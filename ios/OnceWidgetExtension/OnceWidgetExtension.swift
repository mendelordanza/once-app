//
//  OnceWidgetExtension.swift
//  OnceWidgetExtension
//
//  Created by Ralph Ordanza on 2/15/23.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.G53UVF44L3.com.ralphordanza.once"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), title: "Placeholder Title", message: "Placeholder Message")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        let entry = ExampleEntry(date: Date(), title: "It will be a good day if I...", message: "No Message Set")
        completion(entry)
    }
    
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        getSnapshot(in: context) { (entry) in
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//        }
//    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ExampleEntry] = []

        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = ExampleEntry(date: entryDate, title: "It will be a good day if I...", message: sharedDefaults?.string(forKey: "_counter") ?? "")
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ExampleEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

struct OnceWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        VStack.init(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(entry.title).font(.subheadline).colorScheme(.light)
            Spacer()
                    .frame(height: 10)
            Text(entry.message)
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget")).colorScheme(.light)
        }
        ).colorScheme(.light).padding(.all, 8)
    }
}

@main
struct OnceWidgetExtension: Widget {
    let kind: String = "HomeWidgetExample"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OnceWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct OnceWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        OnceWidgetExtensionEntryView(entry: ExampleEntry(date: Date(), title: "Example Title", message: "Example Message"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
