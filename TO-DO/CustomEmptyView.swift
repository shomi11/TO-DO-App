//
//  CustomEmptyView.swift
//  TO-DO
//
//  Created by Milos Malovic on 20.5.21..
//

import SwiftUI

struct CustomEmptyView: View {
    var body: some View {
        Text("Please select project from the menu to begin.")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct CustomEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        CustomEmptyView()
    }
}
