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
                        // 曜日表示は後で追加
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
    // 曜日選択は後で追加

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ゴミの名前")) {
                    TextField("例: 燃やすごみ", text: $name)
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
                    }.disabled(name.isEmpty)
                }
            }
        }
    }

    private func addGarbageType() {
        let newType = GarbageType(context: viewContext)
        newType.id = UUID()
        newType.name = name
        // daysOfWeekは後で追加
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
