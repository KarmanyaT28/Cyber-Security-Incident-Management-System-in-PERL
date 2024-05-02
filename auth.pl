#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header;

my $username = $cgi->param('username');
my $password = $cgi->param('password');

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

# Perform authentication and authorization
my $auth_query = "SELECT * FROM users WHERE username=? AND password=?";
my $sth = $dbh->prepare($auth_query);
$sth->execute($username, $password);

if (my $user = $sth->fetchrow_hashref()) {
    # User authenticated
    print "Content-type: text/plain\n\n";
    print "Welcome, $username!";
} else {
    # Authentication failed
    print "Content-type: text/plain\n\n";
    print "Authentication failed.";
}
