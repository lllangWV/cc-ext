# 3D Scenes Reference

Complete guide to 3D rendering in Manim.

## Table of Contents

1. [ThreeDScene Basics](#threedscene-basics)
2. [Camera Control](#camera-control)
3. [3D Mobjects](#3d-mobjects)
4. [3D Axes and Graphs](#3d-axes-and-graphs)
5. [Parametric Surfaces](#parametric-surfaces)
6. [Lighting](#lighting)
7. [Fixed Objects](#fixed-objects)
8. [2D Moving Camera](#2d-moving-camera)

---

## ThreeDScene Basics

### Basic Setup

```python
from manim import *

class My3DScene(ThreeDScene):
    def construct(self):
        # Set initial camera position
        self.set_camera_orientation(
            phi=75 * DEGREES,    # Angle from z-axis (vertical tilt)
            theta=30 * DEGREES,  # Angle from x-axis (horizontal rotation)
            zoom=1
        )

        # Create and add 3D objects
        sphere = Sphere(radius=1)
        self.add(sphere)
        self.wait()
```

### Camera Orientation

```python
# phi: Angle from positive z-axis (0 = looking down, 90 = horizontal)
# theta: Rotation around z-axis (0 = from +x direction)
# gamma: Roll angle (rotation around view direction)

self.set_camera_orientation(
    phi=70 * DEGREES,
    theta=45 * DEGREES,
    gamma=0,
    zoom=1,
    frame_center=ORIGIN
)
```

### Coordinate System

```
  z (OUT)
  |
  |
  +---- y (UP)
 /
x (RIGHT)

# Direction constants in 3D:
UP = [0, 1, 0]     # +y
DOWN = [0, -1, 0]  # -y
RIGHT = [1, 0, 0]  # +x
LEFT = [-1, 0, 0]  # -x
OUT = [0, 0, 1]    # +z (toward viewer)
IN = [0, 0, -1]    # -z (away from viewer)
```

---

## Camera Control

### Animated Camera Movement

```python
class CameraAnimation(ThreeDScene):
    def construct(self):
        cube = Cube()
        self.add(cube)

        # Set initial position
        self.set_camera_orientation(phi=60*DEGREES, theta=0)

        # Animate camera movement
        self.move_camera(
            phi=75 * DEGREES,
            theta=45 * DEGREES,
            zoom=1.5,
            run_time=3
        )

        # Move camera with frame center
        self.move_camera(
            frame_center=UP * 2,
            run_time=2
        )
```

### Ambient Camera Rotation

```python
class RotatingCamera(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)

        self.set_camera_orientation(phi=75*DEGREES, theta=0)

        # Start continuous rotation
        self.begin_ambient_camera_rotation(rate=0.2)  # radians per second
        self.wait(5)
        self.stop_ambient_camera_rotation()

        # Alternative: specify axis
        self.begin_ambient_camera_rotation(
            rate=0.1,
            about="theta"  # or "phi"
        )
```

### Camera Properties

```python
# Access camera
camera = self.camera

# Get current orientation
phi = self.camera.phi
theta = self.camera.theta
gamma = self.camera.gamma

# Camera frame properties
self.camera.frame.width
self.camera.frame.height
```

---

## 3D Mobjects

### Basic 3D Shapes

```python
# Sphere
sphere = Sphere(radius=1)
sphere = Sphere(
    radius=1,
    resolution=(20, 20),  # (u_subdivisions, v_subdivisions)
    color=BLUE
)

# Cube
cube = Cube(side_length=2, color=RED)

# Rectangular prism
prism = Prism(dimensions=[2, 1, 3])  # width, height, depth

# Cylinder
cylinder = Cylinder(
    radius=1,
    height=2,
    direction=UP,  # Axis direction
    resolution=(24, 1)
)

# Cone
cone = Cone(
    base_radius=1,
    height=2,
    direction=UP
)

# Torus
torus = Torus(
    major_radius=2,
    minor_radius=0.5
)

# Arrow3D
arrow = Arrow3D(
    start=ORIGIN,
    end=[1, 1, 1],
    color=YELLOW
)

# Line3D
line = Line3D(
    start=[-1, -1, -1],
    end=[1, 1, 1]
)

# Dot3D
dot = Dot3D(point=[1, 2, 0], radius=0.1, color=RED)
```

### 3D Text

```python
# Text in 3D (flat, can be rotated)
text = Text3D("Hello 3D")

# Or use regular Text with rotation
text = Text("Hello")
text.rotate(PI/2, axis=RIGHT)

# Always face camera
# Use add_fixed_in_frame_mobjects() - see Fixed Objects section
```

### Transformations in 3D

```python
# Rotation about axis
obj.rotate(PI/4, axis=UP)      # Rotate about y-axis
obj.rotate(PI/4, axis=RIGHT)   # Rotate about x-axis
obj.rotate(PI/4, axis=OUT)     # Rotate about z-axis
obj.rotate(PI/4, axis=[1,1,0]) # Custom axis

# Rotation about point
obj.rotate(PI/4, axis=UP, about_point=[1, 0, 0])

# 3D position
obj.move_to([x, y, z])
obj.shift(OUT * 2)  # Move toward viewer
```

---

## 3D Axes and Graphs

### ThreeD Axes

```python
axes = ThreeDAxes(
    x_range=[-5, 5, 1],
    y_range=[-5, 5, 1],
    z_range=[-3, 3, 1],
    x_length=10,
    y_length=10,
    z_length=6,
    axis_config={
        "include_tip": True,
        "include_ticks": True
    }
)

# Add labels
labels = axes.get_axis_labels(
    x_label=Tex("x"),
    y_label=Tex("y"),
    z_label=Tex("z")
)
```

### 3D Function Graphs

```python
# Surface from function z = f(x, y)
surface = Surface(
    lambda u, v: axes.c2p(u, v, np.sin(u) * np.cos(v)),
    u_range=[-3, 3],
    v_range=[-3, 3],
    resolution=(30, 30)
)

# Or using axes method
surface = axes.plot_surface(
    lambda x, y: np.sin(x) * np.cos(y),
    u_range=[-PI, PI],
    v_range=[-PI, PI],
    color=BLUE
)
```

### 3D Parametric Curves

```python
# Parametric curve in 3D
curve = ParametricFunction(
    lambda t: [
        np.cos(t),
        np.sin(t),
        t / (2 * PI)
    ],
    t_range=[0, 4 * PI],
    color=YELLOW
)

# With axes
curve = axes.plot_parametric_curve(
    lambda t: [np.cos(t), np.sin(t), t/TAU],
    t_range=[0, 2*TAU]
)
```

---

## Parametric Surfaces

### Surface Class

```python
# Basic surface
surface = Surface(
    func=lambda u, v: [u, v, u**2 + v**2],  # Returns [x, y, z]
    u_range=[-2, 2],
    v_range=[-2, 2],
    resolution=(32, 32),
    fill_color=BLUE,
    fill_opacity=0.8,
    stroke_color=WHITE,
    stroke_width=0.5
)

# Checkerboard coloring
surface = Surface(
    lambda u, v: [u, v, np.sin(u)*np.cos(v)],
    u_range=[-PI, PI],
    v_range=[-PI, PI],
    checkerboard_colors=[BLUE_D, BLUE_E]
)
```

### Common Surfaces

```python
# Sphere (parametric)
def sphere_func(u, v):
    return [
        np.cos(u) * np.sin(v),
        np.sin(u) * np.sin(v),
        np.cos(v)
    ]

sphere_surface = Surface(
    sphere_func,
    u_range=[0, TAU],
    v_range=[0, PI]
)

# Torus (parametric)
def torus_func(u, v, R=2, r=0.5):
    return [
        (R + r*np.cos(v)) * np.cos(u),
        (R + r*np.cos(v)) * np.sin(u),
        r * np.sin(v)
    ]

# Mobius strip
def mobius(u, v):
    return [
        (1 + v/2 * np.cos(u/2)) * np.cos(u),
        (1 + v/2 * np.cos(u/2)) * np.sin(u),
        v/2 * np.sin(u/2)
    ]

mobius_strip = Surface(
    mobius,
    u_range=[0, TAU],
    v_range=[-1, 1]
)

# Klein bottle, helicoid, etc. similarly defined
```

### Surface Styling

```python
surface.set_fill(BLUE, opacity=0.7)
surface.set_stroke(WHITE, width=0.5)

# Color by value (z-coordinate)
surface.set_fill_by_value(
    axes=axes,
    colors=[(RED, -1), (YELLOW, 0), (GREEN, 1)],
    axis=2  # z-axis
)
```

---

## Lighting

### Default Lighting

```python
# ThreeDScene has default lighting
# Light source position affects shading

class LightingExample(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)

        # Access light source
        self.camera.light_source

        # Move light
        self.camera.light_source.move_to([3, 3, 3])
```

### Shading

```python
# Objects automatically receive shading based on:
# - Surface normal direction
# - Light source position
# - Camera position

# Disable shading
sphere = Sphere(shade_in_3d=False)

# Adjust material properties (for some objects)
sphere.set_opacity(0.5)
```

---

## Fixed Objects

### Fixed In Frame (HUD/Overlays)

Objects that don't move with camera rotation:

```python
class FixedOverlay(ThreeDScene):
    def construct(self):
        # 3D object
        cube = Cube()
        self.add(cube)

        # Fixed 2D overlay (stays in screen space)
        title = Text("3D Demo").to_corner(UL)
        self.add_fixed_in_frame_mobjects(title)

        # Now rotate camera - title stays fixed
        self.set_camera_orientation(phi=60*DEGREES)
        self.begin_ambient_camera_rotation(rate=0.3)
        self.wait(5)
```

### Fixed Orientation

Objects that maintain their orientation relative to camera:

```python
class FixedOrientation(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        label = Text("Sphere").next_to(sphere, UP)

        self.add(sphere)

        # Label always faces camera
        self.add_fixed_orientation_mobjects(label)

        self.move_camera(phi=60*DEGREES, theta=45*DEGREES)
        # Label still readable
```

### Difference

```python
# add_fixed_in_frame_mobjects:
#   - Object stays at fixed screen position
#   - Like a HUD overlay
#   - Good for: titles, legends, UI elements

# add_fixed_orientation_mobjects:
#   - Object moves in 3D space with its parent
#   - But always faces the camera
#   - Good for: labels on 3D objects, annotations
```

---

## 2D Moving Camera

For 2D scenes with camera movement (pan/zoom):

### MovingCameraScene

```python
class ZoomAndPan(MovingCameraScene):
    def construct(self):
        square = Square(side_length=2)
        circle = Circle(radius=1).shift(RIGHT * 4)

        self.add(square, circle)

        # Zoom in
        self.play(self.camera.frame.animate.scale(0.5))

        # Pan to circle
        self.play(self.camera.frame.animate.move_to(circle))

        # Zoom out
        self.play(self.camera.frame.animate.scale(3))

        # Reset
        self.play(self.camera.frame.animate.move_to(ORIGIN).set(width=14))
```

### Camera Frame Properties

```python
# Access camera frame
frame = self.camera.frame

# Properties
frame.width
frame.height
frame.get_center()

# Animate
self.play(frame.animate.set(width=20))  # Zoom out
self.play(frame.animate.shift(LEFT * 3))  # Pan left
```

### Follow Object

```python
class FollowObject(MovingCameraScene):
    def construct(self):
        dot = Dot()
        self.add(dot)

        # Camera follows dot
        self.camera.frame.add_updater(
            lambda m: m.move_to(dot.get_center())
        )

        # Move dot around
        self.play(dot.animate.shift(RIGHT * 3))
        self.play(dot.animate.shift(UP * 2))
        self.play(dot.animate.shift(LEFT * 5))

        # Stop following
        self.camera.frame.clear_updaters()
```

### ZoomedScene

For picture-in-picture zoom effect:

```python
class ZoomBox(ZoomedScene):
    def __init__(self, **kwargs):
        super().__init__(
            zoom_factor=0.3,
            zoomed_display_height=3,
            zoomed_display_width=4,
            image_frame_stroke_width=20,
            zoomed_camera_config={
                "default_frame_stroke_width": 3,
            },
            **kwargs
        )

    def construct(self):
        # Create content
        formula = MathTex(r"\sum_{n=1}^\infty \frac{1}{n^2} = \frac{\pi^2}{6}")
        self.add(formula)

        # Setup zoom
        self.activate_zooming(animate=False)

        # Position zoomed display
        self.zoomed_display.to_corner(UR)

        # Move zoom frame
        self.play(self.zoomed_camera.frame.animate.move_to(formula[0][0]))
        self.wait()
```
