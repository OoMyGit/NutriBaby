import SwiftUI
struct newsView: View {
    @State private var isSearchActive = false // Mengontrol visibilitas TextField
    @State private var searchText = "" // Teks yang dimasukkan di TextField
    @FocusState private var isTextFieldFocused: Bool // Fokus pada TextField
    @State private var isSidebarVisible = false // Menyimpan status visibilitas sidebar
    
    var body: some View {
        VStack {
            if isSearchActive {
                TextField("Search News and Menu", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        DispatchQueue.main.async {
                            self.isTextFieldFocused = true
                        }
                    }
            }
            
            ScrollView {
                Section(header: Text("Recomended")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredNews.prefix(5), id: \.self) { news in
                                    NavigationLink(destination: NewsDetailView(newsTitle: news.title, newsDescription: news.description)) {
                                        NewsCardView(newsTitle: news.title, newsDescription: news.description)
                                            .frame(width: 150, height: 200)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 1.2) // Warna dan ketebalan outline
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                
                Section(header: Text("News")
                    .font(.headline)
                    .padding()) {
                        VStack(spacing: 16) {
                            ForEach(filteredNews, id: \.self) { news in
                                NavigationLink(destination: NewsDetailView(newsTitle: news.title, newsDescription: news.description)) {
                                    NewsCardView(newsTitle: news.title, newsDescription: news.description)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 1.2) // Outline untuk setiap elemen
                                        )
                                }
                                Divider() // Menambahkan pembatas antar elemen
                            }
                        }
                        .padding()
                    }
                
                Section(header: Text("Menu")
                    .font(.headline)
                    .padding()) {
                        VStack(spacing: 16) {
                            ForEach(filteredMenu, id: \.self) { menu in
                                NavigationLink(destination: MenuDetailView(menuTitle: menu.title, menuDescription: menu.description)) {
                                    MenuCardView(menuTitle: menu.title, menuDescription: menu.description)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 1.2) // Outline untuk setiap elemen
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                
                
                Section {
                    HStack {
                        Spacer()
                        Text("No more news or menu")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Articles")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                isSearchActive.toggle()
            }
        }) {
            Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                .padding()
        })
    }
    
    var allNews: [News] {
        [
            News(
                title: "Kebutuhan gizi bayi usia 0-5 bulan",
                description: """
                    Air susu ibu (ASI) adalah makanan utama untuk memenuhi nutrisi bayi pada lima bulan pertama kehidupannya, atau disebut sebagai ASI ekslusif. Meski hanya dengan menyusu ASI, kebutuhan gizi bayi sebelum usia 6 bulan sebenarnya telah terpenuhi dengan baik.
                    Energi: 550 kkal, Protein: 12 gr, Lemak: 34 gr, Karbohidrat: 58 gr.
                    """
            ),
            News(
                title: "Kebutuhan gizi bayi usia 6-12 bulan",
                description: """
                    Memasuki usia bayi 6 bulan ke atas, ASI bisa tetap diberikan disertai makanan padat. Energi: 725 kkal, Protein: 18 gr, Lemak: 36 gr, Karbohidrat: 82 gr, Serat: 10 gr, Air: 800 ml.
                    """
            ),
            News(
                title: "Komposisi MPASI",
                description: """
                    Berdasarkan Pedoman Gizi Seimbang, MPASI dibagi menjadi dua: MPASI lengkap dan MPASI sederhana. MPASI baik harus padat energi, protein, serta zat gizi mikro.
                    """
            ),
            News(
                title: "Cara Memandikan Bayi",
                description: """
                    Memandikan bayi memerlukan perhatian khusus. Isi bak mandi dengan air hangat setinggi 7 cm, topang tubuh bayi, dan gunakan sabun khusus bayi bila diperlukan.
                    """
            ),
            News(
                title: "Makanan & Minuman yang Harus Dihindari Bayi",
                description: """
                    Bayi di bawah 1 tahun harus menghindari madu, susu sapi segar, makanan tinggi garam, gula, serta makanan kecil yang bisa membuat tersedak.
                    """
            )
        ]
    }
    
    var filteredNews: [News] {
        if searchText.isEmpty {
            return allNews
        } else {
            return allNews.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var allMenu: [Menu] {
        [
            Menu(
                        title: "Puree Wortel dan Kentang",
                        description: """
                        Bahan:
                        - 1 buah wortel kecil
                        - 1/2 kentang kecil
                        - Air secukupnya
                        Cara Membuat:
                        - Kupas wortel dan kentang, lalu potong kecil-kecil.
                        - Kukus kedua bahan hingga empuk (sekitar 10–15 menit).
                        - Haluskan dengan blender atau ulekan, tambahkan sedikit air kukusan hingga mencapai tekstur yang sesuai.
                        - Sajikan hangat.
                        """
                    ),
                    Menu(
                        title: "Bubur Nasi Ayam",
                        description: """
                        Bahan:
                        - 2 sdm beras
                        - 30 gram daging ayam tanpa lemak, cincang halus
                        - 1 gelas air
                        - Sedikit wortel parut (opsional)
                        Cara Membuat:
                        - Rebus beras dengan air hingga menjadi bubur lembut.
                        - Masukkan ayam cincang dan wortel parut, masak hingga matang.
                        - Blender atau saring untuk mendapatkan tekstur halus.
                        - Sajikan hangat.
                        """
                    ),
                    Menu(
                        title: "Puree Alpukat Pisang",
                        description: """
                        Bahan:
                        - 1/4 buah alpukat matang
                        - 1/2 buah pisang matang
                        Cara Membuat:
                        - Kerok daging alpukat dan potong pisang.
                        - Haluskan kedua bahan dengan garpu atau blender.
                        - Sajikan segera agar nutrisinya tetap optimal.
                        """
                    ),
                    Menu(
                        title: "Bubur Labu Kuning",
                        description: """
                        Bahan:
                        - 50 gram labu kuning, potong kecil
                        - 1 sdm beras
                        - 1 gelas air
                        Cara Membuat:
                        - Rebus labu kuning dan beras bersama air hingga lembut.
                        - Blender atau saring campuran hingga halus.
                        - Sajikan hangat.
                        """
                    ),
                    Menu(
                        title: "Puree Apel dan Pir",
                        description: """
                        Bahan:
                        - 1/2 apel
                        - 1/2 pir
                        Cara Membuat:
                        - Kupas dan potong apel serta pir.
                        - Kukus buah hingga empuk (sekitar 5–7 menit).
                        - Haluskan dengan blender atau garpu.
                        - Sajikan hangat atau dingin sesuai selera bayi.
                        """),
        ]
    }
    
    // Filtered menu berdasarkan pencarian
    var filteredMenu: [Menu] {
        if searchText.isEmpty {
            return allMenu
        } else {
            return allMenu.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
struct News: Hashable {
    let title: String
    let description: String
}
// Data Model untuk Menu
struct Menu: Hashable {
    let title: String
    let description: String
}
// Reusable Menu Card
struct MenuCardView: View {
    var menuTitle: String
    var menuDescription: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(menuTitle)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(menuDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding() // Tambahkan padding di semua sisi
        .background(Color.white) // Ganti warna latar sesuai kebutuhan
        .cornerRadius(10) // Membuat sudut membulat
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1.2) // Outline
        )
        .shadow(radius: 3) // Tambahkan bayangan agar lebih menarik
    }
}
// Reusable News Card
struct NewsCardView: View {
    var newsTitle: String
    var newsDescription: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Pastikan alignment ke kiri
            Text(newsTitle)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(newsDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding() // Tambahkan padding di semua sisi
        .background(Color.white) // Ganti warna latar sesuai kebutuhan
        .cornerRadius(10) // Membuat sudut membulat
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1.2) // Outline
        )
        .shadow(radius: 3) // Tambahkan bayangan agar lebih menarik
    }
}
// Menu View
struct MenuView: View {
    var body: some View {
        Text("This is the Menu View")
            .font(.title)
            .padding()
    }
}
// Halaman Detail untuk Menu
struct MenuDetailView: View {
    var menuTitle: String
    var menuDescription: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Container untuk judul dan deskripsi
                VStack(alignment: .leading, spacing: 12) {
                    Text(menuTitle)
                        .font(.title2) // Ukuran font yang pas
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // Pastikan teks rata kiri
                    
                    Text(menuDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(6) // Memberikan jarak antar baris
                        .multilineTextAlignment(.leading) // Rata kiri untuk semua teks
                }
                .padding(16) // Padding internal kontainer
                .background(Color.white) // Latar belakang putih
                .cornerRadius(10) // Membuat sudut membulat
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1.2) // Outline dengan warna abu-abu
                )
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2) // Tambahkan bayangan halus
                
                Spacer()
            }
            .padding(16) // Padding keseluruhan ScrollView
        }
        .background(Color(.systemGray6)) // Warna latar belakang keseluruhan
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// Halaman Detail untuk News
struct NewsDetailView: View {
    var newsTitle: String
    var newsDescription: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Container untuk judul dan deskripsi
                VStack(alignment: .leading, spacing: 12) {
                    Text(newsTitle)
                        .font(.title2) // Ukuran font yang pas
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // Pastikan teks rata kiri
                    
                    Text(newsDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(6) // Memberikan jarak antar baris
                        .multilineTextAlignment(.leading) // Rata kiri untuk semua teks
                }
                .padding(16) // Padding internal kontainer
                .background(Color.white) // Latar belakang putih
                .cornerRadius(10) // Membuat sudut membulat
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1.2) // Outline dengan warna abu-abu
                )
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2) // Tambahkan bayangan halus
                
                Spacer()
            }
            .padding(16) // Padding keseluruhan ScrollView
        }
        .background(Color(.systemGray6)) // Warna latar belakang keseluruhan
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// Preview
#Preview {
    NavigationView {
        newsView()
    }
}



