library(httr)

cookies = c(
  `gl-feat-enable` = "CHECKOUT_PAGES_ENABLED",
  geo_ip = "2001:4860:7:70e::1",
  geo_country = "US",
  AKA_A2 = "A",
  akacd_generic_prod_grayling_adidas = "3907794522~rv=92~id=7fddb2d976dd34a5ff9e1b92b9f1b4dd",
  geo_coordinates = "lat=42.4225, long=-71.4615",
  akacd_plp_prod_adidas_grayling = "3907794523~rv=42~id=0b484a2e60c5722fb9e615caee49e7bd",
  `x-original-host` = "adidas.co.uk",
  `x-site-locale` = "en_GB",
  mt.v = "3.137756904.1730341725855",
  channelcloser = "nonpaid",
  `x-browser-id` = "3beb49d1-4256-401b-8e3c-af65a59b71fc",
  `x-session-id` = "4c51b680-e71f-40e5-bf58-1587e9b245f9",
  `AMCVS_7ADA401053CCF9130A490D4C%40AdobeOrg` = "1",
  `AMCV_7ADA401053CCF9130A490D4C%40AdobeOrg` = "-227196251|MCIDTS|20028|MCMID|38739252772631601791379024170263154780|MCAAMLH-1730946527|7|MCAAMB-1730946527|RKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y|MCOPTOUT-1730348927s|NONE|MCAID|NONE",
  wishlist = "[]",
  notice_preferences = "[0,1,2]",
  paidMediaIntent = "true",
  ab_qm = "b",
  s_cc = "true",
  mt.sc = '{"i":1730341728005,"d":[]}',
  mt.v = "3.137756904.1730341725855",
  `_scid` = "P6NABMMG39rs4rlO9ZMd4Eq4DI6wq4Fg",
  `_fbp` = "fb.2.1730341728084.552833842579295166",
  `_gcl_au` = "1.1.503605663.1730341728",
  `_ga` = "GA1.1.401992662.1730341728",
  `_pin_unauth` = "dWlkPU56ZGxZbUl6Wm1JdE9UQmpNQzAwWWpRMExUazFORFF0TVRNeVpEaGhPRE16T0dVNA",
  `_ScCbts` = '["626;chrome.2:2:5"]',
  QSI_HistorySession = "https://www.adidas.co.uk/~1730341728609",
  `x-commerce-next-id` = "be566beb-8b7b-445e-81cf-1201f0356b0b",
  bm_ss = "ab8e18ef4e",
  QSI_SI_0evq2NrkQkQaBb7_intercept = "true",
  QuantumMetricSessionID = "783bc79981fcbc08ef6d5224b9fc381c",
  QuantumMetricUserID = "7a52b7f642eec3b8b64b35ea6737d615",
  bm_so = "A69085594C98D11DE2BF96880CC9F16C545A00D3D423040D2AF5E96D59FBBB98~YAAQJXEmF1cF0bGSAQAAy8ln4AEjBkhUl8/HUBxv9 Wtf0vX8LZC  EAav8sxVBTZDpmkK7XXarsZXLQBw6tYvxGbEbHGfps79DYm1p6fJcWLjJLLvTgmBjYMpxS6xHzW6SK3PBwOqXLvexYnCiuSPImwqnp87FFdpjV2hViFhk1GJjI10qCjcXM0YLCFESm6IrCvJsAJP3jgsZurpfk6U/x9tvTojWdVvC2V69bNp0uXShK/KOe24nKGARzIW5FZ/EJv2uKd03733YAfI8aMtV6hP9mmdbbsQn4l4t/n 7hNiSpMBWi9f7tot9M5UcuwA6rc8tM9T7pKbkk6LiTxbN06WODtsln87W8tVazt1JDZ8xWZsnpqPsGBuLTBbUz8S5fj5e7VeSCIiFntXdk7/ww8U0t8zzKwQ/J u0q49valr5hdIP70ebwUNAU8F9OE75LSaZTdvPdj3X5QMnOew==",
  bm_sz = "C23098646F827ABECD5E42F482F5BD0D~YAAQJXEmF1gF0bGSAQAAy8ln4BlcvXqN5pfBx7oCfAjfXk1rTwHIjD4owYG2JthwZWgwxAW9Hw1bJBdRTpANwT98zsMQoaYkiFUwns/ml8fwtXLJCGjGZyqbjoZa5ltB iibkFmimPJQZ40adtcs9j9Cg3cU6FO6BMBHkQt3X6bivRM4X1EE2C4wpac8A4Av1c748EIUoxMq1CFV0bFr6GdE9T0RkJ06wm2D7I3UcHBCU/EhSocmGD2n cSCzYuZhTHfBWsDx9x4/VAk46A1I32eUjaUJl3Y60jgERKiCFR0syUIgTV0goB0JgeuaG5e8CrWNSVfktIYIPUprWP1Ypwu5J0vQDEoNYA5YegRFzli9fXPcxMWDWfx9QIb4u8txwA7Anrup3vRiuKEDxVaT1Y2uxDfw9AW66l06sJd4ep1TxbZjg==~4272961~4404024",
  ak_bmsc = "F061A63397DDF3C08362073486A7D9B8~000000000000000000000000000000~YAAQJXEmF5gF0bGSAQAAas5n4Bni6o/OgVyUCbz5Eq04OqdFyNUiWGgEncs2JKa38KDaBdUdRGYxt9LELYC8dShaUdjRMHKW w In0QX8DlW8QhfR//JfrMKos1bl9 ov AZ8rnfiSCeXK2RmYtGA9TIAVz8v8byXn6J6B/FmFs7Jc21tZfWS7fsOrjyT8k6Neb6a6ZPmZ02zWgtwXSsWKiUTCdhdHuaKdBHSfXJ66eZRjvV8YWfaJRBsxRQWwzQYAMeseuL2nLNB3JKaM7cHFBY5orC902Eobu2oEwxpnpWkwZUjGVwF65DP5Iy/nwjgWxz3YrkA55V7N3Ybq0D7U 0OfxeDGtxtBSiAnFi26Cto8irg7eWLUJcIveBiKMy3t tGE/6crknKU D",
  bm_s = "YAAQJXEmF7QF0bGSAQAAJdBn4ALQ7W4Jhg0eludOL5RSNU24QyRYZMaSNvcfXwYIK//e47IKgZCRsZIwgdQfKjMPIW7iMmyF6Ix//2LMlXFYQU3Oq13OsUArZvQFuqL4/MgUOpHuATEEXQaDEoOL4htERMiIWxQrrNvlTvFrK8i3/9kSsnM4M6kT/At4iuAtLST 2hjEQ0F2sYFE9nHFDLRPKEjVq4NsAM7y1b6g5kxxV3c7KIRBSOT1TPw/6rXHBoIBvYN7FRrnM9CJlH2mefYRNL6oO/i8LGDGHa8w1K/ffagt5X3AeKyxhLJVK OjS892WviKz5AGCW0eFeDpZ8alkWKHyg==",
  `_abck` = "7F3A8E3C7F7C7390FBAA35DDA062FC62~-1~YAAQJXEmF8MF0bGSAQAAYNJn4AzTTAo3o32/U0ZVKyG0GQm5ELzcfjwueONGAVHQhpEfTc un6leRmQ9FxQBX9NsqQnMxUNDDLIFi3Lx/aJDFQSj oVjMR9uIm2No8hRpxnhjRz53fBE/HRGNUsSS58G2NR9p4pkvzVGQYfDPb3ieJfFcjfSLAd7f91jArsNDs6Dq4zTO2lNvMNfojbp/bYIuFA/JVIsW7WrctahEFugl8sTOn7r6lSWcsf xc/1eDm9YCjfRC2gzf4d5gHCPiwHtgpxtS L JKqp eOXvz AUSgKixVkFPm3HhEQ5kz7NC9tS72bFMhGTCQ4XEyCM0 NXCP3tIj0Hgekzjbxo/Z2WZcII262AxhkPmIxRnIT48B50m3L3UOoJpNk82SS3Vxocd Xn8TSwaDjO7IEvm5bvtjbc2R7Q6WMcyKGZmgbae5oU9WgVmfUOkJJchap259k35RBUXtZQD26jGg5Td/DJvg6ugkVti4eeSHu6KZxXX0WVREn9a1XQ33ptyLc8xxdgFnfZ32Fd5rgZ MNlJD/w==~-1~-1~1730345325",
  s_pers = " s_vnum=1730433600893%26vn%3D1|1730433600893; s_invisit=true|1730343554383;",
  `_rdt_uuid` = "1730341728001.ddef1731-7073-4b14-a1fc-ab0ad9afd954",
  utag_main = "v_id:0192e06767c700636bd869a5f19c05075001906d00942$_sn:1$_se:9;exp-session$_ss:0;exp-session$_st:1730343554374;exp-session$ses_id:1730341726152;exp-session$_pn:2;exp-session$_vpn:3;exp-session$_prevpage:HOME;exp-1730345354377$ttdsyncran:1;exp-session$dcsyncran:1;exp-session$dc_visit:1$dc_event:3;exp-session$ttd_uuid:d969db7a-6747-452a-b7ad-e172bd34d409;exp-session$cms_514:1;exp-session",
  `_scid_r` = "SCNABMMG39rs4rlO9ZMd4Eq4DI6wq4FgsIsqLw",
  `_ga_4DGGV4HV95` = "GS1.1.1730341728.1.1.1730341754.34.0.0",
  `_uetsid` = "dc0b55e0972f11ef92972f35dd14c4be|ihcr95|2|fqh|0|1765",
  `_uetvid` = "dc0bb040972f11ef9b0e37617c056f5e|1gxrilt|1730341754956|2|1|bat.bing.com/p/insights/c/i",
  RT = '"z=1&dm=www.adidas.co.uk&si=c93867a2-2497-4a6f-89d0-2c067707b16a&ss=m2wosbke&sl=7&tt=8ix&bcn=//173bf106.akstat.io/&ld=ryc"'
)

headers = c(
  accept = "*/*",
  `accept-language` = "en-US,en;q=0.9",
  `content-type` = "application/json",
  priority = "u=1, i",
  `sec-ch-ua` = '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
  `sec-ch-ua-mobile` = "?0",
  `sec-ch-ua-platform` = '"macOS"',
  `sec-fetch-dest` = "empty",
  `sec-fetch-mode` = "cors",
  `sec-fetch-site` = "same-origin",
  `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
  `x-instana-l` = "1,correlationType=web;correlationId=3af436b1fa9c96d5",
  `x-instana-s` = "3af436b1fa9c96d5",
  `x-instana-t` = "3af436b1fa9c96d5"
)

res <- httr::GET(url = "http://www.adidas.co.uk/api/search/tf/suggestions/boots", httr::add_headers(.headers=headers), httr::set_cookies(.cookies = cookies))

library(jsonlite)
tmp <- fromJSON('https://www.adidas.co.uk/api/search/tf/suggestions/cleats')
