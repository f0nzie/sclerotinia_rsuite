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
# library(extrafont)
# loadfonts(device = "win")


loginfo("--> Pandoc version: %s", rmarkdown::pandoc_version())

# change to directory where RMD files are
proj_root <- rprojroot::find_rstudio_root_file()
setwd(file.path(proj_root, "./doc/RMD"))
loginfo(proj_root)

# delete _main.Rmd if it was created before
if (file.exists("_main.Rmd")) {
  file.remove("_main.Rmd")
}

# bookdown::render_book(input = "index.Rmd",
#                       output_format = "bookdown::gitbook",
#                       output_dir = "../../results")

# get all the RMD files under ./doc/RMD
rmd_files <- list.files(".", "*.Rmd$")

# function to print RMD files
knit_rmd <- function(rmds) {
  for (rmd in rmds) {
    loginfo("Knitting notebook [%s]", rmd)
    ezknitr::ezknit(rmd,
                    out_dir = '../../results',
                    fig_dir = 'figures',    # this must be a subfolder of out_dir
                    keep_html = TRUE
    )
  }
}

# function to handle what to do with the arguments
kniter <- function(which) {
  if (which == "all") {
    print(rmd_files)
    rmd_built <- rmd_files
    knit_rmd(rmd_built)
  } else {
    print(which)
    rmd_built <- which
    knit_rmd(which)
  }
  rmd_built
}

# retrieve the arguments from the command line
rmd_built <- kniter(
  which = args$get(name = "which", required = FALSE, default = "all")
  )


loginfo("Finished knitting [%d] notebooks", length(rmd_built))
