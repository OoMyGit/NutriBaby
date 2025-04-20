import SwiftUI
struct ContentView: View {
    @State private var showSplash = true // State untuk mengontrol splash screen
    @State private var showLogin = false // State untuk mengontrol login screen
    @State private var isSearchActive = false // State untuk mengontrol visibilitas search bar
    @State private var searchText = "" // State untuk menyimpan teks pencarian
    @FocusState private var searchFieldIsFocused: Bool // Fokus pada TextField
    var body: some View {
        ZStack {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else if showLogin {
                LoginView(onLoginSuccess: {
                       showLogin = false // Login selesai, lanjut ke tampilan utama
                })
            } else {
                VStack {
                    TabView {
                        NavigationView {
                            homeView()
                        }
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(1)
                        NavigationView {
                            newsView()
                        }
                        .tabItem {
                            Image(systemName: "book")
                            Text("Article")
                        }
                        .tag(2)
                        NavigationView {
                            babyView()
                        }
                        .tabItem {
                            Image(systemName: "person")
                            Text("Baby")
                        }
                        .tag(3)
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            }
        }
        .onAppear {
            // Pindah ke login screen setelah splash selesai
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSplash = false
                showLogin = true
            }
        }
        .statusBarHidden(false)
    }
}
#Preview {
    ContentView()
}



