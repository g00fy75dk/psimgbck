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

# v1.78 (23.10.25)
# wrong use of [System.IO.File] changed to [System.IO.Directory] for changing date of folder
# empty folders skiped and logged to avoid errors when applying date
#----------------------------------------------------------------------------------------

# v1.79 (15.11.25)
# check if folder exists, in case it has been removed
# test-paths replaced with [system.io.directory]::Exists
#----------------------------------------------------------------------------------------

# v1.80 (23.12.25)
# missed -force in a couple of places, causing errors from time to time when trying to remove files
#----------------------------------------------------------------------------------------

# v1.83 (17.05.26)
# changed match string using EndsWith() instead
# logic-bug in loopthrough function
# remove_stuff function simplified
# fixdate function vectorized
#----------------------------------------------------------------------------------------

# v1.84 (24.05.26)
# checkapp checked for directory instead of file
# convertimg optimized
# scan loop optimized
# checks if jpg is webp
#----------------------------------------------------------------------------------------

# v1.85 (25.05.26)
# deletes jpg images if size is 0
# loopthrough function simplified
#----------------------------------------------------------------------------------------

# 1.90 (29.05.2026)
# re-encode jpg images with issues, using same settings as the original
#----------------------------------------------------------------------------------------

# 1.91 (31.06.2026)
# re-encode moved into jxl
# check and fix image combined
# logs using streaming function
# converts images with CMYK to -colorspace sRGB for jxl encodingg to work
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
$destination = "d:\BACKUP"
$rootfolder = "PICTURES"
$topfolders = (Get-ChildItem -Directory "$source\$rootfolder").Where({$_.Name.Length -eq 3}) | Select-Object -ExpandProperty Name
$extensions = (".gif",".png",".bmp",".emf",".webp")
$unwanted = (".html",".txt",".nfo",".db",".idx",".diz",".url",".exe",".download",".css")
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
    if ( ![system.io.file]::Exists("$arg1") )
    {
        Write-Host "Application $arg1 not installed..." -foregroundcolor "red"
        break
    }
}

# check target and source
function checktarget($arg1)
{
    if ( ![system.io.directory]::Exists("$arg1") )
    {
        Write-Host "$(("$arg1").Split("\")[-1]) folder unavailable..." -foregroundcolor "red" 
        break
    }
}

function Write-Log($arg1)
{
    Add-Content -LiteralPath $destination\$rootfolder\$logname -Value $arg1 -Encoding UTF8
}

# archive images in parallel and set archive time with most recent modified file
function turboarchiveimg($arg1)
{
    do { Start-Sleep -Milliseconds 50 } while ( (Get-Process | Where-Object {$_.Name -eq '7z'}).count -gt $limit )
    Write-Log("Creating archive: $destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip")
    Start-Process -NoNewWindow (get-alias 7z).Definition -ArgumentList "-mx0 a -tzip -stl `"$destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip`" `"$arg1`" -bso0 -bsp0"
}

# tidy extensions
function renameimg($arg1)
{
    brc /QUIET /EXECUTE /TIDYDS /NOFOLDERS /NODUP /PATTERN:"*.jpg.crdownload *.jfif *.jpeg *.jpe *.jpg-large" /FIXEDEXT:".jpg" /DIR:"$arg1"
}

# loop through and remove unwanted files
function removestuff($arg1)
{    
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*", [System.IO.SearchOption]::AllDirectories))
    {
        if (([System.IO.FileInfo]$file).Length -eq 0)
        {
            Remove-Item -force -literalpath "$file"
        }
        if ($unwanted -contains ([System.IO.FileInfo]$file).Extension.ToLower())
        {
            Remove-Item -force -literalpath "$file" >$null 2>&1
            if (!$?) { Write-Log("Unable to remove file: $file") }
        }
    }
}


