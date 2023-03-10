//
//  FriendViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//
import SwiftUI

struct FriendViewCell: View {
    
    @State var user: Msg
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    @Binding var findFriendToggle: Bool
    @Binding var checked: Bool
    @State var listsToggle: Bool = false // 친구 체크박스 토글
    @State var friendAlert: Bool = false
    
    var body: some View {
        GeometryReader { g in
                ZStack {
                    Color("Color1")
                        .ignoresSafeArea()
                    
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
                            .frame(width: g.size.width * 0.3, height: g.size.height * 0.9)
                            .clipShape(Circle())
                            .foregroundColor(Color("Color2"))
                            .background(
                                Circle()
                                    .fill(
                                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                    )
                                    .foregroundColor(Color("Color1")))
                            
             
                            Text(user.nickName)
                            
                            Spacer()
                            
                            // MARK: 멀티게임 친구 찾기 시트 부분 체크 박스
                                VStack{
                                    // 초대장 보낼 친구를 추가
                                    if !realtimeViewModel.inviteFriendIdArray.contains(user.id) {
                                        Button {
                                            realtimeViewModel.inviteFriendIdArray.append(user.id)
                                            realtimeViewModel.inviteFriendArray.append(user)
                                            print(realtimeViewModel.inviteFriendArray)
                                            print("idArray:",realtimeViewModel.inviteFriendIdArray)
                                            //  print(realtimeViewModel.inviteFriendArray.firstIndex(of: user))
                                            if realtimeViewModel.inviteFriendIdArray.count >= 4 {
                                                friendAlert = true
                                                realtimeViewModel.inviteFriendArray.remove(at: realtimeViewModel.inviteFriendArray.firstIndex(of: user)!)
                                                realtimeViewModel.inviteFriendIdArray.remove(at: realtimeViewModel.inviteFriendIdArray.firstIndex(of: user.id)!)
                                                print("3명 체크 idArray:",realtimeViewModel.inviteFriendIdArray)
                                                self.listsToggle.toggle()
                                            } else {
                                                friendAlert = false
                                            }
                                            self.checked = true
                                        } label: {
                                            Image(systemName: "square")
                                        }
                                    } else {
                                        // 초대장 보낼 친구를 제거
                                        Button {
                                            realtimeViewModel.inviteFriendArray.remove(at: realtimeViewModel.inviteFriendArray.firstIndex(of: user)!)
                                            realtimeViewModel.inviteFriendIdArray.remove(at: realtimeViewModel.inviteFriendIdArray.firstIndex(of: user.id)!)
                                            print("idArray:",realtimeViewModel.inviteFriendIdArray)
                                            print("Array:",realtimeViewModel.inviteFriendArray)
                                            if realtimeViewModel.inviteFriendArray == [] {
                                                self.checked = false
                                            }
                                        } label: {
                                            Image(systemName: "checkmark.square.fill")
                                        }
                                    }
                                }
                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.9)
                                .alert("최대 3명까지 초대가 가능합니다.", isPresented: $friendAlert) {
                                    Button {} label: { Text("확인") }
                                }
                        }
                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                        .buttonStyle(.bordered)
                        .frame(alignment: .leading)

                }
                .padding()
            
        }
    }
}

struct FriendViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(findFriendToggle: .constant(true))
    }
}
