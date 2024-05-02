#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Database connection parameters
my $mysql_dsn = "DBI:mysql:database=cyber_security;host=localhost";
my $pgsql_dsn = "DBI:Pg:dbname=cyber_security;host=localhost";
my $username = "your_username";
my $password = "your_password";

# Connect to MySQL and PostgreSQL databases
my $dbh_mysql = DBI->connect($mysql_dsn, $username, $password, { RaiseError => 1 })
    or die "Cannot connect to MySQL database: $DBI::errstr";
my $dbh_pgsql = DBI->connect($pgsql_dsn, $username, $password, { RaiseError => 1 })
    or die "Cannot connect to PostgreSQL database: $DBI::errstr";

# Function to create a new security event
sub create_event {
    my ($dbh, $name, $type) = @_;
    my $timestamp = localtime();
    my $sth = $dbh->prepare("INSERT INTO security_events (event_name, event_type, timestamp) VALUES (?, ?, ?)");
    $sth->execute($name, $type, $timestamp);
    print "New event created.\n";
}

# Function to read all security events
sub read_events {
    my ($dbh) = @_;
    my $sth = $dbh->prepare("SELECT * FROM security_events");
    $sth->execute();
    while (my $row = $sth->fetchrow_hashref()) {
        print "ID: $row->{id}, Name: $row->{event_name}, Type: $row->{event_type}, Timestamp: $row->{timestamp}\n";
    }
}

# Function to update a security event
sub update_event {
    my ($dbh, $id, $name, $type) = @_;
    my $sth = $dbh->prepare("UPDATE security_events SET event_name = ?, event_type = ? WHERE id = ?");
    $sth->execute($name, $type, $id);
    print "Event updated.\n";
}

# Function to delete a security event
sub delete_event {
    my ($dbh, $id) = @_;
    my $sth = $dbh->prepare("DELETE FROM security_events WHERE id = ?");
    $sth->execute($id);
    print "Event deleted.\n";
}

# Main Menu
sub main_menu {
    while (1) {
        print "\n";
        print "1. Create Event\n";
        print "2. Read Events\n";
        print "3. Update Event\n";
        print "4. Delete Event\n";
        print "5. Exit\n";
        print "Choose an option: ";
        my $option = <STDIN>;
        chomp($option);
        last if $option == 5;
        process_option($option);
    }
}

# Process user option
sub process_option {
    my ($option) = @_;
    given ($option) {
        when (1) {
            print "Enter event name: ";
            my $name = <STDIN>;
            chomp($name);
            print "Enter event type: ";
            my $type = <STDIN>;
            chomp($type);
            create_event($dbh_mysql, $name, $type);
        }
        when (2) {
            read_events($dbh_pgsql);
        }
        when (3) {
            print "Enter event ID to update: ";
            my $id = <STDIN>;
            chomp($id);
            print "Enter new event name: ";
            my $name = <STDIN>;
            chomp($name);
            print "Enter new event type: ";
            my $type = <STDIN>;
            chomp($type);
            update_event($dbh_mysql, $id, $name, $type);
        }
        when (4) {
            print "Enter event ID to delete: ";
            my $id = <STDIN>;
            chomp($id);
            delete_event($dbh_pgsql, $id);
        }
        default {
            print "Invalid option. Please try again.\n";
        }
    }
}

# Run the main menu
main_menu();
