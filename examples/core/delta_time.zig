//   Port of https://github.com/raysan5/raylib/blob/master/examples/core/core_delta_time.c to zig
//
//   raylib [core] example - delta time
//
//   Example complexity rating: [★☆☆☆] 1/4
//
//   Example originally created with raylib 5.5, last time updated with raylib 5.6-dev
//
//   Example contributed by Robin (@RobinsAviary) and reviewed by Ramon Santamaria (@raysan5)
//
//   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//   BSD-like license that allows static linking with closed source software
//
//   Copyright (c) 2025 Robin (@RobinsAviary)

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - delta time");
    defer rl.closeWindow(); // Close window and OpenGL context

    var currentFps: i32 = 60;

    // Store the position for the both of the circles
    var deltaCircle = rl.Vector2.init(0, screenHeight / 3.0);
    var frameCircle = rl.Vector2.init(0, screenHeight * (2.0 / 3.0));

    // The speed applied to both circles
    const speed = 10.0;
    const circleRadius = 32.0;

    rl.setTargetFPS(currentFps); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Adjust the FPS target based on the mouse wheel
        const mouseWheel = rl.getMouseWheelMove();
        if (mouseWheel != 0) {
            currentFps += @intFromFloat(mouseWheel);
            if (currentFps < 0) currentFps = 0;
            rl.setTargetFPS(currentFps);
        }

        // GetFrameTime() returns the time it took to draw the last frame, in seconds (usually called delta time)
        // Uses the delta time to make the circle look like it's moving at a "consistent" speed regardless of FPS

        // Multiply by 6.0 (an arbitrary value) in order to make the speed
        // visually closer to the other circle (at 60 fps), for comparison
        deltaCircle.x += rl.getFrameTime() * 6.0 * speed;
        // This circle can move faster or slower visually depending on the FPS
        frameCircle.x += 0.1 * speed;

        // If either circle is off the screen, reset it back to the start
        if (deltaCircle.x > screenWidth) deltaCircle.x = 0;
        if (frameCircle.x > screenWidth) frameCircle.x = 0;

        // Reset both circles positions
        if (rl.isKeyPressed(.r)) {
            deltaCircle.x = 0;
            frameCircle.x = 0;
        }

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        // Draw both circles to the screen
        rl.drawCircleV(deltaCircle, circleRadius, .red);
        rl.drawCircleV(frameCircle, circleRadius, .blue);

        // Draw the help text
        // Determine what help text to show depending on the current FPS target
        if (currentFps <= 0) {
            rl.drawText(rl.textFormat("FPS: unlimited (%i)", .{rl.getFPS()}), 10, 10, 20, .dark_gray);
        } else {
            rl.drawText(rl.textFormat("FPS: %i (target: %i)", .{ rl.getFPS(), currentFps }), 10, 10, 20, .dark_gray);
        }
        rl.drawText(rl.textFormat("Frame time: %02.02f ms", .{rl.getFrameTime()}), 10, 30, 20, .dark_gray);
        rl.drawText("Use the scroll wheel to change the fps limit, r to reset", 10, 50, 20, .dark_gray);

        rl.drawText("FUNC: x += GetFrameTime()*speed", 10, 90, 20, .red);
        rl.drawText("FUNC: x += speed", 10, 240, 20, .blue);

        //----------------------------------------------------------------------------------
    }
}
