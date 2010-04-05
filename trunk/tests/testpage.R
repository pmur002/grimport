#######################################
# Produce testpage.ps from R 
#######################################

require(grid)

# A star polygon which is filled differently
# by non-zero winding rule and even-odd fill
star <- function(lab, gp=gpar(fill="black", lwd=1)) {
    grid.text(lab, y=unit(1, "npc"), just="bottom")
    pushViewport(viewport(xscale=c(-1, 1),
                          yscale=c(-1, 1)))
    t <- seq(0, 2*pi, length=6)[-6]
    x <- cos(t)
    y <- sin(t)
    grid.polygon(x[c(1, 4, 2, 5, 3)],
                 y[c(1, 4, 2, 5, 3)],
                 default="native",
                 gp=gp)
    popViewport()
}

postscript("testpage.ps", horiz=FALSE)
# grid.newpage()
pushViewport(viewport(layout=grid.layout(6, 5,
                        heights=unit(c(1, 1), c("lines", "null")),
                        respect=TRUE)))
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=1))
star("eofill")
popViewport()
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=2))
star("fill")
popViewport()
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=3))
star("stroke", gp=gpar(fill=NA))
popViewport()
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=4))
star("colour", gp=gpar(fill="light blue"))
popViewport()
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=5))
star("lwd", gp=gpar(lwd=3))
dev.off()


# Modify the PostScript file to insert eofill def and
# change one of the fills to eofill
testpageps <- readLines("testpage.ps")
p3line <- grep("^/p3", testpageps)
testpageps[p3line] <-
    paste(testpageps[p3line],
          "\n/p4 { gsave bg eofill grestore stroke } def")
fillline <- grep(" p3$", testpageps)
testpageps[fillline[1]] <- gsub(" p3$", " p4", testpageps[fillline[1]])
writeLines(testpageps, "testpage.ps")
          


#######################################
# Now import testpage.ps and draw it in various ways
#######################################

require(grImport)

PostScriptTrace("testpage.ps")
PostScriptTrace("testpage.ps", out="testpagetext.ps.xml", charpath=FALSE)

testpage <- readPicture("testpage.ps.xml")
testpagetext <- readPicture("testpagetext.ps.xml")

# grid.newpage()
# Simple picture (text gets stroked)
pushViewport(viewport(layout=grid.layout(8, 1,
                        heights=unit(c(1, 1), c("lines", "null")))))
pushViewport(viewport(layout.pos.row=1,
                      layout.pos.col=1))
grid.rect()
grid.text("Stroked text")
popViewport()
pushViewport(viewport(layout.pos.row=2,
                      layout.pos.col=1))
grid.picture(testpage)
popViewport()
pushViewport(viewport(layout.pos.row=3,
                      layout.pos.col=1))
grid.rect()
grid.text("Filled text")
popViewport()
pushViewport(viewport(layout.pos.row=4,
                      layout.pos.col=1))
grid.picture(testpage, fillText=TRUE)
popViewport()
pushViewport(viewport(layout.pos.row=5,
                      layout.pos.col=1))
grid.rect()
grid.text("Filled text (dotting the i's)")
popViewport()
pushViewport(viewport(layout.pos.row=6,
                      layout.pos.col=1))
grid.picture(testpage, fillText=TRUE)
grid.picture(testpage[4],
             xscale=testpage@summary@xscale,
             yscale=testpage@summary@yscale,
             fillText=TRUE, bgText="black")
grid.picture(testpage[10],
             xscale=testpage@summary@xscale,
             yscale=testpage@summary@yscale,
             fillText=TRUE, bgText="black")
popViewport()
pushViewport(viewport(layout.pos.row=7,
                      layout.pos.col=1))
grid.rect()
grid.text("Substituted text")
# NOTE: the text "stroke" is drawn in two parts
# in the PostScript file, "strok" and "e", due to kerning
popViewport()
pushViewport(viewport(layout.pos.row=8,
                      layout.pos.col=1))
grid.picture(testpagetext)
popViewport()
# NEW PAGE
grid.newpage()
picturePaths(testpage, col="grey", fill=NA, freeScales=TRUE)
# NEW PAGE
grid.newpage()
picturePaths(testpagetext, col="grey", fill=NA, freeScales=TRUE)
# NEW PAGE
x <- runif(10)
y <- runif(10)
require(lattice)
xyplot(y ~ x,
       panel=function(x, y, ...) {
           grid.symbols(testpage[21], x, y, 
                        size=unit(5, "mm"),
                        units="native")
       })
