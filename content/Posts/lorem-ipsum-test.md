---
title: "Lorem Ipsum — Rendering Test"
date: 2026-07-01
tags:
  - test
  - sandbox
---

> [!note] Sandbox post
> A throwaway post to test Markdown + math rendering. Safe to delete.

## Lorem

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## Markdown features

- [x] task done
- [ ] task to do

| Feature | Works? |
| --- | --- |
| Tables | ✅ |
| Footnotes[^f] | ✅ |

`inline code`, **bold**, *italic*, ~~strike~~, and a [link](https://quartz.jzhao.xyz).

```python
def hello(name: str) -> None:
    print(f"hello, {name}")
```

> [!tip] Callout
> Obsidian-style callouts render too.

## Math (KaTeX grammar coverage)

Inline: $E = mc^2$, $\alpha + \beta = \gamma$, $x \in \mathbb{R}^n$, $\binom{n}{k}$.

Display, integral & fraction:
$$
\int_0^\infty e^{-x^2}\,dx = \frac{\sqrt{\pi}}{2}
$$

Aligned (Maxwell):
$$
\begin{aligned}
\nabla \cdot \mathbf{E} &= \frac{\rho}{\varepsilon_0} \\
\nabla \times \mathbf{B} &= \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}
\end{aligned}
$$

Matrix & cases:
$$
A = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix}, \qquad
f(x) = \begin{cases} x^2 & x \ge 0 \\ -x & x < 0 \end{cases}
$$

Sums & limits:
$$
\sum_{k=1}^{n} k = \frac{n(n+1)}{2}, \qquad \lim_{x \to 0} \frac{\sin x}{x} = 1
$$

[^f]: This is a footnote.
