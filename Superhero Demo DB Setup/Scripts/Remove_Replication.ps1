# full credit goes to https://jesspomfret.com/dbatools-repl-remove/
$servername = ''
$cred = Get-Credential
$pubname = 'ReplTest'
$sourcedb = 'Superheroes'
$subscripDB = 'Superheroes_Repl'

# remove subscription# to remove:
 $sub = @{
     SqlInstance           = $servername
     Database              = $sourcedb
     SubscriberSqlInstance = $servername
     SubscriptionDatabase  = $subscripDB
     PublicationName       = $pubname
}
Remove-DbaReplSubscription @sub -SqlCredential $cred

# Remove articles
#example 
#$article = @{
#    SqlInstance = 'sql1'
#    Database    = 'AdventureWorksLT2022'
#    Publication = 'testpub'
#    Schema      = 'salesLT'
#    Name        = 'customer'
#    WhatIf      = $true
#}
#Remove-DbaReplArticle @article -SqlCredential $cred

# create the list and undo all of these
$tables = 'Alter_Ego',
'Alter_Ego_Person',
'Comic_Universe',
'Person'

$article = @{
    SqlInstance = $servername
    Database    = $sourcedb
    Publication = $pubname
    Schema      = 'dbo'
}

$tables | ForEach-Object {
    Remove-DbaReplArticle @article -SqlCredential $cred -Name $_
}

#remove publication
$pub = @{
    SqlInstance = $servername
    Database    = $sourcedb
    Name        = $pubname
}
Remove-DbaReplPublication @pub -SqlCredential $cred

#disable publishing
Disable-DbaReplPublishing -SqlInstance $servername -SqlCredential $cred

#disable distributor
Disable-DbaReplDistributor -SqlInstance $servername -SqlCredential $cred

Get-DbaReplServer -SqlInstance $servername -SqlCredential $cred
