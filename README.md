# getting-and-cleaning-data
assignment for getting and cleaning data

The test and training datasets are firstly appended to each other using rbind
The column names are generated from the features file.
Only those features containing "mean" or "std" are retained. This is not done using plyr or dplyr but rather using a matrix operation.
The activity and subject (participant) files are appended to the dataset using cbind.
The data is then merged with the activity_labels.txt file so that the textual activity labels are included in the dataset (the activity code is then removed).

The feature columns (79 of) are then melted into a variable column with it's corresponding value.
The average value of each feature is then calculated, grouped by activity and subject.

