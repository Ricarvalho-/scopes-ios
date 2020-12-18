//
//  CommandProvider.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 18/12/20.
//

import Foundation

protocol CommandProvider {
    var availableCommands: [Command] { get }
    mutating func perform(_ command: Command)
}

protocol Command {
    var title: Localizable { get }
}
