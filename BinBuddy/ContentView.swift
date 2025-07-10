//
//  ContentView.swift
//  BinBuddy
//
//  Created by Kohei Inoue on 2025/07/10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GarbageType.name, ascending: true)],
        animation: .default)
    private var garbageTypes: FetchedResults<GarbageType>

    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(garbageTypes) { garbage in
                    VStack(alignment: .leading) {
                        Text(garbage.name ?? "")
                        if let days = garbage.daysOfWeek as? [Int], !days.isEmpty {
                            Text(days.sorted().map { dayNumToStr($0) }.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("ゴミの種類")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddGarbageTypeView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { garbageTypes[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // エラー処理
            }
        }
    }
}

struct AddGarbageTypeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var selectedDays: Set<Int> = []
    
    let days = [
        (1, "日"), (2, "月"), (3, "火"), (4, "水"), (5, "木"), (6, "金"), (7, "土")
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ゴミの名前")) {
                    TextField("例: 燃やすごみ", text: $name)
                }
                Section(header: Text("曜日")) {
                    HStack {
                        ForEach(days, id: \.0) { day in
                            Button(action: {
                                if selectedDays.contains(day.0) {
                                    selectedDays.remove(day.0)
                                } else {
                                    selectedDays.insert(day.0)
                                }
                            }) {
                                Text(day.1)
                                    .frame(width: 32, height: 32)
                                    .background(selectedDays.contains(day.0) ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(selectedDays.contains(day.0) ? Color.accentColor : Color.gray, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("新規追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        addGarbageType()
                        dismiss()
                    }.disabled(name.isEmpty || selectedDays.isEmpty)
                }
            }
        }
    }

    private func addGarbageType() {
        let newType = GarbageType(context: viewContext)
        newType.id = UUID()
        newType.name = name
        newType.daysOfWeek = Array(selectedDays) as NSObject
        do {
            try viewContext.save()
        } catch {
            // エラー処理
        }
    }
}

#Preview {
    ContentView()
}

func dayNumToStr(_ num: Int) -> String {
    switch num {
    case 1: return "日"
    case 2: return "月"
    case 3: return "火"
    case 4: return "水"
    case 5: return "木"
    case 6: return "金"
    case 7: return "土"
    default: return "?"
    }
}
