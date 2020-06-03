library(rvest)
library(tidytext)
library(SnowballC)
library(wordcloud2)
library(dplyr)
library(httr)
library(memoise)

# read page function
f_readpage <- memoise(function(in_url) {
  Sys.sleep(1)
  print(in_url)
  httr::GET(in_url, httr::timeout(1))
  page <- xml2::read_html(in_url)
  text <- rvest::html_nodes(page, '.post_text')
  
  g_topic_title <- rvest::html_node(page, "title")
  g_topic_title
  
  # remove the dirty nodes, we don't need the quoted text again.
  removenode <- text %>% rvest::html_node(".quotetop")
  xml2::xml_remove(removenode)
  removenode <- text %>% rvest::html_node(".quotemain")
  xml2::xml_remove(removenode)
  # remove the dirty nodes, we don't need the edited information
  removenode <- text %>% rvest::html_node(".edit")
  xml2::xml_remove(removenode)
  # remove the dirty nodes, we don't need any url here
  removenode <- text %>% rvest::html_node("a")
  xml2::xml_remove(removenode)

  dplyr::as_tibble(rvest::html_text(text))
})


f_readTitle <- memoise(function(in_url) {
  Sys.sleep(1)
  httr::GET(in_url, httr::timeout(1))
  page <- xml2::read_html(in_url)
  rvest::html_text(rvest::html_node(page, "title"))
})

# clean text function
f_cleanText <- function(textstrAll) {
  
  # combine all the data frame
  textstr <- do.call("rbind", textstrAll)
  
  # clean up the text
  tidythetext <- textstr %>% dplyr::select(value) %>% tidytext::unnest_tokens("word", value)
  
  # remove stop words
  data("stop_words")
  tidythetext <- tidythetext %>% dplyr::anti_join(stop_words)
  
  # remove whitespace
  tidythetext$word <- gsub("\\s+","",tidythetext$word)
  
  # stemming 
  tidythetext <- tidythetext %>%
  dplyr::mutate_at("word", funs(SnowballC::wordStem((.), language="en")))

  tidythetext %>% dplyr::count(word) %>% dplyr::arrange(dplyr::desc(n))
}

