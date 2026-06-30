---
title: "Proposal: Automatic Sprite Sheet Generation from Character Illustrations"
date: 2026-01-18T16:08:10+08:00
draft: false # Set 'false' to publish
description: 'My first steps on diffusion model pipelines.'
categories:
  - CS
tags:
  - Machine Learning
  - Artificial Intelligence
---

## Motivation

Pixel-art animation remains one of the most labor-intensive components of 2D game development. In *Celeste*, a single playable character skin consists of hundreds of tightly coordinated animation frames spanning multiple actions (e.g., walk, idle, jump) and character variants (player, player's dark side, player with no backpack). Each frame must preserve **structural consistency**, **visual identity**, and **temporal coherence**, despite being rendered at low resolutions (typically 32×32).

This project explores the following question:

> **Can we automatically generate a complete, coherent Celeste sprite set from one or several high-resolution character illustrations?**

I plan to begin a research in the near term to study this problem systematically, using modern **diffusion-based generative models**, augmented with structural and temporal constraints tailored for pixel-art animation.

---

## Problem Definition

### Input and Output

**Input**

* One or more high-resolution character design images (illustrations, concept art).
* Alternatively, a low-resolution reference sprite (e.g., `idle00.png`) extracted from an existing mod.

**Output**

* A complete Celeste skin mod following the canonical directory structure:

```
raw/<mod_name>/
├── player/
│   ├── idle00.png
│   ├── idle01.png
│   ├── ...
│   ├── idleA01.png
│   ├── ...
│   ├── idleB01.png
│   ├── ...
│   ├── walk00.png
│   ├── walk01.png
│   └── ...
├── badeline/
│   └── ...
├── ...
└── player_no_backpack/
    └── ...
```

Each output sprite must:

* Match the intended character’s **visual identity** (color palette, clothing, hair, etc.).
* Respect the **action semantics** (e.g., walking vs idle).
* Maintain **frame-to-frame continuity** within the same action.

---

## Dataset Characteristics

The training data consists of existing Celeste skin mods with the structure:

```
<mod_name>/<character_name>/<action>[State][FrameIndex].png
```

Key properties:

* Sprite resolution is small (mostly 32×32, sometimes up to 128×128).
* For a fixed action (e.g., `walk`), all frames across all mods share the same resolution.
* Different mods replace the same underlying character skeleton with different appearances.
* Coverage is incomplete:

  * Some mods only implement certain actions.
  * Some only modify `player` but not `badeline`.
* Total number of mods is small (on the order of tens).

This leads to **severe data sparsity**, especially when conditioning on `(action, frame index)`.

---

## Core Technical Challenges

### Data Scarcity

* For a given action and frame index, the number of available training samples may be fewer than 20.
* Naïve per-frame or per-action training easily overfits.

### Temporal Coherence

* Independent frame generation leads to visual jitter.
* Walk cycles (`walk00` → `walk12`) must form smooth loops when rendered as a GIF.

### Structural Consistency

* Characters differ greatly in color and style across mods.
* However, **limb layout and proportions are approximately aligned**.
* The model must prioritize *structure over color correlation*.

### Resolution Gap

* Inputs are high-resolution illustrations, or low-resolution sprites.
* Outputs are extremely low-resolution pixel sprites.
* This might be a non-trivial cross-scale, cross-style mapping problem.

### Model Availability

* Most open-source generative models target high-resolution natural images.
* Pixel-art animation–specific models are rare and underexplored.

---

## Research Hypothesis

> **A conditional diffusion model, augmented with explicit structural guidance and temporal conditioning, can generate coherent low-resolution pixel animation sequences from sparse sprite datasets.**

Crucially, coherence must be enforced **by design**, not left to chance.

---

## Proposed Model Architecture

### Base Model: Conditional Diffusion

* Start from a diffusion-based image generation framework (e.g., Stable Diffusion–style U-Net).
* Retrain or fine-tune on pixel-art sprites (upsampled to 64×64 or 128×128 for training stability).

### Conditioning Signals

Each generated frame is conditioned on:

1. **Character Appearance**

   * High-resolution illustration (via an IP-Adapter–like module).
   * Alternatively, a low-res canonical reference frame (`idle00.png`).

2. **Action Type**

   * Encoded as a categorical embedding (`walk`, `idle`, etc.).

3. **Frame Index**

   * Explicit numeric or positional embedding (e.g., frame 0–12).

4. **Optional Structural Guidance**

   * Simplified skeletons, stick figures, or hand-labeled keypoints.
   * Fed through a ControlNet-style side network.

### Temporal Consistency Mechanisms

Several strategies will be explored:

* **Frame-to-frame conditioning**: previous frame as an additional input.
* **Sequence generation**: generating all frames of an action jointly (sprite sheet output).
* **Temporal loss terms**: penalizing excessive deviation between adjacent frames in latent space.

---

## Training Strategy

### Action-Centric Training

* Train one model per action (e.g., `walk`), not per frame.
* Use frame index as a condition rather than splitting models.

### Transfer and Parameter Efficiency

* Use LoRA or other low-rank adaptation methods to cope with limited data.
* Pretrain on general pixel-art datasets (e.g., open sprite repositories), then fine-tune on Celeste.

### Data Augmentation

* Horizontal flipping.
* Palette-preserving color jitter.
* Skeleton-level augmentation (slightly altered limb angles).

---

## Evaluation Criteria

Since standard image metrics are insufficient, evaluation will include:

* **Visual loop coherence** (manual and perceptual inspection).
* **Frame similarity consistency** (SSIM / LPIPS between adjacent frames).
* **Structural stability** (no limb teleportation).
* **Mod usability**: can the generated sprite be dropped into Celeste without noticeable artifacts?

---

## Experimental Roadmap

1. **Phase I**:

   * Single character (`player`), single action (`walk`).
   * Low-resolution reference sprite as appearance input.

2. **Phase II**:

   * Replace reference sprite with high-resolution illustration.
   * Introduce structural guidance.

3. **Phase III**:

   * Multi-action conditioning.
   * Sprite-sheet–level generation.

4. **Phase IV**:

   * Extend to `badeline` and other character variants.

---

## Expected Contributions

* A **formalized dataset format** for Celeste sprite learning.
* An empirical study of **diffusion models under extreme low-data regimes**.
* Practical insights into **temporal coherence for pixel-art animation generation**.
* A prototype pipeline for automatic Celeste skin generation.

---

## Conclusion

This project sits at the intersection of **generative modeling**, **animation**, and **game modding**, under unusually strict constraints: low resolution, small datasets, and high temporal sensitivity. While visual perfection can be refined manually, **temporal coherence cannot**—and that is the central technical focus of this research.

I plan to begin experimental implementation shortly and will document progress, failures, and insights in follow-up posts.

---