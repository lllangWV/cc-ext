# Examples Reference

Complete code examples demonstrating common Manim patterns.

## Table of Contents

1. [Basic Scenes](#basic-scenes)
2. [Text and Equations](#text-and-equations)
3. [Graphs and Functions](#graphs-and-functions)
4. [Geometric Proofs](#geometric-proofs)
5. [Data Visualization](#data-visualization)
6. [Physics Simulations](#physics-simulations)
7. [Complex Animations](#complex-animations)

---

## Basic Scenes

### Hello World

```python
from manim import *

class HelloWorld(Scene):
    def construct(self):
        text = Text("Hello, World!")
        self.play(Write(text))
        self.wait()
        self.play(FadeOut(text))
```

### Shape Showcase

```python
class ShapeShowcase(Scene):
    def construct(self):
        circle = Circle(color=RED)
        square = Square(color=BLUE).next_to(circle, RIGHT)
        triangle = Triangle(color=GREEN).next_to(circle, LEFT)

        shapes = VGroup(triangle, circle, square)
        shapes.move_to(ORIGIN)

        self.play(LaggedStart(*[Create(s) for s in shapes], lag_ratio=0.3))
        self.wait()

        # Transform shapes
        self.play(
            circle.animate.set_fill(RED, opacity=0.5),
            square.animate.rotate(PI/4),
            triangle.animate.scale(1.5)
        )
        self.wait()
```

### Color Transitions

```python
class ColorTransitions(Scene):
    def construct(self):
        square = Square(fill_opacity=1)

        self.play(Create(square))

        colors = [RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE]
        for color in colors:
            self.play(square.animate.set_fill(color), run_time=0.5)

        # Gradient
        self.play(square.animate.set_color_by_gradient(RED, YELLOW, GREEN))
        self.wait()
```

---

## Text and Equations

### Equation Derivation

```python
class EquationDerivation(Scene):
    def construct(self):
        # Start with equation
        eq1 = MathTex(r"x^2 + 5x + 6 = 0")
        self.play(Write(eq1))
        self.wait()

        # Factor
        eq2 = MathTex(r"(x + 2)(x + 3) = 0")
        self.play(TransformMatchingShapes(eq1, eq2))
        self.wait()

        # Solutions
        eq3 = MathTex(r"x = -2", r"\quad \text{or} \quad", r"x = -3")
        eq3[0].set_color(BLUE)
        eq3[2].set_color(GREEN)

        self.play(TransformMatchingShapes(eq2, eq3))
        self.wait()
```

### Step-by-Step Proof

```python
class StepByStepProof(Scene):
    def construct(self):
        title = Text("Proof: Sum of First n Integers").scale(0.8).to_edge(UP)
        self.play(Write(title))

        steps = VGroup(
            MathTex(r"S = 1 + 2 + 3 + \cdots + n"),
            MathTex(r"S = n + (n-1) + (n-2) + \cdots + 1"),
            MathTex(r"2S = (n+1) + (n+1) + \cdots + (n+1)"),
            MathTex(r"2S = n(n+1)"),
            MathTex(r"S = \frac{n(n+1)}{2}")
        ).arrange(DOWN, buff=0.5).next_to(title, DOWN, buff=0.5)

        for step in steps:
            self.play(Write(step))
            self.wait(0.5)

        # Highlight final result
        box = SurroundingRectangle(steps[-1], color=YELLOW)
        self.play(Create(box))
        self.wait()
```

### Text Highlighting

```python
class TextHighlighting(Scene):
    def construct(self):
        paragraph = Text(
            "The quadratic formula solves ax² + bx + c = 0",
            t2c={"quadratic formula": YELLOW, "solves": GREEN}
        ).scale(0.7)

        self.play(Write(paragraph))
        self.wait()

        # Formula
        formula = MathTex(r"x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}")
        formula.next_to(paragraph, DOWN, buff=0.8)

        self.play(Write(formula))

        # Highlight discriminant
        disc_box = SurroundingRectangle(formula[0][8:14], color=RED)
        disc_label = Text("Discriminant", font_size=24, color=RED)
        disc_label.next_to(disc_box, DOWN)

        self.play(Create(disc_box), Write(disc_label))
        self.wait()
```

---

## Graphs and Functions

### Function Plot with Animation

```python
class FunctionPlot(Scene):
    def construct(self):
        axes = Axes(
            x_range=[-3, 3, 1],
            y_range=[-1, 9, 1],
            x_length=8,
            y_length=6,
            axis_config={"include_tip": True}
        )
        labels = axes.get_axis_labels(x_label="x", y_label="y")

        # Plot parabola
        parabola = axes.plot(lambda x: x**2, color=YELLOW)
        parabola_label = MathTex(r"y = x^2").next_to(parabola, UR)

        self.play(Create(axes), Write(labels))
        self.play(Create(parabola), Write(parabola_label))
        self.wait()
```

### Animated Graph Tracing

```python
class GraphTracing(Scene):
    def construct(self):
        axes = Axes(x_range=[-PI, PI, PI/2], y_range=[-1.5, 1.5, 0.5])
        graph = axes.plot(lambda x: np.sin(x), color=BLUE)

        self.play(Create(axes))

        # Dot that traces the graph
        dot = Dot(color=YELLOW)
        dot.move_to(axes.c2p(-PI, np.sin(-PI)))

        self.add(dot)
        self.play(MoveAlongPath(dot, graph, rate_func=linear), run_time=3)
        self.wait()
```

### Dynamic Value Display

```python
class DynamicValueDisplay(Scene):
    def construct(self):
        axes = Axes(x_range=[0, 5, 1], y_range=[0, 25, 5])
        graph = axes.plot(lambda x: x**2, color=YELLOW)

        self.play(Create(axes), Create(graph))

        # Tracker and moving elements
        x_tracker = ValueTracker(0)

        dot = always_redraw(lambda: Dot(
            axes.c2p(x_tracker.get_value(), x_tracker.get_value()**2),
            color=RED
        ))

        v_line = always_redraw(lambda: axes.get_vertical_line(
            axes.c2p(x_tracker.get_value(), x_tracker.get_value()**2),
            color=GREEN
        ))

        x_label = always_redraw(lambda: MathTex(
            f"x = {x_tracker.get_value():.2f}"
        ).next_to(axes, DOWN))

        y_label = always_redraw(lambda: MathTex(
            f"y = {x_tracker.get_value()**2:.2f}"
        ).next_to(x_label, DOWN))

        self.add(dot, v_line, x_label, y_label)
        self.play(x_tracker.animate.set_value(4), run_time=4)
        self.wait()
```

### Area Under Curve

```python
class AreaUnderCurve(Scene):
    def construct(self):
        axes = Axes(x_range=[0, 5, 1], y_range=[0, 10, 2])
        graph = axes.plot(lambda x: 0.5 * x**2, color=BLUE)

        self.play(Create(axes), Create(graph))

        # Riemann rectangles (approximation)
        rects = axes.get_riemann_rectangles(
            graph,
            x_range=[1, 4],
            dx=0.5,
            color=[BLUE, GREEN],
            input_sample_type="left"
        )

        self.play(Create(rects))
        self.wait()

        # Improve approximation
        for dx in [0.25, 0.1]:
            new_rects = axes.get_riemann_rectangles(
                graph, x_range=[1, 4], dx=dx, color=[BLUE, GREEN]
            )
            self.play(Transform(rects, new_rects))
            self.wait(0.5)

        # Exact area
        area = axes.get_area(graph, x_range=[1, 4], color=BLUE, opacity=0.5)
        self.play(FadeOut(rects), FadeIn(area))
        self.wait()
```

---

## Geometric Proofs

### Pythagorean Theorem

```python
class PythagoreanTheorem(Scene):
    def construct(self):
        # Right triangle
        A = ORIGIN
        B = RIGHT * 3
        C = UP * 4

        triangle = Polygon(A, B, C, color=WHITE)

        # Labels
        a_label = MathTex("a").next_to(Line(A, B), DOWN)
        b_label = MathTex("b").next_to(Line(A, C), LEFT)
        c_label = MathTex("c").move_to((B + C) / 2 + UR * 0.3)

        # Right angle marker
        right_angle = RightAngle(Line(B, A), Line(A, C), length=0.3)

        self.play(Create(triangle))
        self.play(Write(a_label), Write(b_label), Write(c_label))
        self.play(Create(right_angle))
        self.wait()

        # Squares on each side
        sq_a = Square(side_length=3, color=RED, fill_opacity=0.5)
        sq_a.next_to(Line(A, B), DOWN, buff=0)

        sq_b = Square(side_length=4, color=BLUE, fill_opacity=0.5)
        sq_b.next_to(Line(A, C), LEFT, buff=0)

        hypotenuse = Line(B, C)
        sq_c = Square(side_length=5, color=GREEN, fill_opacity=0.5)
        sq_c.rotate(hypotenuse.get_angle())
        sq_c.move_to(hypotenuse.get_center() + sq_c.width/2 *
                     rotate_vector(RIGHT, hypotenuse.get_angle() - PI/2))

        self.play(Create(sq_a), Create(sq_b))
        self.wait()
        self.play(Create(sq_c))

        # Equation
        equation = MathTex(r"a^2 + b^2 = c^2").to_edge(DOWN)
        self.play(Write(equation))
        self.wait()
```

### Circle Theorem

```python
class CircleTheorem(Scene):
    def construct(self):
        circle = Circle(radius=2, color=WHITE)
        center = Dot(ORIGIN, color=YELLOW)
        center_label = MathTex("O").next_to(center, DL, buff=0.1)

        self.play(Create(circle), Create(center), Write(center_label))

        # Points on circle
        A = circle.point_at_angle(0.3 * PI)
        B = circle.point_at_angle(0.8 * PI)
        C = circle.point_at_angle(1.5 * PI)

        dot_A = Dot(A, color=RED)
        dot_B = Dot(B, color=GREEN)
        dot_C = Dot(C, color=BLUE)

        label_A = MathTex("A").next_to(dot_A, UR, buff=0.1)
        label_B = MathTex("B").next_to(dot_B, UL, buff=0.1)
        label_C = MathTex("C").next_to(dot_C, DOWN, buff=0.1)

        self.play(
            Create(dot_A), Create(dot_B), Create(dot_C),
            Write(label_A), Write(label_B), Write(label_C)
        )

        # Inscribed angle
        inscribed = Polygon(A, C, B, color=YELLOW)
        self.play(Create(inscribed))

        # Central angle
        central = Polygon(A, ORIGIN, B, color=RED)
        self.play(Create(central))

        # Theorem statement
        theorem = Text(
            "Inscribed angle = 1/2 Central angle",
            font_size=32
        ).to_edge(DOWN)
        self.play(Write(theorem))
        self.wait()
```

---

## Data Visualization

### Animated Bar Chart

```python
class AnimatedBarChart(Scene):
    def construct(self):
        chart = BarChart(
            values=[3, 5, 2, 8, 4],
            bar_names=["A", "B", "C", "D", "E"],
            y_range=[0, 10, 2],
            bar_colors=[BLUE, RED, GREEN, YELLOW, PURPLE]
        )

        self.play(Create(chart))
        self.wait()

        # Animate value changes
        new_values = [7, 3, 9, 2, 6]
        self.play(chart.animate.change_bar_values(new_values))
        self.wait()

        # Highlight highest bar
        max_idx = new_values.index(max(new_values))
        self.play(Indicate(chart.bars[max_idx]))
        self.wait()
```

### Pie Chart Animation

```python
class PieChartAnimation(Scene):
    def construct(self):
        data = [30, 20, 25, 15, 10]
        colors = [RED, BLUE, GREEN, YELLOW, PURPLE]
        labels = ["A", "B", "C", "D", "E"]

        sectors = VGroup()
        label_group = VGroup()
        start_angle = 0

        for value, color, label in zip(data, colors, labels):
            angle = value / 100 * TAU
            sector = Sector(
                outer_radius=2,
                angle=angle,
                start_angle=start_angle,
                color=color,
                fill_opacity=0.8
            )
            sectors.add(sector)

            # Label at sector center
            mid_angle = start_angle + angle / 2
            label_pos = 2.5 * np.array([np.cos(mid_angle), np.sin(mid_angle), 0])
            text = Text(f"{label}: {value}%", font_size=24).move_to(label_pos)
            label_group.add(text)

            start_angle += angle

        # Animate creation
        for sector, label in zip(sectors, label_group):
            self.play(Create(sector), Write(label), run_time=0.5)

        self.wait()
```

---

## Physics Simulations

### Pendulum

```python
class Pendulum(Scene):
    def construct(self):
        pivot = Dot(UP * 3)
        length = 4
        theta_max = PI / 6

        tracker = ValueTracker(theta_max)

        bob = always_redraw(lambda: Dot(
            pivot.get_center() + length * np.array([
                np.sin(tracker.get_value()),
                -np.cos(tracker.get_value()),
                0
            ]),
            color=RED,
            radius=0.2
        ))

        rod = always_redraw(lambda: Line(
            pivot.get_center(),
            bob.get_center(),
            color=WHITE
        ))

        self.add(pivot, rod, bob)

        # Simulate pendulum (simplified harmonic motion)
        omega = np.sqrt(9.8 / length)
        t = ValueTracker(0)

        def update_theta(m, dt):
            t.increment_value(dt)
            m.set_value(theta_max * np.cos(omega * t.get_value()))

        tracker.add_updater(update_theta)
        self.wait(5)
        tracker.clear_updaters()
```

### Projectile Motion

```python
class ProjectileMotion(Scene):
    def construct(self):
        axes = Axes(
            x_range=[0, 10, 1],
            y_range=[0, 5, 1],
            x_length=10,
            y_length=5
        )

        # Parameters
        v0 = 8  # Initial velocity
        angle = PI / 4  # Launch angle
        g = 9.8

        # Parametric equations
        def x(t): return v0 * np.cos(angle) * t
        def y(t): return v0 * np.sin(angle) * t - 0.5 * g * t**2

        # Time of flight
        t_flight = 2 * v0 * np.sin(angle) / g

        # Trajectory curve
        trajectory = axes.plot_parametric_curve(
            lambda t: [x(t), max(0, y(t))],
            t_range=[0, t_flight],
            color=YELLOW
        )

        self.play(Create(axes))

        # Animate ball along trajectory
        ball = Dot(color=RED)
        ball.move_to(axes.c2p(0, 0))

        self.add(ball)
        self.play(
            MoveAlongPath(ball, trajectory, rate_func=linear),
            Create(trajectory),
            run_time=2
        )
        self.wait()
```

---

## Complex Animations

### Morphing Shapes

```python
class MorphingShapes(Scene):
    def construct(self):
        shapes = [
            Circle(color=RED),
            Square(color=BLUE),
            Triangle(color=GREEN),
            RegularPolygon(n=6, color=YELLOW),
            Star(color=PURPLE)
        ]

        current = shapes[0].copy()
        self.play(Create(current))

        for next_shape in shapes[1:]:
            self.play(Transform(current, next_shape))
            self.wait(0.3)

        self.wait()
```

### Wave Animation

```python
class WaveAnimation(Scene):
    def construct(self):
        axes = Axes(x_range=[0, 4*PI, PI/2], y_range=[-2, 2, 1])
        self.add(axes)

        t = ValueTracker(0)

        wave = always_redraw(lambda: axes.plot(
            lambda x: np.sin(x - t.get_value()),
            color=BLUE
        ))

        self.add(wave)
        self.play(t.animate.set_value(4*PI), run_time=4, rate_func=linear)
        self.wait()
```

### Matrix Transformation

```python
class MatrixTransformation(Scene):
    def construct(self):
        plane = NumberPlane()
        plane.add_coordinates()

        # Original vectors
        v1 = Arrow(ORIGIN, [1, 0, 0], color=RED, buff=0)
        v2 = Arrow(ORIGIN, [0, 1, 0], color=GREEN, buff=0)

        self.play(Create(plane))
        self.play(Create(v1), Create(v2))

        # Transformation matrix
        matrix = [[2, 1], [1, 2]]

        # Apply transformation
        self.play(
            plane.animate.apply_matrix(matrix),
            v1.animate.apply_matrix(matrix),
            v2.animate.apply_matrix(matrix),
            run_time=3
        )
        self.wait()
```

### Fractal (Sierpinski Triangle)

```python
class SierpinskiTriangle(Scene):
    def construct(self):
        def get_sierpinski(order, scale=4):
            if order == 0:
                return Triangle().scale(scale)

            triangles = VGroup()
            sub = get_sierpinski(order - 1, scale / 2)

            # Three copies arranged in triangle
            t1 = sub.copy().shift(UP * scale / 2)
            t2 = sub.copy().shift(DL * scale / 2)
            t3 = sub.copy().shift(DR * scale / 2)

            triangles.add(t1, t2, t3)
            return triangles

        for order in range(5):
            triangle = get_sierpinski(order)
            triangle.set_stroke(WHITE, width=1)
            triangle.move_to(ORIGIN)

            if order == 0:
                self.play(Create(triangle))
            else:
                self.play(Transform(prev, triangle))

            prev = triangle
            self.wait(0.5)

        self.wait()
```

### Scene with Sections

```python
class SceneWithSections(Scene):
    def construct(self):
        # Introduction
        self.next_section("Introduction")
        title = Text("Mathematical Concepts").scale(1.2)
        self.play(Write(title))
        self.wait()
        self.play(FadeOut(title))

        # Section 1: Geometry
        self.next_section("Geometry")
        circle = Circle(color=RED)
        square = Square(color=BLUE)

        self.play(Create(circle))
        self.play(Transform(circle, square))
        self.play(FadeOut(circle))

        # Section 2: Algebra
        self.next_section("Algebra")
        equation = MathTex(r"E = mc^2")
        self.play(Write(equation))
        self.wait()
        self.play(FadeOut(equation))

        # Conclusion
        self.next_section("Conclusion")
        thanks = Text("Thank you!")
        self.play(Write(thanks))
        self.wait()

# Render sections: manim -pql --save_sections script.py SceneWithSections
```
