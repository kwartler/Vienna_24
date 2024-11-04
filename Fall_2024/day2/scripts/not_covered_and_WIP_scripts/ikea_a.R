#' Ikea product API
#' 

# libraries
library(httr)


# https://curlconverter.com/r/
headers = c(
  accept = "*/*",
  `accept-language` = "en-US,en;q=0.9",
  `content-type` = "text/plain;charset=UTF-8",
  `episod-id` = "1730345369685.r00lwd6",
  origin = "https://www.ikea.com",
  priority = "u=1, i",
  referer = "https://www.ikea.com/",
  `sec-ch-ua` = '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
  `sec-ch-ua-mobile` = "?0",
  `sec-ch-ua-platform` = '"macOS"',
  `sec-fetch-dest` = "empty",
  `sec-fetch-mode` = "cors",
  `sec-fetch-site` = "cross-site",
  `session-id` = "57c5207b-c2bd-4396-af95-8db007f07c16",
  `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
)

params = list(
  c = "sr",
  v = "20240110"
)

data = '{"searchParameters":{"input":"table","type":"QUERY"},"allowAutocorrect":true,"zip":"01754","store":"213","isUserLoggedIn":false,"optimizely":{},"components":[{"component":"PRIMARY_AREA","columns":3,"types":{"main":"PRODUCT","breakouts":["PLANNER","CATEGORY","CONTENT","MATTRESS_WARRANTY"]},"filterConfig":{"subcategories-style":"tree-navigation","max-num-filters":2},"window":{"size":24,"offset":0},"forceFilterCalculation":true},{"component":"CONTENT_AREA","types":{"main":"CONTENT","breakouts":[]},"window":{"size":12,"offset":0}},{"component":"RELATED_SEARCHES"},{"component":"QUESTIONS_AND_ANSWERS"},{"component":"STORES"},{"component":"CATEGORIES"},{"component":"SIMILAR_PRODUCTS"},{"component":"SEARCH_SUMMARY"},{"component":"PAGE_MESSAGES"},{"component":"RELATED_CATEGORIES"},{"component":"PRODUCT_GROUP"}]}'

# Increase 
# size":1000,"offset":1
# You can change the query
# "input":"table","type":"QUERY"

res <- httr::POST(url = "https://sik.search.blue.cdtapps.com/us/en/search", httr::add_headers(.headers=headers), query = params, body = data)

tmp <- content(res)

tmp$results[[4]]$items[[1]]


# End