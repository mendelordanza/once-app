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
        let entry = ExampleEntry(date: Date(), title: "It will be a good day if I", message: "Write the 1st chapter of my book")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ExampleEntry] = []

        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = ExampleEntry(date: entryDate, title: "It will be a good day if I", message: sharedDefaults?.string(forKey: "_counter") ?? "")
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
            Text(entry.title).multilineTextAlignment(.center).font(.body).foregroundColor(.black).padding([.top, .leading, .trailing], 12)
            Spacer()
                    .frame(height: 10)
            Text(entry.message).multilineTextAlignment(.center)
                .font(.headline).foregroundColor(.black).padding([.bottom, .leading, .trailing], 12)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
        }
        ).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.white)
    }
}

@main
struct OnceWidgetExtension: Widget {
    let kind: String = "HomeWidgetExample"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OnceWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Today's One Thing")
        .description("In sight, in mind. View your task directly from your home screen")
    }
}

struct OnceWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        OnceWidgetExtensionEntryView(entry: ExampleEntry(date: Date(), title: "Example Title", message: "Example Message"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
