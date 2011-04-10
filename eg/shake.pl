package main;
use strict;
use warnings;
use Imager::Marquee;

my $image = Imager::Marquee->new(file => shift);
   $image->shake(1)->write(
       file     => 'shake.gif',
       gif_loop => 0,
       delay    => 1,
   );
