---
title: EE411 Information Theory and Coding
categories: CS
description: Notes for information theory and coding
date: 2024-09-24
---

## Outline

- Chapter 0: Introduction
- Chapter 1: Entropy
- Chapter 2: Inequalities

## Chapter 1: Entropy

- **Monotonous**: less probable $\rightarrow$ more information
- **Additive**: Total info = $\sum$ info independent events

For a discrete random variable $X$:

- Realizations: $\mathcal X=\{x_1,\dots,x_q\}$
- Probabilities: $\{p_1,\dots,p_q\}$
- Self-info of $X=x_i$: $-\log p_i$
- Avg. information: $I(X)=-\sum\limits_{i=1}^q p_i \log p_i$

**Entropy**:

A measure of the amount of info required to describe a r.v., average bits to describe the random variable.
$$
H(X) = -\sum\limits_{x\in\mathcal X}p(x)\log p(x)=-E[\log p(X)]
$$

> Lemma 1. $H(X)\ge 0$
>
> Lemma 2. $H_b(X)=(\log_ba)H_a(X)$
>
> Denote $H(p) = -p\log p - (1-p)\log(1-p)$

**Joint Entropy**: 
$$
H(X,Y)=-\sum\limits_{x\in\mathcal X}\sum\limits_{y\in\mathcal Y}p(x,y)\log p(x,y) = -E[\log p(X,Y)]
$$
> If $X$ and $Y$ are independent, then $H(X,Y) = H(X) + H(Y)$

**Conditional Entropy**: 
$$
H(Y\mid X)=-\sum\limits_{x\in\mathcal X}\sum\limits_{y\in\mathcal Y}p(x,y)\log p(y\mid x) = -E[\log p(Y\mid X)]
$$
**Chain Rule of Entropy**:

Proof by induction.
$$
\begin{align*}
\text{Joint} &=\ \ \  \text{Single} +\text{Conditional}\\
H(X,Y) &=\ \ \  H(X) +H(Y \mid X)\\
H(X_1,\dots, X_2) &=\ \ \  \sum\limits_{i=1}^n H(X_i\mid X_{i-1},\dots,X_1)
\end{align*}
$$
**Relative Entropy** (KL Divergence):

A measure of the **distance** between two distributions, extra bits needed for describing another r.v. based on the given r.v.
$$
D(p \parallel q) = \sum\limits_{x\in\mathcal X}p(x)\log\frac {p(x)}{q(x)}
$$

$$
D(p \parallel q) \ne D(q \parallel p)
$$

**Mutual Information**: 

The relative entropy between the joint distribution and the product distribution.
$$
I(X; Y) = -\sum\limits_{x\in\mathcal X}\sum\limits_{y\in\mathcal Y}p(x,y)\log \frac {p(x, y)}{p(x)p(y)} = D(p(x,y)\parallel p(x)p(y))
$$

$$
\begin{align*}
I(X;Y) &= H(X) - H(X\mid Y)\\
I(X;Y) &= H(Y) - H(Y\mid X)\\
I(X;Y) &= H(X) + H(Y) - H(X, Y)\\
I(X;Y) &= I(Y;X)\\
I(X;X) &= H(X)
\end{align*}
$$
**Conditional Mutual Information**:
$$
\begin{align*}
I(X;Y\mid Z) &= H(X\mid Z) - H(X\mid Y,Z)\\
&= E_{p(x,y,z)}\log\frac{p(X,Y\mid Z)}{p(X\mid Z)p(Y\mid Z)}
\end{align*}
$$
**Chain Rule for Mutual Information**:
$$
I(X_1,\dots,X_n;Y) = \sum\limits_{i=1}^n I(X_i;Y\mid X_{i-1},\dots,X_1)
$$
**Conditional Relative Entropy**:

Given joint probability mass functions $p(x, y)$ and $q(x, y)$, the conditional relative entropy is:
$$
\begin{align*}
D(p(y \mid x) \parallel q(y \mid x)) & =\sum_{x} p(x) \sum_{y} p(y \mid x) \log \frac{p(y \mid x)}{q(y \mid x)} \\
& =E_{p(x, y)} \log \frac{p(Y \mid X)}{q(Y \mid X)}
\end{align*}
$$
**Chain Rule for Relative Entropy**
$$
D(p(x,y)\parallel q(x,y)) = D(p(x)\parallel q(x)) + D (p(y\mid x)\parallel q(y\mid x))
$$
**Another way to explain mutual information**
$$
I(X;Y) = D(p(x,y)\| p(x)p(y))
$$
For r.v. $X,Y \sim p(x,y) $, $\tilde X, \tilde Y \sim q(x,y)$:

