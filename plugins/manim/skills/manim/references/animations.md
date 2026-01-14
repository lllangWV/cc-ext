# Animations Reference

Complete guide to Manim's animation system.

## Table of Contents

1. [Animation Fundamentals](#animation-fundamentals)
2. [The .animate Syntax](#the-animate-syntax)
3. [Creation Animations](#creation-animations)
4. [Transform Animations](#transform-animations)
5. [Fading Animations](#fading-animations)
6. [Movement Animations](#movement-animations)
7. [Indication Animations](#indication-animations)
8. [Animation Composition](#animation-composition)
9. [Rate Functions](#rate-functions)
10. [Updaters](#updaters)
11. [Custom Animations](#custom-animations)

---

## Animation Fundamentals

### Animation Lifecycle

Every animation goes through:
1. `begin()` - Initialize, copy starting mobject
2. `interpolate(alpha)` - Called each frame, alpha goes 0→1
3. `finish()` - Completion handling
4. `clean_up_from_scene()` - Optional removal

### Core Parameters

All animations accept these parameters:

```python
Animation(
    mobject,
    run_time=1.0,           # Duration in seconds
    rate_func=smooth,       # Easing function
    lag_ratio=0,            # Stagger for submobjects
    remover=False,          # Remove mobject after animation
    suspend_mobject_updating=True  # Pause updaters during animation
)
```

### Playing Animations

```python
# Single animation
self.play(Create(circle))

# Multiple simultaneous animations
self.play(Create(circle), FadeIn(square))

# With timing
self.play(animation, run_time=2)

# Wait between animations
self.wait()           # 1 second default
self.wait(2)          # 2 seconds
self.wait_until(condition_func)  # Until condition is true

# Add without animation
self.add(mobject)
self.remove(mobject)
```

---

## The .animate Syntax

The most flexible way to animate mobject methods:

```python
# Basic syntax
self.play(mobject.animate.method())

# Chain multiple methods
self.play(square.animate.shift(RIGHT).rotate(PI/4).scale(2))

# Any mobject method works
self.play(circle.animate.set_color(RED))
self.play(text.animate.set_fill(BLUE, opacity=0.5))
self.play(obj.animate.move_to(UP * 2))
self.play(group.animate.arrange(DOWN))

# With animation parameters
self.play(obj.animate.shift(UP), run_time=2, rate_func=linear)

# Multiple objects
self.play(
    circle.animate.shift(LEFT),
    square.animate.shift(RIGHT)
)
```

### Important Notes

```python
# .animate creates a Transform animation internally
# These are equivalent:
self.play(square.animate.shift(RIGHT))
self.play(Transform(square, square.copy().shift(RIGHT)))

# animate.set_x returns None, doesn't work:
# DON'T: new_square = square.animate.shift(RIGHT)
# DO: Use Transform or ReplacementTransform for this
```

---

## Creation Animations

Animations that bring objects into existence:

```python
# Draw stroke progressively
Create(mobject)
Create(mobject, lag_ratio=0.5)  # Stagger submobjects

# Write like handwriting (for text/tex)
Write(mobject)
Write(text, run_time=2)

# Draw border, then fill
DrawBorderThenFill(mobject)
DrawBorderThenFill(shape, run_time=2)

# Reverse of Create (for removal)
Uncreate(mobject)

# Unwrite (reverse of Write)
Unwrite(mobject)
Unwrite(text, reverse=False)  # Unwrite forward

# Add with simple effect
AddTextLetterByLetter(text)
AddTextWordByWord(text)
```

### Growth Animations

```python
# Grow from center
GrowFromCenter(mobject)

# Grow from specific point
GrowFromPoint(mobject, point)
GrowFromPoint(circle, LEFT * 3)

# Grow from edge
GrowFromEdge(mobject, edge)
GrowFromEdge(square, DOWN)

# Grow arrow
GrowArrow(arrow)

# Spinner effect
SpinInFromNothing(mobject)
```

---

## Transform Animations

### Basic Transforms

```python
# Transform: Mutates source to look like target
# Source mobject is modified, target is unused after
Transform(source, target)

# ReplacementTransform: Replaces source with target in scene
# Source is removed, target is added
ReplacementTransform(source, target)

# Key difference:
circle = Circle()
square = Square()

# After Transform(circle, square):
#   - circle now looks like square
#   - circle is still the object in the scene

# After ReplacementTransform(circle, square):
#   - circle is removed from scene
#   - square is now in the scene
```

### Intelligent Transforms

```python
# Match submobjects by shape similarity
TransformMatchingShapes(source, target)
TransformMatchingShapes(text1, text2, path_arc=PI/2)

# Match by tex strings
TransformMatchingTex(tex1, tex2)

# Match with fade for unmatched parts
TransformMatchingShapes(source, target, fade_transform_mismatches=True)

# Counterclockwise transform
CounterclockwiseTransform(source, target)
ClockwiseTransform(source, target)
```

### Morphing

```python
# Cross-fade between objects
FadeTransform(source, target)
FadeTransform(source, target, stretch=True)

# Transform with path arc
Transform(source, target, path_arc=PI/2)

# Transform specific submobjects
TransformFromCopy(source, target)  # Keep source, add transformed copy

# Cycle transforms
CyclicReplace(obj1, obj2, obj3)  # obj1→obj2, obj2→obj3, obj3→obj1
```

### Special Transforms

```python
# Swap positions
Swap(mobject1, mobject2)

# Move along path
MoveAlongPath(mobject, path)
MoveAlongPath(dot, curve, rate_func=linear)

# Restore to saved state
Restore(mobject)  # Must have called save_state() first

# Apply function to mobject
ApplyFunction(lambda m: m.scale(2).shift(UP), mobject)

# Apply method
ApplyMethod(mobject.shift, UP)  # Same as mobject.animate.shift(UP)
```

---

## Fading Animations

### FadeIn Variants

```python
# Basic fade in
FadeIn(mobject)

# Fade in with shift (appear to come from direction)
FadeIn(mobject, shift=UP)      # Fade in moving upward
FadeIn(mobject, shift=DOWN)    # Fade in moving downward
FadeIn(mobject, shift=LEFT*2)  # Fade in from right

# Fade in with scale
FadeIn(mobject, scale=0.5)     # Grow while fading in
FadeIn(mobject, scale=2)       # Shrink while fading in

# Fade in to specific position
FadeIn(mobject, target_position=UP*2)

# Combined
FadeIn(mobject, shift=DOWN, scale=0.5)
```

### FadeOut Variants

```python
# Basic fade out
FadeOut(mobject)

# Fade out with shift
FadeOut(mobject, shift=UP)     # Fade out moving upward
FadeOut(mobject, shift=DOWN)   # Fade out moving downward

# Fade out with scale
FadeOut(mobject, scale=0.5)    # Shrink while fading out
FadeOut(mobject, scale=2)      # Grow while fading out

# Combined
FadeOut(mobject, shift=UP, scale=0)  # Shrink to nothing while moving up
```

### Cross-Fade

```python
# Fade out one, fade in another
FadeTransform(old_mobject, new_mobject)
FadeTransformPieces(old_group, new_group)  # Match submobjects
```

---

## Movement Animations

### Rotation

```python
# Basic rotation
Rotate(mobject, angle=PI)
Rotate(mobject, angle=PI/4)

# About a point
Rotate(mobject, angle=PI, about_point=ORIGIN)
Rotate(mobject, angle=PI, about_point=LEFT*2)

# About an axis (for 3D)
Rotate(mobject, angle=PI, axis=RIGHT)  # Rotate about x-axis
Rotate(mobject, angle=PI, axis=UP)     # Rotate about y-axis
Rotate(mobject, angle=PI, axis=OUT)    # Rotate about z-axis (default 2D)

# Spinning
Rotating(mobject, radians=TAU)  # Continuous rotation
Rotating(mobject, radians=TAU, run_time=3)
```

### Movement

```python
# Move to point
MoveToTarget(mobject)  # Must set mobject.target first

# Setup for MoveToTarget
mobject.generate_target()
mobject.target.shift(UP)
mobject.target.scale(2)
self.play(MoveToTarget(mobject))

# Shift animation
ApplyMethod(mobject.shift, direction)

# Homotopy (complex path movement)
Homotopy(homotopy_func, mobject)
# homotopy_func(x, y, z, t) -> new point
```

### Path Following

```python
# Follow a VMobject path
MoveAlongPath(mobject, path, rate_func=linear)

# Example: move dot along circle
circle_path = Circle(radius=2)
dot = Dot()
self.play(MoveAlongPath(dot, circle_path, run_time=3))
```

---

## Indication Animations

Draw attention to objects without permanent changes:

```python
# Briefly scale up and recolor
Indicate(mobject)
Indicate(mobject, color=YELLOW, scale_factor=1.2)

# Flash lines radiating outward
Flash(mobject)
Flash(point, color=YELLOW, line_length=0.3)

# Shrinking spotlight effect
FocusOn(mobject)
FocusOn(point, color=GRAY, opacity=0.8)

# Draw temporary surrounding line
Circumscribe(mobject)
Circumscribe(mobject, color=YELLOW, time_width=0.3)
Circumscribe(mobject, shape=Circle)  # Circle instead of rectangle

# Wiggle back and forth
Wiggle(mobject)
Wiggle(mobject, scale_value=1.1, rotation_angle=0.05*TAU)

# Show surrounding rectangle temporarily
ShowPassingFlash(mobject)
ShowPassingFlash(vmobject.copy().set_color(YELLOW), time_width=0.3)

# Wave distortion
ApplyWave(mobject)
ApplyWave(mobject, direction=UP, amplitude=0.3)
```

---

## Animation Composition

### Simultaneous Animations

```python
# Multiple animations in same play() call
self.play(
    Create(circle),
    FadeIn(square),
    text.animate.shift(UP)
)

# AnimationGroup (explicit)
self.play(AnimationGroup(
    Create(circle),
    Create(square),
    lag_ratio=0  # 0 = simultaneous (default)
))
```

### Staggered Animations

```python
# LaggedStart: Each starts after delay
self.play(LaggedStart(
    Create(obj1),
    Create(obj2),
    Create(obj3),
    lag_ratio=0.5  # Each starts at 50% of previous
))

# With VGroup
objects = VGroup(*[Circle() for _ in range(10)])
self.play(LaggedStart(*[Create(o) for o in objects], lag_ratio=0.2))

# LaggedStartMap: Apply same animation to each
self.play(LaggedStartMap(Create, objects, lag_ratio=0.1))
self.play(LaggedStartMap(FadeIn, objects, lag_ratio=0.05))
```

### Sequential Animations

```python
# Succession: One after another
self.play(Succession(
    Create(circle),
    Transform(circle, square),
    FadeOut(circle)
))

# With timing
self.play(Succession(
    Create(circle, run_time=1),
    Wait(0.5),
    FadeOut(circle, run_time=0.5)
))
```

### AnimationGroup Parameters

```python
AnimationGroup(
    anim1, anim2, anim3,
    lag_ratio=0,        # 0=simultaneous, 1=sequential
    run_time=None,      # Override total duration
    rate_func=smooth,   # Apply to group
    group=None          # Mobject group to use
)
```

---

## Rate Functions

Control animation timing/easing:

### Built-in Rate Functions

```python
from manim import rate_functions

# Linear
linear                    # Constant speed

# Smooth (default)
smooth                    # S-curve, slow start/end

# Ease In (start slow)
ease_in_sine
ease_in_quad             # Quadratic
ease_in_cubic            # Cubic
ease_in_quart            # Quartic
ease_in_quint            # Quintic
ease_in_expo             # Exponential
ease_in_circ             # Circular
ease_in_back             # Overshoot start
ease_in_elastic          # Elastic
ease_in_bounce           # Bounce

# Ease Out (end slow)
ease_out_sine
ease_out_quad
ease_out_cubic
ease_out_quart
ease_out_quint
ease_out_expo
ease_out_circ
ease_out_back            # Overshoot end
ease_out_elastic
ease_out_bounce

# Ease In-Out (slow start and end)
ease_in_out_sine
ease_in_out_quad
ease_in_out_cubic
ease_in_out_quart
ease_in_out_quint
ease_in_out_expo
ease_in_out_circ
ease_in_out_back
ease_in_out_elastic
ease_in_out_bounce

# Special
there_and_back           # Forward then back to start
there_and_back_with_pause  # Pause in middle
running_start            # Small backup first
rush_into                # Rush into the end
rush_from                # Rush from the start
double_smooth            # Extra smooth
wiggle                   # Oscillate
not_quite_there(0.7)     # Only go 70% of the way
lingering                # Linger at end
exponential_decay        # Decay exponentially
```

### Using Rate Functions

```python
# In play
self.play(Create(circle), rate_func=linear)
self.play(obj.animate.shift(UP), rate_func=ease_in_out_quad)

# In Animation class
Create(circle, rate_func=smooth)
Transform(a, b, rate_func=there_and_back)
```

### Custom Rate Functions

```python
# Rate function signature: takes t (0-1), returns value (usually 0-1)
def custom_rate(t):
    return t ** 3  # Cubic ease in

def bounce(t):
    if t < 0.5:
        return 2 * t
    else:
        return 2 - 2 * t

self.play(animation, rate_func=custom_rate)

# Using lambda
self.play(animation, rate_func=lambda t: t**2)
```

---

## Updaters

Run code every frame for dynamic behavior:

### Basic Updaters

```python
# Standard updater (no time parameter)
def my_updater(mobject):
    mobject.next_to(other_object, RIGHT)

obj.add_updater(my_updater)

# Lambda shorthand
obj.add_updater(lambda m: m.next_to(target, UP))

# Time-based updater (receives dt - time since last frame)
obj.add_updater(lambda m, dt: m.rotate(dt * PI))  # Rotate continuously

# Remove updater
obj.remove_updater(my_updater)
obj.clear_updaters()
obj.clear_updaters(recursive=True)  # Clear from submobjects too
```

### With ValueTracker

```python
# ValueTracker stores a value that can be animated
tracker = ValueTracker(0)

# Updater uses tracker value
dot = Dot()
dot.add_updater(lambda m: m.move_to(axes.c2p(tracker.get_value(), 0)))

# Animate the tracker
self.play(tracker.animate.set_value(5), run_time=3)

# Multiple objects tracking same value
line = always_redraw(lambda: Line(
    axes.c2p(0, 0),
    axes.c2p(tracker.get_value(), tracker.get_value()**2)
))
```

### always_redraw

```python
# Recreate mobject every frame based on function
line = always_redraw(lambda: Line(
    dot1.get_center(),
    dot2.get_center()
))
self.add(line)

# Move dots, line automatically updates
self.play(dot1.animate.shift(UP), dot2.animate.shift(DOWN))
```

### Updater Control

```python
# Temporarily disable
obj.suspend_updating()
# ... do stuff without updates ...
obj.resume_updating()

# Manual update call
obj.update(dt=0.016)  # Simulate one frame

# Check if updating
obj.updating_suspended  # Boolean
```

### DecimalNumber Updater Pattern

```python
tracker = ValueTracker(0)

# Create number display
number = DecimalNumber(0, num_decimal_places=2)

# Two updaters: value and position
number.add_updater(lambda m: m.set_value(tracker.get_value()))
number.add_updater(lambda m: m.next_to(dot, UP))

self.add(number)
self.play(tracker.animate.set_value(100), run_time=3)

# Remember to clear updaters when done
number.clear_updaters()
```

---

## Custom Animations

### Subclassing Animation

```python
from manim import Animation

class Pulse(Animation):
    def __init__(self, mobject, scale_factor=1.2, **kwargs):
        self.scale_factor = scale_factor
        super().__init__(mobject, **kwargs)

    def interpolate_mobject(self, alpha):
        # alpha goes from 0 to 1
        # Apply rate function manually if needed
        alpha = self.rate_func(alpha)

        # Calculate scale: 1 -> scale_factor -> 1
        if alpha < 0.5:
            scale = 1 + (self.scale_factor - 1) * (alpha * 2)
        else:
            scale = self.scale_factor - (self.scale_factor - 1) * ((alpha - 0.5) * 2)

        # Apply to starting mobject
        self.mobject.become(self.starting_mobject.copy().scale(scale))

# Use it
self.play(Pulse(circle, scale_factor=1.5))
```

### Using Homotopy

```python
# Homotopy: animate points through a function
def my_homotopy(x, y, z, t):
    # t goes 0 to 1, (x, y, z) is original point
    return [x + t, y + t * np.sin(x), z]

self.play(Homotopy(my_homotopy, mobject))
```

### ApplyFunction

```python
# Apply arbitrary function to mobject
def transform_func(mobject):
    mobject.scale(2)
    mobject.shift(UP)
    mobject.set_color(RED)
    return mobject

self.play(ApplyFunction(transform_func, circle))
```
