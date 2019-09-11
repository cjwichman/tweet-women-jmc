# simple script to post JMC info on twitter

library('readxl')
library('twitteR')
rm(list=ls())



dir <- "~/Documents/tweetwomenjmc"
setwd(dir)




######################################################################################################
# Set twitter API credentials
# Follow steps 1-4 here: https://www.r-bloggers.com/send-tweets-from-r-a-very-short-walkthrough/
######################################################################################################


# !!!! DO NOT SHARE THESE CREDENTIALS !!!! #
# !!!! DO NOT SHARE THESE CREDENTIALS !!!! #
setup_twitter_oauth(consumer_key    = "",
                    consumer_secret = "",
                    access_token    = "",
                    access_secret   = "")
# !!!! DO NOT SHARE THESE CREDENTIALS !!!! #
# !!!! DO NOT SHARE THESE CREDENTIALS !!!! #



######################################################################################################
# Generate tweet data
######################################################################################################
candidates <- read_excel(paste0(dir,"/data/candidate_list.xlsx"))
candidates$name.lc <- tolower(gsub(" ", "", candidates$name, fixed = TRUE))  # remove spaces, change to lowercase




# generate text of tweet and URL for abstract image
candidates$tweet.text <- paste0(candidates$name, ", ", candidates$university, ". JMP: ", candidates$jmptitle, ".", " Web: ", candidates$website)
candidates$abstract <-  paste0(dir, "/abstractimages/", candidates$name.lc, ".png")



# tweet JMC info!
delay = 5 # in seconds
for (i in 1:length(candidates)) {
  tweet.jmc <- updateStatus(candidates$tweet.text[i], 
                            mediaPath = candidates$abstract[i], 
                            placeID = NULL, lat = NULL, long = NULL, bypassCharLimit = FALSE)
  Sys.sleep(delay)
}



# deletes most recent tweet
# deleteStatus(tweet.jmc)
