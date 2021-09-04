# Powered by Yuanlei Huang 1.21.0711.2129
$SHGIC_LOGO =
"                                             .,,:::::.                        
                                   ,:;iiiiiiii;;;;;;;;;.                      
                             :i1111iiiiiiiiiiiiiii;;;;;;;,                    
                        .itt1111111111111iiiiiiiiiiiiii;;;i,                  
                     ,tfttttttt11111111111111111iiiiiiiiiiiii:                
                   1ftttttttttttttt1i:,.                                      
                 ifffffftttfti:                                               
                tffffffff1.                                                   
               :Lffffff;           .,:;;iii11111111ii:.                       
               :Lfffff.                         .:11iii11,                    
                iLffL; :t1;.                       i111111i                   
                 .fLLi :1111tttt1i;;;;;;i1ttfLi    i1111111;                  
                    iG: it11tttttttttffffLf;     ,11111111t;                  
                          ;1ttttffffff1:      .itttt11111t1                   
                                          ,ittttttttttttt;                    
                                ..,:i1tfffttttttttttttf;                      
                         .fLLLLLLfffffffffffffffffffi.                        
                         1LfLLLLLLLLLLLLLLLLffLLf;                            
                        ;LfLLLLLLLLLLLfffLLL1:                                
                       .fLLLLLLLfffLLLfi:                                     
                       tLffLLLLf1;,                                           
                      ;fi:,                                                   
                                                                              
                    ...                   ...                                 
.LLLLLLLGCCGLLLLLf, :CCL :LffffGCCLG8t  .GCG:LLLLGCCCLLLL, :GLC88CGCCCCCCGGG; 
.C8L,,,,,,,,;;;,LC8: .,:.;CC;.,,LCL,,,  LCC1.iiiiiiiiiiii. :CCGLLLLLLLLLLGCC; 
 :;:::::::::LCG;:;:,C88t ;CCGGGL1CC1LL 1LGCL,111111111111. :CCGLLLLLLLLLLGCC; 
 tfttttftttfGCGftff. G81 ;CC:;CC,tCCC:   GCL:CCCCCCCCCCCC, ;88GffffffffffG8C, 
    G8C,    LCG.    .G81 ;CC,;CC,.CC1    GCL:GGCCCCCCCCGC, .ii:1t; :t1   :11. 
     1CCi   LCG     .G81 ;CC,;CC,i8CL    GCL:CC;      ;8C: i8L;GC1 ,C8i  .CC1 
        :8C8C8t      f88ft8G188L;8CC81   G8G:C8LffffffG8G. G8t L8CGGGGGGC;f8G 
"

<#

Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
Write-Host "PowerShell Common initializing..." -ForegroundColor Yellow
Start-Sleep -Seconds 1

$powershell_common_file_name = "common.ps1";
$powershell_common_file_path = (Split-Path -Parent $MyInvocation.MyCommand.Definition) + "\" + $powershell_common_file_name;
$powershell_common_file_uri = "https://raw.githubusercontent.com/shgic/script/main/powershell/common.ps1";
$web_client_object = New-Object System.Net.WebClient;
$web_client_object.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy() 

if (Test-Path -Path $powershell_common_file_path) {
    Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
    Write-Host "Removing ""$powershell_common_file_name""..." -ForegroundColor Yellow

    Remove-Item -Path $powershell_common_file_path
    Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
    Write-Host "Removed ""$powershell_common_file_name""..." -ForegroundColor Yellow
}

$waiting_next_download_seconds = 10
while ($true) {
    try {
        Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
        Write-Host "Downloading ""$powershell_common_file_uri"" => $powershell_common_file_path..." -ForegroundColor Yellow
        $web_client_object.DownloadFile($powershell_common_file_uri, $powershell_common_file_path);
        if (Test-Path -Path $powershell_common_file_path) {
            Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
            Write-Host "Downloaded ""$powershell_common_file_uri""" -ForegroundColor Yellow

            Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
            Write-Host "Loading ""$powershell_common_file_name""..." -ForegroundColor Yellow
            . $powershell_common_file_path;

            println "Loaded ""$powershell_common_file_name""" Yellow
            println "PowerShell Common initaliztion was completed." Green
            Start-Sleep -Seconds 1
            break
        }
    } Catch [System.Exception] {
        Write-Host $Error[0].ToString() -ForegroundColor Red
        Write-Host $Error[0].ScriptStackTrace -ForegroundColor Red
    }
    Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
    Write-Host "Download ""$powershell_common_file_name"" from ""$powershell_common_file_uri"" failed." -ForegroundColor Red

    Write-Host -NoNewline (Get-Date -format "[yyyy/MM/dd HH:mm:ss]")
    Write-Host "Waiting for $waiting_next_download_seconds seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds $waiting_next_download_seconds
}
cls
print_shgic_logo
##################################################################################

#>

