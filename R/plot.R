
#' Plot an SEIRfansy Fit Object
#'
#' This is a convenient wrapper for output that is already included in the 
#' SEIRfansy output in the plots element. Options are trace or boxplot.
#' 
#' @export
plot.SEIRfansy = function(x, type, ...) {
  if(!(type %in% c("trace", "boxplot"))) stop("You must select one of trace or boxplot.")
  if(type == "trace") {
    plot(x$plots[["trace_plot"]])
  } else if(type == "boxplot") {
    plot(x$plots[["boxplot_R0"]])
  }
}

#' Plot an SEIRfansyPredict Fit Object
#'
#' This is a convenient wrapper for output that is already included in the 
#' predict output in the plots element. Options are panel and cases.
#' 
#' @export
plot.SEIRfansyPredict = function(x, type, ...) {
  if(!(type %in% c("trace", "boxplot", "panel", "cases"))) stop("You must select one of the options.")
  if(type == "panel") {
    plot(x$plots[["panel_plot_fit"]])
  } else if(type == "cases") {
    plot(x$plots[["plot_detected_undetected"]])
  } else if(type == "trace") {
    plot(x$plots[["trace_plot"]])
  } else if(type == "boxplot"){
    plot(x$plots[["boxplot_R0"]])
  }
}