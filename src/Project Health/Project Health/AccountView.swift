//
//  AccountView.swift
//  Project Health
//
//  Created by Joseph Gaza
//

import SwiftUI


// This enum will highlight the text field the user is currently focused on
enum FocusField {
    case username, email, password, confirmPassword
}

struct AccountView: View {

    // Connects this swiftUI file to the Account.swift file
    @StateObject private var connectAccount = Account()
    
    // @State will regenerate the screen if the value changes
    // isSigningUp will determine if you are currently trying to log in or create an account
    @State private var isSigningUp = false
    
    // FocusState will highlight the field when clicked on
    @FocusState private var highlightField: FocusField?
    
    var body: some View {
        // NavigationStack puts new screens on the user's view
        NavigationStack {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Header
                        VStack(spacing: 8) {
                            Text("Project Health")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                        }
                        
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                        VStack(spacing: 16) {
                            // User is signing up
                            if isSigningUp {
                                TextField("Username", text: $connectAccount.userName)
                                    .textContentType(.username)
                                    .focused($highlightField, equals: .username)
                                    .submitLabel(.next)
                                    .onSubmit {highlightField = .email}
                                // Transition effect
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // This will make the email field visible always
                            TextField("Email", text: $connectAccount.email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .focused($highlightField, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { highlightField = .password}
                            
                            // This will make the password field visible always
                            SecureField("Password", text: $connectAccount.password)
                            // This will work with icloud keychain for saving passwords
                                .textContentType(isSigningUp ? .newPassword : .password)
                                .focused($highlightField, equals: .password)
                                .submitLabel(isSigningUp ? .next : .go)
                                .onSubmit {
                                    if isSigningUp {
                                        highlightField = .confirmPassword
                                    }
                                    else {
                                        executeAuthentication()
                                    }
                                }
                            
                            // This is the confirm password field
                            if isSigningUp {
                                SecureField("Confirm password", text: $connectAccount.confirmedPassword)
                                    .textContentType(.newPassword)
                                    .focused($highlightField, equals: .confirmPassword)
                                    .submitLabel(.go)
                                    .onSubmit {
                                        executeAuthentication()
                                    }
                                // Transition
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                        }
                        
                        // Error message design
                        if !connectAccount.errorMessage.isEmpty {
                            Text(connectAccount.errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
                        
                        VStack(spacing: 16) {
                            // Authentication Button
                            Button(action: executeAuthentication) {
                                ZStack {
                                    if connectAccount.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                    else {
                                        Text(isSigningUp ? "Create Account" : "Log In")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(connectAccount.isLoading ? Color.blue.opacity(0.7) : Color.blue)
                                .cornerRadius(14)
                                
                            }
                            .disabled(connectAccount.isLoading)
                            
                            // Spring like animation tied with the button
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    isSigningUp.toggle()
                                }
                            }) {
                                
                                // This will show if the user has an account or not
                                Text(isSigningUp ? "Already have an account?" : "Don't have an account? Sign up")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 10)
                        
                        
                    }
                    .padding(.horizontal, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            
            // Show the onboarding process
            .navigationDestination(isPresented: $connectAccount.showOnboarding) {
                UserInfoView(connectAccount: connectAccount)
            }
            
            // Show the main menu
            .navigationDestination(isPresented: $connectAccount.showDashboard) {
                Dashboard(connectAccount: connectAccount)
            }
        }
        
    }
    // Helper function that helps with triggering the logging in and signing up
    private func executeAuthentication() {
        highlightField = nil
        Task {
            if isSigningUp {
                await connectAccount.createAccount()
            }
            else {
                await connectAccount.loginUser()
            }
        }
    }
}

//#Preview {
//        AccountView()
//}
