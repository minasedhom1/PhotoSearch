//
//  APIResponse.swift
//  PhotoSearch
//
//  Created by Mina Sedhom on 1/26/22.
//  Copyright © 2022 Mina Sedhom. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

