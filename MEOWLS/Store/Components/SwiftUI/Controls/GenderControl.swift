//
// GenderControl.swift
// MEOWLS
//
// Created by Artem Mayer on 03.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//
    
import SwiftUI

struct GenderControl: View {

    @State var genders: [UserCredential.Gender]
    @Binding var hasError: Bool
    @Binding var selectedGender: UserCredential.Gender?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if hasError {
                DomainMessage(label: "Profile.Edit.emptyGender",
                              type: .error)
            }

            genderSelector
                .padding(.horizontal, 12)
        }
    }

    var genderSelector: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Profile.Edit.gender")
                .font(.system(size: 12))
                .foregroundStyle(Colors.Text.textSecondary.suiColor)

            ForEach(genders, id: \.self) { gender in
                HStack(alignment: .top, spacing: 8) {
                    getCheckboxImage(for: gender)
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 10)

                    Text(gender.localizableDescription)
                        .frame(maxHeight: 22)
                        .padding(.top, 10)
                }
                .onTapGesture {
                    withAnimation {
                        selectedGender = gender
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func getCheckboxImage(for gender: UserCredential.Gender) -> some View {
        if selectedGender == gender {
            Images.Buttons.radioButtonActive.suiImage
                .resizable()
        } else {
            Images.Buttons.radioButtonInactive.suiImage
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Colors.Icon.iconSecondary.suiColor)
        }
    }

}

