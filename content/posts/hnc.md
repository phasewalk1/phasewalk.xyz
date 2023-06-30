---
title: "Hybrid Neural Collaboration"
date: 2023-06-28T12:30:21-16:00
draft: false
description: "Music-based Recommendation Systems in production"
tags: [ML, Music]
image: /hnc.png
---

> This document is an evolving **draft**.

Much of the thought process behind this article is unique to our application, and primarily, the task of integration with our backend architecture. This document concerns itself with laying out proposed implementation architectures and discussing how they would fit into our existing application. Some of this information might not be relevant to you if you're only interested in learning about _MBRS_’s (Music Based Recommendation Systems) and less about designing and deploying the pipeline that integrates into a distributed system. If you would just like to read about _MBRS_'s, here are some relevant links that I recommend (no pun intended):

##### Recommendation Systems: Fundamentals
_Fundamentalist approaches do not involve training a model_, they operate purely by data-driven algorithms.

- [Collaborative Filtering](https://en.wikipedia.org/wiki/Collaborative_filtering)
    
- [Matrix Factorization](https://developers.google.com/machine-learning/recommendation/collaborative/matrix)
    

##### Modern Approaches:
_I consider an approach to be modern if it **blends** fundamental approaches with deep learning models_.

- [Neural Collaborative Filtering](https://arxiv.org/pdf/1708.05031.pdf)
    
    - Also alluded to in the _Collaborative Filtering_ article
        
- [Hybrid Neural Collaboration](https://nbviewer.org/github/YIZHE12/music_recom/blob/master/music_recommendation_binary.ipynb)
    
    - _I don't think they're actually called this, I just thought it sounded cool. It's a_ **_hybrid_** _approach because it combines the ideas of collaboration with_ **_content-based_** _recommendation_. _So, fuck it. I'm coining the term **hybrid neural collaboration**_. 
	    - _The approach is also described in further detail in [A Survey of Collaborative Filtering Techniques](https://downloads.hindawi.com/archive/2009/421425.pdf?_ga=2.75799185.56191888.1687976765-564580601.1687976765)_.

There are **_many_** more modern implementations (CRNN's using computer vision on spectrogram images) and papers I could link to here, and I plan on updating this draft routinely; These are just the most relevant to us now.

I think the term that best encapsulates the approach I’ve arrived at is Hybrid Neural Collaboration. It’s a hybrid approach because it combines [collaborative filtering](https://en.wikipedia.org/wiki/Collaborative_filtering) with [content-based filtering](https://developers.google.com/machine-learning/recommendation/content-based/basics), and implements both components in separate neural networks. This is, by no means, a novel approach — see [here](https://downloads.hindawi.com/archive/2009/421425.pdf?_ga=2.75799185.56191888.1687976765-564580601.1687976765) — rather, a term for describing the entire system pipeline in practice. 

## Neural Collaborative Filtering and The User-Item Transaction Matrix
The model architecture we have discussed previously (many months ago) was the _CRNN content-based filtering_ approach. This approach is where we generate _spectrogram_ images that embed information about the _content of the item_, and rely on _computer vision_ in the convolutional layers to learn how to extract certain _features_ from the raw wave information present in the spectrograms. This would introduce added overhead into our system, because we would likely have to set up _processing queues_ to continuously analyze every new item that is written to the _S3 bucket_, then we'd need to store the spectrograms somewhere too. 

We can avoid introducing compute overhead and *processing queue complexity* by ignoring *feature extraction* and *signal processing altogether*. *NCF* models are trained on simple **vectors** that contain *user-item interaction metadata*, and they learn the latent factors that represent the similarities between different users. So if _user1_ likes _x_, _y_, and _z_, and _user2_ likes _x_ and _y_, they are **likely** to be recommended _z_. 

An example of a structure that acts as a single point in the training input data for an NCF *could* look like this:
```C
// The model learns to group users into similar taste categories,
// and can recommend users new items based on distance in the
// vector space (euclidean or cosine similarity; usually)
struct UserItemMetric
{
  int user_id;
  int song_id;
  int listen_count;
};
```

## Sparsity and The Cold Start Problem - Where Hybrid Comes In

A *hybrid collaboration* model introduces *content* metadata into the context of the NCF. This helps combat the [cold start problem](https://en.m.wikipedia.org/wiki/Cold_start_(recommender_systems)#:~:text=Cold%20start%20is%20a%20potential,not%20yet%20gathered%20sufficient%20information.) wherein [sparsity](https://en.wikipedia.org/wiki/Sparse_matrix) in the dataset can make it impossible to serve *good recommendations to new users* (sometimes called *Context-aware Collaborative Filtering*). 
>> Sparsity happens when there are **many** items in the dataset and *most users have only interacted with a **few** items* (implies many zeroes in the *user-item-transaction matrix*). This applies to our application. 

In order to tackle this problem and ensure our engine is useful for new users too, we must feed the model some context on the content of the items during training time. These can be discussed and tuned to what we think works best. They do not need to be raw features such as are commonly extracted from signal processing, rather, they can be simple metadata features (e.g. Title, Author, Length, Tags, etc.).

## Data  Normalization and Context-Injection

Now that we’ve introduced the basic concepts of the *hybrid neural collaboration* architecture, we can discuss applying it from the top down. As we mentioned above, we need **both** the user-item interaction metrics and metadata content from each item. 

Since i’m not sure what the schema for the Song records is now, just humor me with this hypothetical example of what types of metadata we could use. 
```C
struct Song
{
  string title;
  string release;
  string artist_name;
  string year;
};
```
Now, to train the model, we‘ll create dataframes over the two datasets. We’ll then merge the two so that they look something like this:
![[Pasted image 20230628025222.jpg]]

Since the `listen_count` field is a highly variant field (can range from 0 to 1,000+) we will want to normalize it across the dataset. We can do this using [zscore normalization](https://www.statology.org/z-score-normalization/) which is simple in *numpy*. We will also likely want to drop any rows with abnormally high play counts (above 20,000 for example) before performing normalization so that artificially inflated values don’t skew the deviation maliciously.

Once we have this normalized and merged dataframe, we have successfully completed the preprocessing stage and we are ready to train the model. 

## NCF - Model Architecture

## CBF - Model Architecture 
