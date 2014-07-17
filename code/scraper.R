# Script to scrape the data from the New York Times page: 'The Toll in Gaza and Israel, Day by Day'
# containing the death toll from Gaza and Israel.
#
# by Luis Capelo | @luiscape

library(XML)
library(RCurl)

# here the two cURL options allow the request to 'follow' a redirect
# and to not provide a cookie location -- so the NYT doesn't 
# show a pay-wall
url_data <- getURL('http://www.nytimes.com/interactive/2014/07/15/world/middleeast/toll-israel-gaza-conflict.html?_r=0', .opts=curlOptions(followlocation=TRUE, cookiefile="nosuchfile"))

# extracting the data
getData <- function() {
    doc <- htmlParse(url_data)
    serie <- xpathSApply(doc, "//li[@class='g-count-gaza']")
    t <- getNodeSet(serie[[1]],"///h3/span")
    x <- data.frame(value = sapply(t,xmlValue))
    x$variable <- c('targets struck by Israel',
                    'deaths in Gaza',
                    'rockets launched from Gaza',
                    'deaths in Israel')
    x <- x[5:nrow(x), ]  # first 4 == total
    for (i in 1:(nrow(x)/4)) {
        if (i == 1) {
            x$date <- NA
            r <- i + 4
            x$date[1:4] <- as.character(as.Date(Sys.time(), tz = 'EST'))
        }
        else {
            x$date[r:(r+3)] <- as.character(as.Date(Sys.time(), tz = 'EST') - (i - 1))
            r <- r + 4
        }
    }
    return(x)
}
data <- getData()

# writing CSV
write.csv(data, 'data/data.csv', row.names = F)
