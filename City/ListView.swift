//
//  ListView.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI

struct ListView: View {
    @Binding var recentlyViewedPages: [Business]

    var body: some View {
        List {
            ForEach(recentlyViewedPages) { business in
                                    Text(business.name)
                                }
           }    }
}
//
//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