If $q(x,y) = p(x)\cdot p(y)$, then $q(x) = p(x)$, $q(y) = p(y)$

Therefore $q(x,y) = q(x) \cdot q(y)$, $\tilde X \bot \tilde Y$ .

## Chapter 2: Inequalities

$f(x)$ is **convex** IFF over $(a,b)$, $\forall x_1,x_2 \in (a,b)$ and $0\le \lambda \le 1$ :
$$
f(\lambda x_1+(1-\lambda)x_2) \le \lambda f(x_1) + (1-\lambda) f(x_2)
$$
$f(x)$ is **strictly convex** if equality holds only if $\lambda = 0/1$.

$f(x)$ is **concave** if $-f(x)$ is convex. 

**Theorem: Jensen's Equality**

For convex function $f(x)$ and r.v. $X$, $E[f(X)] \ge f(E[X])$. If strict convex, equality holds only if $X$ is constant.

Proof by induction.

**Theorem: Information Inequality**

For any probability mass function $p(x)$ and $q(x)$, $D(p(x)\|q(x)) \ge 0$.

Equality IFF $\forall x, p(x)=q(x)$.

**Theorem: Nonnegativity of mutual information**

For any random variables $X$, $Y$, $I(X;Y)=D(p(x,y)\|p(x)p(y))\ge 0$.

Equality IFF $X \bot Y$.

> Corollaries
>
> - $D(p(y|x)\|q(y|x))\ge0$, with equality IFF
>   $$
>   \forall y\forall x \text{\ s.t.\ } p(x)>0, p(y|x)=q(y|x).
>   $$
>
> - $I(X;Y|Z)\ge0$, with equality IFF $X$ and $Y$ are conditionally independent given $Z$.

**Theorem: The maximum entropy distribution**

For discrete r.v. $X$, $H(X)\le \log | \mathcal X |$, with equality IFF $X$ has a uniform distribution over $|\mathcal X|$.
$$
u(x)=\frac 1 {|\mathcal X|}, \forall p(x), 0 \le D(p\|u)=\sum\limits_x p(x) \log \frac{p(x)}{u(x)} = \log |\mathcal X| - H(X)
$$
**Theorem: Conditioning reduces entropy**

$H(X|Y)\le H(X)$ with equality IFF $X\bot Y$.

**Theorem: Independence bound on entropy**

$H(X_1,\dots,X_n)\le\sum\limits_{i=1}^n H(X_i)$ with equality IFF $\forall i\ne j, X_i\bot X_j$

**Markov Chain**

Random variables $\{X_n\}$ form a Markov chain $X_1\rightarrow\cdots\rightarrow X_n$if the p.m.f. satisfies
$$
p(x_i|x_1,\dots,x_{i-1}) = p(x_i|x_i-1)
$$
> Properties
>
> - $X\rightarrow  Y\rightarrow Z\implies p(x,z|y)=p(x|y)p(z|y)$
> -  $X\rightarrow  Y\rightarrow Z\implies  Z\rightarrow  Y\rightarrow X$
> - If $Z=f(Y)$, then $X\rightarrow  Y\rightarrow Z$.

**Theorem: Data-processing inequality**

If $X\rightarrow Y \rightarrow Z$, then $I(X;Y)\ge I(X;Z)$.
$$
\begin{align*}
I(X;Y,Z) &= I(X;Z) + I(X;Y|Z)\\
&= I(X;Y) + I(X;Z|Y)
\end{align*}
$$
Since $X\rightarrow Y \rightarrow Z$, we have $I(X;Z|Y)=0$. Since $I(X;Y|Z)\ge 0$, it holds.

> Corollaries
>
> In particular, if $Z = g(Y)$, we have $I(X; Y ) ≥ I(X; g(Y ))$.
>
> If $X\rightarrow  Y\rightarrow Z$, then $I(X; Y |Z) ≤ I(X; Y )$.



**Zero conditional entropy**

The conditional entropy of a random variable $X$ given another random variable $Y$ is zero ($H(X|Y ) = 0$) IFF $X$ is a function of $Y$. Hence we can estimate $X$ from $Y$ with zero probability of error IFF $H(X|Y)$ = 0.

**Fano’s inequality**

