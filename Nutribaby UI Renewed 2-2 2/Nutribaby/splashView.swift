//
//  splashView.swift
//  Nutribaby
//
//  Created by Juan Sebastian on 20/11/24.
//
import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool // Binding untuk transisi ke ContentView

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Image("nutribaby_logo") // Ganti dengan logo Anda
                    .resizable()
                    .frame(width: 120, height: 166)
                    .foregroundColor(.white)

                Text("Nutribaby")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
        }
        .onAppear {
            // Mengatur durasi splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}


