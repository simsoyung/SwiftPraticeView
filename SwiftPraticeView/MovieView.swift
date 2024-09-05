//
//  MovieView.swift
//  SwiftPraticeView
//
//  Created by 심소영 on 9/5/24.
//

import SwiftUI

struct MovieView: View {
    
    @State private var text = ""
    @State private var num = ""
    
    let items = ["SF", "가족", "스릴러"]
    
    @State private var list: [Category] = []
    
    var filterUser: [Category] {
        return text.isEmpty ? list : list.filter{$0.item.contains(text)}
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filterUser, id: \.id){ item in
                    NavigationLink {
                        SearchDetailView(genre: $text, count: $num)
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("\(item.item) (\(item.count))")
                        }
                    }
                }
            }
            .navigationTitle("영화 검색")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $text, placement: .navigationBarDrawer, prompt: "영화를 검색해보세요")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가"){
                        list.append(Category(item: "\(items.randomElement()!)", count:  "\(Int.random(in: 1...100))"))
                    }
                }
            }

        }
    }
}

#Preview {
    MovieView()
}
struct Category: Hashable, Identifiable {
    let id = UUID()
    let item: String
    let count: String

}

struct SearchDetailView: View {
    @Binding var genre: String
    @Binding var count: String

    var body: some View {
        Text("SearchDetailView: \(genre)")
    }
}

