//
//  ContentView.swift
//  SwiftPraticeView
//
//  Created by 심소영 on 9/2/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("launch")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 200)
                Image("launchImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                NavigationLink(destination: ProfileView()) {
                    Text("시작하기")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}


struct MBTISelection: Equatable {
    var first: Bool
    var second: Bool
}

struct ProfileView: View {
    var list = [
        ["E", "I"] , ["S", "N"], ["T", "F"], ["J", "P"]
    ]
    @State private var selectedMBTI = Array(repeating: MBTISelection(first: false, second: false), count: 4)
    @State private var profileImage = "profile_\(Int.random(in: 0...11))"
    @State private var nickNameText = ""
    @State private var nickNameButtonResult = false
    @State private var MBTIResult = false
    
    var body: some View {
        VStack {
            Image(profileImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
                .clipShape(.circle)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 5)
                )
                .padding()
                .overlay(alignment: .trailing, content: {
                    NavigationLink(destination: ProfileDetailView(selectedImage: $profileImage)) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14))
                            .padding(6)
                            .tint(.white)
                            .background(.blue)
                            .clipShape(.circle)
                    }
                    .offset(x: -10, y: 30)
                })
            TextField("닉네임을 입력해주세요 :)", text: $nickNameText)
                .padding(.vertical)
                .overlay(Rectangle().frame(height: 2), alignment: .bottom)
                .foregroundColor(.gray)
                .padding()
                .onChange(of: nickNameText) {
                    nickNameButtonResult = nickNameText.count >= 5
                }
            HStack {
                Text("MBTI")
                    .bold()
                    .font(.title3)
                Spacer()
                ForEach(0..<4) { index in
                    MBTIView(items: list[index], isSelected: $selectedMBTI[index])
                }
            }
            .padding(20)
            Spacer()
            NavigationLink(destination: LastView(
                selectedMBTI: getSelectedMBTI(),
                nickname: nickNameText)
            ) {
                Text("완료")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .background((nickNameButtonResult && MBTIResult) ? Color.blue : Color.gray)
            .disabled(!(nickNameButtonResult && MBTIResult))
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .padding()
        .navigationTitle("PROFILE SETTING")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedMBTI) {
            let selectedCount = selectedMBTI.filter { $0.first || $0.second }.count
            MBTIResult = selectedCount >= 4
        }
    }
    func getSelectedMBTI() -> String {
        var result = ""
        for (index, selection) in selectedMBTI.enumerated() {
            if selection.first {
                result += list[index][0]
            } else if selection.second {
                result += list[index][1]
            }
        }
        return result
    }
}

struct MBTIView: View {
    let items: [String]
    @Binding var isSelected: MBTISelection
    
    var body: some View {
        VStack {
            ForEach(0..<2) { index in
                Button(action: {
                    if index == 0 {
                        isSelected = MBTISelection(first: true, second: false)
                    } else {
                        isSelected = MBTISelection(first: false, second: true)
                    }
                }) {
                    Text(items[index])
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(isSelectedForIndex(index) ? Color.blue : Color.clear)
                        .foregroundColor(isSelectedForIndex(index) ? .white : .gray)
                        .overlay(
                            Circle().stroke(isSelectedForIndex(index) ? Color.blue : Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(isSelectedForIndex(index) ? .blue : .gray)
                        .clipShape(Circle())
                }
            }
        }
    }
    func isSelectedForIndex(_ index: Int) -> Bool {
        return index == 0 ? isSelected.first : isSelected.second
    }
}

struct ProfileDetailView: View {
    
    @Binding var selectedImage: String
    
    let profileImages = (0..<12).map { "profile_\($0)" }
    let list = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        NavigationView {
            VStack {
                Image(selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .clipShape(.circle)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 5)
                    )
                    .padding()
                    .overlay(alignment: .trailing, content: {
                        Button {
                            print("카메라 버튼 눌림")
                        } label: {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .padding(6)
                                .tint(.white)
                                .background(.blue)
                                .clipShape(.circle)
                        }
                        .offset(x: -10, y: 30)
                    })
                LazyVGrid(columns: list, spacing: 10) {
                    ForEach(profileImages, id: \.self) { item in
                        VStack {
                            Button(action: {
                                selectedImage = item
                            }, label: {
                                Image("\(item)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(item == selectedImage ? Color.blue : Color.gray, lineWidth: item == selectedImage ? 5 : 1)
                                    )
                                    .opacity(item == selectedImage ? 1 : 0.5)
                            })
                        }
                    }
                }
                Spacer()
                    .padding()
            }
        }
        .navigationTitle("PROFILE SETTING")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LastView: View {
    let selectedMBTI: String
    let nickname: String
    
    var body: some View {
        VStack {
            Text("당신의 MBTI: \(selectedMBTI)")
                .font(.title)
                .padding()
            Text("닉네임: \(nickname)")
                .font(.title2)
                .padding()
            Spacer()
        }
        .navigationTitle("Main")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}
