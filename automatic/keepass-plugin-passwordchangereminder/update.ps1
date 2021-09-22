import-module au

$releases = 'https://github.com/tiuub/PasswordChangeReminder/releases'

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
        }
    }
}

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing #1
     $regex   = '\.plgx$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
     $url     = 'https://github.com' + $url 
     $version = $url -split '/' | select -Last 1 -Skip 1
     $version = $version -replace "v",""#3
     return @{ Version = $version; URL32 = $url }
}

update -NoCheckChocoVersion -ChecksumFor 32