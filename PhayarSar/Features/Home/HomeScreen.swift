//
//  HomeScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 07/12/2023.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var preferences: UserPreferences
    @State private var showOnboarding = false
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        OffsetObservingScrollView(offset: $offset) {
            navView
            
            LazyVStack(spacing: 12) {
                ForEach(1...10, id: \.self) { count in
                    NavigationLink {
                        Text("Hello")
                    } label: {
                        HomeListItemView(title: "နတ်ပင့်")
                    }
                }
            }
            .padding([.horizontal, .top])
        }
        .overlay(alignment: .top) {
            inlineNavView
        }
        .onAppear {
            showOnboarding = preferences.isFirstLaunch == nil
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingScreen()
        }
        
    }
    
    var navView: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PhayarSar")
                        .font(.dmSerif(32))
                    
                    HStack(spacing: 0) {
                        LocalizedText(.today_pray_time)
                            .foregroundColor(.appGreen)
                        LocalizedText(.x_min, args: [preferences.appLang == .Eng ? convertNumberMmToEng("5") : convertNumberEngToMm("5")])
                    }
                    .font(.qsSb(14))
                }
                Spacer()
                
                btnPray
            }
            .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 0.5)
                .background(Color.secondary.opacity(0.2))
                .padding(.horizontal)
                .padding(.top, 8)
        }
    }
    
    var inlineNavView: some View {
        Rectangle()
            .fill(.thinMaterial)
            .ignoresSafeArea(edges: .top)
            .frame(height: 50)
            .overlay {
                Text("PhayarSar")
                    .font(.dmSerif(20))
            }
            .overlay(alignment: .bottom, content: {
                Divider()
            })
            .opacity(min(1, offset.y / CGFloat(44)))
    }
    
    var btnPray: some View {
        Button {
            
        } label: {
            HStack(spacing: 5) {
                Image(.pray)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                
                LocalizedText(.btn_pray)
                    .foregroundColor(.white)
            }
            .font(.dmSerif(16))
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.appGreen))
        }
    }
    
    var btnAdd: some View {
        Button {
            
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                
                LocalizedText(.btn_add)
                    .foregroundColor(.white)
            }
            .font(.dmSerif(16))
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.appGreen))
        }
    }
}

#Preview {
    NavigationView{
        HomeScreen()
    }
    .environmentObject(UserPreferences())
}