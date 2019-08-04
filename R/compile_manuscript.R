# Detect proper script_path (you cannot use args yet as they are build with
# tools in set_env.r)
script_path <- (function() {
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- dirname(sub("--file=", "", args[grep("--file=", args)]))
  if (!length(script_path)) { return(".") }
  return(normalizePath(script_path))
})()

# Setting .libPaths() to point to libs folder
source(file.path(script_path, "set_env.R"), chdir = T)

config <- load_config()
args <- args_parser()


library(ScleroWorld)
library(ggplot2)
library(extrafont)
# loadfonts(device = "win")


loginfo("--> Pandoc version: %s", rmarkdown::pandoc_version())

# change to directory where RMD files are
setwd(file.path(script_path, "../doc/manuscript"))

# delete _main.Rmd if it was created before
if (file.exists("_main.Rmd")) {
  file.remove("_main.Rmd")
}


# get all the RMD files under ./doc/RMD
rmd_files <- list.files(".", "*.Rmd$")

rmarkdown::render(rmd_files)


