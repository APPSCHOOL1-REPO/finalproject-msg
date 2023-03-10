//
//  AlertView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var realtimeService: RealtimeService
    @StateObject var checkAddFriendViewModel = CheckAddFriendViewModel()
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                VStack {
                    if realtimeService.user.isEmpty {
                        Text("알람을 모두 확인했습니다.")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                    }
                    else {
                   
                            List(realtimeService.user, id: \.self) { user in
                                HStack {
                                    VStack {
                                        if user.profileImage.isEmpty{
                                            Image(systemName: "person")
                                                .font(.largeTitle)
                                        }else{
                                            AsyncImage(url: URL(string: user.profileImage)) { Image in
                                                Image
                                                    .resizable()
                                            } placeholder: {
                                                Image(systemName: "person")
                                                    .font(.largeTitle)
                                            }
                                        }
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: g.size.width / 9.375, height: g.size.height / 14.5575)
                                    .clipShape(Circle())
                                    .padding(4)
                                    .foregroundColor(Color("Color2"))
                                    .background(
                                        Circle()
                                            .fill(
                                                .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                            )
                                            .foregroundColor(Color("Color1")))
                                    
                                    Text(user.nickName)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    Button {
                                        Task {
                                            guard let myInfo = try await checkAddFriendViewModel.myInfo() else {return}
                                            checkAddFriendViewModel.addBothWithFriend(user: user, me: myInfo)
                                            checkAddFriendViewModel.acceptAddFriend(friend: user)
                                            await checkAddFriendViewModel.deleteWaitingFriend(userId: user.id)
                                            
                                        }
                                        
                                    } label: {
                                        Text("확인")
                                    }
                                    .buttonStyle(.borderless)
                                    .frame(width: g.size.width / 9, height: g.size.height / 20)
                                    .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                    .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                    .padding(5)
                                    .background(Color("Color1"))
                                    .cornerRadius(10)
                                    .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                    .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                    .padding(.trailing)
                                }
                                .frame(height: g.size.height / 9)
                                .padding(.leading, g.size.width / 39)
                                .listRowBackground(Color("Color1"))
                                .listRowSeparator(.hidden)
                            }
                            .scrollContentBackground(.hidden)
                            .listStyle(.plain)
                        }
                    
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
            }
            .onAppear {
                realtimeService.startObserve()
            }
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
