//
//  GameRequestAlertViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/02/02.
//

import SwiftUI

struct GameRequestAlertViewCell: View {
    @Binding var selectedTabBar: SelectedTab
    @State var sendUser: Msg
    @State private var isPresent = false
    @State private var challengeInfo: Challenge?
    @State var g: GeometryProxy
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var notiManager: NotificationManager
    
    @ObservedObject var gameRequestViewModel: GameRequestViewModel
    @EnvironmentObject var realtimeService: RealtimeService
    var body: some View {
        //        GeometryReader { g in
        HStack{
            VStack {
                if sendUser.profileImage.isEmpty{
                    Image(systemName: "person")
                        .font(.largeTitle)
                }else{
                    AsyncImage(url: URL(string: sendUser.profileImage)) { Image in
                        Image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "person")
                            .font(.largeTitle)
                    }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: g.size.width / 7, height: g.size.height / 12)
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
            
            Text("\(sendUser.nickName)")
                .padding(.leading)
            
            Spacer()
            
            Button {
                Task{
                    await MainActor.run {
                        self.sendUser = sendUser
                    }
                    challengeInfo = await gameRequestViewModel.fetchChallengeInformation(self.sendUser.game)
                    isPresent = true
                }
            } label: {
                Text("??????")
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
        .padding()
        .alert(isPresented: $isPresent) {
            CustomAlertView {
                ZStack {
                    Color("Color1").ignoresSafeArea()
                    VStack(spacing: 10){
                        if let challengeInfo {
                            if challengeInfo.gameTitle.isEmpty {
                                ProgressView()
                            }
                        }
                        Text("\(self.sendUser.nickName)?????? ?????????????" )
                            .padding()
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                        Divider()
                        Spacer()
                        Text("\(challengeInfo?.gameTitle ?? "????????????")")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                        VStack(spacing: 10){
                            Text("????????????????")
                            Text("\(challengeInfo?.limitMoney ?? 0)")
                        }.padding()
                        VStack(spacing: 10){
                            Text("????????? ??????????")
                            Text("\(challengeInfo?.startDate.createdDate ?? "????????????")")
                            Text("\(challengeInfo?.endDate.createdDate ?? "????????????")")
                        }.padding()
                        VStack {
                            Text("??????")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                            Text("??????????????? ?????? ???????????? ???????????????.")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                        }
                        Spacer()
                    }
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                .frame(width: 300, height: 400)
            } primaryButton: {
                    CustomAlertButton(title: Text("??????"), color: Color("Color1")) {
                        isPresent = false
                        Task {
                            await gameRequestViewModel.notAllowChallegeStep1(data: realtimeViewModel.requsetGameArr)
                            //??????????????? ???????????? ?????????
                            await gameRequestViewModel.acceptGameRequest(friend: self.sendUser)
                        }
                        print("??????")
                    }
            } secondButton: {
                CustomAlertButton(title: Text("??????"), color: Color("Color1")) {
                    
                    //????????? ????????? ???
                    //1.?????????????????? id??? ????????????
                    //2.Auth.auth()???asdas??? ????????? ?????? ????????? ????????? invitedFriend??? append?????????
                    //3.waitingFriend?????? ??? ???????????? ???????????? ??????
                    Task {
                        challengeInfo = await gameRequestViewModel.fetchChallengeInformation(self.sendUser.game)
                        await gameRequestViewModel.acceptGame(self.sendUser.game)

                        //1. ??????????????? ?????????????????? ?????? waiting???????????? ?????????
                        await gameRequestViewModel.notAllowChallegeStep1(data: realtimeService.requsetGameArr)
                        //??????????????? ???????????? ?????????
                        await gameRequestViewModel.acceptGameRequest(friend: self.sendUser)
                        // ?????? ?????? ???????????? invite append?????? ??????
                        await gameRequestViewModel.waitingLogic(data: challengeInfo)
                        await notiManager.doSomething()
                        
                        selectedTabBar = .first
                    }
                    isPresent = false
                    print("??????")
                    
                }
            }
        }
        .onAppear{
            Task{
                challengeInfo = await gameRequestViewModel.fetchChallengeInformation(self.sendUser.game)
                realtimeService.fetchRequest()
                if let challengeInfo {
                    // ???????????? ????????? 5?????? ????????????
                    if Double(challengeInfo.startDate)! + 300.0 < Double(Date().timeIntervalSince1970) {
                        //????????? ??????
                        await gameRequestViewModel.afterFiveMinuteDeleteChallenge(friend: self.sendUser)
                        //??? waiting ??????????????? ??????
                            await gameRequestViewModel.notAllowChallegeStep2(data: challengeInfo)
                    }
                }
            }
        }
    }
}


//struct GameRequestAlertViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRequestAlertViewCell()
//    }
//}
