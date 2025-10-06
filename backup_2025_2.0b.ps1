# v.1.0.0 (26.10.14)
# backup script that traverses TOP folder structure and ZIPs each SUB folder into non-compressed archives
# great in situations with lots of folders and files
# empty folders are explicitly ignored
# various sanity checks prevents it somewhat from breaking
# nothing is deleted but potentially the archives could be written in the wrong place
#----------------------------------------------------------------------------------------

# v.1.0.1 (12.01.15)
# added "break" if source or destination is not available
# auto mount and dismount of source
#----------------------------------------------------------------------------------------

# v.1.0.2 (16.01.15)
# checks log for errors
#----------------------------------------------------------------------------------------

# v.1.0.3 (30.03.15)
# uses BULK RENAME UTILITY to keep extensions the same
# crashes with too deep folder structure, needs to be imbedded and run inside each folder loop or its related to date issue below
# brc crashes when no "date modified" is present! "(ls your-file-name-here).LastWriteTime = Get-Date" on a non-read-only file can fix this
#----------------------------------------------------------------------------------------

# v.1.0.4 (04.05.15)
# uses IMAGEMAGICK to convert non-jpg images to JPG
# image is converted and original deleted using a recursive loop to check only BMP, GIF and PNG
# scanning an empty folder crashes the program, but the loop prevents this from ever happening
#----------------------------------------------------------------------------------------

# v.1.0.5 (23.02.16)
# brc now also rename jpg-large names
# mogrify now also converts EMF files
#----------------------------------------------------------------------------------------

# v.1.1.0 (14.05.16)
# skip if archive already exists to speed up subsequent runs
#----------------------------------------------------------------------------------------

# v.1.2.0 (18.05.16)
# rearranged whole structure to massively speedup check-and-continue
# color output [new][updated][existing]
#----------------------------------------------------------------------------------------

# v.1.2.1 (19.05.16)
# simplified and cleaned up using functions
#----------------------------------------------------------------------------------------

# v.1.2.2 (01.11.16)
# mogrify discontinued from imagemagick (moved under legacy components)
# ephemeral no longer working...
# check implemented before deleting original
#----------------------------------------------------------------------------------------

# v.1.2.3 (08.04.17)
# added counters for new, updated and existing files
#----------------------------------------------------------------------------------------

# v.1.2.4 (24.07.17)
# source and destination check now a function
# counters did not work, fixed
#----------------------------------------------------------------------------------------

# v.1.2.5 (09.07.18)
# extention .webp added to mogrify
#----------------------------------------------------------------------------------------

# v.1.2.6 (05.12.20)
# zip folder date not same as original source.
# "$subfolder" vs. "$subfolder/*" measured using -bt to be super slow?
#----------------------------------------------------------------------------------------

# v.1.2.7 (13.07.22)
# removes Thumbs.db from folders
#----------------------------------------------------------------------------------------

# v.1.2.8 (16.07.22)
# split combined function into individual ones
#----------------------------------------------------------------------------------------

# v.1.3.0 (20.07.22)
# Thumbs.db now also removed from all sub-folders
# Changed to a mix of CreationTime and LastWriteTime between source and destination
#----------------------------------------------------------------------------------------

# v.1.3.1 (21.10.22)
# split loops and simplify to speedup
# removed double-recursive causing slowdown
#----------------------------------------------------------------------------------------

# v1.4 (10.12.22)
# changed away from legacy mogrify to magick
#----------------------------------------------------------------------------------------

# v1.41 (12.09.23)
# added .crdownload to rename list
#----------------------------------------------------------------------------------------

# v1.43 (14.03.25)
# check source would only output source and not destination, fixed
# simplified with a loopthrough function
# get-childitem replaced with [System.IO.Directory] for massive speed boost
#----------------------------------------------------------------------------------------

# v1.50 (24.03.25)
# system.io with sub-loop of array with extensions replaced get-childitem
# variables for image magic changed to work with system.io
#----------------------------------------------------------------------------------------

# v1.51 (29.03.25)
# fixed that renamed files in folders moved up a level...
# moves log to old if already exists 
# extra variables added to count 
#----------------------------------------------------------------------------------------

# v1.52 (30.03.25)
# extra variables added to count
# now remove files like .txt and .nfo
#----------------------------------------------------------------------------------------

# v1.53 (31.03.25)
# convert to jxl using native binaries (switch to imagemagick when lossless is supported)
# https://www.reddit.com/r/jpegxl/comments/14y2uh6/killing_jpg_by_converting_to_jxl/
# https://www.datahoards.com/lossless-conversion-from-jpg-to-jxl/
#----------------------------------------------------------------------------------------

