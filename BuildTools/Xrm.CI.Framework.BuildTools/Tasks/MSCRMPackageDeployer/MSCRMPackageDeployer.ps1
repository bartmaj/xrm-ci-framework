[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackageDeployer.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$packageName = Get-VstsInput -Name packageName -Require
$packageDirectory = Get-VstsInput -Name packageDirectory -Require
$crmSdkVersion = Get-VstsInput -Name crmSdkVersion -Require

#TFS Release Parameters
$artifactsFolder = $env:AGENT_RELEASEDIRECTORY

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "packageName = $packageName"
Write-Verbose "packageDirectory = $packageDirectory"
Write-Verbose "artifactsFolder = $artifactsFolder"
Write-Verbose "crmSdkVersion = $crmSdkVersion"

#Script Location
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script Path: $scriptPath"

$LogFile = "$packageDirectory" +"\Microsoft.Xrm.Tooling.PackageDeployment-" + (Get-Date -Format yyyy-MM-dd) + ".log"

$PackageDeploymentPath = "$scriptPath\Lib\PackageDeployment\$crmSdkVersion"

try
{
	& "$scriptPath\Lib\xRMCIFramework\$crmSdkVersion\DeployPackage.ps1" -CrmConnectionString $crmConnectionString -PackageName $packageName -PackageDirectory $packageDirectory -LogsDirectory $packageDirectory -PackageDeploymentPath $PackageDeploymentPath
}
finally
{
	Write-Host "Locating log file: $LogFile"

	if (Test-Path $LogFile -PathType Leaf)
	{
		Write-Host "Writing Contents of Log File..."
		Write-Host "------------------------------------------"
		Get-Content $LogFile
		Write-Host "------------------------------------------"
	}
}

Write-Verbose 'Leaving MSCRMPackageDeployer.ps1'
