package main;
use strict;
use warnings;
use Imager::Marquee;

my $image = Imager::Marquee->new(file => shift);
   $image->rmarquee(3)->write(
       file     => 'rmarquee.gif',
       gif_loop => 0,
       delay    => 1,
   );
