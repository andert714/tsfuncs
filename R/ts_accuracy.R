#' Time series accuracy
#'
#' Calculates ME, MAE, MASE, Coverage, and Width for a time series tibble.
#'
#' @param ts_df A tibble containing dates in column labeled 'ds' and values in column labeled 'y'.
#' The point forecast should be in a column labeled 'yhat', and respective prediction intervals should
#' be in columns labeled 'yhat_lower' and 'yhat_upper'.
#'
#' @param lag The lag to be used in calculating MASE, which should be the period of seasonality of the time series.
#'
#' @return A tibble with ME, MAE, MASE, Coverage, and Width columns.
#' @export
#'
#' @examples
#' df <- tidyr::tibble(
#'   ds = lubridate::today() - 100:1,
#'   y = rnorm(100),
#'   yhat = rnorm(100),
#'   yhat_lower = yhat - 1,
#'   yhat_upper = yhat + 1
#' )
#' ts_accuracy(df)
#' @importFrom dplyr %>%
ts_accuracy <- function(ts_df, lag = 1){
  ts_df %>%
    dplyr::summarize(
      ME = mean(y - yhat, na.rm = TRUE),
      MAE = mean(abs(y - yhat), na.rm = TRUE),
      MASE = mean(abs(y - yhat), na.rm = TRUE)/mean(abs(y - dplyr::lag(y, lag)), na.rm = TRUE),
      Coverage = mean(yhat_lower <= y & yhat_upper >= y, na.rm = TRUE),
      Width = mean(yhat_upper - yhat_lower, na.rm = TRUE)
    ) %>%
    dplyr::arrange(MASE, dplyr::desc(Coverage))
}


