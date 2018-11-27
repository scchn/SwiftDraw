//
//  CGRenderer.PathTests.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 27/11/18.
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

import XCTest
@testable import SwiftDraw

final class RendererTests: XCTestCase {

    func testPerformCommands() {
        let renderer = MockRenderer()
        renderer.perform([
            .pushState,
            .popState,
            .pushTransparencyLayer,
            .popTransparencyLayer,
            .concatenate(transform: .identity),
            .translate(tx: 10, ty: 20),
            .scale(sx: 1, sy: 2),
            .rotate(angle: 10),
            .setFill(color: .none),
            .setStroke(color: .none),
            .setLine(width: 10),
            .setLineCap(.butt),
            .setLineJoin(.bevel),
            .setLineMiter(limit: 10),
            .setClip(path: .mock),
            .fill(.mock, rule: .nonzero),
            .stroke(.mock),
            .setAlpha(0.5),
            .setBlend(mode: .sourceIn),
            .draw(image: .mock)
            ])

        XCTAssertEqual(renderer.operations, [
            "pushState",
            "popState",
            "pushTransparencyLayer",
            "popTransparencyLayer",
            "concatenateTransform",
            "translate",
            "scale",
            "rotate",
            "setFillColor",
            "setStrokeColor",
            "setLineWidth",
            "setLineCap",
            "setLineJoin",
            "setLineMiterLimit",
            "setClip",
            "fillPath",
            "strokePath",
            "setAlpha",
            "setBlendMode",
            "drawImage"
            ])
    }
}


private extension LayerTree.Path {

    static var mock: LayerTree.Path {
        return LayerTree.Path()
    }
}

private extension LayerTree.Shape {

    static var mock: LayerTree.Shape {
        return .line(between: [])
    }
}


private extension LayerTree.Image {

    static var mock: LayerTree.Image {
        return .png(data: Data())
    }
}