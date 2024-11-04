#' Use a HTML-API to MD workflow to extract page information using an JSON
#' TK
#' Nov 1

# libraries
library(httr)

# At this point you don't need an API key but you need it for other services
jinaAPI <- 'jina_c1c81dab252d430ab24eec12d7c94f94hPRD5LlUYAktUBZDqnfuhXRsBA9B'

# Make it part of the GET request
#headers <- c(  Authorization = "Bearer jina_c1c81dab252d430ab24eec12d7c94f94hPRD5LlUYAktUBZDqnfuhXRsBA9B")
headers <- c(Authorization = paste0("Bearer ", jinaAPI))

# Url to get search results
searchTerm <- 'soccer cleats'
searchURL <- paste0('https://www.adidas.co.uk/api/plp/content-engine/search?query=',
                    URLencode(searchTerm))

# Use the Service to get results in MD
jinaAI <- paste0('https://r.jina.ai/',searchURL)

# Get the results
response <- GET(jinaAI,
                httr::add_headers(.headers=headers),
                timeout(30)) # can timeout with long webpages

# Get the status code
status_code(response) # 200 is good

# Get the response information
searchResults <- content(response)

# Since this is an API there is JSON returned so one could parse the JSON with jsonlite
# Other website to markdowns urls wouldn't need to do this
json_content <- sub(".*Markdown Content:\n(\\{.*\\})", "\\1", searchResults)
json_content <- gsub("\\\\(\\[|\\])", "\\1", json_content)
json_content <- gsub("\\\\_", "_", json_content) 
parsed_data  <- fromJSON(json_content, flatten = T)

# The item list is within the JSON response:
parsed_data$raw$itemList$items$productId

# Now let's construct another set of URLS - product information
productInfo <- paste0('https://r.jina.ai/',
                      'https://www.adidas.co.uk/api/products/',
                      parsed_data$raw$itemList$items$productId)

# Use the Jina service and construct a list
responseProdInfo <- GET(productInfo[1],
                        httr::add_headers(.headers=headers),
                        timeout(30))

# Parse the response
jsonContentProdInfo <- sub(".*Markdown Content:\n(\\{.*\\})", 
                           "\\1", 
                           responseProdInfo)
jsonContentProdInfo <- gsub("\\\\(\\[|\\])", "\\1", jsonContentProdInfo)
jsonContentProdInfo <- gsub("\\\\_", "_", jsonContentProdInfo) 
parsedData  <- fromJSON(jsonContentProdInfo, flatten = T)

# organize into a data frame
df <- data.frame(
  id                 = parsedData$id,
  price              = parsedData$pricing_information$currentPrice,
  title              = parsedData$product_description$title,
  subTitle           = parsedData$product_description$subtitle,
  productDescription = parsedData$product_description$text)

# Now we will want to append the time we grabbed the data and the current inventory
# https://www.adidas.co.uk/api/products/B75806/availability
inventoryAPI <- paste0('https://r.jina.ai/',
                       'https://www.adidas.co.uk/api/products/',
                       df$id,
                       '/availability')

# Fetch the data
responseProdInventory <- GET(inventoryAPI,
                             httr::add_headers(.headers=headers),
                             timeout(30))

# Extract the content
responseProdInventory <- content(responseProdInventory)

# Again some clean up
jsonContentProdInv <- sub(".*Markdown Content:\n(\\{.*\\})", 
                           "\\1", 
                           responseProdInventory)
jsonContentProdInv <- gsub("\\\\(\\[|\\])", "\\1", jsonContentProdInv)
jsonContentProdInv <- gsub("\\\\_", "_", jsonContentProdInv) 
parsedData  <- fromJSON(jsonContentProdInv, flatten = T)
parsedData$variation_list

# We could ignore shoe size and just sum available inventory 
# but its better to organize into a list object
oneProductInfo <- list(id               = df$id,
                       productText      = df,
                       productInventory = parsedData$variation_list,
                       scrapeTime       = Sys.time())

# End

# Construct JSON payload; we're using lm-studio but could be a 3rd part too
data <- jsonlite::toJSON(
  list(
    model = "meta-llama-3.1-8b-instruct",
    messages = list(
      list(role = "system", content = "Please extract all modelId values"),
      list(role = "user", content = searchResults)  # Insert searchResults
    ),
    temperature = 0.7,
    max_tokens = -1,
    stream = TRUE
  ),
  auto_unbox = TRUE,
  pretty = FALSE
)

# Define headers
headersLMstudio <- c(
  `Content-Type` = "application/json"
)

# Send POST request
lmResponse <- httr::POST(
  url = "http://127.0.0.1:1234/v1/chat/completions",
  httr::add_headers(.headers = headersLMstudio),
  body = data,
  httr::content_type_json())

# End

# https://www.adidas.co.uk/samba-og-shoes/B75806.html
# Developer console, network, fetch, "availability", "B75807", Headers GET request:



# https://www.adidas.co.uk/api/products/B75807
# https://www.adidas.co.uk/api/products/B75806/availability
# https://www.adidas.co.uk/api/plp/content-engine/search?query=boots
# https://www.adidas.co.uk/search?q=soccer+cleats
# https://www.adidas.co.uk/api/search/tf/suggestions/cleats
tmp <- httr::GET('https://r.jina.ai/https://www.adidas.co.uk/api/products/B75806/availability')
