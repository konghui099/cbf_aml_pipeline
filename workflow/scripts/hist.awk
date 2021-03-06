#!/bin/awk -f
# https://stackoverflow.com/questions/39614454/creating-histograms-in-bash
# By Riccardo Petraglia


BEGIN{
    bin_width=0.1;

}
{
    bin=int(($1-0.0001)/bin_width);
    if( bin in hist){
        hist[bin]+=1
    }else{
        hist[bin]=1
    }
}
END{
    for (h in hist)
        printf " * > %2.2f  ->  %i \n", h*bin_width, hist[h]
}