# change folder-date to that of latest file/folder and remove empty folders
function fixdate($arg1)
{
    $dateorg = [datetime]::MinValue.Ticks
    foreach ( $file in [System.IO.Directory]::EnumerateFileSystemEntries($arg1) )
    {
        if ( [System.IO.File]::GetLastWriteTime($file).Ticks -gt $dateorg )
        {
            $dateorg=[System.IO.File]::GetLastWriteTime($file).Ticks
        }        
    }
    if ( $dateorg -gt [datetime]::MinValue.Ticks )
    {
        [System.IO.Directory]::SetLastWriteTime($arg1, $dateorg)
    }
    else
    {
        Write-Log("Deleted empty folder: $arg1")
        Remove-Item -force -LiteralPath "$arg1" >$null 2>&1
    }
}

# get image type
function chckimg($arg1) {
    # Read first 512 bytes (JPEG subtype markers appear later)
    # Convert Int32 → Byte (0–255)
    $bytes = $(Get-Content -LiteralPath $arg1 -AsByteStream -TotalCount 512) | ForEach-Object { [byte]$_ }
    # --- WEBP (RIFF....WEBPVP8?) ---
    if ($bytes.Length -ge 16 -and
        $bytes[0] -eq 0x52 -and $bytes[1] -eq 0x49 -and $bytes[2] -eq 0x46 -and $bytes[3] -eq 0x46) {
        # Extract VP8?, bytes 12–15
        $codec = -join ($bytes[12..15] | ForEach-Object { [char]$_ })
        # if jpg image is webp, rename extenstion
        Rename-Item -LiteralPath $arg1 -NewName ([IO.Path]::ChangeExtension($arg1, ".webp"))
        # function only works on folder, but im lazy...
        convertimg ("$([System.IO.Path]::GetDirectoryName($file))")
        return "WEBP ($codec)"
    }
    # --- JPEG (FF D8 FF) ---
    if ($bytes.Length -ge 3 -and
        $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF) {
        # Look for baseline (FFC0) or progressive (FFC2)
        for ($i = 0; $i -lt $bytes.Length - 1; $i++) {
            if ($bytes[$i] -eq 0xFF) {
                switch ($bytes[$i+1]) {
                    0xC0 { return "JPEG (Baseline)" }
                    0xC2 { return "JPEG (Progressive)" }
                }
            }
        }
        return "JPEG (Subtype not found)"
    }
}

# convert to jpg and remove original (should be changed directly to JXL eventually)
function convertimg($arg1)
{
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*", 'AllDirectories'))
    {
        $ext = [IO.Path]::GetExtension($file).ToLower()
        if ($extensions -contains $ext)
        {
            $folder = [IO.Path]::GetDirectoryName($file)
            $newfile = Join-Path $folder ([IO.Path]::GetFileNameWithoutExtension($file) + ".jpg")
            magick $file $newfile
            if ([System.IO.File]::Exists($newfile))
            {
                [System.IO.File]::SetLastWriteTime($newfile, [System.IO.File]::GetLastWriteTime($file))
                Remove-Item -Force -LiteralPath $file
                Write-Log("Converted file: $file")
                $converted.Value++
            }
            else
            {
                Write-Log("Issues with conversion: $file")
            }
        }
    }
}


