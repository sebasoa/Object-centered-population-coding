# Object-centered-population-coding

This repository contains functions necessary to perform some analyses from the paper "Object-centered population coding
in CA1 of the hippocampus", by Nagelhus et al. 2023. 

The most important functions are <objectTuningScore> and <distanceDecoder, responsible for calculating
the object-tuning score and performing the distance decoding, respectively. Please see each function for explanations
of how to use them. 

The object-tuning score requires having recorded position- and spike data from two trials 
with an object placed in different locations (Object and Object Moved in our paper).

The distance decoder requires having recorded position- and spike data from two trials. In our paper, we record
an Empty trial and an Object trial and assess the decoding accuracy at different distances from the object. 

Some functions, including <calculateRateMap> and other funtions necessary to run it, are taken from 
Behavioural Neurology Toolbox, (c) Vadim Frolov 2018. 
