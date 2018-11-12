sessionInfo()


#my keys
keyTable <- read.csv("~/Downloads/accessKeysOregon.csv", header = T)
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

#activate
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "us-west-2") 



library(aws.comprehend)
# simple language detection
detect_language("This is a test sentence in English")

# how about some non-sarcastic sentiment?
detect_sentiment("I have never been happier. This is the best day ever.")

# read a large text file and check its sentiment
short_story <- readLines('short_story.txt') # read the file
length(short_story) # check how long it is
a <- detect_sentiment(short_story[1]) # get sentiment from the first line
a # it is a dataframe
a$Sentiment # overall sentiment
a$Negative # negativity score
a$Positive # positivity score

detect_sentiment(short_story[2]) # how about second paragraph?
detect_sentiment(short_story[3]) # and third?
# this is repeating. we can loop it

library(dplyr)
library(ggplot2)

sentiment_vector = c()
positive_vector = c()
negative_vector = c()
for (i in 1:length(short_story)) {   
  if (short_story[i] > "") {
    df <- detect_sentiment(short_story[i])
    sentiment_vector <- c(sentiment_vector, as.character(df$Sentiment))
    positive_vector <- c(positive_vector, df$Positive)
    negative_vector <- c(negative_vector, df$Negative)
  } 
}

# ...and plot them
data_frame(positive_vector, negative_vector, sentiment_vector) %>%
  ggplot(aes(positive_vector, negative_vector)) +
  geom_point() +
  ggtitle("positive vs negative sentiments")


#We can detect entities in a given text
txt <- c("Central European University provides education", "Gyorgy Soros is the founder.",
         "Orban Viktor is the prime minister", "Vienna is a city")
detect_entities(txt)


# translate some text 
library(aws.translate)
translate("Bonjour le monde!", from = "fr", to = "en")
translate("Guten Tag!", from = "de", to = "en")
translate("My name is Cagdas", from = 'en', to = 'de')

library(aws.s3)
# i can have a look at my bucket list on s3
bucketlist()

#Get the website content:
library(Rcrawler)
my_url <- "https://www.nytimes.com/"
my_content <- ContentScraper(my_url, astext = T, XpathPatterns = c("."))

#Make a unique s3 bucket name
my_name <- "cagdas-"
bucket_name <- paste(c(my_name, sample(c(0:9, letters), size = 10, replace = TRUE)), collapse = "")
print(bucket_name)

#Now we can create the bucket on s3
put_bucket(bucket_name)

#bucket location
get_location(bucket_name)

#Create a text file using the website content:
write.csv(my_content[[1]], "my_content.txt")

#Send the text file to AWS S3 bucket
put_object("my_content.txt", bucket = bucket_name)

#We have data on The Cloud! Check on your browser. Now let's get it back on our computer:
save_object("my_content.txt", bucket = bucket_name, file = "my_content_s3.txt")

# lets delete this object
delete_object("my_content.txt", bucket = bucket_name)

# We're finished with this bucket, so let's delete it.
delete_bucket(bucket_name) #currently the delete_bucket function does not work


# Currently I can not make Polly work in R
library("aws.polly")
library("tuneR")

# list available voices
list_voices()

vec <- synthesize("Hello world!", voice = "Joanna")
# On a mac: "https://stackoverflow.com/questions/23310005/permission-denied-when-playing-wav-file"
setWavPlayer('/usr/bin/afplay')
play(vec)
