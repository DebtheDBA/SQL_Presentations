#full credit goes to https://jesspomfret.com/dbatools-repl-setup/
$servername = ''
$cred = Get-Credential
$pubname = 'ReplTest'
$sourcedb = 'Superheroes'
$subscripDB = 'Superheroes_Repl'

# confirm that trusted certificate is on
Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true

# confirm 
Get-DbaReplServer -SqlInstance $servername -SqlCredential $cred


#enable distirbutor
Enable-DbaReplDistributor -SqlInstance $servername -SqlCredential $cred

#set up publisher
Enable-DbaReplPublishing -SqlInstance $servername -SqlCredential $cred

# add a transactional publication
New-DbaReplPublication -SqlInstance $servername -SqlCredential $cred -Name $pubname -Type 'Transactional' -Database $sourcedb


#--New-DbaReplCreationScriptOptions

# add articles
# example of adding a single table
#$article = @{
#    SqlInstance = $servername
#    Database    = $sourcedb
#    Publication = $pubname
#    Schema      = 'dbo'
#    Name        = 'Alter_Ego'
#}
#Add-DbaReplArticle @article -SqlCredential $cred

#create the list
$tables = 'Alter_Ego',
'Alter_Ego_Person',
'Comic_Universe',
'Person'

$article = @{
    SqlInstance = $servername
    Database    = $sourcedb
    Publication = $pubname
    Schema      = 'dbo'
#    Name        = 'Alter_Ego'
}

$tables | ForEach-Object {
    Add-DbaReplArticle @article -SqlCredential $cred -Name $_
}

# add the subscription - NOTE: for some reason, I get errors but it seems to work??
$sub = @{
    SqlInstance           = $servername
    Database              = $sourcedb
    SubscriberSqlInstance = $servername
    SubscriptionDatabase  = $subscripDB
    PublicationName       = $pubname
    Type                  = 'Push'
}
New-DbaReplSubscription @sub -SqlCredential $cred


# start snapshot
Get-DbaAgentJob -SqlInstance $servername -SqlCredential $cred -Category repl-snapshot | Start-DbaAgentJob