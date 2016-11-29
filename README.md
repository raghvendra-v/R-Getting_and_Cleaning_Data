# **Getting and Cleaning Data - Assignment**

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
Data for this assignment can be found [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "coursera")


**run_analysis.R :**
This script **downloads** the Samsung dataset from the url to a temp directory and makes a summarized tidy dataset.
Instead of saving the file in the working directory, I have preferred online download method. Because it leaves out the dependency on directory hierarchy after extraction.
Requires package dplyr **0.5.0+** for summarize_all group of functions.
The tidy data_set formed after summarization is stored in a text file "tidy_data_set.txt"