A random variable $Y$ is related to another random variable $X$ with a distribution $p(x)$. From $Y$, we calculate a function $g(Y ) = \hat X$, where $\hat X$ is an estimate of $X$ and takes on values in $\hat X$. For Markov chain $X → Y → \hat X$, the estimate error probability $P_e = \text{Pr}[\hat X\ne X]$ satisfies
$$
H(P_e)+P_e\log(|\mathcal X|-1)\ge H(X|\hat X)\ge H(X|Y).
$$
This inequality can be weakened to
$$
1+P_e\log(|\mathcal X|-1) \ge H(X|Y)\\
P_e \ge \frac{H(X|Y)-1}{\log |\mathcal X|-1}.
$$
> Corollaries
>
> For any two r.v. $X$ and $Y$, let $p=\text{Pr}[X\ne Y]$, $H(p)+p\log (|\mathcal X|-1)\ge H(X|Y)$.
>
> If $X$ and $X^\prime$ are i.i.d. with entropy $H(X)$, $\text{Pr}[X=X^\prime]\ge 2^{-H(X)}$, with equality IFF $X$ has a uniform distribution.

## Chapter 3: Asymptotic Equipartition Property

**Theorem: Weak Law of Large Number**

For i.i.d.r.v. $\{X_n\}$, $\frac 1 n \sum\limits_{i=1}^n X_i \rightarrow E[X]$ in probability, i.e.,
$$
\forall \epsilon >0, \mathop{\text{lim}}\limits_{n\rightarrow \infty} \text{Pr}\left[\left|\frac 1 n \sum\limits_{i=1}^n X_i-E[X]\right|\le \epsilon\right]=1
$$
**Theorem: Asymptotic Equipartition Property (AEP)**

For i.i.d.r.v. $\{X_n\}\sim p(x)$, $-\frac 1 n \log p(X_1,\dots,X_n)\rightarrow H(X)$ in probability.

> Proof using the weak law of large number
> $$ \begin{align*}
 -\frac 1 n \log p(X_1,\dots,X_n) &= -\frac 1 n \sum\limits_i \log p(X_i)\\
 &\rightarrow -E[\log p(x)]\ \text{ in probability}\\
 &= H(X)
 \end{align*} $$

**Typical Set**

A typical set $A_\epsilon^{(n)}$ contains all sequence realizations $(x_1,\dots,x_n)\in \mathcal X^n$ of i.i.d.r.v. sequence $(X_1,\dots,X_n)$, satisfying
$$
2^{-n(H(X)+\epsilon)}\le p(x_1,\dots,x_n) \le2^{-n(H(X)-\epsilon)}
$$
- If $(x_1,\dots,x_n)\in A_\epsilon^{(n)}$, then $H(X)-\epsilon\le -\frac 1 n \log p(x_1,\dots,x_n)\le H(X)+\epsilon$
- $|A_\epsilon^{(n)}|\le 2^{n(H(X)+\epsilon)}$
- If $n$ is sufficiently large,

  - $\text{Pr}[(X_1,\dots,X_n)\in A_\epsilon^{(n)}] > 1-\epsilon$
  - $|A_\epsilon^{(n)}|\ge (1-\epsilon) 2^{n(H(X)-\epsilon)}$

Let $X^n$ be i.i.d. $\sim p(x)$. There exists a code that one-to-one maps sequences $x^n$ of length $n$ into binary strings with
$$
E[\frac 1 n \mathscr l (X^n)] \le H(X) + \epsilon
$$
for $n$ sufficiently large.

## Chapter 5: Source Coding

### Chapter 5-1

Goal: develop practical lossless coding algorithms approaching(achieving) the best achievable data compression $H(X)$.

**Terminology**: source alphabet, code alphabet, codeword, codeword length, codebook.

// ignored some intermediate contents

**Theorem: Kraft Inequality**

For any prefix code over an alphabet of size $D$, the codeword lengths $\mathscr l_1, \dots, \mathscr l_m$ must satisfy the inequality
$$
\sum\limits_i D^{-\mathscr l_i} \le 1
$$
Conversely, given a set of codeword lengths satisfying this inequality, there exists a prefix code with these codeword lengths.

Proof: $\sum\limits_i D^{\mathscr l_{\max}-\mathscr l_i}\le D ^{\mathscr l_\max} \implies \sum\limits_i D^{-\mathscr l_i} \le 1$

### Chapter 5-2

{{< img src="https://s2.loli.net/2023/01/01/8pS9IbAPfWXDOgt.png" style="zoom:25%;"  >}}

### Chapter 5-3 - Huffman Code
