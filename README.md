# Kurochroe
a personal-use interactive secretary, work as twitter bot.

## Preparation
To use this code, you required to make ./auth directory and put google/twitter credentials and some secret keys into there.

## Feature
+ Search a book information from ISBN-10/13 and make a list of searched books
+ Simple Tarot Reading (One Card Spread)
+ Manage tasks using GoogleTasks
+ Roll the dice (like: 2d6+4)

## How It Works
Kurochroe simply read the timeline of linked account using UserStream. 
And she is monitoring tweets from pre-configured specific user which she called "master".

./store/respond.csv is a Responce List.
Once Kurochroe find the master's tweet, she tries to Regexp it using the first column of the RL.
When match found, Kurochroe collect the information from master's tweet and do some (corresponding) tasks and make a reply using Twitter REST API.

## Conclusion
This is an experimental rubbish heap.
これは実験的なごみの山です．