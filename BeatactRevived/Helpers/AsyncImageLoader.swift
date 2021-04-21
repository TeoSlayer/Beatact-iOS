//
//  AsyncImageLoader.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation
import UIKit
import SwiftyJSON
import Combine
import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

class ImageLoader: ObservableObject {
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    @Published var image: UIImage?
        private let url: URL

        init(url: URL) {
            self.url = url
        }

        deinit {
            cancel()
        }
    private var cancellable: AnyCancellable?
        
        func cancel() {
            cancellable?.cancel()
        }
    private var cache: ImageCache?

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    private(set) var isLoading = false
        
        func load() {
            // 2.
            guard !isLoading else { return }

            if let image = cache?[url] {
                self.image = image
                return
            }
            
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: Self.imageProcessingQueue)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                // 3.
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: { [weak self] in self?.cache($0) },
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.image = $0 }
                
        }
        
        private func onStart() {
            isLoading = true
        }
        
        private func onFinish() {
            isLoading = false
        }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
        private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    init(
            url: URL,
            @ViewBuilder placeholder: () -> Placeholder,
            @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
        ) {
            self.placeholder = placeholder()
            self.image = image
            _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
        }

    var body: some View {
            content
                .onAppear(perform: loader.load)
        }
    private var content: some View {
            Group {
                if loader.image != nil {
                    image(loader.image!)
                } else {
                    placeholder
                }
            }
        }
}
