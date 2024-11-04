library(httr)
#https://github.com/search?q=repo%3Avrslev%2Fikea-api-client%20stock&type=code
headers = c(
  `sec-ch-ua-platform` = '"macOS"',
  Referer = "https://www.ikea.com/",
  `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
  Accept = "application/json;version=2",
  `sec-ch-ua` = '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
  `X-Client-ID` = "b6c117e5-ae61-4ef5-b4cc-e0b1e37f0631",
  `sec-ch-ua-mobile` = "?0"
)

res <- httr::GET(url = "https://api.ingka.ikea.com/cia/availabilities/ru/us?itemNos=29420393&expand=StoresList,Restocks,SalesLocations,DisplayLocations,ChildItems,", httr::add_headers(.headers=headers))
res <- httr::GET(url = "https://api.ingka.ikea.com/cia/availabilities/ru/us?itemNos=29420393,", httr::add_headers(.headers=headers))
stock <- content(res)
stock$availabilities[[1]]
stock$availabilities[[2]]
stock$salesLocations[[1]]
stock$availabilities[[1]]$buyingOption$cashCarry
