#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header;

# Database connection parameters
my $mysql_dsn = "DBI:mysql:database=security_incidents;host=localhost";
my $pgsql_dsn = "DBI:Pg:dbname=security_incidents;host=localhost";
my $db_username = "your_db_username";
my $db_password = "your_db_password";

# Connect to MySQL or PostgreSQL database
my $dbh;
if ($cgi->param('db_type') eq 'mysql') {
    $dbh = DBI->connect($mysql_dsn, $db_username, $db_password, { RaiseError => 1 });
} elsif ($cgi->param('db_type') eq 'pgsql') {
    $dbh = DBI->connect($pgsql_dsn, $db_username, $db_password, { RaiseError => 1 });
}

# Perform CRUD operations
my $action = $cgi->param('action');
if ($action eq 'create') {
    my $title = $cgi->param('title');
    my $description = $cgi->param('description');
    my $severity = $cgi->param('severity');
    my $reported_by = $cgi->param('reported_by');
    
    my $insert_query = "INSERT INTO incidents (title, description, severity, timestamp, reported_by) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
    my $sth = $dbh->prepare($insert_query);
    $sth->execute($title, $description, $severity, $reported_by);
    print "Incident created.";
} elsif ($action eq 'read') {
    my $select_query = "SELECT * FROM incidents";
    my $sth = $dbh->prepare($select_query);
    $sth->execute();
    while (my $incident = $sth->fetchrow_hashref()) {
        print "ID: $incident->{id}, Title: $incident->{title}, Description: $incident->{description}, Severity: $incident->{severity}, Reported By: $incident->{reported_by}\n";
    }
} elsif ($action eq 'update') {
    # Update operation
} elsif ($action eq 'delete') {
    # Delete operation
}
