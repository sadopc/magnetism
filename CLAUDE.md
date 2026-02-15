# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Regenerate Xcode project after adding/removing files (uses XcodeGen)
xcodegen

# Build
xcodebuild -project Magnetism.xcodeproj -scheme Magnetism -destination 'platform=macOS' build

# Find and run the built app
open "$(find ~/Library/Developer/Xcode/DerivedData -path '*/Magnetism-*/Build/Products/Debug/Magnetism.app' -maxdepth 5 | head -1)"
```

**You must run `xcodegen` after creating or deleting any Swift file** — the project.yml sources the entire `Magnetism/` directory, but the .xcodeproj needs regeneration to pick up changes.

## Architecture

Menu-bar-only macOS window manager (LSUIElement=true, no dock icon). Swift 6 strict concurrency, macOS 14+, single SPM dependency: [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts).

### Data Flow

```
ShortcutManager (onKeyUp)  ──┐
                              ├──→ WindowManager.execute(WindowAction)
SnapManager (CGEvent tap)  ──┘         │
MenuBarManager (NSMenuItem)──┘    ┌────┼────────┐
                                  ↓    ↓        ↓
                             .restore .snap  .nextDisplay
                                  │    │        │
                           WindowHistory │  ScreenManager
                                  WindowCalculationFactory
                                       │
                                       ↓
                              AccessibilityElement.animateFrame()
                              (AX API: position + size via triple-set)
```

### Key Modules

- **Core/** — `WindowManager` orchestrates everything. `AccessibilityElement` wraps AXUIElement. `WindowAction` enum is the single source of truth for all 18 actions (display names, categories, shortcut bindings via extension in ShortcutNames.swift).
- **Calculations/** — One struct per layout action, all conforming to `WindowCalculation` protocol. Factory in `WindowCalculation.swift` maps `WindowAction` → calculation.
- **Shortcuts/** — `ShortcutNames.swift` defines `KeyboardShortcuts.Name` constants with Magnet-compatible defaults. `ShortcutManager` registers `onKeyUp` handlers.
- **Snapping/** — `SnapManager` uses a passive CGEvent tap (`.listenOnly`). `SnapZoneDetector` checks mouse position against screen edges/corners. `SnapOverlayWindow` shows an animated preview.
- **Preferences/** — `PreferencesWindowController` hosts SwiftUI views in an AppKit NSWindow (SwiftUI Settings scene is unreliable in LSUIElement apps).

## Critical Technical Patterns

### Coordinate Flipping
NSScreen uses bottom-left origin; AX API uses top-left origin. **All** window calculations must use `NSScreen.flippedVisibleFrame` (defined in `CGExtensions.swift`), never raw `visibleFrame`. The overlay window converts back with `CGRect.screenFlipped()` for display.

### Triple-Set Pattern
`AccessibilityElement.frame` setter does `setSize → setPosition → setSize`. macOS enforces per-display size limits during cross-display moves — setting size twice ensures the final frame is exact. This pattern also appears at the end of `animateFrame()`.

### Animation
`WindowManager.animateWindow()` is `nonisolated` and dispatches to `DispatchQueue.global(qos: .userInteractive)` because the animation loop uses `Thread.sleep()` in 12 steps with ease-out cubic interpolation. Cross-display moves skip animation (would look wrong flying through dead space).

### CGEvent Tap Memory Management
`SnapManager` passes `self` to the C callback via `Unmanaged.passUnretained()`. The `eventTap` property **must** be held — if it's deallocated, the tap stops working silently.

### Terminal.app Workaround
`WindowManager.execute()` temporarily disables `AXEnhancedUserInterface` before moving Terminal windows, then re-enables it in a `defer` block.

### Private API: `_AXUIElementGetWindow`
Declared via `@_silgen_name` in `AccessibilityElement.swift` to get `CGWindowID` from an AXUIElement. Used for window history tracking. May break in future macOS versions.

## Swift 6 Concurrency Strategy

All singleton managers are `@MainActor final class`. No async/await patterns. The only off-main-thread work is the animation loop in `AccessibilityElement.animateFrame()`.

The `kAXTrustedCheckOptionPrompt` global variable triggers a Swift 6 concurrency warning — worked around by using the string literal `"AXTrustedCheckOptionPrompt"` directly in `AccessibilityPermission.swift`.

## Adding a New Window Layout

1. Add a case to `WindowAction` enum (with `displayName` and `category`)
2. Create `Calculations/[Name]Calculation.swift` conforming to `WindowCalculation`
3. Add the case to `WindowCalculationFactory.calculation(for:)`
4. Add a `KeyboardShortcuts.Name` in `ShortcutNames.swift` with a default binding
5. Add the mapping in the `WindowAction.shortcutName` extension
6. Run `xcodegen` to pick up the new file

## Permissions

- **No App Sandbox** — required for AX API access
- **Accessibility permission** — prompted on first launch; re-prompted during development because ad-hoc re-signing invalidates the trust entry
- **No Input Monitoring needed** — CGEvent tap uses `.listenOnly` mode
