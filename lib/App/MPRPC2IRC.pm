package App::MPRPC2IRC;
use strict;
use warnings;
use 5.008001;
our $VERSION='0.01';

1;
__END__

=head1 DESCRIPTION

This is a MessagePack RPC to IRC gateway.

This script provides two scripts named mprpc2irc-client.pl and mprpc2irc-server.pl.

mprprc2irc-server.pl should run on the daemontools.

=head1 USECASE

You can send commit message to the IRC channel.

You can send any message to the IRC channel by cron.

etc. etc.

=head1 AUTHOR

Tokuhiro Matsuno tokuhirom at gmail com

=head1 SEE ALSO

L<AnyEvent::MPRPC>, L<AnyEvent::IRC>

