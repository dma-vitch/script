# Project and relative paths as script parameters
param([string]$project, [string]$relPath)

# Let's see if there is an item .hg. If not, report error and quit
if((test-path ".hg") -eq $false ) {
   "You MUST run this at the top of your directory structure and use relative paths"
    return
}

# Call Mercury
& hg clone $project $relPath

# Add data to .hgsub using composite formatting string
add-content -path ".hgsub" -value $("{0} = {1}" -f $relPath, $project)

# Check that .hgsub exists and issue Mercury commands if it does
if(test-path ".hgsub") {
    hg add .hgsub
    hg commit
} else {
    "failure, see error messages above"
}