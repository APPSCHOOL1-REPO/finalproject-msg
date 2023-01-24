//
//  ContentView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//
import SwiftUI

struct ContentView: View {
    //** 코어데이터 -> 로그인 처리 **
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var kakaoAuthViewModel: KakaoViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @State private var checked: Msg?
    @AppStorage("DarkModeEnabled") private var darkModeEnabled: Bool = false
    
    // 탭바
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
    }

    var body: some View {
        ZStack {
            Color("Background")
            NavigationStack {
                Group {
                    if loginViewModel.currentUser != nil {
                        if loginViewModel.currentUserProfile == nil {
                            withAnimation {
                                MakeProfileView()
                            }
                        } else {
                            TabView {
                                HomeView()
                                    .tabItem {
                                        Image(systemName: "dpad.fill")
                                        Text("도전")
                                    }
                                ChallengeRecordView()
                                    .tabItem {
                                        Image(systemName: "archivebox")
                                        Text("기록")
                                    }
                                FriendSettingView()
                                    .tabItem {
                                        Image(systemName: "person.2.fill")
                                        Text("친구")
                                    }
                                SettingView(darkModeEnabled: $darkModeEnabled)
                                    .tabItem {
                                        Image(systemName: "gearshape")
                                        Text("설정")
                                    }
                            }
                            .onAppear {
                                realtimeViewModel.myInfo = loginViewModel.currentUserProfile
                            }
                        }
                    } else {
                        LoginView()
                    }
                }
                .onAppear{
                    if loginViewModel.currentUser != nil {
                        Task{
                                loginViewModel.currentUserProfile = try await fireStoreViewModel.fetchUserInfo(_: loginViewModel.currentUser!.uid)
                        }
                    }
                }
            }
            .accentColor(Color("Font"))
        }.task {
//            try! await fireStoreViewModel.getGameHistory()
        }
        .onAppear {
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let kakaoAuthViewModel = KakaoViewModel()
    static let fireStoreViewModel = FireStoreViewModel()
    static let realtimeViewModel = RealtimeViewModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(kakaoAuthViewModel)
            .environmentObject(fireStoreViewModel)
            .environmentObject(realtimeViewModel)
    }
}
