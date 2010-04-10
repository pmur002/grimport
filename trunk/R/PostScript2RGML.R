# Function to extract outlines from PostScript paths

PScaptureText <- c()

PScaptureChars <- c()
    
PScaptureHead <- function(file, charpath, setflat, encoding) {
    c("%!PS-Adobe-2.0 EPSF-1.2",
      "%%BeginProcSet:convertToR 0 0",
      
      # XML file header info
      sprintf("(<?xml version='1.0' encoding='%s' ?>\n\n) print",
              encoding),
      paste("(<picture version='3' xmlns:rgml='http://r-project.org/RGML'",
            " source='", file, "'",
            " date='", as.character(Sys.time()), "'",
            " creator='R (", R.Version()$major, ".", R.Version()$minor, ")'",
            " >\n\n) print", sep=""),
      # useful definitions
      # Define my counters GLOBALLY so the postscript
      # file I run cannot reset my counters with a restore!
      "true setglobal",
      "/convertToR dup 100 dict def load begin",
      "/str 20 string def",
      "/id 1 def",
      # Do these need to be even "larger"?
      "/xmax -99999 def",
      "/xmin  99999 def",
      "/ymax -99999 def",
      "/ymin  99999 def",

      # bounding box processing
      "/boxinit {",
      "  convertToR /bxmax -99999 put",
      "  convertToR /bxmin  99999 put",
      "  convertToR /bymax -99999 put",
      "  convertToR /bymin  99999 put",
      "  } def",
      "/boxmove {",
      "  transform",
      "  dup",
      "  convertToR exch /cury exch put",
      "  dup",
      "  convertToR /bymin get lt {convertToR /bymin cury put} if",
      "  convertToR /bymax get gt {convertToR /bymax cury put} if",
      "  dup",
      "  convertToR exch /curx exch put",
      "  dup",
      "  convertToR /bxmin get lt {convertToR /bxmin curx put} if",
      "  convertToR /bxmax get gt {convertToR /bxmax curx put} if",
      "  } def",
      "/boxline {",
      "  transform",
      "  dup",
      "  convertToR exch /cury exch put",
      "  dup",
      "  convertToR /bymin get lt {convertToR /bymin cury put} if",
      "  convertToR /bymax get gt {convertToR /bymax cury put} if",
      "  dup",
      "  convertToR exch /curx exch put",
      "  dup",
      "  convertToR /bxmin get lt {convertToR /bxmin curx put} if",
      "  convertToR /bxmax get gt {convertToR /bxmax curx put} if",
      "  } def",
      "/boxcurve {",
      " } def",
      "/boxclose {",
      " } def",

      # Update global bbox from bbox
      "/boxupdate {",
      "  convertToR /bymin get convertToR /ymin get lt {convertToR /ymin convertToR /bymin get put} if",
      "  convertToR /bymax get convertToR /ymax get gt {convertToR /ymax convertToR /bymax get put} if",
      "  convertToR /bxmin get convertToR /xmin get lt {convertToR /xmin convertToR /bxmin get put} if",
      "  convertToR /bxmax get convertToR /xmax get gt {convertToR /xmax convertToR /bxmax get put} if",
      " } def",
      
      # path processing
      "/mymove {",
      "  (\t<move) print",
      "  matrix currentmatrix",
      "  transform",
      "  dup",
      "  convertToR exch /ystart exch put",
      "  dup",
      "  convertToR exch /cury exch put",
      "  dup",
      "  convertToR /ymin get lt {convertToR /ymin cury put} if",
      "  dup",
      "  convertToR /ymax get gt {convertToR /ymax cury put} if",
      "  ( y=') print str cvs print (') print",
      "  dup",
      "  convertToR exch /xstart exch put",
      "  dup",
      "  convertToR exch /curx exch put",
      "  dup",
      "  convertToR /xmin get lt {convertToR /xmin curx put} if",
      "  dup",
      "  convertToR /xmax get gt {convertToR /xmax curx put} if",
      "  ( x=') print str cvs print (') print",
      "  (/>\n) print",
      "} def",
      "/myline {",
      "  (\t<line) print",
      "  matrix currentmatrix",
      "  transform",
      "  dup",
      "  convertToR exch /cury exch put",
      "  dup",
      "  convertToR /ymin get lt {convertToR /ymin cury put} if",
      "  dup",
      "  convertToR /ymax get gt {convertToR /ymax cury put} if",
      "  ( y=') print str cvs print (') print",
      "  dup",
      "  convertToR exch /curx exch put",
      "  dup",
      "  convertToR /xmin get lt {convertToR /xmin curx put} if",
      "  dup",
      "  convertToR /xmax get gt {convertToR /xmax curx put} if",
      "  ( x=') print str cvs print (') print",
      "  (/>\n) print",
      "  } def",
      "/mycurve {",
      "  } def",
      "/myclose {",
      # Convert 'closepath' to 'lineto'
      # "  (\t<close/>\n) print",
      "  (\t<line) print",
      "  ( y=') print convertToR /ystart get str cvs print (') print",
      "  ( x=') print convertToR /xstart get str cvs print (') print",
      "  (/>\n) print",
      "  } def",
      
      # echoing graphics state
      "/printcol {",
      "  currentrgbcolor",
      "  (\t\t<rgb) print",
      # make sure the colour is RGB not BGR
      "  ( r=') print 2 index str cvs print (') print",
      "  ( g=') print 1 index str cvs print (') print",
      "  ( b=') print str cvs print (') print",
      "  (/>\n) print",
      "  pop pop",
      "  } def",
      "/printlwd {",
      # lwd is in user coords so transform
      # This will need transforming to a grDevices "lwd" in R
      "  currentlinewidth 0 transform pop",
      "  0 0 transform pop sub",
      "  ( lwd=') print str cvs print (') print",
      "} def",
      "/printdash {",
      "  currentdash",
      # Like lwd, transform user coords
      # Ignore offset
      "  ( lty=') print pop {0 transform pop 0 0 transform pop sub str cvs print ( ) print} forall (') print",
      "} def",      
      "/printstyle {",
      "  (\t\t<style) print",
      "  printlwd",
      "  printdash",
      "  (/>\n) print",
      "} def",

      # print out "closestroke" marker plus graphics state info
      "/mystroke {",
      "  (<path type='stroke') print",
      "  ( id=') print convertToR /id get str cvs print ('>\n) print",
      "  (\t<context>\n) print",
      "  printcol  ",
      "  printstyle",
      "  (\t</context>\n\n) print",
      "  pathforall",
      "  convertToR /id get 1 add convertToR exch /id exch put",
      "  (</path>\n\n) print",
      "} def",
      "/myfill {",
      "  (<path type='fill') print",
      "  ( id=') print convertToR /id get str cvs print ('>\n) print",
      "  (\t<context>\n) print",
      "  printcol",
      "  printstyle",
      "  (\t</context>\n\n) print",
      "  pathforall",
      "  convertToR /id get 1 add convertToR exch /id exch put",
      "  (</path>\n\n) print",
      "} def",
      "/mytext {",
      "  (<text ) print",
      "  ( id=') print convertToR /id get str cvs print (') print",
      # Insert MARKS here so that postProcess() can easily locate strings
      "  ( string='###TEXT) print dup print (###TEXT') print",
      # (x, y) location of text
      "  currentpoint",
      "  matrix currentmatrix",
      "  transform",
      "    dup",
      "    convertToR exch /cury exch put",
      "    dup",
      "    convertToR /ymin get lt {convertToR /ymin cury put} if",
      "    dup",
      "    convertToR /ymax get gt {convertToR /ymax cury put} if",
      "    ( y=') print str cvs print (') print",
      "    dup",
      "    convertToR exch /curx exch put",
      "    dup",
      "    convertToR /xmin get lt {convertToR /xmin curx put} if",
      "    dup",
      "    convertToR /xmax get gt {convertToR /xmax curx put} if",
      "    ( x=') print str cvs print (') print",
      # width of text (reading text horizontally)
      "  dup stringwidth",
      # stringwidth has put wx and wy on stack
      # If wy is non-zero, text is at an angle
      # Save this angle
      "  1 index 1 index exch atan convertToR exch /angle exch put",
      # Calculate user-space width from wx and wy
      "  2 exp exch 2 exp add sqrt",      
      # Transform user-space width to device
      "  0 transform",
      # Subtract (0, 0)[x]
      "  exch 0 0 transform pop sub",
      # Subtract (0, 0)[y]
      "  exch 0 0 transform exch pop sub",
      # If transformed y is non-zero then text is at an angle 
      "  dup 0 ne { 1 index 1 index exch atan } { 0 } ifelse",
      # Record user-space angle plus angle
      "  ( angle=') print",
      "    convertToR /angle get add str cvs print (') print",
      # Calculate device width 
      "  2 exp exch 2 exp add sqrt",
      # Print width
      "  ( width=') print",
      "    str cvs print (') print",
      # Height of text (based on text bounding box)
      # Calculate text bb
      "  dup true charpath flattenpath",
      "  boxinit",
      "  {boxmove} {boxline} {boxcurve} {boxclose} pathforall",
      # Print height
      "  ( height=') print",
      "  convertToR /bymax get convertToR /bymin get sub",
      "    str cvs print (') print",      
      # Update global xmin/xmax/ymin/ymax
      "  boxupdate",
      
      "  (>\n) print",
      "  (\t<context>\n) print",
      "  printcol",
      "  printstyle",
      "  (\t</context>\n\n) print",
      "  convertToR /id get 1 add convertToR exch /id exch put",
      "  (</text>\n\n) print",
      "} def",
      "/mychar {",
      "  (<path type='char') print",
      "  ( id=') print convertToR /id get str cvs print ('>\n) print",
      "  pathforall",
      "  (\t<context>\n) print",
      "  printcol",
      "  printstyle",
      "  (\t</context>\n\n) print",
      "  convertToR /id get 1 add convertToR exch /id exch put",
      "  (</path>\n\n) print",
      "} def",

      # override paint operators
      "/stroke {",
      "  flattenpath {mymove} {myline} {mycurve} {myclose}",
      "  mystroke",
      "  newpath",
      "} def",
      "/fill {",
      "  flattenpath {mymove} {myline} {mycurve} {myclose}",
      "  myfill",
      "  newpath",
      "} def",
      "/eofill {",
      "  flattenpath {mymove} {myline} {mycurve} {myclose}",
      "  myfill",
      "  newpath",
      "} def",
      # text is split into individual characters,
      # each character is converted to a path, flattened
      # and then stroked
      "/strokechar {",
      "  exch dup 3 -1 roll",
      "  1 getinterval", 
      "  true charpath flattenpath",
      "  {mymove} {myline} {mycurve} {myclose}",
      "  mychar",
      # Save current location (starting position for next char),
      # start new path for next char,
      # move to save location
      "  currentpoint newpath moveto",
      "} def",
      "/widthstrokechar {",
      "  exch dup 3 -1 roll",
      "  1 getinterval",
      "  dup",
      "  true charpath flattenpath",
      "  {mymove} {myline} {mycurve} {myclose}",
      "  mychar",
      # Check for special char adjustment
      # (the get converts char to int)
      "  0 get 2 index eq {3 index 3 index rmoveto} if",
      "  currentpoint newpath moveto",
      "} def",
      "/astrokechar {",
      "  exch dup 3 -1 roll",
      "  1 getinterval",
      "  3 index 3 index rmoveto",
      "  true charpath flattenpath",
      "  {mymove} {myline} {mycurve} {myclose}",
      "  mychar",
      "  currentpoint newpath moveto",
      "} def",
      "/awidthstrokechar {",
      "  exch dup 3 -1 roll",
      "  1 getinterval",
      # Do adjustment on every char
      "  3 index 3 index rmoveto",
      "  dup",
      "  true charpath flattenpath",
      "  {mymove} {myline} {mycurve} {myclose}",
      "  mychar",
      # Check for special char adjustment
      "  0 get 4 index eq {5 index 5 index rmoveto} if",
      "  currentpoint newpath moveto",
      "} def",
      
      if (charpath) {
          c("/show {",
            "  dup length -1 add 0 exch 1 exch {strokechar} for",
            "} def",

            "/widthshow {",
            "  dup length -1 add 0 exch 1 exch {widthstrokechar} for",
            "} def",

            "/ashow {",
            # Do first char without adjustment
            "  0 strokechar",
            # Do remaining chars with adjustment
            "  dup length -1 add 1 exch 1 exch {astrokechar} for",
            # Remove original string plus ax and ay
            "  pop pop pop", 
            "} def",

            "/awidthshow {",
            # Do first char without adjustment
            "  4 copy 0 widthstrokechar pop pop pop pop",
            # Do remaining chars with adjustment
            "  dup length -1 add 1 exch 1 exch {awidthstrokechar} for",
            # Remove original string plus ax,ay,char,cx,cy
            "  pop pop pop pop pop pop", 
            "} def")
      } else {
          c("/show {",
            "  mytext",
            "  currentpoint newpath moveto",
            "} def",

            # Ignores the fine placement of characters within a /widthshow
            "/widthshow {",
            "  mytext",
            # Remove the string and cx and cy and char from the /widthshow
            "  pop pop pop pop", 
            "  currentpoint newpath moveto",
            "} def",

            # Ignores the fine placement of characters within an /ashow
            "/ashow {",
            "  mytext",
            "  pop pop pop", # Remove the string and ax and ay from the /ashow
            "  currentpoint newpath moveto",
            "} def",
            
            # Ignores the fine placement of characters within an /awidthshow
            "/awidthshow {",
            "  mytext",
            "  pop pop pop", # Remove the string and ax and ay and
            "  pop pop pop", # char and cx and cy from the /awidthshow
            "  currentpoint newpath moveto",
            "} def")
      },
      
      "end",
      # end global settings
      "false setglobal",
      # Dummy LOCAL dict for top-level defs (e.g., defs
      # of main dictionary) in file to be run
      "/dummy 100 dict def",
      "%%EndProcSet",
      "%% EndProlog",
      "",
      "convertToR begin",
      "dummy begin",
      if (!is.null(setflat)) {
          paste(setflat, "setflat")
      },
      "")
}

