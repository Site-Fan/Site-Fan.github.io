---
title: Reinforcement Learning Seminar Ⅱ
tags: [Artificial Intelligence, Reinforcement Learning]
categories: CS
description: RL Seminar 2/4 by Yansong Li
date: 2023-07-09
---

## Info

深圳市-福田区-景田路-中国茶宫-6层

## Markov Decision Process (MDP)

### State Space Form, with Controller

$$x_{t+1}=f(x_t,u_t)$$

Consider a space system with perturbation

$$x_{t+1}=f(x_t,u_t,w_t)$$

where $w_t\sim P$.

The system $x_{t+1}=f(x_t,u_t,w_t)$ is equivalent to $x_{t+1}=D(x_t,u_t)$. 

### MDP

**Assumption.** $|S|,|A|\le \infty$

An infinite-horizon Markov Decision Process is a tuple $(S,A,r,\gamma,\mathbb P)$, where $S$ is the state space, $A$ is the action space, $r: A\times S\rightarrow [0,1]$, $\gamma\in(0,1)$ is the discount factor and $\mathbb P: S\times A\rightarrow \Delta(S)$ is the transition kernel(aka. model/dynamics).

**State-Value function**

$V:S\rightarrow [0,1]$, defined as

$$V^\pi(s)\triangleq \mathbb E_{s_{h+1}\sim \mathbb P(s_h,a_h),a_h\sim\pi(s_h)}(\sum\limits_{h=1}^\infty \gamma^hr(s_h,a_h)|s_1=s)$$

where $\pi = (\pi_1,\pi_2,\cdots)$

State-Action Value Function

$Q^\pi(s,a) \triangleq ?$

## Value Iteration

$\{Q_1,Q_2,\cdots,Q_\infty\}$. Goal: $Q_\infty=Q^\star$, $Q^\star\triangleq Q^{\pi^\star}$, $Q^\star(s,a)\triangleq r(s,a) + \gamma\mathbb E_{s'\sim\mathbb P(s,a)}(V^{\pi^\star}(s'))$.

$$V_{k+1(s)}\leftarrow r(s,a)+\gamma\max\limits_{a'\in A}(\mathbb E_{s'\sim\mathbb P(s,a)}(Q_k(s',a')))$$

$$\pi^\star(s) = \mathop{\arg\max}\limits_{a\in A} Q_\infty(s,a)$$

**Bellman Optimality Operator**

$\text T^\star: Q\rightarrow Q$ defined as

$$Q_{k+1}\triangleq \text T^\star Q_k$$

$$V_{k+1(s)}\leftarrow r(s,a)+\gamma\max\limits_{a'\in A}(\mathbb E_{s'\sim\mathbb P(s,a)}(Q_k(s',a')))$$

for all $(s,a)\in S\times A$.

**Theorem.** $Q_\infty$ is the fixed point of $\text T^\star$, i.e., $Q_\infty=\text T^\star Q_\infty$

Proof: $Q$ is a contraction mapping of $\text T^\star$'s Banach Space

## Appendix

$r(s,a) = \int R(s,a)d D(s,a) = \mathbb E(R(s,a))$

$\Delta_n$: Probability simplex

$\Delta_2 = \{x\in \mathbb R^3 : \mathbb 1^T x=1,x\succeq 0\}$

Policy: $\pi: S\rightarrow \Delta(A)$

Deterministic policy $\pi:S\rightarrow A$

Nonstationary policy $\pi: S\times T\rightarrow \Delta(A)$

Optimal policy $\pi^\star=\mathop{\arg\max}\limits_{\pi} V^\pi(s_1)$

**Banach space**

- Complete: Any Cauchy Sequence converges
  - Cauchy Sequence: $\{x_k\}_{k=1}^\infty,\ \forall \epsilon\ \exists N$ s.t. $k>N$, $|x_{k+1}-x_k|<\epsilon$
- Normed: Distance can be defined (Metric space?)
  - Metric: two-point distance, norm: distance to $O$
- Vector space

**Contraction mapping**

$\text T: V\rightarrow V$

$\mathbb F||v||\le ||v||,\ F||v||\le\gamma||v||, \gamma\in(0,1)$

**Theorem.** Banach Space Fixed Point Theorem

If $\text T$ is a contraction mapping on $\mathscr B$

$\forall x\in \mathscr B, \text T^\infty x=t_{fix}$

where $\text T^\infty t_{fix}=t_{fix}$ 

## Assignment

1. Prove that the system $x_{t+1}=f(x_t,u_t,w_t)$ is equivalent to $x_{t+1}=D(x_t,u_t)$.
2. Prove that an infinite horizon MDP with a stationary policy $\pi$ is a Markov process. (hint: prove $s'\sim\mathbb P(s,\pi(s))$ is Markovian)
3. Prove that for an infinite horizon MDP with discount factor $\gamma\in (0,1)$, the optimal policy is stationary and deterministic, i.e., $\pi^\star = (\pi^\star,\pi^\star,\cdots,\pi^\star)$ or $\pi^\star:S\rightarrow \Delta(A)$.
4. State and prove the Banach Space Fixed Point Theorem.
5. Prove that $Q_\infty=\text T^\star Q_\infty$ using Banach Space Fixed Point Theorem. (Hint: Prove that the $\text T^\star$ in )

## Epilogue

Unfortunately, the seminar was not continued and Yansong Li returned to his university abroad.