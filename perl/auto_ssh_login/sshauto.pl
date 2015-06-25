#!usrbinperl
use Expect;
use TermReadKey;
print Password;
ReadMode 'noecho';
$password = ReadLine(0);
chomp($password);
print n;
ReadMode 'normal';
$command = $ARGV[0];
open (IP_list, 'ip_addresses.txt');
foreach $IP (IP_list) {
    chomp($IP);
    $cli = usrbinssh -q -t -o StrictHostKeyChecking=no et0362@$IP  $command;
    $exp = new Expect;
    $exp-raw_pty(1);
    $exp-spawn($cli) or die Cannot spawn $cli $!n;
    $exp-expect(5, [ qr ssword = sub { my $exph = shift; $exph-send($passwordn); exp_continue; }] );
};
close (IP_list);