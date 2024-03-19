#!/usr/bin/perl

use strict;
use warnings;
use Math::BigFloat;
use HTML::TokeParser;

my $fortran_data = "fort.3";
my $start_string = "1ENERGY";
my $header = "";
my @header_split = ();
my $particle = "";
my $mass = "";
my $calc_charge = "";
my $magnet_k = "";
my $energy = "";
my $calc_energy = "";
my $rounded_energy = "";
my $table_energy = "";
my @nmrdata = ();
my $calc_frequency = "";
my $passed_checks = 0;
my $failed_checks = 0;
my $total_checks = 0;
my $script = "/var/www/cgi-bin/findenergy";
my $scriptoutput = "";

# Constants
my $M_zero 		= 	1876.5592;

open (file_handle, "<$fortran_data") or die qq(Unable to open "$fortran_data");

foreach (<file_handle>) {
    s/^\s+//; #remove leading whitespace
    @header_split = split ' ', $_;
    # read in the page index
    if ($header = rindex($_,$start_string,0) == 0) {
        # @header_split[7] is particle
        # @header_split[10] is mass
        # @header_split[14] is charge state named calc_charge to match findenergy
        # @header_split[17] is magnet constant
        $particle = $header_split[7];
        $mass = $header_split[10];
        $calc_charge = $header_split[14];
        $magnet_k = $header_split[17];
        next;
    }
    # Discard page headers
    if ($header = rindex($_,"E",0) == 0) {
        next;
    }
    # Discarge page footers
    if ($_ =~ /$particle/) {
        next;
    }
    # This means that the line we're reading in starts with an energy and is
    # followed by 10 NMR Frequency values.
    else {
        # grab the energy and store it.
        $energy = $header_split[0];
        if ($energy) {
            # Split out all of the NMR values and store them in nmrdata
            for (my $index = 0; $index < 10; $index++) {
                # @nmrdata[$index] = $header_split[$index+1];
                $calc_frequency = $header_split[$index+1];
                $table_energy = sprintf("%.3f", $energy + $index/1000);

                # # call the CGI script (path in header) using this particle,
                # # frequency, and charge.  Stick the output in $scriptoutput
                # # $scriptoutput = `$script particle=$particle frequency=$calc_frequency charge=$calc_charge`;

                # # initialize p to parse the script output                
                # my $p = HTML::TokeParser->new(\$scriptoutput);
                # # print $!, "\n";
                # # get the table header <th> tags
                # # print $scriptoutput, "\n"; 
                # while (my $token = $p->get_tag("td")) {
                #     if(defined($token->[1]{id})) {
                #         if($token->[1]{id} =~ /energy/) {
                #             $calc_energy = $p->get_trimmed_text("/a");
                #         }
                #     }
                # }

                # # Since there are 500 frequencies to check per page of output,
                # # calling the CGI script would take excessively long.  Instead, we
                # # will test by comparing the energy calculated by findenergy with
                # # the corresponding NMR value.
                $calc_energy = ($M_zero / 2) * ( - $mass + sqrt($mass**2 + (4*$magnet_k*$calc_charge**2*$calc_frequency**2)/($M_zero)));
                $rounded_energy = sprintf("%.3f", $calc_energy);
                # print $table_energy, "\n";
                # print $rounded_energy, "\n";
                if ($table_energy == $rounded_energy) {
                    $passed_checks++;
                    # print "Calculated energy of ", $rounded_energy, " matches frequency lookup of ", $calc_frequency, "\n";
                } else {
                    $failed_checks++;
                    # print "Calculated energy of ", $rounded_energy, " DOES NOT MATCH ", $calc_frequency, "\n";
                }
            }
        }
    }
}

$total_checks = $passed_checks + $failed_checks;
while ($total_checks =~ s/^(\d+)(\d{3})/$1,$2/) {};
print "Checked ", $total_checks, " and found ", $failed_checks, " errors.\n";
