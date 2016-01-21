Set-NetFirewallProfile -All -DefaultOutboundAction Block

$programs = 
    ('Доступ для Internet Explorer (x86)',
            (${env:ProgramFiles(x86)}+'\Internet Explorer\iexplore.exe')),
    
    ('Доступ для Internet Explorer',
            ($env:ProgramFiles+'\Internet Explorer\iexplore.exe')),
    
    ('Доступ для Google Chrome',
            (${env:ProgramFiles(x86)}+'\Google\Chrome\Application\chrome.exe')),
    
    ('Доступ для Google Update',
            (${env:ProgramFiles(x86)}+'\Google\Update\GoogleUpdate.exe')),
    
    ('Доступ для Tor Browser',
            ($env:USERPROFILE+'\AppData\Local\Tor Browser\Browser\firefox.exe')),
    
    ('Доступ для Tor Browser updater',
            ($env:USERPROFILE+'\AppData\Local\Tor Browser\Browser\updater.exe')),
    
    ('Доступ для Yandex.Browser',
            ($env:USERPROFILE+'\AppData\Local\Yandex\YandexBrowser\Application\browser.exe')),
    
    ('Доступ для Notepad++ (GUP)',
            (${env:ProgramFiles(x86)}+'\Notepad++\updater\GUP.exe')),
    
    ('Доступ для Visual Studio 2015',
            (${env:ProgramFiles(x86)}+'\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe')),
    
    ('Доступ для Blend (Visual Studio)',
            (${env:ProgramFiles(x86)}+'\Microsoft Visual Studio 14.0\Common7\IDE\Blend.exe')),
    
    ('Доступ для qBittorrent',
            (${env:ProgramFiles(x86)}+'\qBittorrent\qbittorrent.exe')),
    
    ('Доступ для HWMonitor',
            ($env:ProgramFiles+'\CPUID\HWMonitor\HWMonitor.exe')),
    
    ('Доступ для OneDrive',
            ($env:USERPROFILE+'\AppData\Local\Microsoft\OneDrive\OneDrive.exe')),
    
    ('Доступ для PowerShell (выключить для безопасности)',
            ($env:SystemRoot+'\System32\WindowsPowerShell\v1.0\powershell.exe')),
    
    ('Доступ для PowerShell ISE (выключить для безопасности)',
            ($env:SystemRoot+'\System32\WindowsPowerShell\v1.0\powershell_ise.exe')),
    
    ('Доступ для Steam',
            (${env:ProgramFiles(x86)}+'\Steam\Steam.exe')),
    
    ('Доступ для steamwebhelper',
            (${env:ProgramFiles(x86)}+'\Steam\bin\steamwebhelper.exe')),
    
    ('Доступ для Steam CS GO',
            ('D:\Games\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo.exe')),
    
    ('Доступ для TeamViewer',
            (${env:ProgramFiles(x86)}+'\TeamViewer\TeamViewer.exe')),
            
    ('Доступ для TeamViewer_Service',
            (${env:ProgramFiles(x86)}+'\TeamViewer\TeamViewer_Service.exe')),

    ('Доступ для explorer.exe',
            ($env:SystemRoot+'\explorer.exe')),

    ('Доступ для AvastUI+',
            ($env:ProgramFiles+'\AVAST Software\Avast\AvastUI.exe')),
    
    ('Доступ для AvastSvc',
            ($env:ProgramFiles+'\AVAST Software\Avast\AvastSvc.exe')),
    
    ('Доступ для Avast планировщик (AvastEmUpdate)',
            ($env:ProgramFiles+'\AVAST Software\Avast\AvastEmUpdate.exe')),
    
    ('Доступ для Avast обновления (instup)',
            ($env:ProgramFiles+'\AVAST Software\Avast\setup\instup.exe')),
 
    ('Доступ для Mozilla Firefox',
            (${env:ProgramFiles(x86)}+'\Mozilla Firefox\firefox.exe'))


foreach($prog in $programs)
{
    try
    {
        New-NetFirewallRule -Program $prog[1] -Action Allow -Profile Any -DisplayName $prog[0] -Direction Outbound
        Write-Host 'Успех: '$prog[0]
    }
    catch
    {
        Write-Host 'Ошибка: '$prog[0]
    }
    Write-Host
}

try
{
    $i = 'Доступ для Windows Update/Modern Apps'
    New-NetFirewallRule -Program ($env:SystemRoot+'\System32\svchost.exe') -Protocol TCP -RemotePort 80, 443 -Action Allow -Profile Any -DisplayName $i -Direction Outbound

    $i = 'Доступ для Avast (служба)'
    New-NetFirewallRule -Service 'avast! Antivirus' -Action Allow -Profile Any -DisplayName $i -Direction Outbound

    $i = 'Доступ для Mozilla Maintenance Service'
    New-NetFirewallRule -Service 'MozillaMaintenance' -Action Allow -Profile Any -DisplayName $i -Direction Outbound
    
    $i = 'Доступ для ping (v4)'
    New-NetFirewallRule -Profile Any -Action Allow -DisplayName $i -Protocol ICMPv4 -IcmpType 8 -Direction Outbound
    
    $i = 'Доступ для ping (v6)'
    New-NetFirewallRule -Profile Any -Action Allow -DisplayName $i -Protocol ICMPv6 -IcmpType 8 -Direction Outbound

    $i = 'Доступ для Службы Магазина Windows'
    New-NetFirewallRule -Service 'WSService' -Action Allow -Profile Any -DisplayName $i -Direction Outbound

    # На редкие исключения, когда огненную стену надо приопустить (при установке программ, например)
    $i = 'Доступ для Частного профиля (выключить)'
    New-NetFirewallRule -Enabled False -Action Allow -Profile Private -DisplayName $i -Direction Outbound

    Write-Host 'Успех при применении особых правил'
}
catch
{
    Write-Host 'Ошибка при применении особых правил на шаге:' $i 
}
Write-Host