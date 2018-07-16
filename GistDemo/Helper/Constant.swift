//
//  AppDelegate.swift
//  GistDemo
//
//  Created by Apple on 16/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import AlamofireOauth2

let gistSettings = Oauth2Settings(
    baseURL: "https://api.github.com/authorizations",
    authorizeURL: "https://github.com/login/oauth/authorize",
    tokenURL: "https://github.com/login/oauth/access_token",
    redirectURL: "gistdemo://home",
    clientID: "995437183f8f74891677",
    clientSecret: "8ed633d8fb90f629945024f1d173e60c8969505b",
    scope: "gist"
)

