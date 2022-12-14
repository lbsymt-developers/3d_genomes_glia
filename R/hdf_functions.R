ReturnH5FileConnection <- function(File = NULL){
  HDF.File <- File
  if(Sys.getenv("HDF5_USE_FILE_LOCKING") == ""){
    Sys.setenv(HDF5_USE_FILE_LOCKING="FALSE")
  }
  HDF.Connection = H5Fopen(name=HDF.File)
  return(HDF.Connection)
}
ReturnH5Handler <- function(Path=NULL,File = NULL){
  Temp.connection <- ReturnH5FileConnection(File=File)
  Handle <- Temp.connection&Path
  return(Handle)
}
ReturnH5Attribute <- function(Handle = NULL, name = NULL, type = NULL){
  if(!H5Aexists(Handle, name)){
    CloseH5Con(Handle = Handle, type = type)
    stop("Attribute ",name," not found in HDF file.\n")
  }
  Attributes <- rhdf5::H5Aread(H5Aopen(Handle,name))
  return(Attributes)
}
CloseH5Con <- function(Handle = NULL, type = NULL){
  if(type == "group"){
    H5Gclose(Handle)
  }else if(type == "dataset"){
    H5Dclose(Handle)
  }else if(type == "file"){
    H5Fclose(Handle)
  }
}
Create_Path <- function(groups){
  Path.to.file <- ""
  for (x in groups) {
    Path.to.file <- file.path(Path.to.file,x)
  }
  # cat(Path.to.file,"\n")
  return(Path.to.file)
}
CreateGroups <- function(Group.path = NULL, File = NULL){
  Temp.connection = ReturnH5FileConnection(File=File)
  h5createGroup(file = Temp.connection, group = Group.path)
  H5Fclose(Temp.connection)
}
CreateDataset <- function(Path = NULL, File = NULL, name = NULL, dims = NULL,
                          maxdims = NULL, data_type = "H5T_NATIVE_DOUBLE", chunk_size = NULL,
                          compression_level = 6, fill_with = 0){
  Full.path <- Create_Path(Path)
  if(is.null(chunk_size)){
    chunk_size <- ceiling(dims/100)
  }
  H5Handler <- ReturnH5Handler(Path=Full.path,File = File)
  h5createDataset(file=H5Handler, dataset=name, dims= dims,
                  maxdims = dims, H5type=data_type, chunk = chunk_size,
                  level = compression_level, fillValue = fill_with)
  H5Gclose(H5Handler)
}
CreateAttributes <- function(Path = NULL, File = NULL, Attributes = NULL,
                             data_types = NULL, on = "group",
                             dims = 1, maxdims = 1){
  if(is.null(Attributes) | is.null(data_types)){
    stop("Attributes and data_type cannot take NULL values")
  }
  Brick.handler <- ReturnH5Handler(Path = Path,File = File)
  for (i in seq_len(length(Attributes))) {
    An.attribute <- Attributes[i]
    data_type <- data_types[i]
    dim <- ifelse(!is.null(dims),dims[[i]],NULL)
    maxdim <- ifelse(!is.null(maxdims),maxdims[[i]],dim)
    MaxLen <- NULL
    if(data_type == "character"){
      ## If you can write a 280 char tweet, you can constrain
      ## yourself to 280 chars here as well.
      ## It's not too small, its actually larger than the
      ## linux filename limit.
      MaxLen <- 280
    }
    h5createAttribute(obj = Brick.handler, attr = An.attribute,
                      storage.mode = data_type, dims = dim, maxdims = maxdim,
                      size = MaxLen)
  }
  CloseH5Con(Handle = Brick.handler, type = on)
}
WriteAttributes <- function(Path = NULL, File = NULL, Attributes = NULL,
                            values = NULL, on = "group"){
  if(length(Attributes) != length(values)){
    stop("length of Attributes and value does not match")
  }
  Brick.handler <- ReturnH5Handler(Path = Path,File = File)
  for (i in seq_len(length(Attributes))) {
    value <- values[i]
    An.attribute <- Attributes[i]
    h5writeAttribute(attr = value, h5obj = Brick.handler,
                     name = An.attribute)
  }
  CloseH5Con(Handle = Brick.handler, type = on)
}
GetAttributes <- function(Path = NULL, File = NULL, Attributes = NULL,
                          on = "group", ignore.fun.cast = FALSE){
  Reference.object <- GenomicMatrix$new()
  FUNCasts <- Reference.object$matrices.chrom.attributes.fun.cast
  if(is.null(Path)){
    Brick.handler <- ReturnH5FileConnection(File = File)
  }else{
    Brick.handler <- ReturnH5Handler(Path = Path,File = File)
  }
  Attribute.df <- do.call(cbind,lapply(Attributes, function(An.attribute){
    Attr.val <- ReturnH5Attribute(Handle = Brick.handler,
                                  name = An.attribute, type = on)
    if(!ignore.fun.cast){
      Val <- FUNCasts(type = An.attribute)(Attr.val)
    }else{
      Val <- Attr.val
    }
    temp.df <- data.frame(attribute = Val)
    colnames(temp.df) <- An.attribute
    temp.df
  }))
  CloseH5Con(Handle = Brick.handler, type = on)
  return(Attribute.df)
}

# # InsertIntoDataset = function(Path = NULL, File = NULL, Name = NULL,
#  Data=NULL, Index = NULL,
# #     Start = NULL, Stride = NULL, Count = NULL){
# #     DatasetHandler <- ._Brick_Get_Something_(Group.path = Path,
#       Brick = File,
#  Name = Name, return.what = "group_handle")
# #     if(!is.null(Index)){
# #         h5writeDataset(obj=Data, h5loc=DatasetHandler, name=Chrom,
# index=Index)
# #     }else if(!is.null(Count) & !is.null(Stride) & !is.null(Start)){
# #         h5writeDataset(obj=Data, h5loc=DatasetHandler, name=Chrom,
# start=Start, stride=Stride, count=Count)
# #     }else{
# #         stop("FetchFromDataset expects one of Start, Stride,
# Count if Index is NULL")
# #     }
# #     private$Flush.HDF()
# }