PScaptureFoot <-
    c(
      # XML file footer info
      "(<summary count=') print convertToR /id get 1 sub str cvs print (') print",
      "( ymax=') print convertToR /ymax get str cvs print (') print",
      "( ymin=') print convertToR /ymin get str cvs print (') print",
      "( xmax=') print convertToR /xmax get str cvs print (') print",
      "( xmin=') print convertToR /xmin get str cvs print (') print",
      "(/>\n\n) print",
      "(</picture>) print",

      # EOF
      "%% EOF\n"
      )

# Perform some post-processing of the XML file that is generated by the
# above PostScript code.
# (e.g., do some character escaping that would be more painful to do
#  in PostScript code)
postProcess <- function(outfilename, enc) {
    processStringLine <- function(stringLine) {
        paste(stringLine[1],
              gsub("<", "&lt;",
                   gsub(">", "&gt;",
                        gsub("'", "&apos;",
                             gsub("&", "&amp;",
                                  stringLine[2])))),
              stringLine[3],
              sep="")
    }
    # The XML file has been created by ghostscript in ISO-8859-1
    infile <- file(outfilename, "r", enc="ISO-8859-1")
    lines <- readLines(infile)
    close(infile)
    # All string values have been marked 
    stringLines <- grep("###TEXT", lines)
    if (length(stringLines) > 0) {
        stringLinesBits <- strsplit(lines[stringLines], "###TEXT")
        stringLinesMod <- sapply(stringLinesBits, processStringLine)
        lines[stringLines] <- stringLinesMod
    }
    # Write the file using 'enc' encoding
    outfile <- file(outfilename, "w", encoding=enc)
    writeLines(lines, outfile)
    close(outfile)
}

