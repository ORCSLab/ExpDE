#' Stop criteria for DE
#' 
#' Implements different stop criteria for the ExpDE framework
#' 
#' @section Warning:
#' This routine accesses the parent environment used in the main function 
#' \code{ExpDE()}, which means that changes made in the variables 
#' contained in \code{env} WILL change the original values. DO NOT change 
#' anything unless you're absolutely sure of what you're doing.
#' 
#' @return logical flag indicating whether any stop condition has been reached.
#' @export
#' 
check_stop_criteria <- function(){
  
  env   <- parent.frame()
  
  # ========== Error catching and default value definitions
  assertthat::assert_that("stopcrit" %in% names(env),
                          "names" %in% names(env$stopcrit))

  crits <- env$stopcrit$names
  
  assertthat::assert_that(("stop_maxiter" %in% crits && "maxiter" %in% names(env$stopcrit)) ||
                          ("stop_maxeval" %in% crits && "maxevals" %in% names(env$stopcrit)))
  # ==========
  
  keep.running <- TRUE
  
  for (crit in crits){
    keep.running <- keep.running * !(do.call(crit,
                                             args = list()))
  }
  
  return(as.logical(keep.running))
}

# Stop criterion: maximum number of iterations
stop_maxiter <- function(env = parent.frame(n = 2)){
  return(env$t >= env$stopcrit$maxiter)
}

# Stop criterion: maximum number of objective function calls
stop_maxeval <- function(env = parent.frame(n = 2)){
  return(env$nfe >= env$stopcrit$maxevals)
}