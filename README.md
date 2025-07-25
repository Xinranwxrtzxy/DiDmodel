# DiDmodel

Welcome to my R script for running a Difference-in-Differences (DiD) analysis on 3-waves survey data, with experimental survey design! I upload the script showing the general procedure in case anyone is also struggling with analyzing treatment effect under similar survey research design:

This script focuses on a single survey question (you can also aggregate responses to multiple questions together), tracking changes across three time points: timeA, timeB, and TimeC

The setup is a bit complex:
  At timeA (baseline), all respondents took a survey.
  Then—random assignment! Half of the respondents received campaign materials and messages. The other half received nothing.
  The campaign was rolled out in two waves:
    Wave 1: Messages delivered between timeA and timeB
    Wave 2: A different set of messages delivered between timeB and timeC
  Everyone was surveyed again at both timeB and timeC.

To evaluate whether the campaign worked — and which message wave was more effective — by comparing outcomes:
  Over time (timeA vs. timeB vs. timeC)
  Between groups (treatment vs. control)
  For a key outcome question

Whether you're measuring impact or just curious how to track messaging effectiveness over time — hope this script will give you answers :)
