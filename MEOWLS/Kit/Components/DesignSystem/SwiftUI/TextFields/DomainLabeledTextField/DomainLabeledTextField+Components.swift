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
                        .foregroundStyle(UIColor(resource: .textPrimary).asColor)
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxHeight: .infinity)
                .background {
                    Color(.backgroundPrimary)
                }
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
            Image(.removeCircleSolid)
                .renderingMode(.template)
                .foregroundStyle(Color(.iconSecondary))
                .padding([.vertical, .leading], 8)
        }
    }

    var errorMessageText: some View {
        Text(LocalizedStringKey(viewModel.dataState.errorText ?? ""))
            .font(.system(size: 12))
            .foregroundStyle(Color(.badgeRedPrimary))
            .frame(height: 16)
            .padding(.horizontal, 12)
    }

    var errorMark: some View {
        Image(.exclamationMarkCircleUnfilled)
            .padding([.vertical, .leading], 8)
    }

    private func getFlag(for region: String) -> String {
        region.unicodeScalars.reduce(into: "") {
            $0.unicodeScalars.append(UnicodeScalar(127397 + $1.value)!)
        }
    }

}
