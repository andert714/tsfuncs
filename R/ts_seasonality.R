#' Explore time series seasonality
#'
#' Creates side-by-side boxplots for analyzing seasonality for weekly, monthly, and quarterly time series tibbles.
#'
#' @param ts_df A tibble containing dates in column labeled 'ds' and values in column labeled 'y'.
#' @param ts_type A string indicating the type of time series. Valid options are 'daily', 'monthly', and 'quarterly'.
#'
#' @return A seasonality plot.
#' @export
#'
#' @examples
#' df <- tidyr::tibble(ds = lubridate::today() - 100:1, y = rnorm(100))
#' ts_seasonality(df, 'daily')
#' @importFrom dplyr %>%
ts_seasonality <- function(ts_df, ts_type){
  if(ts_type == 'daily'){
    graph <- ts_df %>%
      dplyr::mutate(
        Weekday = lubridate::wday(ds, label = TRUE),
        Day = as.factor(lubridate::day(ds)),
        Month = lubridate::month(ds, label = TRUE)
      ) %>%
      ggplot2::ggplot()
    gridExtra::grid.arrange(
      graph + ggplot2::geom_boxplot(ggplot2::aes(Weekday, y)),
      graph + ggplot2::geom_boxplot(ggplot2::aes(Month, y)),
      graph + ggplot2::geom_boxplot(ggplot2::aes(Day, y)),
      layout_matrix = matrix(c(1, 3, 2, 3), ncol = 2)
    )
  } else if(ts_type == 'monthly'){
    ts_df %>%
      dplyr::mutate(
        Month = lubridate::month(ds, label = TRUE)
      ) %>%
      ggplot2::ggplot(ggplot2::aes(Month, y)) +
      ggplot2::geom_boxplot()
  } else if(ts_type == 'quarterly'){
    ts_df %>%
      dplyr::mutate(
        Quarter = dplyr::case_when(
          lubridate::month(ds) %in% 1:3 ~ 'Q1',
          lubridate::month(ds) %in% 4:6 ~ 'Q2',
          lubridate::month(ds) %in% 7:9 ~ 'Q3',
          lubridate::month(ds) %in% 10:12 ~ 'Q4'
        )
      ) %>%
      ggplot2::ggplot(ggplot2::aes(Quarter, y)) +
      ggplot2::geom_boxplot()
  }
}

