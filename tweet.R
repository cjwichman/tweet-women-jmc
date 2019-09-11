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
candidates$jmptitle.trim <- strtrim(candidates$jmptitle, 80) # limit length of title to 80 characters 



# quality control notes
# is JMC already posted to twitter? no=0, yes=1
# generic quality control flag? good=0, bad=1
## only post if flag == 0

candidates$flag <- candidates$posted + candidates$qflag




# generate text of tweet and filepath for abstract images
candidates$tweet.text <- paste0(candidates$name, 
                                ", ", 
                                candidates$university, 
                                ", ", 
                                candidates$department,
                                "\r\n \r\n", 
                                "JMP: ", 
                                candidates$jmptitle.trim,
                                "\r\n \r\n", 
                                "Web: ", 
                                candidates$website)
candidates$abstract <-  paste0(dir, "/abstractimages/", candidates$name.lc, ".png")





######################################################################################################
# Post thread to twitter
######################################################################################################

# initiate tweet for thread
female.jmc.thread <- updateStatus(text = "Testing thread for JMCs #hashtag \r\n [your text here]")  


# tweet JMC info!
delay = 1 # in seconds
for (i in 1:nrow(candidates)) {
  
  # set reply-to tweet to generate thread
  if ( i==1 ) { replytotweet <- female.jmc.thread$id } 
  else { replytotweet <- tweet.jmc$id }
  
  # should i post this tweet?
  if ( candidates$flag[i] == 0 ) { # only tweet jmc if posted=0 and qflag==0 
    
    # post individual jmc tweets
    tweet.jmc <- updateStatus(candidates$tweet.text[i], 
                              mediaPath = candidates$abstract[i], 
                              inReplyTo = replytotweet,
                              placeID = NULL, lat = NULL, long = NULL, bypassCharLimit = TRUE)
    Sys.sleep(delay)
    
  } ## closes quality control loop
} ## closes tweet loop




# deletes most recent tweet
# deleteStatus(tweet.jmc)
