//
//  net_image.swift
//  temp1
//
//  Created by Jill on 2021/3/2.
//

import Combine
import SwiftUI


@available(iOS 14.0, *)
struct NetworkImage: View {
    @StateObject private var viewModel = ViewModel()

    let url: URL?
    
    var body: some View {
        Group {
            if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if viewModel.isLoading {
                Image(systemName: "photo")
            } else {
                Image(systemName: "photo")
            }
        }
        .onAppear {
            viewModel.loadImage(from: url)
        }
    }
}


@available(iOS 14.0, *)
extension NetworkImage {
    class ViewModel: ObservableObject {
        @Published var imageData: Data?
        @Published var isLoading = false

        private static let cache = NSCache<NSURL, NSData>()

        private var cancellables = Set<AnyCancellable>()

        func loadImage(from url: URL?) {
            isLoading = true
            guard let url = url else {
                isLoading = false
                return
            }
            if let data = Self.cache.object(forKey: url as NSURL) {
                imageData = data as Data
                isLoading = false
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    if let data = $0 {
                        Self.cache.setObject(data as NSData, forKey: url as NSURL)
                        self?.imageData = data
                    }
                    self?.isLoading = false
                }
                .store(in: &cancellables)
        }
    }
}
