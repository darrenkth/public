##################################################################
# Script for collecting performance metrics of ALL RUNNING VMs   #
##################################################################

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | out-null

$credential = Get-Credential -Message "Please key in the vCenter Server user name and password"
$vCenter = Read-Host "Enter the vCenter name in FQDN format or IP Address"
$sdate = Get-Date (Read-Host "Enter start date of the report(mm/dd/yyyy)")  
$fdate = Get-Date (Read-Host "Enter finish date of the report(mm/dd/yyyy)")
$nsamples = Read-Host "How many samples do you want to retrieve in the specified interval"

$stats = @()
$allvms = @()

Connect-VIServer $vCenter -Credential $credential

$allvms = Get-VM -Name *

foreach($VM in $allvms)
    {
     Write-Host "Collecting data for" $VM "..."
     $stats += Get-Stat -Entity $VM -Common -MaxSamples $nsamples -Start $sdate -Finish $fdate 
    }

$stats | Export-Csv -Path .\PerfStats.csv -Force -NoTypeInformation

Write-Host "`nPerfStats.csv file has been generated in the current directory ..." -ForegroundColor Yellow

Disconnect-VIServer $vCenter -Confirm:$false