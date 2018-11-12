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

txt <- c("Central European University provides education", "Gyorgy Soros is the founder.",
         "Orban Viktor is the prime minister", "Vienna is a city")
detect_entities(txt)



library(aws.translate)
# translate some text from English
translate("Bonjour le monde!", from = "fr", to = "en")
translate("Guten Tag!", from = "de", to = "en")
translate("My name is Cagdas", from = 'en', to = 'de')

library(aws.s3)
# my bucket list on s3
bucketlist()

#Get the website content:
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
