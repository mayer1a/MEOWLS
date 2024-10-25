//
//  ProductListingCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI
import Kingfisher

public struct ProductListingCell: View {

    @Binding var isShortMode: Bool
    @State var model: ViewModel
    var isInACart: Bool
    var ratioMultiplier: Double

    var favoriteHandler: ((Product) -> Void)?
    var cartAction: ((Product) -> Void)?

    @State private var selectedPage = 0
    @State private var imageHeight: CGFloat = .zero

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            imageTabView
                .frame(minHeight: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background {
                    GeometryReader { proxy in
                        Color(.backgroundWhite)
                            .onAppear {
                                if imageHeight == .zero {
                                    imageHeight = proxy.size.width * ratioMultiplier
                                }
                            }
                    }
                }
                .onChange(of: selectedPage) { value in
                    model.selectedPage = value
                }
                .onAppear {
                    selectedPage = model.selectedPage
                }

            infoView
        }
    }

}

private extension ProductListingCell {

    var imageTabView: some View {
        ZStack {
            imageView

            VStack {
                HStack(alignment: .top) {
                    promoBadgesContainer

                    Spacer()

                    #if Store

                    foviritesContainer

                    #endif
                }
                .padding([.horizontal, .top], 8)

                Spacer()

                if model.images.count > 1 {
                    CustomizedPageControl(numberOfPages: model.images.count,
                                          currentPage: $selectedPage)
                    .padding(.bottom, 8)
                }
            }
        }
    }

    var foviritesContainer: some View {
        ZStack(alignment: .topTrailing) {
            favoriteImage
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(favoriteImageColor)
        }
        .frame(width: 40, height: 40, alignment: .topTrailing)
        .contentShape(Rectangle())
        .onTapGesture {
            favoriteHandler?(model.product)
        }
    }

    var imageView: some View {
        GeometryReader { proxy in
            TabView(selection: $selectedPage) {
                if !model.images.isEmpty {
                    ForEach(0..<model.images.count, id: \.self) { imageIndex in
                        kfImage(for: model.images[imageIndex], with: proxy.size)
                            .tag(imageIndex)
                    }
                } else {
                    Image(.itemLong)
                        .resizable()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    func kfImage(for image: ItemImage, with size: CGSize) -> some View {
        KFImage(image.scale(factor: .pixels(size.width * UIScreen.main.scale)).url?.toURL)
            .targetCache(ImageCache.default)
            .originalCache(ImageCache.default)
            .cacheOriginalImage()
            .placeholder { Image(.itemLong) }
            .onFailureImage(UIImage(resource: .checkboxChecked))
            .fade(duration: 0.2)
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                priceView

                Text(model.name)
                    .font(UIFont.systemFont(ofSize: 12, weight: .medium).asFont)
            }

            Spacer(minLength: 0)
            if !isShortMode {
                makeCartButton()
            }
        }
    }

    var priceView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(model.newPrice)
                .font(UIFont.systemFont(ofSize: 18, weight: .semibold).asFont)

            if let oldPrice = model.oldPrice, let discount = model.discount {
                StrikethroughPriceView(oldPrice: oldPrice, discount: discount)
            }
        }
    }

    @ViewBuilder
    func makeCartButton() -> some View {
        Button {
            cartAction?(model.product)
        } label: {
            cartButtonText
                .frame(minWidth: 44, maxWidth: .infinity, minHeight: 36)
                .background {
                    cartButtonBackgroundColor
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    var cartButtonText: some View {
        if isInACart {
            Text("Catalogue.inCart")
                .font(UIFont.systemFont(ofSize: 16, weight: .semibold).asFont)
                .foregroundStyle(Color(.accentPrimary))
        } else {
            Text("Catalogue.addToCart")
                .font(UIFont.systemFont(ofSize: 16, weight: .semibold).asFont)
                .foregroundStyle(Color(.textWhite))
        }
    }

    @ViewBuilder
    var promoBadgesContainer: some View {
        if let badges = model.badges {
            HStack(spacing: 4) {
                ForEach(badges, id: \.text) { badge in
                    DomainBadge(badge.title, with: .init(type: .square, color: .green(opaque: false)))
                }
            }
        }
    }
    var cartButtonImage: Image {
        Image(isInACart ? .check : .details)
    }

    var cartButtonForegroundColor: Color {
        Color(isInACart ? .accentPrimary : .backgroundWhite)
    }

    var cartButtonBackgroundColor: Color {
        Color(isInACart ? .accentFaded : .accentPrimary)
    }

    var favoriteImage: Image {
        Image(.heartButtonChecked)
    }

    var favoriteImageColor: Color {
        Color(model.isFavorite ? .accentTertiary : .textDisabled)
    }

}
