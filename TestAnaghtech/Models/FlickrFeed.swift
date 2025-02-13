//
//  FlickrFeed.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

struct FlickrFeed: Codable {
    let title: String
    let items: [FlickrItem]
}
