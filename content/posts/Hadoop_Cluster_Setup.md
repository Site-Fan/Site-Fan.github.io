---
title: Set Up a Hadoop Cluster From Scratch
tags: Distributed System
categories: CS
description: Tutorial for setting up a hadoop cluster with ZKFC and YARN over Docker.
date: 2024-07-26
---

A sample Hadoop cluster augmented with ZKFC and YARN, for MapReduce tasks.

The official Docker image of [Apache Hadoop](https://hub.docker.com/r/apache/hadoop) is based on CentOS 7, but as the EOL of CentOS 7 on June 30th, 2024, no new updates for CentOS will be made available. Time to deploy a Hadoop cluster in Docker on our own!

### Overview

In this article, we will set up a Hadoop cluster in Docker with 2 name nodes and 3 data nodes, along with ZKFC (Zookeeper Failover Controller) and YARN (Yet Another Resource Negotiator). 

![](https://s2.loli.net/2023/01/01/8pS9IbAPfWXDOgt.png)
