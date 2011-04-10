package main;
use strict;
use warnings;
use Imager::Marquee;

my $image = Imager::Marquee->new(file => shift);
   $image->marquee(3)->write(
       file     => 'marquee.gif',
       gif_loop => 0,
       delay    => 1,
   );
