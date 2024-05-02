use strict;
use warnings;
use DBI;

# Database connection parameters
my $dsn_mysql = "DBI:mysql:database=your_db_name;host=your_host";
my $dsn_pgsql = "DBI:Pg:dbname=your_db_name;host=your_host";
my $username = "your_username";
my $password = "your_password";

# Connect to MySQL database
my $dbh_mysql = DBI->connect($dsn_mysql, $username, $password, { RaiseError => 1 })
    or die "Cannot connect to MySQL database: $DBI::errstr";

# Connect to PostgreSQL database
my $dbh_pgsql = DBI->connect($dsn_pgsql, $username, $password, { RaiseError => 1 })
    or die "Cannot connect to PostgreSQL database: $DBI::errstr";

# CRUD operations examples
sub create_record {
    my ($dbh, $table, $data) = @_;
    my $fields = join ',', keys %$data;
    my $placeholders = join ',', map { '?' } keys %$data;
    my $sth = $dbh->prepare("INSERT INTO $table ($fields) VALUES ($placeholders)");
    $sth->execute(values %$data);
}

sub read_records {
    my ($dbh, $table, $condition) = @_;
    my $where_clause = $condition ? "WHERE $condition" : '';
    my $sth = $dbh->prepare("SELECT * FROM $table $where_clause");
    $sth->execute();
    while (my $row = $sth->fetchrow_hashref()) {
        print "ID: $row->{id}, Name: $row->{name}\n"; # Adjust fields accordingly
    }
}

sub update_record {
    my ($dbh, $table, $data, $condition) = @_;
    my $set_clause = join ',', map { "$_ = ?" } keys %$data;
    my $sth = $dbh->prepare("UPDATE $table SET $set_clause WHERE $condition");
    $sth->execute(values %$data);
}

sub delete_record {
    my ($dbh, $table, $condition) = @_;
    my $sth = $dbh->prepare("DELETE FROM $table WHERE $condition");
    $sth->execute();
}

# Usage examples
create_record($dbh_mysql, 'cyber_security_data', { name => 'example', type => 'attack' });
read_records($dbh_pgsql, 'cyber_security_data', "type = 'attack'");
update_record($dbh_mysql, 'cyber_security_data', { name => 'updated_example' }, "id = 1");
delete_record($dbh_pgsql, 'cyber_security_data', "type = 'attack'");
