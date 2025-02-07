#' Evaluate stratification
#'
#' @description
#'Calculate the factor detector \emph{q}-statistic and the interaction detector in the geographical detector model described by Wang et al. (2010). The \emph{q}-statistic measures the SSH of the sampling attribute in terms of a given stratification, which can be used for the selection of an SSH layer for Sandwich model-based mapping. The interactive effects indicate whether a combination of two stratifications enhances the SSH of the sampling attribute.
#'
#' @usage ssh.test(object,
#'        y,
#'        x,
#'        test="factor",
#'        type="shp")
#'
#' @param object An object generated by \code{\link{ssh.data.shp}} or \code{\link{ssh.data.txt}}.
#' @param y Text for the name of the explained variable (sampling attribute) in \code{object}.
#' @param x Text for the name(s) of the explanatory variable(s) (stratification(s)) in \code{object}.
#' @param test Text for the type of test. \code{test="factor"} denotes the factor detector, and \code{test="interaction"} denotes the interaction detector. By default, \code{test="factor"}.
#' @param type Text for the type of input data. \code{type="shp"} denotes shapefiles, and \code{type="txt"} denotes text files. By default, \code{type="shp"}.
#'
#' @return A value of the \emph{q}-statistic or the combined \emph{q}-statistic.
#'
#' @references
#' Wang, J. F., Li, X. H., Christakos, G., Liao, Y. L., Zhang, T., Gu, X., & Zheng, X. Y. (2010). Geographical detectors-based health risk assessment and its application in the neural tube defects study of the Heshun Region, China. \emph{International Journal of Geographical Information Science}, 24(1), 107-127.
#'
#' @seealso \code{\link{ssh.data.shp}}, \code{\link{ssh.data.txt}}
#' @import sf geodetector
#' @export
#'
#' @examples
#' library(sf)
#' library(tools)
#' data(sim.data)
#' sim.join <- ssh.data.shp(object=sim.data[[1]], ssh.lyr=sim.data[[2]], ssh.id="X")
#' head(sim.join)
#' ssh.test(object=sim.join, y="Value", x=c("X"), test="factor")
#'
#' @name ssh.test
# ---- End of roxygen documentation ----

ssh.test <- function(object, y, x, test="factor", type="shp"){
  if (type == "shp"){
    #--------------------------- Check inputs ----------------------------------
    if (st_geometry_type(object, by_geometry=FALSE) != "POINT"){
      stop("Geometry type of the input object should be POINT.")
    }

    st_geometry(object) = NULL
    object = as.data.frame(object)
  }

  #---------------- Calculating factor detector ----------------------
  if (test == "factor"){
    factor_detector(y, x, object)
  }
  else if (test == "interaction"){
    interaction_detector(y, x, object)
  }
}
