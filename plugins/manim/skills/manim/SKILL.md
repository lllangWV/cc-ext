---
name: manim
description: Create mathematical animations with Manim Community Edition. Use when users want to create animated videos explaining math, science, or programming concepts. Triggers include- creating animations, visualizing equations, animating graphs/plots, making educational videos, geometric animations, LaTeX animations, 3D visualizations, or any request mentioning "manim".
---

# Manim Community Edition

Create professional mathematical animations for educational videos.

**Important**: This skill covers Manim Community Edition (docs.manim.community), NOT manimgl or 3b1b's original manim.

## Quick Start

### Basic Scene Structure

```python
from manim import *

class MyScene(Scene):
    def construct(self):  # MUST be spelled exactly "construct"
        circle = Circle(color=BLUE)
        self.play(Create(circle))
        self.wait()
```

### Rendering Commands

```bash
# Quick test (low quality, preview)
manim -pql script.py SceneName

# Medium quality
manim -pqm script.py SceneName

# High quality (1080p @ 60fps)
manim -qh script.py SceneName

# 4K quality
manim -qk script.py SceneName

# Save as GIF
manim -pql --format gif script.py SceneName

# Transparent background
manim -pql -t script.py SceneName
```

**Flags**: `-p` (preview), `-q[l/m/h/p/k]` (quality), `-s` (save last frame as PNG), `-a` (all scenes)

### Project Initialization

```bash
manim init project my-project --default
```

## Core Concepts

### Scene Dimensions
- Height: 8 units (fixed)
- Width: ~14.22 units (16:9 ratio)
- Origin (0, 0, 0) is at center

### The Three Pillars

1. **Mobjects** - Mathematical objects (shapes, text, graphs)
2. **Animations** - Transform mobjects over time
3. **Scenes** - Canvas that orchestrates everything

### Mobject Hierarchy

```
Mobject (base)
├── VMobject (vector graphics with stroke/fill)
│   ├── Circle, Square, Polygon, Arc, Line, Arrow
│   ├── Text, Tex, MathTex
│   └── VGroup (container)
├── Group (general container)
└── 3D objects (Sphere, Cube, etc.)
```

## Essential Mobjects

### Shapes

```python
# Basic shapes
circle = Circle(radius=1, color=RED)
square = Square(side_length=2, color=BLUE)
rect = Rectangle(width=4, height=2)
tri = Triangle()
polygon = Polygon([-1, 0, 0], [1, 0, 0], [0, 1.5, 0])

# Lines and arrows
line = Line(LEFT, RIGHT)
arrow = Arrow(LEFT, RIGHT)
dashed = DashedLine(UP, DOWN)

# Arcs
arc = Arc(radius=1, start_angle=0, angle=PI/2)
```

### Text and LaTeX

```python
# Plain text (Pango-based)
text = Text("Hello World", font_size=48, color=WHITE)
styled = Text("Styled", font="Arial", slant=ITALIC, weight=BOLD)

# LaTeX (requires LaTeX installation)
tex = Tex(r"\LaTeX")  # Normal mode
math = MathTex(r"x^2 + y^2 = r^2")  # Math mode

# Isolate parts for animation (use double braces)
equation = MathTex(r"{{ a^2 }} + {{ b^2 }} = {{ c^2 }}")
equation[0].set_color(RED)   # a^2
equation[2].set_color(BLUE)  # b^2
```

**Always use raw strings** (`r'...'`) for LaTeX.

### Graphs and Axes

```python
# Create coordinate system
axes = Axes(
    x_range=[-3, 3, 1],  # [min, max, step]
    y_range=[-2, 2, 1],
    x_length=6,
    y_length=4,
    axis_config={"include_tip": True}
)

# Plot a function
graph = axes.plot(lambda x: x**2, color=YELLOW)

# Add labels
labels = axes.get_axis_labels(x_label="x", y_label="y")

# Number line
number_line = NumberLine(x_range=[0, 10, 1], include_numbers=True)
```

### Grouping

```python
# VGroup for VMobjects (supports styling)
group = VGroup(circle, square, triangle)
group.arrange(RIGHT, buff=0.5)  # Arrange horizontally
group.set_color(RED)  # Apply color to all

# Group for any mobjects
mixed = Group(mobject1, mobject2)
```

## Positioning and Styling

### Positioning Methods

```python
# Absolute positioning
obj.move_to(ORIGIN)
obj.move_to([2, 1, 0])

# Relative positioning
obj.shift(UP * 2)
obj.shift(RIGHT + UP)

# Position relative to another object
obj.next_to(other, RIGHT, buff=0.5)
obj.align_to(other, UP)  # Align top edges

# Arrange multiple objects
VGroup(a, b, c).arrange(RIGHT, buff=0.3)
VGroup(a, b, c).arrange_in_grid(rows=2, cols=2)
```

### Direction Constants

```python
UP, DOWN, LEFT, RIGHT, ORIGIN
UL, UR, DL, DR  # Diagonals (UpperLeft, etc.)
IN, OUT  # For 3D (along z-axis)
```

### Styling VMobjects

```python
# Colors
obj.set_color(BLUE)
obj.set_fill(RED, opacity=0.5)
obj.set_stroke(WHITE, width=2)

# Transformations
obj.scale(2)
obj.rotate(PI/4)
obj.stretch_to_fit_width(5)

# State management
obj.save_state()
# ... modify obj ...
obj.restore()
```

