//
//  SpendingWritingView.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI

struct SpendingWritingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var selection: Int = 0
    
    @State private var consumeTag = ""
    @State private var consumeTilte = ""
    @State private var consumeMoney = ""
    
    private func convertTextLogic(tag: String, money: String) -> String {
        return tag + "_" + money
    }
    
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            VStack{
                Group{
                    Spacer()
                    HStack{
                        Text("소비 날짜")
                        Text("|")
                        Text("2023/01/17")
                        Spacer()
                    }
                    .padding()
                    
                    HStack{
                        Text("소비 태그")
                        Text("|")
                        VStack{
                            Picker("한국어",selection: $selection) {
                                Text("식비").tag(0)
                                Text("교통비").tag(1)
                                Text("쇼핑").tag(2)
                                Text("의료").tag(3)
                                Text("주거").tag(4)
                                Text("여가").tag(5)
                                Text("금융").tag(6)
                                Text("기타").tag(7)
                            }
                            .pickerStyle(.menu)
                            //                            .accentColor(Color("Font"))
                            
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("Point2"))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding()
                    
                    HStack{
                        Text("상세 내용")
                        Text("|")
                        VStack{
                            HStack {
                                TextField("", text: $consumeTilte)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                Button {
                                    consumeTilte = ""
                                } label: {
                                    Image(systemName: "eraser")
                                }
                            }
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("Point2"))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding()
                    
                    HStack{
                        Text("금액")
                        Text("|")
                        VStack{
                            HStack {
                                TextField("", text: $consumeMoney)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                Button {
                                    consumeMoney = ""
                                } label: {
                                    Image(systemName: "eraser")
                                }
                            }
                            Rectangle()
                                .frame(height:1)
                                .foregroundColor(Color("Point2"))
                                .padding(.leading, 16)
                                .padding(.trailing, 29)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    Button {
                        let convert = convertTextLogic(tag: consumeTag, money: consumeMoney)
                        fireStoreViewModel.addExpenditure(user: loginViewModel.currentUserProfile!, categoryAndExpenditure: convert)
                    } label: {
                        Text("추가하기")
                            .foregroundColor(Color("Background"))
                            .padding(.horizontal, 100)
                            .padding(.vertical, 8)
                            .background(Color("Point2"))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .foregroundColor(Color("Font"))
        }
    }
}

struct SpendingWritingView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingWritingView()
    }
}
