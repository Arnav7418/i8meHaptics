// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreHaptics
import Foundation
import UIKit


public enum HapticType {
    // Basic UI
    case primaryTap
    case secondaryTap
    case tertiaryTap
    case lightTap
    case mediumTap
    case heavyTap
    
    // Toggles / checkboxes
    case checkboxSelected
    case checkboxDeselected
    
    // Navigation
    case navigationForward
    case navigationBack
    case tabChanged
    
    // Gestures
    case longPress
    case dragStart
    case dragChange
    case dragEnd
    
    // Feedback
    case success
    case successSoft
    case successStrong
    case error
    case failureSoft
    case failureStrong
    case warning
    case critical
    case disabled
    
    // Loading
    case loading
    case loadingStart
    case loadingProgress
    case loadingComplete
    
    // Notifications
    case notification
    case softNotification
    case attention
    
    // Data
    case selectionChanged
    case selectionBoundary
    case selectionInvalid
    case dataCopied
    case dataDeleted
    
    // Branding / Special
    case brandSignature
    case brandHeartbeat
    case highlight
    case emphasize
    
    // Fun / Gamified
    case pop
    case burst
    case coinDrop
    case sparkle
}

public final class I8MeHaptics {
    private static var engine: CHHapticEngine?

    public static func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        engine = try? CHHapticEngine()
        try? engine?.start()
    }
    
    public static func play(_ type: HapticType) {
        guard let engine = engine else { return }

        let pattern: CHHapticPattern
        switch type {
        
        // --- Basic taps ---
        case .primaryTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.55)], parameters: [])
        case .secondaryTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.35)], parameters: [])
        case .tertiaryTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.2)], parameters: [])
        case .lightTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.1)], parameters: [])
        case .mediumTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.4)], parameters: [])
        case .heavyTap: pattern = try! CHHapticPattern(events: [tap(intensity: 0.8)], parameters: [])
        
        // --- Toggles ---
        case .checkboxSelected:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.6),
                tap(at: 0.06, intensity: 0.3)
            ], parameters: [])
            
        case .checkboxDeselected:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.25)
            ], parameters: [])
        
        // --- Navigation ---
        case .navigationForward:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.5),
                continuous(at: 0.02, intensity: 0.3, sharpness: 0.4, duration: 0.08)
            ], parameters: [])
        
        case .navigationBack:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.4),
                tap(at: 0.05, intensity: 0.2)
            ], parameters: [])
        
        case .tabChanged:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.5),
                tap(at: 0.07, intensity: 0.3)
            ], parameters: [])
        
        // --- Gestures ---
        case .longPress:
            pattern = try! CHHapticPattern(events: [
                continuous(intensity: 0.3, sharpness: 0.2, duration: 0.3)
            ], parameters: [])
        
        case .dragStart:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.3)
            ], parameters: [])
        
        case .dragChange:
            pattern = try! CHHapticPattern(events: [
                continuous(intensity: 0.2, sharpness: 0.3, duration: 0.05)
            ], parameters: [])
        
        case .dragEnd:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.5)
            ], parameters: [])

        // --- Success / Failure ---
        case .success:
            pattern = try! complexSuccess()

        case .successSoft:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.4),
                tap(at: 0.08, intensity: 0.2)
            ], parameters: [])
            
        case .successStrong:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.9),
                tap(at: 0.1, intensity: 0.7),
                continuous(at: 0.15, intensity: 0.4, sharpness: 0.2, duration: 0.1)
            ], parameters: [])
        
        case .error:
            pattern = try! complexError()
        
        case .failureSoft:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.25),
                tap(at: 0.07, intensity: 0.1)
            ], parameters: [])
            
        case .failureStrong:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 1.0),
                tap(at: 0.12, intensity: 0.6)
            ], parameters: [])
        
        case .warning:
            pattern = try! CHHapticPattern(events: [
                continuous(intensity: 0.5, sharpness: 0.7, duration: 0.12)
            ], parameters: [])
        
        case .critical:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 1.0),
                tap(at: 0.1, intensity: 0.8),
                continuous(at: 0.14, intensity: 0.4, sharpness: 1.0, duration: 0.2)
            ], parameters: [])
        
        case .disabled:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.1, sharpness: 0.1)
            ], parameters: [])

        // --- Loading ---
        case .loading:
            pattern = try! CHHapticPattern(events: [
                continuous(intensity: 0.2, sharpness: 0.1, duration: 0.6)
            ], parameters: [])
            
        case .loadingStart:
            pattern = try! tap(intensity: 0.3).pattern
            
        case .loadingProgress:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.2),
                tap(at: 0.1, intensity: 0.2)
            ], parameters: [])
            
        case .loadingComplete:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.4),
                tap(at: 0.1, intensity: 0.6)
            ], parameters: [])

        // --- Notifications ---
        case .notification:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.5),
                tap(at: 0.08, intensity: 0.4)
            ], parameters: [])
        
        case .softNotification:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.3)
            ], parameters: [])
        
        case .attention:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.7),
                tap(at: 0.08, intensity: 0.7),
                tap(at: 0.16, intensity: 0.7)
            ], parameters: [])

        // --- Data ---
        case .selectionChanged:
            pattern = try! CHHapticPattern(events: [tap(intensity: 0.25)], parameters: [])
        case .selectionBoundary:
            pattern = try! CHHapticPattern(events: [tap(intensity: 0.45)], parameters: [])
        case .selectionInvalid:
            pattern = try! CHHapticPattern(events: [tap(intensity: 0.15)], parameters: [])
        case .dataCopied:
            pattern = try! complexCopy()
        case .dataDeleted:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.2),
                tap(at: 0.05, intensity: 0.4)
            ], parameters: [])

        // --- Branding Patterns ---
        case .brandSignature:
            pattern = try! brandSignature()
        case .brandHeartbeat:
            pattern = try! brandHeartbeat()
        case .highlight:
            pattern = try! rippleHighlight()
        case .emphasize:
            pattern = try! rippleEmphasize()

        // --- Fun / Gamified ---
        case .pop:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 0.5, sharpness: 0.9)
            ], parameters: [])
        
        case .burst:
            pattern = try! CHHapticPattern(events: [
                tap(intensity: 1.0),
                tap(at: 0.05, intensity: 0.5),
                tap(at: 0.10, intensity: 0.3)
            ], parameters: [])
        
        case .coinDrop:
            pattern = try! coinDrop()
        
        case .sparkle:
            pattern = try! sparkle()
        }

        let player = try? engine.makePlayer(with: pattern)
        try? player?.start(atTime: 0)
    }
}