## Essential Animations

### The .animate Syntax (Most Common)

```python
# Animate ANY mobject method
self.play(square.animate.shift(RIGHT))
self.play(circle.animate.scale(2).set_color(RED))
self.play(text.animate.rotate(PI/4).move_to(UP))

# Combine with run_time
self.play(obj.animate.shift(UP), run_time=2)
```

### Creation Animations

```python
self.play(Create(circle))        # Draw incrementally
self.play(Write(text))           # Pen-like writing
self.play(FadeIn(obj))           # Fade in
self.play(FadeIn(obj, shift=UP)) # Fade in from below
self.play(GrowFromCenter(obj))   # Grow from center
self.play(DrawBorderThenFill(shape))  # Outline then fill
```

### Transform Animations

```python
# Transform source INTO target (mutates source)
self.play(Transform(circle, square))

# Replace source WITH target in scene
self.play(ReplacementTransform(circle, square))

# Match shapes intelligently (great for text)
self.play(TransformMatchingShapes(text1, text2))
```

### Removal Animations

```python
self.play(FadeOut(obj))
self.play(Uncreate(obj))  # Reverse of Create
```

### Indication Animations

```python
self.play(Indicate(obj))           # Highlight temporarily
self.play(Circumscribe(obj))       # Draw surrounding line
self.play(Flash(obj))              # Flash effect
self.play(Wiggle(obj))             # Wiggle motion
self.play(FocusOn(obj))            # Shrinking spotlight
```

### Animation Composition

```python
# Simultaneous (default when multiple in play)
self.play(Create(circle), FadeIn(square))

# Staggered start
self.play(LaggedStart(
    Create(a), Create(b), Create(c),
    lag_ratio=0.5  # Each starts at 50% of previous
))

# Sequential
self.play(Succession(anim1, anim2, anim3))

# With custom timing
self.play(animation, run_time=3, rate_func=smooth)
```

### Common Rate Functions

```python
from manim import rate_functions

linear           # Constant speed
smooth           # Default, S-curve
ease_in_quad     # Start slow
ease_out_quad    # End slow
ease_in_out_quad # Both
there_and_back   # Forward then reverse
rush_into        # Dramatic acceleration
```

## Updaters (Dynamic Animations)

```python
# Value tracker for animating values
tracker = ValueTracker(0)

# Updater that runs every frame
dot = Dot()
dot.add_updater(lambda m: m.move_to(
    axes.c2p(tracker.get_value(), tracker.get_value()**2)
))

# Animate the tracker
self.play(tracker.animate.set_value(3), run_time=3)

# Time-based updater
obj.add_updater(lambda m, dt: m.rotate(dt * PI/2))

# Remove updaters
obj.clear_updaters()
```

### DecimalNumber with Updater

```python
tracker = ValueTracker(0)
number = DecimalNumber(0, num_decimal_places=2)
number.add_updater(lambda m: m.set_value(tracker.get_value()))
self.play(tracker.animate.set_value(100), run_time=3)
```

## Configuration

### Config File (manim.cfg)

```ini
[CLI]
quality = low_quality
preview = True
background_color = WHITE
```

### Programmatic Config

```python
from manim import config

config.background_color = WHITE
config.pixel_height = 1080
config.frame_rate = 60
```

## Common Patterns

### Highlight Then Transform

```python
self.play(Indicate(equation[0]))
self.wait(0.5)
self.play(Transform(equation[0], new_term))
```

### Sequential Object Creation

```python
objects = VGroup(*[Circle() for _ in range(5)])
objects.arrange(RIGHT)
self.play(LaggedStart(*[Create(o) for o in objects], lag_ratio=0.3))
```

### Following Object with Label

```python
dot = Dot()
label = Text("Point").next_to(dot, UP)
label.add_updater(lambda m: m.next_to(dot, UP))
self.play(dot.animate.shift(RIGHT * 3))
label.clear_updaters()
```

### Graph Animation

```python
axes = Axes(x_range=[-3, 3], y_range=[-1, 5])
graph = axes.plot(lambda x: x**2, color=YELLOW)
self.play(Create(axes))
self.play(Create(graph))

# Animate area under curve
area = axes.get_area(graph, x_range=[0, 2], color=BLUE, opacity=0.5)
self.play(FadeIn(area))
```

## Common Pitfalls

1. **Misspelling `construct()`** - Results in blank output
2. **Wrong Manim version** - Ensure you're using Community Edition
3. **Transform vs ReplacementTransform** - Transform mutates, ReplacementTransform replaces
4. **Missing raw string for LaTeX** - Use `r"\frac{1}{2}"` not `"\frac{1}{2}"`
5. **Ligatures in Text iteration** - Use `disable_ligatures=True`
6. **Unsaved file** - Save before rendering

## Reference Documentation

For detailed information on specific topics:

- **[Mobjects Reference](references/mobjects.md)** - Complete guide to all Mobject types, methods, and styling
- **[Animations Reference](references/animations.md)** - All animation types, rate functions, and updaters
- **[3D Scenes Reference](references/3d-scenes.md)** - ThreeDScene, camera control, 3D objects
- **[Examples Reference](references/examples.md)** - Common patterns and complete code examples
