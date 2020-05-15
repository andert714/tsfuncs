#' Explore time series seasonality
#'
#' Creates side-by-side boxplots for analyzing weekly, monthly, and yearly seasonalities for
#' a time series tibble.
#'
#' @param ts_df A tibble containing dates in column labeled 'ds' and values in column labeled 'y'.
#' @param seasonalities A string containing which seasonalities will be plotted. The options are 'weekly',
#' 'monthly', and 'yearly'.
#'
#' @return A collection of seasonality plots.
#' @export
#'
#' @examples
#' df <- tidyr::tibble(ds = lubridate::today() - 100:1, y = rnorm(100))
#' ts_seasonality(df)
#' @importFrom dplyr %>%
ts_seasonality <- function(ts_df, seasonalities = c('weekly', 'monthly', 'yearly')){
  plots <- list()

  if('weekly' %in% seasonalities){
    plots$weekly <- ts_df %>%
      dplyr::mutate(Weekday = lubridate::wday(ds, label = TRUE)) %>%
      ggplot2::ggplot() +
      ggplot2::geom_boxplot(ggplot2::aes(Weekday, y))
  }

  if('monthly' %in% seasonalities){
    plots$monthly <- ts_df %>%
      dplyr::mutate(Day = as.factor(lubridate::day(ds))) %>%
      ggplot2::ggplot() +
      ggplot2::geom_boxplot(ggplot2::aes(Day, y))
  }

  if('yearly' %in% seasonalities){
    plots$monthly <- ts_df %>%
      dplyr::mutate(Month = lubridate::month(ds, label = TRUE)) %>%
      ggplot2::ggplot() +
      ggplot2::geom_boxplot(ggplot2::aes(Month, y))
  }

  if(length(plots) == 1){
    plots[[seasonalities]]
  } else if(length(plots) == 2){
    gridExtra::grid.arrange(plots[[1]], plots[[2]], ncol = 1)
  } else if(length(plots == 3)){
    gridExtra::grid.arrange(
      plots$weekly,
      plots$yearly,
      plots$monthly,
      layout_matrix = matrix(c(1, 3, 2, 3), ncol = 2)
    )
  }
}
