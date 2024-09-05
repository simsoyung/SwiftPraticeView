//
//  RandomImageView.swift
//  SwiftPraticeView
//
//  Created by 심소영 on 9/4/24.
//

import SwiftUI
import Kingfisher


struct Banner: Hashable, Identifiable {
    let id = UUID()
    var url = "https://picsum.photos/id/\(Int.random(in: 1...250))/200/300"
    
    var urlFormat: URL {
        return URL(string: url) ?? URL(string: "")!
    }
}

struct RandomImageView: View {
    @State private var titleText : [String] = ["첫번째 섹션", "두번째 섹션", "세번째 섹션", "네번째 섹션"]
    @State private var banners: [Banner] = (0..<10).map { _ in Banner() }
    
    var body: some View {
        NavigationView {
            VStack{
                horizontalBannerView(titleText)
            }
            .navigationTitle("My Random Image")
        }
    }
    
    func horizontalBannerView(_ title: [String]) -> some View {
        ScrollView {
            ForEach(0..<title.count, id: \.self) { index in
                VStack {
                    Text(title[index])
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(banners, id: \.id) { banner in
                                NavigationLink {
                                    DetailImageView(sectionText: title[index], randomImage: banner)
                                } label: {
                                    bannerView(banner)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
    
    func bannerView(_ banner: Banner?) -> some View {
        HStack {
            if let imageURL = banner {
                KFImage(imageURL.urlFormat)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                Image(systemName: "xmark")
            }
        }
    }
}

#Preview {
    RandomImageView()
}
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    
    var body: some View {
        build()
    }
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
        print("NavigationLazyView init")
    }
}

struct DetailImageView: View {
    
    var sectionText: String
    var randomImage: Banner
    
    var body: some View {
        VStack{
            KFImage(randomImage.urlFormat)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Text(sectionText)
        }
    }
    
}
