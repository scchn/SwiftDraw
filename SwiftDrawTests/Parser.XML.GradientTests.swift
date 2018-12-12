//
//  Parser.XML.GradientTests.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 10/12/18.
//  Copyright 2018 Simon Whitty
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/swhitty/SwiftDraw
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


import Foundation

import XCTest
@testable import SwiftDraw

final class ParserXMLGradientTests: XCTestCase {

    func testParseGradients() throws {
        let child = XML.Element(name: "child")
        child.children = [XML.Element.makeMockGradient(), XML.Element.makeMockGradient()]

        let parent = XML.Element(name: "parent")
        parent.children = [XML.Element.makeMockGradient(), child]

        XCTAssertEqual(try XMLParser().parseLinearGradients(child).count, 2)
        XCTAssertEqual(try XMLParser().parseLinearGradients(parent).count, 3)
    }
}

private extension XML.Element {

    static func makeMockGradient() -> XML.Element {
        return XML.Element(name: "linearGradient")
    }
}