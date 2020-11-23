#cmd -> d: -> cd D:\R기반_빅데이터처리\Rexam
# -> java -Dwebdriver.chrome.driver="chromedriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" , 
                      port = 4445, browserName = "chrome")

#요기요_셰플리-셰프의건강한한끼(강남)
remDr$open()
site <- 'https://www.yogiyo.co.kr/mobile/#/260443/'
remDr$navigate(site)

Sys.sleep(3)

#클린리뷰 탭 클릭
pageLink <- remDr$findElements(using='css',
                               value= paste0('#content > div.restaurant-detail.row.ng-scope > div.col-sm-8 > ul > li:nth-child(2) > a'))
remDr$executeScript("arguments[0].click();",pageLink)

#작업 디렉토리에 새폴더 생성(csv파일 저장 폴더)
dir.create('yogiyo')

webElem <- remDr$findElement("css", "body")

repeat {
  Sys.sleep(2)
  pageLink_next <- remDr$findElements(using='css',"#review > li.list-group-item.btn-more > a")

  pageLink_next <- remDr$findElements(using='css',"#review > li.list-group-item.btn-more > a")
  remDr$mouseMoveToLocation(webElement = pageLink_next[[1]])
  remDr$click()
  Sys.sleep(2)
  webElem$sendKeysToElement(list(key = "end"))
}

user_id <- NULL; order_date <- NULL; order_item <- NULL; point <- NULL; comment <- NULL

#아이디
user_id_node <- remDr$findElements(using='css',
                                   value= paste0('#review > li > div:nth-child(1) > span.review-id.ng-binding'))
users_id <- sapply(user_id_node, function(x) {x$getElementText()})
#print(users_id)
user_id <- append(user_id, unlist(users_id))

#주문날짜
order_date_node <- remDr$findElements(using='css',
                                      value= paste0('#review > li > div:nth-child(1) > span.review-time.ng-binding'))
order_dates <- sapply(order_date_node, function(x) {x$getElementText()})
#print(order_dates)
order_date <- append(order_date, unlist(order_dates))

#주문음식
order_item_node <- remDr$findElements(using='css',
                                      value= paste0('#review > li > div.order-items.default.ng-binding'))
order_items <- sapply(order_item_node, function(x) {x$getElementText()})
#print(order_items)
order_item <- append(order_item, unlist(order_items))

#맛 평점
point_node <- remDr$findElements(using='css',
                                 value= paste0('#review > li > div:nth-child(2) > div > span.category > span:nth-child(3)'))
points <- sapply(point_node, function(x) {x$getElementText()})
#print(points)
point <- append(point, unlist(points))

#코멘트
comment_node <- remDr$findElements(using='css',
                                   value= paste0('#review > li > p'))
comments <- sapply(comment_node, function(x) {x$getElementText()})
#print(comments)
comment <- append(comment, unlist(comments))

df <- data.frame(user_id, order_date, order_item, point, comment, check.rows = FALSE)
# 파일 저장
write.csv(df, "yogiyo_review_data.csv")
