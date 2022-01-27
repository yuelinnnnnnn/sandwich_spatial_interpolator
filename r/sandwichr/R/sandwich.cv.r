#' @title Perform \emph{k}-fold cross validation
#'
#' @description
#' \code{sandwich.cv} perfoms \emph{k}-fold cross validation to evaluate the overall model accuracy and outputs the average root mean square error (RMSE).
#'
#' @usage sandwich.cv(object,
#'                    sampling.attr,
#'                    k=10,
#'                    type="shp",
#'                    ssh.id.col=NULL,
#'                    reporting.id.col=NULL,
#'                    ssh.weights=NULL)
#'
#' @param object When \code{type="shp"}, \code{object} is a list of 3 \code{sf} objects generated by \code{load.data.shp}, including a POINT \code{sf} object used as the sampling layer, a POLYGON \code{sf} object used as the SSH layer, and a POLYGON \code{sf} object used as the SSH layer. When \code{type="txt"}, \code{object} is a list of 2 data frames generated by \code{load.data.txt}, including a file linking sampling and SSH layers linking reporting and SSH layers and a file.
#' @param sampling.attr A \code{string} denoting the name of the attribute in the sampling layer to be interpolated.
#' @param k The number of folds (\code{k} > 1). By default, \code{k} = 10.
#' @param type A \code{string} denoting the type of input data. \code{type="shp"} denotes shapefiles, and \code{type="txt"} denotes text files. By default, \code{type="shp"}.
#' @param ssh.id.col A \code{string} denoting the column that specifies which stratum each sampling unit falls into in the file linking sampling and SSH layers.
#' @param reporting.id.col A \code{string} denoting the column that specifies which reporting unit each sampling unit falls into in the file linking sampling and SSH layers.
#' @param ssh.weights A \code{list} that specifies the strata in the SSH layer and their corresponding columns of weights in the file linking reporting and SSH layers.
#'
#' @import sf caret
#' @name sandwich.cv
#' @export
#'
# ---- End of roxygen documentation ----


sandwich.cv <- function(object, sampling.attr, k=10, type="shp", ssh.id.col=NULL, reporting.id.col=NULL, ssh.weights=NULL){
  if (type == "shp"){

    sampling.lyr = object[[1]]
    ssh.lyr = object[[2]]
    reporting.lyr = object[[3]]

    #--------------------------- Check inputs ----------------------------------
    if (st_geometry_type(sampling.lyr, by_geometry=FALSE) != "POINT"){
      stop("Geometry type of the sampling layer should be POINT.")
    }
    if (st_geometry_type(ssh.lyr, by_geometry=FALSE) != "POLYGON" &
        st_geometry_type(ssh.lyr, by_geometry=FALSE) != "MULTIPOLYGON"){
      stop("Geometry type of the SSH layer should be POLYGON or MULTIPOLYGON.")
    }
    if (st_geometry_type(reporting.lyr, by_geometry=FALSE) != "POLYGON" &
        st_geometry_type(reporting.lyr, by_geometry=FALSE) != "MULTIPOLYGON"){
      stop("Geometry type of the reporting layer should be POLYGON or MULTIPOLYGON.")
    }
    if (!is.element(sampling.attr, names(sampling.lyr))){
      stop("Attribute name not found in the sampling layer.")
    }

    #----------------------- Create k equally-sized folds ------------------------
    sampling.lyr$index = 1:nrow(sampling.lyr)
    folds = createFolds(sampling.lyr$index, k=k)

    #----------------------- k-fold cross validation ------------------------
    rmse = 0
    for(i in 1:k){
      # split data sets
      val = lapply(folds[i], function(ind, dat) dat[ind,], dat=sampling.lyr)
      val = st_as_sf(as.data.frame(val))
      dev = lapply(list(unique(unlist(folds[-i]))), function(ind, dat) dat[ind,], dat=sampling.lyr)
      dev = st_as_sf(as.data.frame(dev))
      # perform sandwich model
      object_dev = list(dev, ssh.lyr, reporting.lyr)
      out = sandwich.model(object_dev, sampling.attr, type)$object
      # calculate MSE
      val.join = suppressMessages(st_join(val, out))
      st_geometry(val.join) = NULL
      val.join = as.data.frame(val.join)
      new.attr.name = paste(names(folds)[i], sampling.attr, sep=".")
      dif = (val.join[new.attr.name] - val.join$mean)[[new.attr.name]]
      rmse[i] = sqrt(mean(dif^2))
    }
    rmse.mean = mean(rmse)
    rmse.mean}
  else if (type == "txt"){

    sampling_ssh = object[[1]]
    reporting_ssh = object[[2]]

    #--------------------------- Check inputs ----------------------------------
    if (!ssh.id.col %in% names(sampling_ssh) | is.null(ssh.id.col)){
      stop("Column name ssh.id.col not exists in the file linking sampling and SSH layers.")
    }
    if (!all(ssh.weights[[2]] %in% names(reporting_ssh)) | is.null(ssh.weights)){
      stop("Some columns in ssh.weights not exist in the file linking reporting and SSH layers.")
    }
    if (!all(sort(ssh.weights[[1]]) == sort(unique(sampling_ssh[[ssh.id.col]])))){
      stop("ssh.weights not matches with the values in column ssh.id.col")
    }
    if (!is.element(sampling.attr, names(sampling_ssh))){
      stop("Attribute name not found in the file linking sampling and SSH layers.")
    }

    #----------------------- Create k equally-sized folds ------------------------
    sampling_ssh$index = 1:nrow(sampling_ssh)
    folds = createFolds(sampling_ssh$index, k=k)

    #----------------------- k-fold cross validation ------------------------
    rmse = 0
    for(i in 1:k){
      # split data sets
      val = lapply(folds[i], function(ind, dat) dat[ind,], dat=sampling_ssh)[[1]]
      dev = lapply(list(unique(unlist(folds[-i]))), function(ind, dat) dat[ind,], dat=sampling_ssh)[[1]]
      # perform sandwich model
      object_dev = list(dev, reporting_ssh)
      out = sandwich.model(object_dev, sampling.attr, type, ssh.id.col, ssh.weights)$object
      # calculate MSE
      val.join = merge(val, out, reporting.id.col, all.x=TRUE)
      dif = (val.join[sampling.attr] - val.join$mean)[[sampling.attr]]
      rmse[i] = sqrt(mean(dif^2))
    }
    rmse.mean = mean(rmse)
    rmse.mean}
}
