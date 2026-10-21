import SwiftUI
struct IconGallery: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 18) {
                ForEach(Ico.allCases, id: \.self) { i in
                    VStack(spacing: 6) {
                        Icon(i, size: 30, weight: 1.8)
                        Text(i.rawValue).font(.system(size: 8)).foregroundStyle(T.ink3)
                    }
                }
            }
            .padding(20)
        }
    }
}
