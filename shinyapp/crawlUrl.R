library(rvest)
library(tm)
library(tidytext)
library(SnowballC)
library(udpipe)
library(wordcloud2)
library(tibble)
library(dplyr)

# read page function
f_readpage <- function(in_url) {
  Sys.sleep(1)
  GET(in_url, timeout(1))
  page <- read_html(in_url)
  text <- rvest::html_nodes(page, '.post_text')
  
  # remove the dirty nodes, we don't need the quoted text again.
  removenode <- text %>% html_node(".quotetop")
  xml_remove(removenode)
  removenode <- text %>% html_node(".quotemain")
  xml_remove(removenode)
  # remove the dirty nodes, we don't need the edited information
  removenode <- text %>% html_node(".edit")
  xml_remove(removenode)
  # remove the dirty nodes, we don't need any url here
  removenode <- text %>% html_node("a")
  xml_remove(removenode)

  class(text)
  as_tibble(html_text(text))
}

sessionInfo()
# compile the url of pages
textstrAll <- lapply(paste0(rep('https://forum.lowyat.net/topic/4001664/+'), 
                            seq(0,100,20)),
                f_readpage)
head(textstrAll)
tail(textstrAll)
class(textstrAll)
# combine all the data frame
textstr <- do.call("rbind", textstrAll)

#model <- udpipe_download_model(language = "english")
#udmodel_english <- udpipe_load_model(file = 'english-ewt-ud-2.4-190531.udpipe')
#s <- udpipe_annotate(udmodel_english, textstr$value)
#x <- data.frame(s)
#head(x)

#ADJstats <- subset(x, upos %in% c("ADJ")) 
#head(ADJstats)
#colnames(ADJstats)

# clean up the text
tidythetext <- textstr %>% select(value) %>% unnest_tokens("word", value)

# remove stop words
data("stop_words")
tidythetext <- tidythetext %>% anti_join(stop_words)
class(tidythetext)
names(tidythetext)

# remove whitespace
tidythetext$word <- gsub("\\s+","",tidythetext$word)

# stemming 
tidythetext <- tidythetext %>%
  mutate_at("word", funs(wordStem((.), language="en")))

tidythetext <- tidythetext %>% count(word) %>% arrange(desc(n))
head(tidythetext)

# extract the verb and adjective


# show wordcloud
wordcloud2(tidythetext, size=1.6, color='random-light', backgroundColor="black")

