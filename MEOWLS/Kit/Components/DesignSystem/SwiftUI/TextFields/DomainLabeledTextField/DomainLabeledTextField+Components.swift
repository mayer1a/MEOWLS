//
//  DomainLabeledTextField+Components.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import SwiftUI

extension DomainLabeledTextField {

    var topLabelView: some View {
        Text(LocalizedStringKey(viewModel.dataState.label))
            .font(.system(size: 12))
            .foregroundStyle(labelColor)
    }

    @ViewBuilder
    var regionSelectionButton: some View {
        if let selectedRegion = selectedRegion?.wrappedValue, let regionCode = regionCode?.wrappedValue {
            Button(action: {}) {
                HStack(spacing: 6) {
                    Text(getFlag(for: selectedRegion))

                    Text(regionCode)
                        .foregroundStyle(Colors.Text.textPrimary.suiColor)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxHeight: .infinity)
                .background(Colors.Background.backgroundPrimary.suiColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
        }
    }

    var clearButton: some View {
        Button {
            withAnimation {
                inputText = ""
            }
        } label: {
            Images.Common.removeCircleSolid.suiImage
                .renderingMode(.template)
                .foregroundStyle(Colors.Icon.iconSecondary.suiColor)
                .padding([.vertical, .leading], 8)
        }
    }

    var errorMessageText: some View {
        Text(LocalizedStringKey(viewModel.dataState.errorText ?? ""))
            .font(.system(size: 12))
            .foregroundStyle(Colors.Badge.badgeRedPrimary.suiColor)
            .frame(height: 16)
            .padding(.horizontal, 12)
    }

    var errorMark: some View {
        Images.Common.exclamationMarkCircleUnfilled.suiImage
            .padding([.vertical, .leading], 8)
    }

    private func getFlag(for region: String) -> String {
        region.unicodeScalars.reduce(into: "") {
            $0.unicodeScalars.append(UnicodeScalar(127397 + $1.value)!)
        }
    }

}
