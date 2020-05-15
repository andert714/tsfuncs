ts_graph <- function(ts){
  graph <- ts %>%
    select('y', contains('yhat')) %>%
    xts::xts(ts$ds) %>%
    dygraphs::dygraph() %>%
    dygraphs::dySeries('y', 'Actual', 'black') %>%
    dygraphs::dyRangeSelector()

  if('yhat' %in% names(ts)){
    graph <- graph %>%
      dygraphs::dySeries(c('yhat_lower', 'yhat', 'yhat_upper'), 'Forecast', 'blue')
  }
  graph
}
