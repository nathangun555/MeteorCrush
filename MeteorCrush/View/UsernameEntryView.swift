//
//  UsernameEntryView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

//
//  UserEntryView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

import SwiftUI

struct UsernameEntryView: View {
    @State private var enteredName: String = ""
    @State private var navigateToNextPage = false
    @StateObject private var userData = UserData()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("bg1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()
                    Text("METEOR")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    Text("CRUSH")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    Text("Please Enter your Username")
                        .foregroundColor(.black)
                        .padding(.top, 30)

                    TextField("Your Name", text: $enteredName)
                        .padding()
                        .frame(height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(20)
                        .padding(.horizontal)

                    Button(action: {
                        if !enteredName.isEmpty {
                            userData.username = enteredName
                            navigateToNextPage = true
                        }
                    }) {
                        Text("Continue")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(35)
                            .padding(.horizontal)
                    }

                    // Invisible NavigationLink controlled by button press
                    NavigationLink(
                        destination: MainMenuView().environmentObject(userData),
                        isActive: $navigateToNextPage,
                        label: { EmptyView() }
                    )

                    Spacer()
                }
            }
        }
    }
}


#Preview {
    UsernameEntryView()
}