# v1.54 (03.04.25)
# .diz and .idx added to remove stuff.
# added -literalpath and -SimpleMatch (as . counted as a character!)
#----------------------------------------------------------------------------------------

# v1.60 (05.04.25)
# clean-up with new loopthrough function
#----------------------------------------------------------------------------------------

# v1.61 (06.04.25)
# suppress jxl conversion issues
# missed relplacing a get-childitem with [System.IO.Directory] for faster folder and archive date check!
#----------------------------------------------------------------------------------------

# v1.70 (07.04.25)
# 7zip runs in parallel, instances limited by variable...
# waits for all 7zip instances to finish...
#----------------------------------------------------------------------------------------

# v1.71 (14.04.25)
# converted variable not counting when script is run from prompt, only if run from visualstudio...
# changed variable used within function to type [ref]
# https://superuser.com/questions/1754385/how-to-increment-a-value-in-a-function-in-powershell

# v1.72 (21.04.25)
# limit variable based on cpu and nic.
# errors from deleting files supressed and written in log
#----------------------------------------------------------------------------------------

# v1.73 (21.09.25)
# archive date now changed to latest FILE by traversing files for newest date.
# https://sourceforge.net/p/sevenzip/discussion/45797/thread/04ecb9a980/ (not possible using just 7zip at least...)
# https://forums.powershell.org/t/suppressing-error-output-for-type-conversion-on-null/16213/3
#----------------------------------------------------------------------------------------

# v1.74 (23.09.25)
# optimized a few more variables
#----------------------------------------------------------------------------------------

# v1.75 (28.09.25)
# archive date now changed to latest file or FOLDER by also traversing folders for newest date
#----------------------------------------------------------------------------------------

# v1.76 (30.09.25)
# log parsed before moved into renamed folder, should it fail
#----------------------------------------------------------------------------------------

# v1.77 (05.10.25)
# detection of network interface changed to active one
# logfile created in rootfolder
#----------------------------------------------------------------------------------------

# v2.00 ()
# only use imagemagic to convert to jxl, when lossless is supported?
# duplicate image search?
#----------------------------------------------------------------------------------------

# SOFTWARE REQUIRED
# https://www.7-zip.org/download.html
# https://www.bulkrenameutility.co.uk/Download.php
# https://artifacts.lucaversari.it/libjxl/libjxl/latest/
# https://imagemagick.org/script/download.php

# DUPLICATE IMAGE FINDER (options)
# https://ermig1979.github.io/AntiDupl/english/index.html
# https://github.com/qarmin/czkawka/releases
# https://github.com/ermig1979/AntiDuplX

# if required to run as admin 
# Set-ExecutionPolicy UnRestricted

# clears the screen
Clear-Host