# convert jpg to jxl(lossless) with orignal date-time and remove original
function losslessjxl($arg1)
{
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*.jpg", 'AllDirectories'))
    {
        $leftpart = [System.IO.Path]::GetFileNameWithoutExtension("$file")+".jxl"
	    $joinedvar = "$file".TrimEnd("$file".split("\")[-1])+"$leftpart"
        cjxl "$file" "$joinedvar" --lossless_jpeg=1 --quiet >$null 2>&1
        if ( [System.IO.File]::Exists("$joinedvar") )
        {
            [System.IO.File]::SetLastWriteTime($joinedvar, $([System.IO.File]::GetLastWriteTime($file).Ticks))
            Remove-Item -force -literalpath $file
            Write-Log("Converted file: $file")
            $converted.Value++
        }
        else
        {
            Write-Log("Issues with conversion")
            Write-Log(magick identify $file)
            # very slow, only try this if it must
            # checks if jpg is webp, renames and converts to jxl
            Write-Log(chckimg $file)

            $info = magick identify -verbose "$file" 2>&1
            # delete file if not an image
            #if (($info) = magick identify -verbose "$file" 2>&1) {Remove-Item -force -literalpath $file}
            #if (!($info | Select-String "jpeg:sampling-factor"))
            #{
            #    write-host $file
            #    $parts = (($info | Select-String "jpeg:sampling-factor")[0].ToString().Split(":")[2].Trim().Split(",")[0]).Split("x")
            #}
            $parts = (($line = ($info | Select-String "jpeg:sampling-factor" | Select-Object -First 1)) ? $line.ToString().Split(":")[2].Trim().Split(",")[0].Split("x") : $null)
           
            if ($parts.Count -ge 2)
            {
                $jpegSampling = "4:{0}:{1}" -f $parts[0], $parts[1]
            }
            else
            {
                $jpegSampling = "4:2:2"
            }

            $quality = ( ($m = $info | Select-String "Quality:" 2>$null) ? ($m.ToString().Split(":")[1].Trim()) : 92 )

            magick  $file -sampling-factor $jpegSampling -quality $quality -strip "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" >$null 2>&1
            cjxl --quiet --lossless_jpeg=1 "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jxl" >$null 2>&1
            if (!$?)
            {
                magick $file -colorspace sRGB -sampling-factor 4:2:2 -quality $quality -strip "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" >$null 2>&1
                cjxl --quiet --lossless_jpeg=1 "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" "$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jxl" >$null 2>&1
            }
            [System.IO.File]::SetLastWriteTime("$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jxl", [System.IO.File]::GetLastWriteTime("$file"))
            if ( [System.IO.File]::Exists("$([System.IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jxl") )
            {
                Remove-Item $file, (Join-Path (Split-Path $file) ("$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg"))
            }
            else
            {
                Remove-Item (Join-Path (Split-Path $file) ("$([IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg"))
            }
        }
    }
}

# loops through all folders individually to allow output after each folder is processed
function loopthrough()
{
    foreach ($folder in @("$source\$rootfolder\$topfolder\$subfolder") + [System.IO.Directory]::EnumerateDirectories("$source\$rootfolder\$topfolder\$subfolder", "*", 'AllDirectories'))
    {
        removestuff $folder
        renameimg $folder
        convertimg $folder
        losslessjxl $folder
        fixdate $folder
    }
}

# output information
function textout($arg1, $arg2)
{
    Write-Host "$topfolder" "- " -f gray -nonewline; Write-Host "$subfolder" -f white -nonewline; Write-Host " $arg1" -f "$arg2"
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
if ( ![system.io.directory]::Exists("$destination\$rootfolder") )
{
    New-Item -ItemType directory -Path "$destination\$rootfolder" | Out-Null
}

# loop through only select top-level folders...
foreach ( $topfolder in $topfolders )
{
    foreach ( $subfolder in [system.io.directory]::EnumerateDirectories("$source\$rootfolder\$topfolder") | ForEach-Object { $_.split("\")[-1] } )
    {
        # skip empty topfolders
        if ([System.IO.Directory]::EnumerateFiles("$source\$rootfolder\$topfolder\$subfolder","*", 'AllDirectories').GetEnumerator().MoveNext())
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
Write-Log($startdate)
Write-Log(Get-date)

# count number of files in each subfolder and add to total
foreach ($folder in [System.IO.Directory]::EnumerateDirectories("$destination\$rootfolder"))
{
    $total += [System.IO.Directory]::GetFiles($folder).Length
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

# parse log for deleted empty folders
$empty = (select-string $destination\$rootfolder\$logname -pattern "empty")
if ( $empty.count -ge 1 )
{
    write-host $empty.count "empty folders deleted" -foregroundcolor "yellow"    
}

# append current date and size to folder name
$newname = "$rootfolder($("{0:N2}" -f ((Get-ChildItem $destination\$rootfolder\ -recurse | Measure-Object -property length -sum).sum / 1GB) + "GB"), $total Files)"
Rename-Item -literalpath "$destination\$rootfolder" "$destination\$newname"
