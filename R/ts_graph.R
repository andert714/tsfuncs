#' Graph time series
#'
#' Create an interactive graph of a time series tibble.
#'
#' @param ts_df A tibble containing dates in column labeled 'ds' and
#' values in column labeled 'y'.
#' If forecast is contained, the point forecast should be in a column labeled 'yhat', and
#' respective prediction intervals should be in columns labeled 'yhat_lower' and 'yhat_upper'.
#'
#' @return An interactive graph.
#' @export
#'
#' @examples
#' ts_graph(tidyr::tibble(ds = lubridate::today() - 100:1, y = rnorm(100)))
#' @importFrom dplyr %>%
ts_graph <- function(ts_df){
  graph <- ts_df %>%
    dplyr::select('y', dplyr::contains('yhat')) %>%
    xts::xts(ts_df$ds) %>%
    dygraphs::dygraph() %>%
    dygraphs::dySeries('y', 'Actual', 'black') %>%
    dygraphs::dyRangeSelector()

  if('yhat' %in% names(ts_df)){
    graph <- graph %>%
      dygraphs::dySeries(c('yhat_lower', 'yhat', 'yhat_upper'), 'Forecast', 'blue')
  }
  graph
}