private func tap(at time: TimeInterval = 0,
                 intensity: Float,
                 sharpness: Float = 0.5) -> CHHapticEvent {
    CHHapticEvent(eventType: .hapticTransient,
                  parameters: [
                      CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                      CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                  ],
                  relativeTime: time)
}

private func continuous(at time: TimeInterval = 0,
                        intensity: Float,
                        sharpness: Float,
                        duration: TimeInterval) -> CHHapticEvent {
    CHHapticEvent(eventType: .hapticContinuous,
                  parameters: [
                      CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                      CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                  ],
                  relativeTime: time,
                  duration: duration)
}

private func brandSignature() throws -> CHHapticPattern {
    let events = [
        tap(intensity: 0.7),
        tap(at: 0.10, intensity: 0.5),
        continuous(at: 0.15, intensity: 0.3, sharpness: 0.2, duration: 0.15)
    ]
    return try CHHapticPattern(events: events, parameters: [])
}

private func brandHeartbeat() throws -> CHHapticPattern {
    let events = [
        tap(intensity: 0.8),
        tap(at: 0.12, intensity: 0.6)
    ]
    return try CHHapticPattern(events: events, parameters: [])
}

private func rippleHighlight() throws -> CHHapticPattern {
    let events = [
        tap(intensity: 0.4),
        tap(at: 0.07, intensity: 0.3)
    ]
    return try CHHapticPattern(events: events, parameters: [])
}

private func rippleEmphasize() throws -> CHHapticPattern {
    let events = [
        tap(intensity: 0.7),
        tap(at: 0.10, intensity: 0.5),
        tap(at: 0.18, intensity: 0.3)
    ]
    return try CHHapticPattern(events: events, parameters: [])
}

private func coinDrop() throws -> CHHapticPattern {
    let events = [
        tap(intensity: 0.8),
        continuous(at: 0.05, intensity: 0.3, sharpness: 1.0, duration: 0.1)
    ]
    return try CHHapticPattern(events: events, parameters: [])
}

private func sparkle() throws -> CHHapticPattern {
    let events: [CHHapticEvent] = (0..<5).map { i in
        tap(at: TimeInterval(i) * 0.03, intensity: Float.random(in: 0.2...0.5), sharpness: 1.0)
    }
    return try CHHapticPattern(events: events, parameters: [])
}
