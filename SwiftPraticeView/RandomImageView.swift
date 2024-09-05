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
    var url = "https://picsum.photos/id/\(Int.random(in: 1...300))/200/300"
    
    var urlFormat: URL {
        return URL(string: url) ?? URL(string: "")!
    }
}

struct RandomImageView: View {
    @State private var titleText : [String] = ["첫번째 섹션", "두번째 섹션", "세번째 섹션", "네번째 섹션"]
    
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
            VStack {
                ForEach(0..<title.count, id: \.self) { item in
                    Text(title[0])
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<11, id: \.self){ item in
                                NavigationLink {
                                    NavigationLazyView(DetailImageView())
                                } label: {
                                    bannerView(Banner())
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
    
    @Binding var sectionText: [String]
    @Binding var randomImage: Banner
    
    var body: some View {
        VStack{
            KFImage(randomImage.urlFormat)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Text(sectionText[0])
        }
    }
    
}
