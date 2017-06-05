//
//  LayerTree.Commands.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 5/6/17.
//  Copyright © 2017 WhileLoop Pty Ltd. All rights reserved.
//

import Foundation

// Convert a LayerTree into RenderCommands


extension LayerTree {
    
    final class CommandGenerator<P: RendererTypeProvider>{
        
        let provider: P
        
        init(provider: P) {
            self.provider = provider
        }
        
        func renderCommands(for layer: Layer) -> [RendererCommand<P.Types>] {
            guard layer.opacity > 0.0 else { return [] }
            
            let opacityCommands = renderCommands(forOpacity: layer.opacity)
            let transformCommands = renderCommands(forTransform: layer.transform)
            let clipCommands = renderCommands(forClip: layer.clip)
            
            //TODO: handle layer.mask
            // render to transparanency layer then composite contents on top.
            
            var commands = [RendererCommand<P.Types>]()
            
            if !opacityCommands.isEmpty ||
               !transformCommands.isEmpty ||
               !clipCommands.isEmpty {
                commands.append(.pushState)
            }

            commands.append(contentsOf: transformCommands)
            commands.append(contentsOf: opacityCommands)
            commands.append(contentsOf: clipCommands)
            
            //render all of the layer contents
            for contents in layer.contents {
                commands.append(contentsOf: renderCommands(for: contents))
            }
            
            if !opacityCommands.isEmpty {
                commands.append(.popTransparencyLayer)
            }
            
            if !opacityCommands.isEmpty ||
               !transformCommands.isEmpty ||
               !clipCommands.isEmpty {
                commands.append(.popState)
            }
            
            return commands
        }
        
        func renderCommands(for contents: Layer.Contents) -> [RendererCommand<P.Types>] {
            switch contents {
            case .shape(let shape, let stroke, let fill):
                return renderCommands(for: shape, stroke: stroke, fill: fill)
            case .image(let image):
                return renderCommands(for: image)
            case .text(let text, let point, let att):
                return renderCommands(for: text, at: point, attributes: att)
            case .layer(let layer):
                return renderCommands(for: layer)
            }
        }
        
        func renderCommands(for shape: Shape, stroke: StrokeAttributes, fill: FillAttributes) -> [RendererCommand<P.Types>] {
            var commands = [RendererCommand<P.Types>]()
            let path = provider.createPath(from: shape)
            
            if fill.color != .none {
                let color = provider.createColor(from: fill.color)
                let rule = provider.createFillRule(from: fill.rule)
                commands.append(.setFill(color: color))
                commands.append(.fill(path, rule: rule))
            }
            
            if stroke.color != .none,
               stroke.width > 0.0 {
                let color = provider.createColor(from: stroke.color)
                let width = provider.createFloat(from: stroke.width)
                let cap = provider.createLineCap(from: stroke.cap)
                let join = provider.createLineJoin(from: stroke.join)
                let limit = provider.createFloat(from: stroke.miterLimit)
                
                commands.append(.setLineCap(cap))
                commands.append(.setLineJoin(join))
                commands.append(.setLine(width: width))
                commands.append(.setLineMiter(limit: limit))
                commands.append(.setStroke(color: color))
                commands.append(.stroke(path))
            }
            
            return commands
        }
        
        func renderCommands(for image: Image) -> [RendererCommand<P.Types>] {
            guard let renderImage = provider.createImage(from: image) else { return  [] }
            return [.draw(image: renderImage)]
        }
        
        func renderCommands(for text: String, at point: Point, attributes: TextAttributes) -> [RendererCommand<P.Types>] {
            guard let path = provider.createPath(from: text, at: point, with: attributes) else { return [] }
            
            let color = provider.createColor(from: attributes.color)
            let rule = provider.createFillRule(from: .nonzero)
            
            return [.setFill(color: color),
                    .fill(path, rule: rule)]
        }
    
        func renderCommands(forOpacity opacity: Float) -> [RendererCommand<P.Types>] {
            guard opacity < 1.0 else { return [] }
            
            return [.setAlpha(provider.createFloat(from: opacity)),
                    .pushTransparencyLayer]
        }
        
        func renderCommands(forTransform transform: Transform) -> [RendererCommand<P.Types>] {
            guard transform != .identity else { return [] }
            
            return [.concatenate(transform: provider.createTransform(from: transform))]
        }
        
        func renderCommands(forClip shapes: [Shape]) -> [RendererCommand<P.Types>] {
            guard !shapes.isEmpty else { return [] }
            
            let paths = shapes.map{ provider.createPath(from: $0) }
            let clipPath = provider.createPath(from: paths)
            
            return [.setClip(path: clipPath)]
        }
    }
    
}