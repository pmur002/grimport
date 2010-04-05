
# Go from numeric vector for lty to string
fixLTY <- function(ltyString, lwdString) {
    tc <- textConnection(ltyString)
    lty <- scan(tc, quiet=TRUE)
    close(tc)
    if (length(lty)) {
        # Arbitrary 0.5 multiplier
        # Minimum allowed is 1
        paste(as.hexmode(pmax(1, round(0.5*lty/as.numeric(lwdString)))),
              collapse="")
    } else {
        "solid"
    }
}
