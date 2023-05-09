//
//  ListView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
               Text("this is a bar")
               Text("click")
               Text("Hello World")
           }    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
