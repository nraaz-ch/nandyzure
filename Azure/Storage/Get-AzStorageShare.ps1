﻿#Requires -Version 5.0
#Requires -Modules Az.Storage

<#
    .SYNOPSIS
        Gets a list of file shares
    
    .DESCRIPTION  
        
    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Az.Storage

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Azure/Storage  

    .Parameter StorageAccountName 
        [sr-en] Specifies the name of the Storage account
        [sr-de] Name des Storage Accounts
        
    .Parameter ResourceGroupName
        [sr-en] Specifies the name of the resource group
        [sr-de] Name der resource group

    .Parameter Name 
        [sr-en] Specifies the name of the file share
        [sr-de] Name der Dateifreigabe

    .Parameter Prefix 
        [sr-en] Specifies the prefix for file shares
        [sr-de] Präfix, das im Namen der Dateifreigabe verwendet wird

    .Parameter ConcurrentTaskCount 
        [sr-en] Specifies the maximum concurrent network calls
        [sr-de] Maximale gleichzeitige Netzwerk calls

    .Parameter Properties
        [sr-en] List of properties to expand. Use * for all properties
        [sr-de] Liste der zu anzuzeigenden Eigenschaften. Verwenden Sie * für alle Eigenschaften
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [string]$Name,
    [string]$Prefix,
    [int]$ConcurrentTaskCount = 10,
    [ValidateSet('*','Name','LastModified','IsSnapshot','SnapshotTime','Quota','CloudFileShare','ShareClient','ShareProperties')]
    [string[]]$Properties = @('Name','LastModified','IsSnapshot','SnapshotTime','Quota')
)

Import-Module Az.Storage

try{
    if($Properties -contains '*'){
        $Properties = @('*')
    }
    $azAccount = $null
    GetAzureStorageAccount -AccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -StorageAccount ([ref]$azAccount)
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'Context' = $azAccount.Context
                            'ConcurrentTaskCount' = $ConcurrentTaskCount
    }
    if([System.String]::IsNullOrWhiteSpace($Name) -eq $false){
        $cmdArgs.Add('Name',$Name)
    }
    elseif([System.String]::IsNullOrWhiteSpace($Prefix) -eq $false){
        $cmdArgs.Add('Prefix',$Prefix)
    }
    
    $ret = Get-AzStorageShare @cmdArgs | Select-Object $Properties

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret 
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw
}
finally{
}