//
//  DrawingModel.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 29/10/2023.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable
class DrawingModel {
    
    //MARK: - Properties
    /// Public Properties
    
    /// Stores the points that need to be drawn in the canvas.
    public var points: [Point] = []
    
    /// Tracks the total size of the canvas for later calculations.
    public var frameSize = CGSize(width: 500, height: 500)
    
    /// Tracks the message to be shown under the dot on the canvas.
    public var message: String = ""
    
    public var scoreMessage: String = ""
    
    /// Tracks the current score from the user's drawing.
    public var score: Int = 0
    
    /// Tracks the user's best drawing score.
    public var bestScore: Int = 0
    
    /// Tracks the color used for the score label at the dot on the canvas.
    public var scoreColor: Color = .clear
    
    /// Tracks if the current score is a new best score.
    public var newBestScore = false
    
    /// Tracks if the best score should be shown.
    public var showBest = false
    
    /// Tracks if the user has drawn yet.
    public var hasDrawn = false
    
    /// Tracks if the user can currently draw.
    /// This can prevent a user from drawing when set to true as it disabled the gesture recogniser.
    /// The intention is to stop a drawing from continuing as the user is still dragging on the screen.
    public var canDraw = false
    
    /// Tracks if the user has drawn a valid circle
    public var isValid = false
    
    /// Private Properties
    private var isDrawing = false
    private var point: CGPoint = .zero
    private var time: Date = .init()
    private var speed: CGFloat = 0
    private var accuracy: CGFloat = 0
    private var dx: CGFloat = 0
    private var dy: CGFloat = 0
    private var angle: CGFloat = 0
    private var radius: CGFloat = 0
    private var distance: CGFloat = 0
    private var stroke: Double = 0
    private var radiusCalculatedAtStartOfDrawing: CGFloat = 0
    private var l: CGFloat = 0
    private var d: CGFloat = 0
    
    /// Tracks how many angles (0 to 360) the user has drawn so far of their circle.
    private var drawnAnglesOfCircle: CGFloat = 0
    
    private var e: CGPoint = .init()
    
    /// Timer used to draw the intro animation.
    private var demoTimer: Timer?
    
    /// Timer used to fail user if they take too long.
    private var timeOutTimer: Timer?
    
    private var failSoundEffect: AVAudioPlayer?
    private var successSoundEffect: AVAudioPlayer?
    private var drawingSoundEffect: AVAudioPlayer?
    
    //MARK: - Functions
    func drawStart(dragValue: DragGesture.Value) {
        
        /// Break earl if drawing has been set.
        /// This lets us use the Drag Gesture's onChanged method to trigger the start function once while its being constantly.
        if self.isDrawing { return }
        
        /// Set the hasDrawn to true with animation so that the instructions fade after beginning to draw.
        withAnimation(.spring) {
            self.hasDrawn = true
        }
        
        /// Reset internal properties so that we're ready for drawing.
        self.showBest = false
        self.newBestScore = false
        self.isDrawing = true
        self.isValid = false
        
        self.message = ""
        self.scoreMessage = ""
        
        self.canDraw = true
        
        self.points = []
        
        let coords = dragValue.location
        
        self.point.x = coords.x
        self.point.y = coords.y
        self.time = Date.now
        self.speed = 0
        self.accuracy = 1
        self.dx = 0
        self.dy = 0
        self.angle = 180 + 180 * atan2(coords.y - (frameSize.height / 2), coords.x - (frameSize.width / 2)) / .pi
        self.radius = sqrt(pow(coords.x - (frameSize.width / 2), 2) + pow(coords.y - (frameSize.height / 2), 2))
        self.distance = 0
        self.stroke = 20
        self.radiusCalculatedAtStartOfDrawing = radius
        self.l = 0
        self.d = 0
        self.drawnAnglesOfCircle = 0
        
//        let tempRadius = radius
//        if tempRadius < 100 {
//            self.message = "Too close to dot"
//        }
        
        /// Create timer that stops the user if they take too long
        self.timeOutTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self] timer in
            
            self.canDraw = false
            self.score = 0
            self.scoreColor = colorForAccuracy(accuracy: 0)
            self.message = "Too slow"
            
            timer.invalidate()
            
