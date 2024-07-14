#' Title: Intro: Use an LLM for named entity extraction
#' Purpose: Search a specific section of a document, then NER
#' Author: Ted Kwartler
#' Date: June 6, 2024
#' Source: US State Dept description of torture (1 of 14k online)

# Libraries
library(httr)
library(jsonlite)

# Model Type & request type MUST SWITCH MODELS
llmModel <- 'lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF'

headers <- c(`Content-Type` = "application/json")

# Read the doc
oneDoc <- readLines('~/Desktop/GSERM_2024/lessons/Day5_LLMs_explained/data/ZAF_1985_State_Department.txt')

# Let's find relevant section to focus the LLM; section headers
st <- grep('c. Torture and Cruel', oneDoc)
en <- grep('d. Arbitrary Arrest, Detention, or Exile', oneDoc)


# Index to the doc chunk
oneChunk <- paste(oneDoc[st:en], collapse = ' ')

# Organize Request
dataLLM <- list(model = llmModel,
                messages = list(
                  list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant helping a professor to extract information from State Department data. You always fulfill the user's requests to the best of your ability.  As a professor doing research I need have document chunks regarding alleged torture.  I would like to extract who the perpetrator of the torture is, a description of the torture, and who it was perpetrated upon.  For example after reviewing a document, you would respond in markdown:\n
                       \n```\n
                       # Perp: Police\n
                       # Type: Excessive Force\n
                       # Victim: Female.\n
                       # Summary: The police were detaining a political prisioner.\n
                       \n```\n
                       Here is the new document chunk, please extract the offending party, actions taken and describe the victim:\n"),
                  list(role = "user", content = oneChunk)),
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

# End