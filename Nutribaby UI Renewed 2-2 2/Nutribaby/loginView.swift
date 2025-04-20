//
//  loginView.swift
//  Nutribaby
//
//  Created by Juan Sebastian on 02/12/24.
//
import SwiftUI
struct LoginView: View {
    @State private var showTextFields = false
    @State private var logoOffset: CGFloat = 0
    var onLoginSuccess: () -> Void = {} // Tambahkan closure default kosong
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack {
                    Image("nutribaby_logo")
                        .resizable()
                        .frame(width: 120, height: 166)
                        .foregroundColor(.white)
                        .padding(.top, -100)
                    Text("Nutribaby")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 0)
                }
                .offset(y: logoOffset)
                .padding(.top, 300)
                if showTextFields {
                    VStack(spacing: 20) {
                        TextField("Email", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 40)
                        SecureField("Password", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 40)
                        Button(action: {
                            onLoginSuccess() // Panggil closure ketika login berhasil
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: showTextFields)
                    .padding(.bottom, 50)
                }
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                logoOffset = -127
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showTextFields = true
                }
            }
        }
    }
}
#Preview {
    LoginView()
}



