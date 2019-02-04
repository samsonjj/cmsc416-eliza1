=begin comment

This program was created by Jonathan Samson for CMSC 416-001 VCU
Spring 2019 due date 2/5/19. This program follows in the
footsteps of the famous ELIZA program which imitates a Rogerian
psychotherapist. The intention of this program is to use natural
language processing techniques to "turn answers into questions."
 
The role of a Rogerian psychotherapist would be to "create a
facilitative, empathic environment wherein the patient could
discover the answers for him or herself."
[https://en.wikipedia.org/wiki/Person-centered_therapy]

This program aims to accomplish this task by asking a series of
questions, answered in between by the user. Eliza will take the
user's responses and use them to formulate new questions to ask.
Or, if the user's argument is giberish, Eliz will reply
appropriately. 




=end comment
=cut

use feature qw(say);
use strict;
use warnings;

# Print eliza's speech to STDOUT
sub eliza_talk {
    say "ELIZA: ".$_[0];
}

# Prompts for and returns a response from the user
sub eliza_listen {
    print "User:  ";
    my $response = <STDIN>;
    chomp $response;
    return $response;
}

# Print on startup
sub say_hello {

    print "\n  Welcome to";

    say "                               
     _____ __    _____ _____ _____
    |   __|  |  |     |__   |  _  |
    |   __|  |__|-   -|   __|     |
    |_____|_____|_____|_____|__|__|\n";
    
    say "  Written by Jonathan Samson";
    say "  For CMSC 416-001 VCU Spring 2019\n";

    eliza_talk "Hi, I'm a psychotherapist. What is your name?";
}

# Split a sentence into tokens
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

#my @keygex = (s/foo/doo/, qr/bar/);
my %keygex = (
    qr/foo/ => "doo"
);


sub generate_phrase {
    my @tokens = tokenify($_[0]);
    my $sentence = join (" ", @tokens);
    my $match = 0;
    for my $match ( keys %keygex ) {
        my $replace = $keygex{$match};
        my $sentence =~ s/$match/$replace/;
        print $match;
    }
    print "$sentence matches $match regexes\n";
    return $sentence;
}

##############################################
## Program execution begins here #############
##############################################

my $user = "User";

my $exitWords = "bye|goodbye|quit|exit";
my $days = "Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday";
my $times = "Evening|Morning|Afternoon";

# popular stations from http://www.greateranglia.co.uk/travel-information/journey-planning/timetables
my $trainStations = "London|Braintree|Colchester|Ely|Stratford|Broxbourne|Cheshunt|Enfield Town|Clacton-on-Sea|Shenfield|Chingford|Peterborough|Marks Tey|Upminster|Sheringham|Harwich|Manningtree|Norwich|Great Yarmouth|Lowestoft|Cromer|Sudbury|Southend Victoria|Romford|Cambridge|Ipswich";

# 

my %substitution_rules = (
    ".*Are you ([^?]*)\\??.*" =>    ['"Would you prefer if I were not $1?"'],

    ".*My name is ([^\\.]*).*" => [ '"Hi $1, is something troubling you ?"',
                                    '"Oh my name is Eliza. Nice to meet you, $1. What\'s troubling you today?"',
                                    '"What a pretty name :) What\'s troubling you today?"']
);

# Print out a welcome line (and fancy title)
say_hello();

while(1) {

    my $input = eliza_listen();

    chomp $input;

    if ($input =~ /($exitWords)/i) {
        print "Eliza: Goodbye\n";
        exit 1;
    }
 
    # perform first match
    my $found = 0;
    my @key_words = keys %substitution_rules;
    for my $key_word (@key_words) {

        my $length = scalar( @{ $substitution_rules{$key_word} } );
        my $random = int(rand($length));

        if( $found == 0 && $input =~ s/$key_word/$substitution_rules{$key_word}[$random]/geei ) {
            eliza_talk "$input";
            $found = 1;
        }
    }

    if ($found == 0) {
        eliza_talk "I don't understand.";
    }
}