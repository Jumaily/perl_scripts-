#!/usr/bin/perl
use Date::Manip;

$today = UnixDate("today","%b%e_%Y");
$today =~ s/\s//g;


# backup databases
@dbs = ("database_1","database_2","database_3");
foreach(@dbs){
   $databaseBU_a = "mysqldump --opt  -uUserName -pPassWord $_ > /backups/dbs/$_.sql";
   $databaseBU_b = "tar -czf /backups/dbs/$_"."$today.tar.gz  /backups/dbs/$_.sql";
   $databaseBU_c = "rm -f /backups/dbs/$_.sql";
   
   system($databaseBU_a);
   system($databaseBU_b);
   system($databaseBU_c);
   
   # Keep only seven past days versions of databases
   &removeOlderFiles($_);
   }


# Remove backups past 7 days
sub removeOlderFiles(){
   my ($filex) = @_;
   my $rootdir = "/backups/dbs";
   my @delete = "";

   my @files = `ls -t $rootdir/$filex*`;

   if(@files>7){
      my $d=0;
          for($i=7;$i<@files;$i++){
             @delete[$d] = @files[$i];
             $d++;
             }
          }
   foreach $s (@delete){
      chomp($s);
      my $rm = "rm -f $s";
      system($rm);
      }
   }
   
   
exit;
