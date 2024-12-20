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
                        Colors.Background.backgroundWhite.suiColor
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
                    Images.Catalogue.noImagePlaceholder.suiImage
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
            .placeholder { Images.Catalogue.imagePlaceholder.suiImage }
            .onFailureImage(Images.Catalogue.noImagePlaceholder.image)
            .fade(duration: 0.2)
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                priceView

                Text(model.name)
                    .lineLimit(3)
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
                .background(cartButtonBackgroundColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    var cartButtonText: some View {
        if isInACart {
            Text("Catalogue.inCart")
                .font(UIFont.systemFont(ofSize: 16, weight: .semibold).asFont)
                .foregroundStyle(Colors.Accent.accentPrimary.suiColor)
        } else {
            Text("Catalogue.addToCart")
                .font(UIFont.systemFont(ofSize: 16, weight: .semibold).asFont)
                .foregroundStyle(Colors.Text.textWhite.suiColor)
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
        isInACart ? Images.Common.check.suiImage : Images.Tabs.tabCart.suiImage
    }

    var cartButtonForegroundColor: Color {
        isInACart ? Colors.Accent.accentPrimary.suiColor : Colors.Background.backgroundWhite.suiColor
    }

    var cartButtonBackgroundColor: Color {
        isInACart ? Colors.Accent.accentFaded.suiColor : Colors.Accent.accentPrimary.suiColor
    }

    var favoriteImage: Image {
        Images.Buttons.heartChecked.suiImage
    }

    var favoriteImageColor: Color {
        model.isFavorite ? Colors.Accent.accentTertiary.suiColor : Colors.Text.textDisabled.suiColor
    }

}
