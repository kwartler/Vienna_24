#' Title: Intro: LLM Based Sentiment & NER
#' Purpose: Feature Extraction & Sentiment using a local LLM
#' Author: Ted Kwartler
#' Date: May 12, 2024
#' Source: Clinton Emails

# Libraries
library(httr)
library(jsonlite)
library(pbapply)

# Get the emails from github
githubURL <- 'https://api.github.com/repos/kwartler/teaching-datasets/contents/clinton'
response <- httr::GET(githubURL)
contents <- httr::content(response, as = "text")
tmp      <- fromJSON(contents)
allEmails <- pblapply(tmp$download_url, readLines)
allEmails <- lapply(allEmails, paste, collapse =' ')

# See an example
allEmails[[1]]

# Get an example just for class, in reality you would do all the docs
idx <- sample(1:length(allEmails), 1)
oneDoc <- allEmails[[idx]]

# Model & request type
llmModel <- 'lmstudio-ai/gemma-2b-it-GGUF'
headers <- c(`Content-Type` = "application/json")

# Organize Request
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant performing sentiment analysis. You always fulfill the user's requests to the best of your ability.  For example you are presented some text and will resond like this:
                       ```polarity:positive\nemotion:joy\n```"),
                  list(role = "user", content = oneDoc)),
                temperature = 0.7,
                max_tokens = 512,
                stream = FALSE)

# Make the POST request
res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                  httr::add_headers(.headers = headers),
                  body = toJSON(dataLLM, auto_unbox = TRUE))

# Extract the response
llmResponse <- httr::content(res)$choices[[1]]$message$content
cat(llmResponse)

## Keep in mind we could remove lots of the standard text to possibly improve results. For Example
## "UNCLASSIFIED U.S. Department of State Case No. F-2014-20439 Doc No. C05795271 Date: 02/13/2016..."


# End
