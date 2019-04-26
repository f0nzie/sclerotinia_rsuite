#' Plot posterior values from DAPC analysis in adegenet
#'
#' @param da.object an object of class "dapc"
#' @param gid an object of class "genind"
#' @param pal a color palette
#' @param cols the number of columns to display
#' @return a ggplot object with each population stacked on top of each other.
#' @export
#' @examples
#' library('adegenet')
#' library('ggcompoplot')
#' library('ggplot2')
#' data(microbov)
#' strata(microbov) <- data.frame(other(microbov))
#' dapc1 <- dapc(microbov, n.pca=20, n.da=15)
#' setPop(microbov) <- ~breed
#' compoplot(dapc1, lab="") # Adegenet compoplot
#' # Showing per breed
#' ggcompoplot(dapc1, microbov) + theme(axis.text.x = element_blank())
#' \dontrun{
#'
#' # 3 columns
#' ggcompoplot(dapc1, microbov, col = 3) + theme(axis.text.x = element_blank())
#'
#' # Different color palette
#' ggcompoplot(dapc1, microbov, col = 3, pal = funky) + theme(axis.text.x = element_blank())
#'
#' # Per Country
#' setPop(microbov) <- ~coun
#' ggcompoplot(dapc1, microbov) + theme(axis.text.x = element_blank())
#' }
#' @importFrom adegenet pop
#' @importFrom ggplot2 ggplot aes_string geom_bar theme element_text facet_wrap
#' @importFrom ggplot2 scale_y_continuous scale_x_discrete scale_fill_manual
#' @importFrom reshape2 melt
#' @importFrom grDevices rainbow
ggcompoplot <- function(da.object, gid, pal = rainbow, cols = 1){
  posterior <- da.object$posterior
  names(dimnames(posterior)) <- c("sample", "population")
  to_merge <- data.frame(list(sample = dimnames(posterior)$sample,
                              oldPopulation = adegenet::pop(gid)))
  post <- reshape2::melt(posterior, value.name = "probability")
  post <- merge(post, to_merge)
  if (is.numeric(post$sample)){
    post$sample <- factor(post$sample, levels = unique(post$sample))
  }
  if (is.numeric(post$population)){
    post$population <- factor(post$population)
  }
  if (length(pal) == 1){
    PAL <- match.fun(pal)
    pal <- char2pal(post$population, PAL)
  }
  outPlot <- ggplot(post, aes_string(x = "sample", fill = "population", y = "probability")) +
    geom_bar(stat = "identity", position = "fill", width = 1) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_discrete(expand = c(0, 0)) +
    facet_wrap(~oldPopulation, scales = "free_x", drop = TRUE, ncol = cols) +
    scale_fill_manual(values = pal)
  return(outPlot)
}

#' Creates a named color palette.
#'
#' This is useful for defining a color palette that can be used by population factors.
#'
#' @param x a vector of identifiers to be used for colors.
#' @param pal a color palette. Default is \code{\link[grDevices]{rainbow}}
#'
#' @return a named character vector of hexadecimal colors.
#'
#' @export
#' @examples
#' char2pal(LETTERS)
char2pal <- function(x, pal = rainbow){
  PAL <- match.fun(pal)
  outPal <- PAL(length(unique(x)))
  names(outPal) <- unique(x)
  return(outPal)
}