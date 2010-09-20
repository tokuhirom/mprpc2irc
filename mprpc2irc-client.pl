#!/usr/bin/perl
use strict;
use warnings;

package App::MPRPC2IRC::Client;
use Mouse;
with 'MouseX::Getopt';
use AnyEvent::MPRPC;

has host => (is => 'ro', isa => 'Str', default => '127.0.0.1');
has port => (is => 'ro', isa => 'Int', default => 4423);

sub run {
    my $self = shift;
    my $client = mprpc_client $self->host, $self->port;
    my @args = $self->extra_argv;
    my $d = $client->call( 'send_srv', @args );
    my $res = $d->recv;
}

package main;
App::MPRPC2IRC::Client->new_with_options->run();

__END__

=head1 SYNOPSIS

    % perl -Ilib mprpc2irc-client.pl JOIN '#testtest'
    % perl -Ilib mprpc2irc-client.pl PRIVMSG '#testtest' やほー

