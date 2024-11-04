#' API curl to R example
#' Youtube API Timed Text save as curl request
#' Paste into https://curlconverter.com/r/
#' Nov 1, 2024
#' Note cookie info is removed for github repo, you have to paste your own info from curlconverter

# Libraries
library(httr)

# Browser information
cookies = c(
  LOGIN_INFO = "XXXX",
  VISITOR_INFO1_LIVE = "XXXX",
  VISITOR_PRIVACY_METADATA = "XXXX",
  YT_CL = "XXXX",
  SID = "XXXX",
  `__Secure-1PSID` = "XXXX",
  `__Secure-3PSID` = "XXXX",
  HSID = "XXXX",
  SSID = "XXXX",
  APISID = "XXXX",
  SAPISID = "XXXX",
  `__Secure-1PAPISID` = "XXXX",
  `__Secure-3PAPISID` = "XXXX",
  YSC = "XXXX",
  PREF = "XXXX",
  `__Secure-1PSIDTS` = "XXXX",
  `__Secure-3PSIDTS` = "XXXX",
  CONSISTENCY = "XXXX",
  SIDCC = "XXXX",
  `__Secure-1PSIDCC` = "XXXX",
  `__Secure-3PSIDCC` = "XXXX"
)

# Request header inputs
headers = c(
  accept = "*/*",
  `accept-language` = "en-US,en;q=0.9",
  priority = "u=1, i",
  referer = "XXXX",
  `sec-ch-ua` = "XXXX",
  `sec-ch-ua-arch` = "XXXX",
  `sec-ch-ua-bitness` = "XXXX",
  `sec-ch-ua-form-factors` = "XXXX",
  `sec-ch-ua-full-version` = "XXXX",
  `sec-ch-ua-full-version-list` = "XXXX",
  `sec-ch-ua-mobile` = "XXXX",
  `sec-ch-ua-model` = "XXXX",
  `sec-ch-ua-platform` = "XXXX",
  `sec-ch-ua-platform-version` = "XXXX",
  `sec-ch-ua-wow64` = "XXXX",
  `sec-fetch-dest` = "empty",
  `sec-fetch-mode` = "cors",
  `sec-fetch-site` = "same-origin",
  `user-agent` = "XXXX",
  `x-client-data` = "XXXX",
  `x-goog-authuser` = "XXXX",
  `x-goog-visitor-id` = "XXXX",
  `x-youtube-ad-signals` = "XXXX",
  `x-youtube-client-name` = "XXXX",
  `x-youtube-client-version` = "XXXX",
  `x-youtube-device` = "XXXX",
  `x-youtube-identity-token` = "XXXX",
  `x-youtube-page-cl` = "XXXX",
  `x-youtube-page-label` = "XXXX",
  `x-youtube-time-zone` = "XXXX",
  `x-youtube-utc-offset` = "XXXX"
)

# Request parameters
params = list(
  v = "XXXX",
  ei = "XXXX",
  caps = "XXXX",
  opi = "XXXX",
  exp = "XXXX",
  xoaf = "XXXX",
  hl = "en",
  ip = "XXXX",
  ipbits = "XXXX",
  expire = "XXXX",
  sparams = "XXXX",
  signature = "XXXX",
  key = "XXXX",
  kind = "XXXX",
  lang = "en",
  fmt = "XXXX",
  xorb = "XXXX",
  xobt = "XXXX",
  xovt = "XXXX",
  cbrand = "XXXX",
  cbr = "XXXX",
  cbrver = "XXXX",
  c = "XXXX",
  cver = "XXXX",
  cplayer = "XXXX",
  cos = "XXXX",
  cosver = "XXXX",
  cplatform = "XXXX"
)

# Make the request to the API
res <- httr::GET(url = "https://www.youtube.com/api/timedtext", httr::add_headers(.headers=headers), query = params, httr::set_cookies(.cookies = cookies))

# Parse it into an R object
apiResponse <- content(res)


# End