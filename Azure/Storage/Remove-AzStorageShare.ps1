﻿#Requires -Version 5.0
#Requires -Modules Az.Storage

<#
    .SYNOPSIS
        Deletes a file share
    
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
        [sr-en] Specifies the name of the share
        [sr-de] Name der Dateifreigabe

    .Parameter IncludeAllSnapshot
        [sr-en] Remove File Share with all of its snapshots
        [sr-de] Dateifreigabe inklusive aller Snapshots löschen

    .Parameter ConcurrentTaskCount 
        [sr-en] Specifies the maximum concurrent network calls
        [sr-de] Maximale gleichzeitige Netzwerk calls
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [switch]$IncludeAllSnapshot,
    [int]$ConcurrentTaskCount = 10
)

Import-Module Az.Storage

try{
    $azAccount = $null
    GetAzureStorageAccount -AccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -StorageAccount ([ref]$azAccount)
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'Context' = $azAccount.Context
                            'Name' = $Name
                            'Force' = $null
                            'Confirm' = $false
                            'IncludeAllSnapshot' = $IncludeAllSnapshot
                            'ConcurrentTaskCount' = $ConcurrentTaskCount
    }
    
    $null = Remove-AzStorageShare @cmdArgs

    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Share $($Name) removed"
    }
    else{
        Write-Output "Share $($Name) removed"
    }
}
catch{
    throw
}
finally{
}