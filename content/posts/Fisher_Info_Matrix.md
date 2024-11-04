---
title: Fisher Information Matrix
tags: Probability & Statistics
categories: Math
description: Some notes on FIM.
date: 2023-06-23
---

Learning a parameter vector $\theta$:

$$\underset{\theta\in\mathbb R^n}{\arg\max}\ p(x|\theta)$$

Here $p(x|\theta)$ is the likelihood, which we need to maximize wrt. $\theta$.

**Score function**:

$$s(\theta) =\nabla_{\theta}\log p(x\vert\theta)$$

**Claim.** The expected value of $s(\theta)$ wrt. $\theta$ is $0$.

**Proof.** 

$$\begin{align*} \mathop{\mathbb{E}}_{p(x\vert\theta)}\left[ s(\theta)\right] &=\mathop{\mathbb{E}}_{p(x\vert\theta)}\left[\nabla\log p(x\vert\theta)\right]\\[5pt]    &=\int\nabla\log p(x\vert\theta)  p(x\vert\theta)\text{d}x\\[5pt]    &=\int\frac{\nabla p(x\vert\theta)}{p(x\vert\theta)} p(x\vert\theta)\text{d}x\\[5pt]    &=\int\nabla p(x\vert\theta)\text{d}x\\[5pt]    &=\nabla\int p(x\vert\theta)\text{d}x\\[5pt]    &=\nabla 1\\[5pt]    &= 0\end{align*}$$

**Fisher Information Matrix** is the covariance of score function:

$\text F=\mathop{\mathbb{E}}_{p(x\vert\theta)}\left[ (s(\theta) - 0)(s(\theta) - 0)^{\text{T}}\right] =\mathop{\mathbb{E}}_{p(x\vert\theta)}\left[\nabla\log p(x\vert\theta)\nabla\log p(x\vert\theta)^{\text{T}}\right] $

Calculating the exact expectation can be hard, so we approximate the expectation by using [empirical distribution](https://en.wikipedia.org/wiki/Empirical_distribution_function). Given training data $X =\{ x_1, x_2,\cdots, x_N\}$, we have **Empirical Fisher Information Matrix**:

$$\begin{align}\text F &=\frac{1}{N}\sum_{i=1}^{N}\nabla\log p(x_i\vert\theta)\nabla\log p(x_i\vert\theta)^{\text{T}} .\end{align}$$

Not sure: Calculating empirical FIM takes $O(nk^2)$ time, where $n$ is the size of training set and $k$ is the number of parameters.
