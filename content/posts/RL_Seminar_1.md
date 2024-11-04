---
title: Reinforcement Learning Seminar Ⅰ
tags: [Artificial Intelligence, Reinforcement Learning]
categories: CS
description: RL Seminar 1/4 by Yansong Li
date: 2023-07-02
---

## Info

Text editor: $\text{Textmacs}$

Email: [yli340@uic.edu](mailto: yli340@uic.edu)

## From Physics to Control Theory

State of Newton's System(deterministic):

$$s(t) = \begin{bmatrix}x(t)\\\dot x(t)\end{bmatrix}.$$

State-space form of Newton's 2nd Law:

$$\begin{align*}\dot s(t) &=\begin{bmatrix}\dot x(t)\\\ddot x(t)\end{bmatrix}\\&= \begin{bmatrix}0\quad1\\0\quad0\end{bmatrix} \begin{bmatrix}x(t)\\\dot x(t)\end{bmatrix} + \begin{bmatrix}0\quad0\\0\quad1\end{bmatrix}\begin{bmatrix}0\\u\end{bmatrix}\\&=A s(t) + B\begin{bmatrix}0\\u\end{bmatrix}.\end{align*}$$

What's a linear transformation? 

$$\mathscr A(x) = \begin{bmatrix}\mathscr Ae_1\quad \mathscr Ae_2\end{bmatrix}x.$$

Group, Flow, Lie Group

General form of state transform:

$$\dot s(t) = f(s(t), u(t)).$$

## From Deterministic to Stochastic

> Discrete System Only

### Without Controller:

$\dot s(t)=f(s(t)) \rightarrow s_{t+1} = f(s_t)$

Stochastic dynamic system:

$s_{t+1} = f(s_t) \rightarrow s_{t+1} \sim p(s_t)$

Markov System (memoryless):

$s_{t+1} \sim p(s_0,\cdots,s_t)=p(s_t)$

### With Controller:

$x_{t+1}=f(x_t,u_t)\rightarrow s_{t+1}\sim p(s_t,a_t)$

## Introduction to RL

Interact with environment

Logic -> Supervised -> RL

Safe RL

Sim2Real

## Next Seminar: MDP

Maximize reward function

$\pi: S\rightarrow\Delta(A)$

$r: S\times A\rightarrow[0,1]$