# Generate RGML file from PostScript file
PostScriptTrace <- function(file, outfilename,
                            charpath=TRUE, setflat=NULL,
                            encoding="ISO-8859-1") {
    # Create temporary PostScript file which loads
    # dictionary redefining stroke and fill operators
    # and then runs target PostScript file
    psfilename <- paste("capture", basename(file), sep="")
    psfile <- file(psfilename, "w")
    writeLines(PScaptureHead(file, charpath, setflat, encoding), psfile)
    # Reconstitute file name here to handle Windows-style paths
    # in the file name
    writeLines(paste("(", file.path(dirname(file), basename(file)),
                     ") run", sep=""), psfile)
    writeLines(PScaptureFoot, psfile)
    close(psfile)

    if (missing(outfilename)) {
        outfilename <- paste(basename(file), ".xml", sep="")
    }
    
    # Run temp file using ghostscript
    gscmd <- Sys.getenv("R_GSCMD")
    if (is.null(gscmd) || nchar(gscmd) == 0) {
        gscmd <- switch(.Platform$OS.type,
                        unix = "gs",
                        windows = "gswin32c.exe")
    }
    outfile <- switch(.Platform$OS.type,
                      unix = "/dev/null",
                      windows = tempfile())
    cmd <- paste(gscmd, 
                 " -q -dBATCH -dNOPAUSE -sDEVICE=pswrite -sOutputFile=",
                 outfile, " -sstdout=",
                 outfilename, " ",
                 psfilename, sep="")
    ret <- switch(.Platform$OS.type,
                  unix = system(cmd),
                  windows = system(cmd, invisible = TRUE))
    if(ret != 0) {
        stop(gettextf("status %d in running command '%s'", ret, cmd),
             domain = NA)
    } else {
        postProcess(outfilename, encoding)
    }
    invisible(cmd)
}
