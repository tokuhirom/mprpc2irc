#!/usr/bin/perl
use strict;
use warnings;

$|++;

package App::MPRPC2IRC::Server;
use Mouse;
with 'MouseX::Getopt';

use AE;
use AnyEvent::IRC::Client;
use AnyEvent::MPRPC;
use JSON qw/encode_json/;

has 'irc'   => ( is => 'ro', lazy => 1, builder => 'init_irc', traits  => [ 'NoGetopt' ],);
has 'irc_addr' => (is => 'rw', isa => 'Str', default => '127.0.0.1');
has 'irc_port' => (is => 'rw', isa => 'Int', default => '6667');
has 'irc_nick' => (is => 'rw', isa => 'Str', required => 1);

has 'mprpc' => ( is => 'ro', lazy => 1, builder => 'init_mprpc', traits  => [ 'NoGetopt' ], );
has 'mprpc_addr' => (is => 'rw', isa => 'Str', default => '127.0.0.1');
has 'mprpc_port' => (is => 'rw', isa => 'Int', default => '4423');

has 'cv' => ( is => 'ro', default => sub { AE::cv() } , traits  => [ 'NoGetopt' ],);

sub dbg { print "@_\n" if $ENV{DEBUG} }

sub init_irc {
    my ($self) = @_;

    my $irc = AnyEvent::IRC::Client->new();
    $irc->reg_cb(
        'connect' => sub {
            my ( $pc, $err ) = @_;
            dbg "connected";
            if ( defined $err ) { die $err; }
        },
        disconnect => sub { dbg "I'm out!"; $self->cv->broadcast },
        registered => sub { dbg "I'm in!";  $irc->enable_ping(60); },
        sent       => sub {
            my ($con) = @_;
            dbg "sent";
        },
        irc_001 => sub {
            dbg "irc_001";
        },
        irc_privmsg => sub {
            my ( $self, $msg ) = @_;
            dbg encode_json($msg);
        },
    );
    $irc->connect( $self->irc_addr, $self->irc_port,
        { nick => $self->irc_nick } );
    return $irc;
}

sub init_mprpc {
    my ($self) = @_;

    my $server = mprpc_server $self->mprpc_addr, $self->mprpc_port;
    $server->reg_cb(
        send_srv => sub {
            my ( $res_cv, $param ) = @_;
            $self->irc->send_srv(@$param);
            $res_cv->result('OK');
        },
    );
    return $server;
}

sub run {
    my ($self) = @_;

    # initialize
    $self->irc();
    $self->mprpc();

    $self->cv->recv();
}

package main;
App::MPRPC2IRC::Server->new_with_options->run;

