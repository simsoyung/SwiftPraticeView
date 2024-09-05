//
//  CoinView.swift
//  SwiftPraticeView
//
//  Created by 심소영 on 9/3/24.
//

import Foundation
import SwiftUI

struct Market: Hashable, Codable {
    let market, koreanName, englishName: String


    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    
    }
}

typealias Markets = [Market]

struct UpbitAPI {
    
    private init() { }
    
    static func fetchMarket() async throws -> Markets {
        let url = URL(string: "https://api.upbit.com/v1/market/all")!
        let (data, _) = try await URLSession.shared.data(from: url)
            
        let decodedData = try JSONDecoder().decode(Markets.self, from: data)
        return decodedData
    }

    static func fetchAllMarket(completion: @escaping (Markets) -> Void) {
 
        let url = URL(string: "https://api.upbit.com/v1/market/all")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(Markets.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
struct SearchBar: View {
    
    @Binding var text: String
 
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $text)
                    .foregroundColor(.primary)
 
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}

struct CoinView: View {
    
    @State private var market: Markets = []
    @State private var searchText = ""
    @State private var like = false
    
    var body: some View {
        NavigationView {
            ScrollView(content: {
                SearchBar(text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                listView()
            })
            .refreshable {
                UpbitAPI.fetchAllMarket { data in
                    market = data
                }
            }
            .navigationTitle("Search")
        }
        .task {
            do {
                let result = try await
                UpbitAPI.fetchMarket()
                market = result
            } catch {
                print("통신 에러")
            }
            
        }
    }
    //func
    func listView() -> some View {
        LazyVStack {
            ForEach(market.filter{ $0.koreanName.hasPrefix(searchText) }, id: \.self) {
                item in
                rowView(item)
            }
        }
    }
    func rowView(_ item: Market) -> some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.green)
            VStack(alignment: .leading) {
                Text(item.koreanName)
                    .fontWeight(.bold)
                Text(item.market)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(item.englishName)
                .fontWeight(.medium)
                .font(.system(size: 14))
            Button {
                like.toggle()
            } label: {
                Image(systemName: like ? "star.fill" : "star")
                    .foregroundStyle(.pink)
            }

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
    }
}

#Preview {
    CoinView()
}