            /// Stop the drawing sound and play the fail sound
            stopDrawingSound()
            playFailSound()
            
        }
        
        playDrawingSound()
        
    }
    
    init() {
        
        self.bestScore = AppSettings().bestScore
        
    }
    
    func drawMove(dragValue: DragGesture.Value) {
        
        /// Break early if not drawing.
        if (!self.isDrawing) { return }
        if (!self.canDraw) { return }

        
        let currentTime = Date.now
        let coords = dragValue.location
        
        /// Calculate difference for the x and y coordinates between the last iteration and this iteration.
        let xDiff = coords.x - self.point.x
        let yDiff = coords.y - self.point.y
        
        
        /// Calculate the difference distance of the x and y coordinates calculated above.
        let internalDistance = sqrt(pow(xDiff, 2) + pow(yDiff, 2))
        
        /// Calculate the speed of the drawing at the current point.
        let internalSpeed = internalDistance / ((currentTime.timeIntervalSince1970 * 1000) - (time.timeIntervalSince1970 * 1000) + 0.001 )
        
        
        if self.distance == 0 {
            self.distance = internalDistance
        }
        
        if self.speed == 0 {
            self.speed = internalSpeed
        }
        
        
        /// Calculate the stroke width for the current point.
        var internalStroke = 1.5 + 2 / (0.05 + internalSpeed)
        internalStroke = (3 * self.stroke + internalStroke) / 4
        internalStroke = min(internalStroke, 20);
        
        /// Calculate the angle of the current point.
        let internalAngle = 180 + 180 * atan2(coords.y - (frameSize.height / 2), coords.x - (frameSize.width / 2)) / .pi
        
        var internalY = internalAngle - self.angle
        
        if internalY < -180 {
            internalY += 360
        } else if internalY > 180 {
            internalY -= 360
        }
        
        let k: CGFloat = internalY < 0 ? -1 : 1
        
        if 0 == self.l {
            if abs(internalY) < 0.1 { return }
            self.l = k
        }
        
    
        /// Calculate the radius of the current point from the center.
        let internalRadius: CGFloat = sqrt(pow(coords.x - (frameSize.width / 2), 2) + pow(coords.y - (frameSize.height / 2), 2))
        
        /// Calculate the accuracy of the current point
        let tempAccuracy = abs((internalRadius + radius) / 2 - radiusCalculatedAtStartOfDrawing)
        var internalAccuracy = 1 - tempAccuracy / radiusCalculatedAtStartOfDrawing
            internalAccuracy = max(internalAccuracy, 0)

        
        /// Check if the user is drawing back on the path.
        /// If so then display the wrong way message and stop drawing.
        if k != l {
//            print("wrong way")
            
            self.canDraw = false
            self.score = 0
            self.scoreColor = colorForAccuracy(accuracy: 0)
            self.message = "Wrong Way"
            
            /// Kill the timeout timer
            timeOutTimer?.invalidate()
            
            /// Stop the drawing sound and play the fail sound
            stopDrawingSound()
            playFailSound()
        }
        
        /// Check if the user is drawing too close to the center point.
        /// If so then display the too close message and stop drawing.
        else if internalRadius < 60 {
//            print("Too close to dot")
            
            self.canDraw = false
            self.score = 0
            self.scoreColor = colorForAccuracy(accuracy: 0)
            self.message = "Too close to dot"
            
            /// Kill the timeout timer
            timeOutTimer?.invalidate()
            
            /// Stop the drawing sound and play the fail sound
            stopDrawingSound()
            playFailSound()
            
        }
        
//        print(internalRadius)
        
        /// If we are able to draw then add the current touch point for drawing.
        if canDraw {
            points.append(Point(point: dragValue.location,
                                color: colorForAccuracy(accuracy: internalAccuracy),
                                stroke: internalStroke,
                                accuracy: internalAccuracy
                               )
            )
        }

        /// Store properties for using next iteration.
        self.point.x = coords.x
        self.point.y = coords.y
        self.time = currentTime
        self.speed = internalSpeed
        self.accuracy = internalAccuracy
        self.dx = xDiff
        self.dy = yDiff
        self.angle = internalAngle
        self.radius = internalRadius
        self.distance = internalDistance
        self.stroke = internalStroke
        
        internalY = abs(internalY)
        
        /// Calculate how much of the circle the user has drawn.
        self.drawnAnglesOfCircle += internalY
        
        if self.drawnAnglesOfCircle > 360 {
            internalY -= self.drawnAnglesOfCircle - 360
            self.drawnAnglesOfCircle = 360
        }
        
        
        
        /// No idea what this does yet...
        self.d += internalY * internalAccuracy
 
        /// Calculate score
        self.score = min(Int(round(1000 * d / drawnAnglesOfCircle)), 999)

        /// Determine score label color
        self.scoreColor = colorForAccuracy(accuracy: d / drawnAnglesOfCircle)
        
        /// Check if a user has completed drawing a circle.
        if self.drawnAnglesOfCircle >= 360 {
            drawingCompleted()
        }
        
        print(drawnAnglesOfCircle)
        
    }
    
    func drawEnd(dragValue: DragGesture.Value) {
        isDrawing = false
        canDraw = true
        
        timeOutTimer?.invalidate()
        
        /// Check if user hasn't finished drawing a full circle when lifting their finger.
        if self.drawnAnglesOfCircle < 360 && message.isEmpty {
            self.score = 0
            self.scoreColor = colorForAccuracy(accuracy: 0)
            self.message = "Draw a full circle"
            
            /// Kill the timeout timer
            timeOutTimer?.invalidate()
            
            /// Stop the drawing sound and play the fail sound
            stopDrawingSound()
            playFailSound()
        }
        
        stopDrawingSound()
    }
    
    func drawingCompleted() {
        
        /// Disable drawing.
//        self.isDrawing = false
        self.canDraw = false
        
        self.isValid = true
        
        stopDrawingSound()

        if self.bestScore == 0 {
            self.scoreMessage = "Have another go!"
        } else {
            self.showBest = true
        }
        
        if self.score > bestScore {
            self.bestScore = score
            
            playSuccessSound()
            
            if self.score >= 950 {
//                v.play()
            }
            
//            m.play("best")
            
            if self.bestScore == 0 { return }

            self.newBestScore = true
            self.showBest = false

            if self.score == 999 {
                self.scoreMessage = "Perfect circle"
            } else if self.score >= 990 {
                self.scoreMessage = "Divine circle"
            } else if self.score >= 980 {
                self.scoreMessage = "Legendary circle"
            } else {
                self.scoreMessage = "New best score"
            }
        }
        
    }
    
    func playDemoDrawingAnimation() {
        
        /// Clear points to wipe canvas.
        self.points = []
        
//        var pathString = ""
        
        var radiusCorrect: Double = 0
        var lastX: Double = 0
        var lastY: Double = 0
        var stroke: Double = 0
        var angle: Double = 0
        
        var count = 0
        let maxCount = 1200
        
        let timer = Timer(timeInterval: 0.001, repeats: true) { [self] timer in
            
            if count <= maxCount {
                
                let t = 0.04 + 0.01 * cos(2 + Double(count) / 47)
                angle += t
                
                var e = 280 + 85 * sin(4 + Double(count) / 66)
                
                let cosAngle = cos(angle)
                let r = (frameSize.width / 2) + e * cosAngle  + 50 * sin(1 + Double(count) / 29)
                
                let sinAngle = sin(angle)
                let o = (frameSize.height / 2) + e * sinAngle + 50 * cos(5 + Double(count) / 17)
                
                e = sqrt(pow(r - (frameSize.width / 2), 2) + pow(o - (frameSize.height / 2), 2))
                
                if radiusCorrect == 0 {
                    radiusCorrect = e
                }
                
                let d = 1 - abs(e - radiusCorrect) / radiusCorrect
    //            if lastX == 0 {
                    lastX = r
                    lastY = o
    //            }
                
    //            self.draw("path", attributes: [
    //                "d": "M\(n.lastX) \(n.lastY) L\(r) \(o)",
    //                "style": "stroke: \(M(d)); stroke-width: \(n.stroke)px;"
    //            ])
                
                
                
                
                
                self.points.append(Point(point: CGPoint(x: lastX, y: lastY), color: colorForAccuracy(accuracy: d), stroke: stroke, accuracy: d))
                
                self.point.x = r
                self.point.y = o
                
                let c = 16 - 300 * t
                stroke = (9 * stroke + c) / 10
                
                count += 1
                
                if count >= maxCount {
                    timer.invalidate()
                    
//                    for (index, point) in points.enumerated() {
//                        
//                        if let previousPoint = points[safe: index - 1] {
//                            
//                            var holder = point.accuracy - 0.75
//                            
//                            var color1: Double = 480 * holder
//                            color1 = min(color1, 120)
//                            color1 = max(color1, 0)
//                            
//                            pathString.append("""
//                                        <path style="stroke:hsl(\(color1), 100%, 50%)" stroke-width="\(point.stroke)" d="M\(point.point.x) \(point.point.y) L\(previousPoint.point.x) \(previousPoint.point.y)"/>
//                            """)
//                        }
//                        
//                    }
//                    
//
//                    print(pathString)
                }
                
                
            }
            
        }
        
        //add the timer to the run loop
        RunLoop.current.add(timer, forMode: .common)
        
        self.demoTimer = timer
        
        
        
        
    }
    
    func stopDemoAnimation() {
        
        self.demoTimer?.invalidate()
        
    }
    
