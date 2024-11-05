//
// DatePickerControl.swift
// MEOWLS
//
// Created by Artem Mayer on 03.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//
    
import SwiftUI

struct DatePickerControl: View {

    enum PickerState: Equatable {
        case show, datePicked, dateUnpicked, error
    }

    @Binding var date: Date?
    @Binding var dateState: PickerState
    @State private var selectedDate: Date = .now
    private let buttonTitle: String
    private let range: ClosedRange<Date>

    init(date: Binding<Date?>, dateState: Binding<PickerState>, buttonTitle: String, isBirthday: Bool = false) {
        self._date = date
        self._dateState = dateState
        self.buttonTitle = buttonTitle
        self.range = Date().pickerRange(isTodayUpper: isBirthday)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.shadowMedium))
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        dateState = .dateUnpicked
                    }
                }

            VStack {
                DatePicker("",
                           selection: $selectedDate,
                           in: range,
                           displayedComponents: .date)
                .datePickerStyle(.wheel)

                Button {
                    date = selectedDate
                    withAnimation {
                        dateState = .datePicked
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 48)
                            .foregroundColor(Color(.accentPrimary))

                        Text(LocalizedStringKey(buttonTitle))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.textWhite))
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(.backgroundWhite))
                    .padding(.horizontal, 16)
            }
        }
    }

}
