package Imager::Marquee;
use 5.008001;
use strict;
use warnings;

use Imager;
use List::Rubyish::Circular;

our $VERSION = '0.01';

sub new {
    my ($class, %args) = @_;
    my $image = Imager->new(%args)
        or dir Imager->errstr;

    bless {
        image  => $image,
        matrix => $class->matrix_for($image),
        images => [],
    }, $class;
}

sub marquee {
    my ($self, $count, $direction) = @_;
    $count ||= 1;

    my @images;
    for (my $i = 0; $i < $self->{image}->getwidth; $i += $count) {
        $self->cycle($count, $direction);
    }

    $self;
}

sub rmarquee {
    my ($self, $count) = @_;
    $count ||= 1;
    $self->marquee($count, 'right');
}

sub shake {
    my ($self, $count) = @_;
    $count ||= int($self->{image}->getwidth/100);
    $self->cycle($_) for (1 .. $count);
    $self->rcycle($_) for (- $count .. $count);
    $self;
}

sub write {
    my ($self, %args) = @_;
    Imager->write_multi({ %args, type => 'gif' }, @{$self->{images}});
}

sub matrix_for {
    my ($class, $image) = @_;
    my $height = $image->getheight;

    my @matrix;
    for (my $i = 0; $i < $height; $i++) {
        my @colors = $image->getpixel(
            x => [ 0 .. ($image->getwidth - 1) ],
            y => [ map { $i } (0 .. ($image->getwidth - 1)) ],
        );
        my $row = List::Rubyish::Circular->new(@colors);
        push @matrix, $row;
    }

    \@matrix;
}

sub cycle {
    my ($self, $count, $direction) = @_;
    $count ||= 1;

    my $image = Imager->new(
        xsize    => $self->{image}->getwidth,
        ysize    => $self->{image}->getheight,
        channels => $self->{image}->getchannels,
    );

    for (my $j = 0; $j < $self->{image}->getwidth; $j++) {
        if (($direction || '') eq 'right') {
            $self->{matrix}->[$j] = $self->{matrix}->[$j]->rcycle($count);
        } else {
            $self->{matrix}->[$j] = $self->{matrix}->[$j]->cycle($count);
        }

        $image->setpixel(
            x     => $_,
            y     => $j,
            color => $self->{matrix}->[$j]->[$_],
        ) for (0 .. ($self->{image}->getwidth - 1));
    }

    push @{$self->{images}}, $image;
    $self;
}

sub rcycle {
    my ($self, $count) = @_;
    $count ||= 1;
    $self->cycle($count, 'right');
}

1;

__END__

=encoding utf8

=head1 NAME

Imager::Marquee -

=head1 SYNOPSIS

  use Imager::Marquee;

=head1 DESCRIPTION

Imager::Marquee is

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentarok@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kentaro Kuribayashi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
