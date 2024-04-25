import SwiftUI
import SDWebImageSwiftUI

struct BookImageLoader: View {
    var imageURL: String
    
    var body: some View {
        WebImage(url: URL(string: imageURL)) { image in
            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
        } placeholder: {
                Rectangle().foregroundColor(.gray)
        }
        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
        .onSuccess { image, data, cacheType in
            // Success
            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
        }
        .indicator(.activity) // Activity Indicator
        .transition(.fade(duration: 0.5)) // Fade Transition with duration
        .scaledToFit()
        .frame(width: 100, height: 100, alignment: .center)
    }
}
