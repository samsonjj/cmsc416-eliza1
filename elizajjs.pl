# This program was created by Jonathan Samson for
# CMSC 416-001 VCU Spring 2019 due date 2/.../19
# This program follows in the footsteps of the
# famous ELIZA program which imitates a
# Rogerian psychotherapist. The intention of this
# program is to use natural language processing
# techniques to trick an unaware user into thinking
# they are communicating with a human

use feature qw(say);
use strict;
use warnings;

sub eliza_talk {
    say "ELIZA: ".$_[0];
}

sub eliza_listen {
    print "YOU:   ";
    my $response = <STDIN>;
    chomp $response;
    return $response;
}

sub say_hello {

    print "\n  Welcome to";

    say "                               
     _____ __    _____ _____ _____
    |   __|  |  |     |__   |  _  |
    |   __|  |__|-   -|   __|     |
    |_____|_____|_____|_____|__|__|\n";
    
    say "  Written by Jonathan Samson";
    say "  For CMSC 416-001 VCU Spring 2019\n";

    eliza_talk "Is something troubling you ?";
}

sub tokenify {
    (my $sentence) = @_;
    $sentence =~ s/[^a-zA-Z]]*/ /g ;
    $sentence = lc($sentence);

    my @tokens = split(/\s+/, $sentence);
    return @tokens;
}

sub sentificate {

    my $sentence = $_[0];
    chomp $sentence;
    $sentence = ucfirst($sentence);
    
    my $last = substr($sentence, -1);
    if ($last ne "." and $last ne "?") {
        $sentence .= ".";
    }
    
    return $sentence;
}

# Run the loop

say_hello();

while(1) {
    my $response = eliza_listen();
    my @tokens = tokenify($response);
    my $message = join("~", @tokens);
    eliza_talk($message);
}
