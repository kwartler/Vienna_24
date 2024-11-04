#' Use html to markdown to llm workflow for webscraping
#' TK
#' Nov 3

# libraries
library(httr)

# Custom function
chunkText <- function(textMarkdown, chunkSize = 4000, overlap = 0) {
  # Calculate number of chunks
  numChunks <- ceiling(nchar(textMarkdown) / chunkSize)
  
  # Initialize chunks vector
  chunks <- list(numChunks)
  
  # Split text into chunks with optional overlap
  for (i in 1:numChunks) {
    st <- (i - 1) * chunkSize + 1
    en <- min(i * chunkSize + overlap, nchar(textMarkdown))
    chunks[i] <- substr(textMarkdown, st, en)
  }
  
  return(chunks)
}


# Jina doesn't really need an API key at the moment but you need it for other services so showing how
jinaAPI <- 'jina_c1c81dab252d430ab24eec12d7c94f94hPRD5LlUYAktUBZDqnfuhXRsBA9B'
headers = c(
  Authorization = paste0("Bearer ", jinaAPI),
  `X-Remove-Selector` = "header, table, #id", #optional
  `X-Target-Selector` = "body, .class", #optional
  `X-With-Images-Summary` = "true" #optional
)

# We can use the Jina service or similar through the API
schoolURL <- 'https://en.wikipedia.org/wiki/University_of_Vienna'

# Use the Service to get results in MD
jinaAI <- paste0('https://r.jina.ai/',schoolURL)

# Get the results
response <- GET(jinaAI,
                httr::add_headers(.headers=headers),
                timeout(30)) # can timeout with long webpages

# Get the status code
status_code(response) # 200 is good

# Because this is a large webpage, with lots of text, its a good idea to examine it in chunks, or use string manipulation to hone in on what is needed
chunkedResponse <- chunkText(webpageResults)

# Organize Request for each chunk- more can be done to improve the extraction
llmList <- list()
#for(i in 1:length(chunkedResponse)){
for(i in 1:2){
  dataLLM <- list(model = "meta-llama-3.1-8b-instruct",
                  messages = list(
                    list(role = "system", content = "You are a helpful, smart, kind, and efficient AI assistant. You always fulfill the user's requests to the best of your ability.  Please examine this text and note if it mentions a riot.  If there is a riot mentioned please state TRUE and if not FALSE.  The text is here:/n"),
                    list(role = "user", content = unlist(chunkedResponse[[i]]))),
                  temperature = 0.7,
                  max_tokens = 512,
                  stream = FALSE)
  # Request header
  headers <- c(`Content-Type` = "application/json")
  
  # Make the POST request
  print(paste('checking on chunk',i, 'of',length(chunkedResponse)))
  res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                    httr::add_headers(.headers = headers),
                    body = toJSON(dataLLM, auto_unbox = TRUE))
  
  # Extract the response
  llmResponse <- httr::content(res)$choices[[1]]$message$content
  llmList[[i]] <- llmResponse
}

# Review the respinses, some clean up is probably needed.
sapply(unlist(llmList),cat)

# End