function print_shgic_logo {
    Write-Host $SHGIC_LOGO
}

function isFileExists {
    $exists = $false
    if ($args.Count -gt 0) {
        $exists = Test-Path -Path ($args.Get(0))
    }
    return $exists
}

function exec {
    $pipe = ""
    if ($args.Count -gt 0) {
        if (isFileExists $args.Get(0)) {
            $pipe = Start-Process $args.Get(0) -NoNewWindow -Wait | Out-String
            #$console_output_string = . $args.Get(0) | Out-String
        }
    }
    return $pipe
}

function resetCaret {
    Write-Host -NoNewline "`r"
}

$PRINT_ARGS_TEXT_INDEX = 0
$PRINT_ARGS_FOREGROUND_COLOR_INDEX = 1
$PRINT_ARGS_NO_NEW_LINE_INDEX = 2
$PRINT_ARGS_END = 3

function print {
    $now = Get-Date -format "[yyyy/MM/dd HH:mm:ss]"
    Write-Host -NoNewline $now

    $text = if ($args.Count -gt $PRINT_ARGS_TEXT_INDEX) { $args.Get($PRINT_ARGS_TEXT_INDEX) } Else { "" }
    $foregroundColor = if ($args.Count -gt $PRINT_ARGS_FOREGROUND_COLOR_INDEX) { $args.Get($PRINT_ARGS_FOREGROUND_COLOR_INDEX) } Else { [System.ConsoleColor]::White }
    $no_new_line = if ($args.Count -gt $PRINT_ARGS_NO_NEW_LINE_INDEX) { $args.Get($PRINT_ARGS_NO_NEW_LINE_INDEX) } Else { $false }

    if ($no_new_line) {
        Write-Host -NoNewline $text -ForegroundColor $foregroundColor
    } else {
        Write-Host $text -ForegroundColor $foregroundColor
    }
}

function println {
    $text = if ($args.Count -gt $PRINT_ARGS_TEXT_INDEX) { $args.Get($PRINT_ARGS_TEXT_INDEX) } Else {""}
    $foregroundColor = if ($args.Count -gt $PRINT_ARGS_FOREGROUND_COLOR_INDEX) { $args.Get($PRINT_ARGS_FOREGROUND_COLOR_INDEX) } Else { [System.ConsoleColor]::White }
    print $text $foregroundColor $false
}

function reset_caret_and_print {
    resetCaret
    $text = if ($args.Count -gt $PRINT_ARGS_TEXT_INDEX) {$args.Get($PRINT_ARGS_TEXT_INDEX)} Else {""}
    $foregroundColor = if ($args.Count -gt $PRINT_ARGS_FOREGROUND_COLOR_INDEX) { $args.Get($PRINT_ARGS_FOREGROUND_COLOR_INDEX) } Else { [System.ConsoleColor]::White }
    print $text $foregroundColor $true
}

function reset_caret_and_println {
    resetCaret
    $text = if ($args.Count -gt $PRINT_ARGS_TEXT_INDEX) {$args.Get($PRINT_ARGS_TEXT_INDEX)} Else {""}
    $foregroundColor = if ($args.Count -gt $PRINT_ARGS_FOREGROUND_COLOR_INDEX) { $args.Get($PRINT_ARGS_FOREGROUND_COLOR_INDEX) } Else { [System.ConsoleColor]::White }
    print $text $foregroundColor $false
}

function rasdial_connect_vpn($vpn_entry_name) {
    $rasdial = $env:WINDIR + "\System32\rasdial.exe"
    $expression = "$rasdial ""$vpn_entry_name"""
    return Invoke-Expression -Command $expression | Out-String
}

function rasdial_disconnect_vpn($vpn_entry_name) {
    $rasdial = $env:WINDIR + "\System32\rasdial.exe"
    $expression = "$rasdial ""$vpn_entry_name"" /disconnect"
    return Invoke-Expression -Command $expression | Out-String
}

function download_file_from_uri($uri, $location) {
    try{
        $web_client_object = New-Object System.Net.WebClient;
        $web_client_object.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy() 
        $web_client_object.DownloadFile($uri, $location);
    } Catch {
    }
}

function format_time_span($timespan) {
    $durationText = ("{0}:{1}:{2}" -f $timespan.ToString("hh"), $timespan.ToString("mm"), $timespan.ToString("ss"))
    if ($timespan.Days -eq 1) {
        $durationText = ("{0}Day {1}:{2}:{3}" -f $timespan.ToString("dd"), $timespan.ToString("hh"), $timespan.ToString("mm"), $timespan.ToString("ss"))
    } elseif ($timespan.Days -gt 1) {
        $durationText = ("{0}Days {1}:{2}:{3}" -f $timespan.ToString("dd"), $timespan.ToString("hh"), $timespan.ToString("mm"), $timespan.ToString("ss"))
    }
    return $durationText
}