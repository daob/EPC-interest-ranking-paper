#!/bin/bash

gs -sOutputFile=ideal-points.pdf -sDEVICE=pdfwrite -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH <(pdftops -level3sep ideal-points-color.pdf -)

pdfcrop ideal-points.pdf ideal-points.pdf
