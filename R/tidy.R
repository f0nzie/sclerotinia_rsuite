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


loginfo("--> Pandoc version: %s", rmarkdown::pandoc_version())


# PARSE_DATA <- "results/data-comparison.md"
DATA_FILES <- list.files("data", pattern = "*.rda|*.rds|*.csv|*.rdb",
                         full.names = TRUE)
# ANALYSES   <-  "results/table-1.md"
MANUSCRIPT <- c("doc/manuscript/manuscript.pdf",
                "doc/manuscript/manuscript.log",
                "doc/manuscript/manuscript.tex")
DIRS       <- c("results/figures/publication", "results/tables")

# file.remove(PARSE_DATA)
file.remove(DATA_FILES)
# file.remove(ANALYSES)
# file.remove(MANUSCRIPT)
# file.remove(DIRS)

unlink(DIRS, recursive = TRUE, force = TRUE)
unlink("results", recursive = TRUE, force = TRUE)
file.remove(list.files("doc/RMD", pattern = "*.html|*.Rmd~|*.pdf",
                       full.names = TRUE))
file.remove(list.files("doc/manuscript", pattern = "*.pdf|*.tex|*.un~|*.Rmd~",
                       full.names = TRUE))
