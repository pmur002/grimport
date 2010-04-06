
readLTY <- function(ltyString) {
    tc <- textConnection(ltyString)
    lty <- scan(tc, quiet=TRUE)
    close(tc)
    lty
}

# Go from numeric vector for lty to string
fixLTY <- function(lty, lwd) {
    if (length(lty)) {
        # Minimum allowed is 1
        paste(as.hexmode(pmax(1, round(lty/lwd))),
              collapse="")
    } else {
        "solid"
    }
}
