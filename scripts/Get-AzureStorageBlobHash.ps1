#Requires -Modules Az.Storage, Az.Accounts
[Cmdletbinding()]
param (

    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory=$true)]
    [string]$StorageAccountResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$StorageBlobNameName,

    [Parameter(Mandatory=$true)]
    [string]$StorageContainerName

)

$Context = (Get-AzStorageAccount -ResourceGroupName $StorageAccountResourceGroupName -StorageAccountName $StorageAccountName).Context
[Convert]::ToHexString((Get-AzStorageBlob -Context $Context -Container $StorageContainerName -Blob $StorageBlobNameName).BlobProperties.ContentHash)