//    func clearDrawing() {
//        
//    }
    
    
    
    private func playFailSound() {
        
        if AppSettings().soundEffectEnabled == false { return }
        
        guard let path = Bundle.main.path(forResource: "fail.mp3", ofType:nil) else { return }
        let url = URL(fileURLWithPath: path)

        do {
            failSoundEffect = try AVAudioPlayer(contentsOf: url)
            failSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playSuccessSound() {
        
        if AppSettings().soundEffectEnabled == false { return }
        
        guard let path = Bundle.main.path(forResource: "success.mp3", ofType:nil) else { return }
        let url = URL(fileURLWithPath: path)

        do {
            successSoundEffect = try AVAudioPlayer(contentsOf: url)
            successSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playDrawingSound() {
        
        if AppSettings().soundEffectEnabled == false { return }
        
        guard let path = Bundle.main.path(forResource: "drawing.mp3", ofType:nil) else { return }
        let url = URL(fileURLWithPath: path)

        do {
            drawingSoundEffect = try AVAudioPlayer(contentsOf: url)
            drawingSoundEffect?.volume = 0.2
            drawingSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    private func stopDrawingSound() {
        
        guard let drawingSoundEffect = self.drawingSoundEffect else { return }
        
        drawingSoundEffect.stop()
        
    }
    

}

extension EnvironmentValues {
    var drawingModel: DrawingModel {
        get { self[DrawingModelKey.self] }
        set { self[DrawingModelKey.self] = newValue }
    }
}

private struct DrawingModelKey: EnvironmentKey {
    static var defaultValue: DrawingModel = DrawingModel()
}
