library(rvest)
library(tm)
library(tidytext)
library(SnowballC)
library(wordcloud2)

html <- 'Casa_Idaman_.html'

page <- read_html(html)
text <- html_nodes(page, '.printpost')

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
textstr <- as_tibble(html_text(text))
class(textstr)
names(textstr)
typeof(textstr)
head(textstr, 3)

# clean up the text
textcorpus <- Corpus(VectorSource(as.vector(textstr))) 
str(textcorpus)

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

tidythetext <- tidythetext %>% count("word") %>% arrange(desc(freq))
head(tidythetext)

# show wordcloud
wordcloud2(tidythetext, size=1.5, color='random-light', backgroundColor="black")