# set variables
$source = "\\192.168.0.3\temp"
$destination = "\\192.168.0.3\backup"
#$destination = "\\192.168.0.3\usbshare1"
$rootfolder = "PICTURES"
$topfolders = (Get-ChildItem -Directory "$source\$rootfolder").Where({$_.Name.Length -eq 3}) | Select-Object -ExpandProperty Name
$extensions = (".gif",".png",".bmp",".emf",".webp")
$unwanted = (".txt",".nfo",".db",".idx",".diz",".url",".exe")
$startdate = Get-Date
$logname = (Get-Date).tostring("ddMMyy_HHmmss") + "_log.txt"
$total = 0
$new = 0
[Ref]$converted = 0
$updated = 0
$exists = 0
if ( (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum -ge 4 ) { $corval = 3 } else { $corval = 1 }
if ( (Get-CimInstance win32_networkadapter -filter "netconnectionstatus = 2" | Select-Object -ExpandProperty Speed)[0]/1000000000 -gt 2 ) { $nicval = 2 } else { $nicval = 1 } 
$limit = $corval + $nicval

# set aliases
set-alias 7z "$env:ProgramFiles\7-Zip\7z.exe"
set-alias brc "$env:ProgramFiles\Bulk Rename Utility\cli\brc64.exe"
set-alias cjxl "$env:ProgramFiles\jxl\cjxl.exe"
set-alias magick "$env:ProgramFiles\ImageMagick\magick.exe"

# check if applications are avaiable
function checkapp($arg1)
{
    if ( !(Test-Path $arg1) )
    {
        Write-Host "Application $arg1 not installed..." -foregroundcolor "red"
        break
    }
}

# archive images in parallel and set archive time with most recent modified file
function turboarchiveimg($arg1)
{
    do { Start-Sleep -Milliseconds 50 } while ( (Get-Process | Where-Object {$_.Name -eq '7z'}).count -gt $limit )
    write-Output "Creating archive: $destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip" >> "$destination\$rootfolder\$logname"
    Start-Process -NoNewWindow (get-alias 7z).Definition -ArgumentList "-mx0 a -tzip -stl `"$destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip`" `"$arg1`" -bso0 -bsp0"
}

# rename extensions in all subfolder
function renameimg($arg1)
{
    brc /EXECUTE /TIDYDS /NOFOLDERS /NODUP /PATTERN:"*.jpg.crdownload *.jfif *.jpeg *.jpe *.jpg-large" /FIXEDEXT:".jpg" /DIR:"$arg1" >> "$destination\$rootfolder\$logname" 2>&1
}

# remove unwanted files
function removestuff($arg1)
{
    ForEach ( $ext in $unwanted )
    {
        foreach ( $file in [system.io.directory]::EnumerateFiles("$arg1","*",[System.IO.SearchOption]::AllDirectories) | Select-String -SimpleMatch "$ext" )
        {
            Remove-Item -literalpath "$file" >$null 2>&1
            if (!$?) { write-Output "Unable to remove file: $file" >> "$destination\$rootfolder\$logname" }
        }
    }
}

# change folder-date to that of latest file or folder
function fixdate($arg1)
{
    $dateorg = "0"
    foreach ( $file in [system.io.directory]::EnumerateFiles($arg1) )
    {
        if ( [System.IO.File]::GetLastWriteTime($file).Ticks -gt $dateorg )
        {
            $dateorg=[System.IO.File]::GetLastWriteTime($file).Ticks
        }        
    }
    foreach ( $folder in [system.io.directory]::EnumerateDirectories($arg1) )
    {
        if ( [System.IO.File]::GetLastWriteTime($folder).Ticks -gt $dateorg )
        {
            $dateorg=[System.IO.File]::GetLastWriteTime($folder).Ticks
        }      
    }
}

# convert to jpg and remove original (should be changed directly to JXL eventually)
function convertimg($arg1)
{
    ForEach ( $ext in $extensions )
    {
        foreach ( $file in [system.io.directory]::EnumerateFiles("$arg1","*",[System.IO.SearchOption]::AllDirectories) | Select-String -SimpleMatch "$ext" )
        {
            $leftpart = [System.IO.Path]::GetFileNameWithoutExtension("$file")+".jpg"
            $joinedvar = "$file".TrimEnd("$file".split("\")[-1])+"$leftpart"
            magick $file $joinedvar
            if ( [System.IO.File]::Exists("$joinedvar") )
            {
                [System.IO.File]::SetLastWriteTime($joinedvar, $([System.IO.File]::GetLastWriteTime($file).Ticks))
                Remove-Item -literalpath $file
                write-output "Converted file:" $file >> "$destination\$rootfolder\$logname"
                $converted.Value++
            }
            else
            {
                write-output "Issues with conversion:" "$file" >> "$destination\$rootfolder\$logname"
            }
        }
    }
}

# convert jpg to jxl(lossless) with orignal date-time and remove original
function losslessjxl($arg1)
{
	foreach ( $file in [system.io.directory]::EnumerateFiles("$arg1","*",[System.IO.SearchOption]::AllDirectories) | Select-String -SimpleMatch ".jpg" )
    {
        $leftpart = [System.IO.Path]::GetFileNameWithoutExtension("$file")+".jxl"
	    $joinedvar = "$file".TrimEnd("$file".split("\")[-1])+"$leftpart"
        cjxl "$file" "$joinedvar" --lossless_jpeg=1 --quiet >$null 2>&1
        if ( [System.IO.File]::Exists("$joinedvar") )
        {
            [System.IO.File]::SetLastWriteTime($joinedvar, $([System.IO.File]::GetLastWriteTime($file).Ticks))
            Remove-Item -literalpath $file
            write-output "Converted file:" "$file" >> "$destination\$rootfolder\$logname"
            $converted.Value++
        }
        else
        {
            write-output "Issues with conversion:" "$file" >> "$destination\$rootfolder\$logname"
        }
    }
}

# loops through all folders individually to allow output after each folder is processed
function loopthrough()
{
    foreach ( $folder in [system.io.directory]::EnumerateDirectories("$source\$rootfolder\$topfolder\$subfolder","*",[System.IO.SearchOption]::AllDirectories) )
    {
        #folders inside subfolder...
        removestuff $folder
        renameimg $folder
        convertimg $folder
        losslessjxl $folder
        fixdate $folder
    }
    #top of subfolder...
    removestuff $source\$rootfolder\$topfolder\$subfolder
    renameimg $source\$rootfolder\$topfolder\$subfolder
    convertimg $source\$rootfolder\$topfolder\$subfolder
    losslessjxl $source\$rootfolder\$topfolder\$subfolder
    fixdate $source\$rootfolder\$topfolder\$subfolder  
}

# output information
function textout($arg1, $arg2)
{
    Write-Host "$topfolder" "- " -f gray -nonewline; Write-Host "$subfolder" -f white -nonewline; Write-Host " $arg1" -f "$arg2"
}

# check target and source
function checktarget($arg1)
{
    if ( !(Test-Path "$arg1") )
    {
        Write-Host "$(("$arg1").Split("\")[-1]) folder unavailable..." -foregroundcolor "red" 
        break
    }
}

# -------------------------------------------------
# MAIN PROGRAM
# -------------------------------------------------

# check if programs are installed and available
checkapp (get-alias brc).Definition
checkapp (get-alias 7z).Definition
checkapp (get-alias magick).Definition
checkapp (get-alias cjxl).Definition

# check if SOURCE and DESTINATION are available
checktarget $source
checktarget $destination

# create subfolder in target
if( !(Test-Path -Path "$destination\$rootfolder") )
{
    New-Item -ItemType directory -Path "$destination\$rootfolder" | Out-Null
}

# loop through only select top-level folders...
foreach ( $topfolder in $topfolders )
{
    foreach ( $subfolder in [system.io.directory]::EnumerateDirectories("$source\$rootfolder\$topfolder") | ForEach-Object { $_.split("\")[-1] } )
    {
        # skip empty topfolders
        if ( ([system.io.directory]::EnumerateFiles("$source\$rootfolder\$topfolder\$subfolder","*",[System.IO.SearchOption]::AllDirectories) | Select-String -Pattern ".*").count -gt 0 )
        {
            # create archive if none exists
            if ( ![System.IO.File]::Exists("$destination\$rootfolder\$topfolder\$subfolder.zip") )
            {
                textout new green
                $new++
                loopthrough
                turboarchiveimg $source\$rootfolder\$topfolder\$subfolder
            }
            else
            {
                # update existing archive or skip if unchanged
                if ( [System.IO.Directory]::GetLastWriteTime("$source\$rootfolder\$topfolder\$subfolder") -gt [System.IO.File]::GetCreationTime("$destination\$rootfolder\$topfolder\$subfolder.zip") )
                {
                    textout updated yellow
                    $updated++
                    loopthrough
                    turboarchiveimg $source\$rootfolder\$topfolder\$subfolder
                }
                else
                {
                    textout exists darkgreen
                    $exists++
                }
            }
        }
    }
}

# write start and end time to log
$startdate >> "$destination\$rootfolder\$logname"
Get-date >> "$destination\$rootfolder\$logname"

# count number of files in each subfolder and add to total
foreach ( $topfolder in Get-ChildItem -Path "$destination\$rootfolder" | Where-Object{ $_.PSIsContainer } | Select-Object -ExpandProperty Name )
{
    $total+=(get-childitem "$destination\$rootfolder\$topfolder").count
}
# display data and write to log
write-host "`nTotal number of archives: $total"
write-Output "Total number of archives: $total" >> "$destination\$rootfolder\$logname"
write-host "New archives: $new"
write-Output "New archives: $new" >> "$destination\$rootfolder\$logname"
write-host "Updated archives: $updated"
write-Output "Updated archives: $updated" >> "$destination\$rootfolder\$logname"
write-host "Existing archives: $exists"
write-Output "Existing archives: $exists" >> "$destination\$rootfolder\$logname"
write-host "Number of converted images:" $converted.Value
write-Output "Number of converted images:" $converted.Value >> "$destination\$rootfolder\$logname"

# wait until all 7zip instances are finished
do { Start-Sleep -Seconds 1 } while ( (Get-Process | Where-Object {$_.Name -eq '7z'}).count -gt 0 )

# parse log for errors
$errors = (select-string $destination\$rootfolder\$logname -pattern "error:")
if ( $errors.count -ge 1 )
{
    write-host $errors.count "Error(s) found in log!" -foregroundcolor "red"    
}
else
{
    write-host "No errors in log!" -foregroundcolor "green"
}

# parse log for issues
$issues = (select-string $destination\$rootfolder\$logname -pattern "issues")
if ( $issues.count -ge 1 )
{
    write-host $issues.count "Issue(s) found in log!" -foregroundcolor "yellow"
}
else
{
    write-host "No issues in log!" -foregroundcolor "green"
}

# append current date and size to folder name
$newname = "$rootfolder($("{0:N2}" -f ((Get-ChildItem $destination\$rootfolder\ -recurse | Measure-Object -property length -sum).sum / 1GB) + "GB"), $total Files)"
Rename-Item -literalpath "$destination\$rootfolder" "$destination\$newname"