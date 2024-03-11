
#' @title title
#' 
#' @importFrom lubridate now
#' @export
hello_world <- function() {
  hello <- paste0("Hello world!", now())
  return (hello)
}
