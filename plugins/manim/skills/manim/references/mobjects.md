# Mobjects Reference

Complete guide to Manim's Mathematical Objects (Mobjects).

## Table of Contents

1. [Base Mobject Methods](#base-mobject-methods)
2. [VMobjects](#vmobjects)
3. [Geometric Shapes](#geometric-shapes)
4. [Text and LaTeX](#text-and-latex)
5. [Graphs and Coordinate Systems](#graphs-and-coordinate-systems)
6. [Tables](#tables)
7. [Data Visualization](#data-visualization)
8. [Special Mobjects](#special-mobjects)
9. [Colors](#colors)

---

## Base Mobject Methods

All Mobjects share these core methods:

### Positioning

```python
# Absolute positioning
obj.move_to(point)              # Move center to point
obj.move_to([x, y, z])          # Move to coordinates
obj.to_edge(direction, buff=0.5) # Move to screen edge
obj.to_corner(corner, buff=0.5)  # Move to screen corner (UL, UR, DL, DR)

# Relative positioning
obj.shift(direction)            # Move by vector
obj.shift(RIGHT * 2 + UP)       # Combine directions

# Relative to other objects
obj.next_to(other, direction, buff=0.25)  # Position adjacent
obj.align_to(other, direction)            # Align edges
obj.match_x(other)                        # Match x-coordinate
obj.match_y(other)                        # Match y-coordinate

# Get positions
obj.get_center()                # Returns center point
obj.get_top(), obj.get_bottom() # Edge points
obj.get_left(), obj.get_right()
obj.get_corner(UL)              # Corner points
```

### Transformations

```python
# Scaling
obj.scale(factor)                    # Uniform scale
obj.scale(factor, about_point=ORIGIN) # Scale about point
obj.scale_to_fit_width(width)
obj.scale_to_fit_height(height)
obj.stretch(factor, dim)             # Stretch in dimension (0=x, 1=y, 2=z)
obj.stretch_to_fit_width(width)
obj.stretch_to_fit_height(height)

# Rotation
obj.rotate(angle)                    # Rotate about center
obj.rotate(angle, axis=OUT)          # Specify axis (OUT=z, RIGHT=x, UP=y)
obj.rotate(angle, about_point=point) # Rotate about point
obj.rotate_about_origin(angle)

# Flipping
obj.flip(axis=UP)                    # Mirror across axis
```

### State Management

```python
obj.save_state()     # Save current configuration
obj.restore()        # Restore to saved state
obj.copy()           # Create independent duplicate
obj.become(other)    # Adopt another mobject's appearance
```

### Hierarchy

```python
obj.add(submobject)           # Add child
obj.remove(submobject)        # Remove child
obj.get_family()              # Get all descendants
obj.submobjects               # Direct children list
obj[0], obj[1], ...           # Index submobjects
```

### Arrangement (for Groups)

```python
group.arrange(direction, buff=0.25)  # Line up in direction
group.arrange(RIGHT, center=False)   # Don't center the group
group.arrange_in_grid(rows=2, cols=3, buff=0.5)
group.arrange_submobjects()          # Default arrangement
```

---

## VMobjects

VMobjects (Vectorized Mobjects) are shapes defined by Bezier curves with stroke and fill.

### Styling Methods

```python
# Color (applies to both stroke and fill)
obj.set_color(color)
obj.set_color_by_gradient(RED, BLUE)  # Gradient across object

# Stroke (outline)
obj.set_stroke(color=WHITE, width=4, opacity=1)
obj.get_stroke_color()
obj.get_stroke_width()

# Fill (interior)
obj.set_fill(color=BLUE, opacity=0.5)
obj.get_fill_color()
obj.get_fill_opacity()

# Sheen (gradient effect)
obj.set_sheen(factor, direction)
obj.set_sheen_direction(direction)
```

### VGroup

Container for multiple VMobjects:

```python
group = VGroup(obj1, obj2, obj3)
group = VGroup(*list_of_objects)

# All VMobject methods apply to all children
group.set_color(RED)
group.set_fill(BLUE, opacity=0.5)

# Arrangement
group.arrange(RIGHT, buff=0.5)
group.arrange(DOWN, center=True)
group.arrange_in_grid(rows=2, cols=2, buff=(0.5, 0.3))

# Access elements
group[0]                    # First element
group[-1]                   # Last element
group[1:3]                  # Slice (returns VGroup)
```

---

## Geometric Shapes

### Basic Shapes

```python
# Circle
Circle(radius=1, color=RED, fill_opacity=0)
circle.surround(mobject, buffer_factor=1.2)  # Surround another object
Circle.from_three_points(p1, p2, p3)         # Circle through points

# Ellipse
Ellipse(width=4, height=2, color=BLUE)

# Arc
Arc(radius=1, start_angle=0, angle=PI/2)
Arc(arc_center=[0, 0, 0], ...)
ArcBetweenPoints(start, end, angle=PI/2)

# Annulus (ring)
Annulus(inner_radius=0.5, outer_radius=1)

# Dot
Dot(point=ORIGIN, radius=0.08, color=WHITE)
Dot3D()  # For 3D scenes

# Square and Rectangle
Square(side_length=2, color=BLUE)
Rectangle(width=4, height=2, color=GREEN)
RoundedRectangle(corner_radius=0.5, width=4, height=2)

# Polygons
Triangle()
RegularPolygon(n=6)  # Hexagon
Polygon(point1, point2, point3, ...)  # Custom vertices

# Star
Star(n=5, outer_radius=2, inner_radius=1)
```

### Lines and Arrows

```python
# Basic line
Line(start=LEFT, end=RIGHT, buff=0)
Line(start=[-2, 0, 0], end=[2, 0, 0])

# With buffer (gap at endpoints)
Line(start, end, buff=0.5)

# Curved line
Line(start, end, path_arc=PI/4)  # Arc path

# Dashed line
DashedLine(start, end, dash_length=0.2)

# Arrow
Arrow(start, end, buff=0.25)
Arrow(start, end, stroke_width=6, tip_length=0.3)
DoubleArrow(start, end)

# Vector (arrow from origin)
Vector(direction)

# Tangent line to curve
TangentLine(vmobject, alpha, length=1)  # alpha is 0-1 along curve

# Number line
NumberLine(
    x_range=[0, 10, 1],
    length=10,
    include_numbers=True,
    include_tip=True,
    include_ticks=True
)
number_line.n2p(5)  # Number to point
number_line.p2n(point)  # Point to number
```

### Special Shapes

```python
# Brace
Brace(mobject, direction=DOWN)
brace.get_text("Label")
brace.get_tex(r"x^2")
BraceBetweenPoints(point1, point2)

# Surrounding rectangle
SurroundingRectangle(mobject, buff=0.1, color=YELLOW)

# Cross mark
Cross(mobject, stroke_width=6)

# Cutout (shape with hole)
Cutout(main_shape, *shapes_to_cut)

# Right angle marker
RightAngle(line1, line2, length=0.3)
Elbow()  # Alternative

# Always-facing camera (billboard)
# Use add_fixed_orientation_mobjects() in 3D
```

---

## Text and LaTeX

### Text (Pango-based)

```python
# Basic text
Text("Hello World")
Text("Hello", font_size=72)
Text("Hello", color=BLUE)

# Font styling
Text("Styled", font="Arial")
Text("Bold", weight=BOLD)      # NORMAL, BOLD
Text("Italic", slant=ITALIC)   # NORMAL, ITALIC, OBLIQUE

# Substring styling with dictionaries
Text(
    "Hello World",
    t2c={"Hello": RED, "World": BLUE},   # text to color
    t2f={"Hello": "Arial"},               # text to font
    t2s={"World": ITALIC},                # text to slant
    t2w={"Hello": BOLD}                   # text to weight
)

# Gradient
Text("Gradient", gradient=(RED, BLUE, GREEN))

# Line spacing
Text("Line 1\nLine 2", line_spacing=1.5)

# Disable ligatures (for character iteration)
Text("fi fl", disable_ligatures=True)

# Access characters
text[0]  # First character
text[0:5]  # First 5 characters (returns VGroup)
```

### Tex and MathTex

```python
# Normal LaTeX (text mode)
Tex(r"\LaTeX")
Tex(r"Hello $x^2$ World")  # Math needs $ delimiters

# Math mode (automatic align* environment)
MathTex(r"x^2 + y^2 = r^2")
MathTex(r"\frac{a}{b}")
MathTex(r"\int_0^1 x\,dx")

# Isolate substrings for animation
MathTex(r"{{ a^2 }} + {{ b^2 }} = {{ c^2 }}")
# Now equation[0] = "a^2", equation[2] = "b^2", etc.

# Alternative: substrings_to_isolate
MathTex(
    r"a^2 + b^2 = c^2",
    substrings_to_isolate=["a^2", "b^2", "c^2"]
)

# Color specific parts
equation = MathTex(r"E", r"=", r"mc^2")
equation[0].set_color(RED)

# Debug submobject structure
equation.index_labels()  # Shows indices
```

### LaTeX Templates

```python
from manim import TexTemplate

# Custom preamble
template = TexTemplate()
template.add_to_preamble(r"\usepackage{amsmath}")
template.add_to_preamble(r"\usepackage{physics}")

MathTex(r"\bra{\psi}", tex_template=template)

# Built-in font templates
from manim import TexFontTemplates
MathTex(r"x^2", tex_template=TexFontTemplates.french_cursive)
```

### Paragraph and MarkupText

```python
# Multi-line text with wrapping
Paragraph(
    "Long text that wraps...",
    line_spacing=1,
    alignment="center"
)

# Pango markup
MarkupText('<span foreground="red">Red</span> text')
MarkupText('<b>Bold</b> and <i>italic</i>')
```

---

## Graphs and Coordinate Systems

### Axes

```python
axes = Axes(
    x_range=[-5, 5, 1],      # [min, max, step]
    y_range=[-3, 3, 1],
    x_length=10,              # Screen units
    y_length=6,
    axis_config={
        "include_tip": True,
        "include_numbers": True,
        "font_size": 24
    },
    x_axis_config={"color": BLUE},
    y_axis_config={"color": GREEN}
)

# Add labels
labels = axes.get_axis_labels(x_label="x", y_label="f(x)")
labels = axes.get_axis_labels(
    Tex("t").scale(0.7),
    Tex("v(t)").scale(0.7)
)

# Coordinate conversions
axes.c2p(x, y)        # Coordinates to point
axes.p2c(point)       # Point to coordinates
axes.coords_to_point(x, y)  # Same as c2p
axes.point_to_coords(point)  # Same as p2c
```

### Plotting Functions

```python
# Plot lambda function
graph = axes.plot(lambda x: x**2, color=YELLOW)
graph = axes.plot(lambda x: np.sin(x), x_range=[-PI, PI])

# Plot with discontinuities
graph = axes.plot(
    lambda x: 1/x,
    x_range=[-3, 3],
    discontinuities=[0],
    dt=0.01
)

# Parametric plot
parametric = axes.plot_parametric_curve(
    lambda t: [np.cos(t), np.sin(t)],
    t_range=[0, TAU]
)

# Implicit curve
implicit = axes.plot_implicit_curve(
    lambda x, y: x**2 + y**2 - 1,
    color=BLUE
)

# Get area under curve
area = axes.get_area(graph, x_range=[0, 2], color=BLUE, opacity=0.5)
area = axes.get_area(graph, bounded_graph=other_graph)  # Between curves

# Get vertical line to graph
line = axes.get_vertical_line(axes.c2p(2, 4))
lines = axes.get_vertical_lines_to_graph(graph, x_range=[0, 2], num_lines=10)

# Get horizontal line
hline = axes.get_horizontal_line(axes.c2p(2, 4))
```

### NumberPlane

```python
plane = NumberPlane(
    x_range=[-5, 5, 1],
    y_range=[-3, 3, 1],
    background_line_style={
        "stroke_color": BLUE_D,
        "stroke_width": 2,
        "stroke_opacity": 0.5
    }
)
plane.add_coordinates()  # Add number labels
```

### FunctionGraph (Standalone)

```python
# Without axes
graph = FunctionGraph(
    lambda x: np.sin(x),
    x_range=[-PI, PI],
    color=BLUE
)

# Parametric
curve = ParametricFunction(
    lambda t: [np.cos(t), np.sin(t), 0],
    t_range=[0, TAU]
)
```

### NumberLine

```python
line = NumberLine(
    x_range=[0, 10, 1],
    length=10,
    include_numbers=True,
    numbers_to_include=[0, 2, 4, 6, 8, 10],
    include_tip=True,
    tip_width=0.2,
    tip_height=0.2,
    decimal_number_config={"num_decimal_places": 0}
)

# Convert between number and point
point = line.number_to_point(5)  # or line.n2p(5)
number = line.point_to_number(point)  # or line.p2n(point)

# Add labels
line.add_labels({
    0: Tex("start"),
    10: Tex("end")
})
```

---

## Tables

```python
table = Table(
    [["a", "b", "c"],
     ["d", "e", "f"]],
    row_labels=[Text("R1"), Text("R2")],
    col_labels=[Text("C1"), Text("C2"), Text("C3")],
    include_outer_lines=True
)

# Access elements
table.get_cell((1, 1))           # Row 1, Col 1
table.get_entries()              # All entries
table.get_entries_without_labels()
table.get_row_labels()
table.get_col_labels()
table.get_rows()[0]              # First row
table.get_columns()[0]           # First column

# Highlighting
table.add_highlighted_cell((1, 2), color=YELLOW)
table.get_highlighted_cell((1, 2), color=RED)  # Returns mobject

# Horizontal/vertical lines
table.get_horizontal_lines()
table.get_vertical_lines()

# MathTable for LaTeX content
MathTable(
    [[r"x^2", r"y^2"],
     [r"\alpha", r"\beta"]]
)

# IntegerTable for numbers
IntegerTable(
    [[1, 2, 3],
     [4, 5, 6]]
)

# DecimalTable
DecimalTable(
    [[1.5, 2.3],
     [4.7, 5.9]],
    num_decimal_places=2
)
```

---

## Data Visualization

### BarChart

```python
chart = BarChart(
    values=[3, 5, 2, 8, 4],
    bar_names=["A", "B", "C", "D", "E"],
    y_range=[0, 10, 2],
    bar_colors=[BLUE, RED, GREEN, YELLOW, PURPLE]
)

# Animate value changes
chart.change_bar_values([4, 6, 3, 5, 7])

# Get bars and labels
chart.bars              # VGroup of bars
chart.bar_labels        # VGroup of labels
chart.get_bar_labels()
```

### PieChart (via Sector)

```python
# Manual pie chart with sectors
values = [30, 20, 50]
colors = [RED, BLUE, GREEN]
start = 0
sectors = VGroup()
for val, col in zip(values, colors):
    angle = val / 100 * TAU
    sector = Sector(
        outer_radius=2,
        inner_radius=0,
        angle=angle,
        start_angle=start,
        color=col
    )
    sectors.add(sector)
    start += angle
```

---

## Special Mobjects

### ValueTracker

```python
tracker = ValueTracker(0)

# Get/set value
tracker.get_value()
tracker.set_value(5)

# Animate
self.play(tracker.animate.set_value(10))
self.play(tracker.animate.increment_value(2))

# Use in updaters
dot.add_updater(lambda m: m.move_to(
    axes.c2p(tracker.get_value(), 0)
))
```

### DecimalNumber

```python
number = DecimalNumber(
    3.14159,
    num_decimal_places=2,
    include_sign=True,
    group_with_commas=True,
    unit=r"\text{m}"  # LaTeX unit
)

# Update value
number.set_value(5.5)

# With tracker
number.add_updater(lambda m: m.set_value(tracker.get_value()))
```

### Integer

```python
num = Integer(42, color=BLUE)
num.set_value(100)
```

### Variable (Number with Label)

```python
var = Variable(
    3,
    Text("x"),
    num_decimal_places=2
)
var.tracker  # Access internal ValueTracker
```

### SVGMobject

```python
svg = SVGMobject("path/to/file.svg")
svg = SVGMobject(
    "icon.svg",
    height=2,
    width=3,
    color=BLUE,  # Override SVG colors
    fill_opacity=1
)
```

### ImageMobject

```python
img = ImageMobject("path/to/image.png")
img.height = 3
img.set_resampling_algorithm(RESAMPLING_ALGORITHMS["nearest"])
```

---

## Colors

### Built-in Colors

```python
# Basic colors
WHITE, BLACK, GRAY, GREY
RED, GREEN, BLUE
YELLOW, ORANGE, PINK, PURPLE
TEAL, MAROON, GOLD

# Shaded variants (A=lightest, E=darkest)
BLUE_A, BLUE_B, BLUE_C, BLUE_D, BLUE_E
RED_A, RED_B, RED_C, RED_D, RED_E
# Same pattern for: GREEN, YELLOW, GOLD, GRAY, TEAL, PURPLE

# Pure colors
PURE_RED, PURE_GREEN, PURE_BLUE

# Grayscale
GRAY_A, GRAY_B, GRAY_C, GRAY_D, GRAY_E
DARKER_GRAY, LIGHTER_GRAY
```

### Extended Palettes

```python
from manim.utils.color import X11, XKCD, SVGNAMES

# Usage with prefix
X11.ALICE_BLUE
XKCD.CERULEAN
SVGNAMES.CORAL
```

### ManimColor Class

```python
from manim import ManimColor

# Create from various formats
color = ManimColor.from_rgb((255, 128, 0))     # 0-255 range
color = ManimColor.from_rgb((1.0, 0.5, 0.0))   # 0-1 range
color = ManimColor.from_hex("#FF8000")
color = ManimColor.from_hsv((0.1, 1.0, 1.0))   # Hue, Saturation, Value

# Manipulate
lighter = color.lighter(0.3)
darker = color.darker(0.3)
inverted = color.invert()
mixed = color.interpolate(other_color, 0.5)

# Convert
rgb = color.to_rgb()
hex_str = color.to_hex()
hsv = color.to_hsv()

# Color interpolation
color_gradient = color_gradient([RED, BLUE, GREEN], length=100)
interpolate_color(RED, BLUE, 0.5)  # Midpoint
```

### Applying Colors

```python
# Single color
obj.set_color(BLUE)

# Gradient
obj.set_color_by_gradient(RED, YELLOW, GREEN)

# Different stroke/fill
obj.set_stroke(WHITE)
obj.set_fill(BLUE, opacity=0.5)

# Submobject colors
for i, sub in enumerate(group):
    sub.set_color(color_gradient([RED, BLUE], len(group))[i])
```
