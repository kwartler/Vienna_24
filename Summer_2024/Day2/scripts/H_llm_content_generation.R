#' Title: Intro: LLM Content Generation
#' Purpose: Content Generation using a local LLM
#' Author: Ted Kwartler
#' Date: May 12, 2024

# Libraries
library(httr)
library(jsonlite)

# Inputs
# Write a movie review as a 5yr old
promptA <- 'Write a movie review as a 5 year old for Star Wars'

# Write a movie review as an old person
promptB <- 'Write a moview review as a 95 year old, senior citizen for Star Wars'

# Write a movie review as a pirate
promptC <- 'Write a movie review of star wars as a pirtate.'

# Write a movie review as Taylor Swift
promptD <- 'Write a movie review of Star Wars as Taylor Swift.'

# Specify the model & request type
llmModel <- 'lmstudio-ai/gemma-2b-it-GGUF'
headers <- c(`Content-Type` = "application/json")

# Organize Request A
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant. You always fulfill the user's requests to the best of your ability."),
                  list(role = "user", content = promptA)),
                temperature = 0.7,
                max_tokens = 512,
                stream = FALSE)

# Make the POST request
res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                  httr::add_headers(.headers = headers),
                  body = toJSON(dataLLM, auto_unbox = TRUE))

# Extract the response
llmResponseA <- httr::content(res)$choices[[1]]$message$content
cat(llmResponseA)

# Organize Request B
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant. You always fulfill the user's requests to the best of your ability."),
                  list(role = "user", content = promptB)),
                temperature = 0.7,
                max_tokens = 512,
                stream = FALSE)

# Make the POST request
res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                  httr::add_headers(.headers = headers),
                  body = toJSON(dataLLM, auto_unbox = TRUE))

# Extract the response
llmResponseB <- httr::content(res)$choices[[1]]$message$content
cat(llmResponseB)

# Organize Request C
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant. You always fulfill the user's requests to the best of your ability."),
                  list(role = "user", content = promptC)),
                temperature = 0.7,
                max_tokens = 512,
                stream = FALSE)

# Make the POST request
res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                  httr::add_headers(.headers = headers),
                  body = toJSON(dataLLM, auto_unbox = TRUE))

# Extract the response
llmResponseC <- httr::content(res)$choices[[1]]$message$content
cat(llmResponseC)

# Organize Request D
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant. You always fulfill the user's requests to the best of your ability."),
                  list(role = "user", content = promptD)),
                temperature = 0.7,
                max_tokens = 512,
                stream = FALSE)

# Make the POST request
res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                  httr::add_headers(.headers = headers),
                  body = toJSON(dataLLM, auto_unbox = TRUE))

# Extract the response
llmResponseD <- httr::content(res)$choices[[1]]$message$content
cat(llmResponseD)

# End