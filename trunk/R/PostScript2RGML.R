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
      "  (curve ) print",
      "  str cvs print ( ) print",
      "  str cvs print (\n) print",
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
      # (width, height) of text
      "  dup true charpath flattenpath mark pathbbox",
      "  ( width=') print",
      # pathbbox has put left, bottom, right, top on stack
      # (indexing is 0-based)
      # Leave this original for height calculation later
      # Calculate width
      # Transform bbox THEN subtract
      #    Pull out right-top
      #    (NOTE: after first index, there is another value on stack)
      "    1 index 1 index",
      #    Transform right-top and pop transformed top
      #    (NOTE: transformed right is now on top of stack)
      "    matrix currentmatrix transform pop",
      #    Pull out left-bottom
      "    4 index 4 index",
      #    Transform left-bottom and pop transformed top
      #    (NOTE: transformed left is now on top of stack)
      "    matrix currentmatrix transform pop",
      # Subtract transformed right - transformed left
      "    sub",
      "    str cvs print (') print",
      # At this point should be back to pathbbox on top of stack
      # DO NOT add to current x for checking against xmin/xmax
      # because current point has already moved to end of text, 
      # so just use currentpoint
      "    currentpoint",
      "    matrix currentmatrix",
      "    transform pop", # Drop (transformed) currentpoint[y]
      "    dup",
      "    convertToR exch /curx exch put",
      "    dup",
      "    convertToR /xmin get lt {convertToR /xmin curx put} if",
      "    convertToR /xmax get gt {convertToR /xmax curx put} if",      
      "  ( height=') print",
      # At this point should be back to pathbbox on top of stack
      # Calculate height
      "    dup 3 index sub",
      # Add to current y for checking against ymin/ymax
      "    currentpoint exch pop add",
      # Get currentpoint[x] so can transform 
      "    currentpoint pop exch", # Drop currentpoint[y]
      "    matrix currentmatrix",
      "    transform exch pop", # Drop (transformed) currentpoint[x]
      "    dup",
      "    convertToR exch /cury exch put",
      "    dup",
      "    convertToR /ymin get lt {convertToR /ymin cury put} if",
      "    convertToR /ymax get gt {convertToR /ymax cury put} if",      
      # At this point should be back to pathbbox on top of stack
      # Transform bbox THEN subtract
      #    Pull out right-top
      #    (NOTE: after first index, there is another value on stack)
      "    1 index 1 index",
      #    Transform right-top and pop transformed right
      #    (NOTE: transformed top is now on top of stack)
      "    matrix currentmatrix transform exch pop",
      #    Pull out left-bottom
      "    4 index 4 index",
      #    Transform left-bottom and pop transformed left
      #    (NOTE: transformed bottom is now on top of stack)
      "    matrix currentmatrix transform exch pop",
      # Subtract transformed top - transformed bottom
      "    sub",
      "    str cvs print (') print",
      # Clean up stack back to pre-pathbbox call
      "  cleartomark",
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
      "/astrokechar {",
      "  exch dup 3 -1 roll",
      "  1 getinterval",
      "  3 index 3 index rmoveto",
      "  true charpath flattenpath",
      "  {mymove} {myline} {mycurve} {myclose}",
      "  mychar",
      "  currentpoint newpath moveto",
      "} def",
      
      if (charpath) {
          c("/show {",
            "  dup length -1 add 0 exch 1 exch {strokechar} for",
            "} def",
            "/ashow {",
            # Do first char without adjustment
            "  0 strokechar",
            # Do remaining chars with adjustment
            "  dup length -1 add 1 exch 1 exch {astrokechar} for",
            "  pop pop pop", # Remove original string plus ax and ay
            "} def")
      } else {
          c("/show {",
            "  mytext",
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
      "%% EOF"
      )

# Perform some post-processing of the XML file that is generated by the
# above PostScript code.
# (e.g., do some character escaping that would be more painful to do
#  in PostScript code)
postProcess <- function(outfilename, enc) {
    processStringLine <- function(stringLine) {
        paste(stringLine[1],
              gsub("&", "&amp;",
                   gsub("<", "&lt;",
                        gsub(">", "gt;",
                             gsub("'", "&apos;",
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
