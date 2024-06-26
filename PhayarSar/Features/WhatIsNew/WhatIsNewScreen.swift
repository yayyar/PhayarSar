//
//  WhatIsNewScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 25/05/2024.
//

import SwiftUI

struct WhatIsNewScreen: View {
  var dismiss: (() -> ())?
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var frcManager: RemoteConfigManager
  @State private var selectedModel: WhatIsNewFRCModel = .empty
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(.black)
        .opacity(0.4)
        .ignoresSafeArea()
      
      Rectangle()
        .fill(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea()
        .onTapGesture {
          dismiss?()
        }

      VStack(spacing: 20) {
        LocalizedText(.whats_new_in_v_x, args: ["\(appVersion)"])
          .font(.dmSerif(28))
          .shadow(color: .black.opacity(0.3), radius: 10, x: 4, y: 0)
          .foregroundStyle(.white)
          .padding(.top, 20)
          .onTapGesture {
            dismiss?()
          }
        
        TabView(selection: $selectedModel) {
          ForEach(frcManager.whisnwModels) { model in
            TabItemView(model)
              .tag(model)
          }
        }
        .id(frcManager.whisnwModels.count)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color(uiColor: .white))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 30)
        
        HStack {
          ForEach(frcManager.whisnwModels) { model in
            Circle()
              .fill(selectedModel == model ? .white : .white.opacity(0.6))
              .frame(width: 8, height: 8)
          }
        }
        .onTapGesture {
          dismiss?()
        }
        
        LocalizedText(.tap_anywhere_to_dismiss)
          .font(.qsSb(16))
          .foregroundStyle(.white.opacity(0.7))
          .shimmering()
          .padding(.vertical)
          .onTapGesture {
            dismiss?()
          }
      }
    }
    .onAppear {
      if !frcManager.whisnwModels.isEmpty {
        selectedModel = frcManager.whisnwModels[0]
      }
    }
  }
  
  @ViewBuilder
  private func TabItemView(_ model: WhatIsNewFRCModel) -> some View {
    ScrollView {
      VStack(spacing: 0) {
        AsyncImage(url: .init(string: model.image_url)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          Rectangle()
            .fill(.white)
            .overlay {
              ProgressView()
                .scaleEffect(1.3)
            }
            .aspectRatio(5/4, contentMode: .fit)
        }
        
        VStack(spacing: 16) {
          Text(model.localizedTitle)
            .font(.qsSb(24))
          
          Text(model.localizedBody)
            .font(.qsSb(15))
            .lineSpacing(preferences.appLang == .Mm ? 4 : 0)
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundStyle(.black)
      }
    }
    .tag(model)
  }
}

#Preview {
    TabScreen()
        .previewEnvironment()
}
