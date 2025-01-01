---
title: EE411 Information Theory and Coding - Review
tags: Information Theory
categories: CS
description: Review Notes for information theory and coding
date: 2024-12-24
---

Since there's only calculation questions in the final exam, only calculation is covered in this note.

### Introduction

![](https://s2.loli.net/2023/01/01/8pS9IbAPfWXDOgt.png)

### Entropy

**Entropy**
$$
H(X) = -\sum\limits_{x\in\cal{X}}p(x)\log p(x)=\mathbb E[\log\frac{1}{p(X)}]
$$
**Joint entropy**
$$
H(X,Y)=\mathbb E[logp(X,Y)]
$$
**Conditional entropy**
$$
H(Y|X) = -\sum\limits_{x\in\cal X}\sum\limits_{y\in\cal Y}p(x,y)\log p(y|x) = - \mathbb E \log p(Y|X)
$$
**Mutual**

### **Chain rules?**

### **3 Inequalities**

- info
- jensen
- markov

### **AEP**

typical set?

4 properties

### Source Coding!

- Codes
  - Nonsingular
  - 优妮可莉笛蔻德保寇德
  - 普勒菲克斯寇德
- Kraft inequality
- Mcmillan inequality
- Huffman code

### Entropy Rate!

- stationary

### Channel Coding

- joint typical set?
- joint AEP?
- Channel coding theorem?
  - Achievability
  - Converse

### Differential entropy

- relation of differential entropy to discrete entropy
- joint/conditional differential entropy
- relative entropy
- AWGN, 
