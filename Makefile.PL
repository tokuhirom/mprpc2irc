use inc::Module::Install;

all_from 'lib/App/MPRPC2IRC.pm';
license 'perl';

requires 'Mouse';
requires 'MouseX::Getopt';
requires 'AE';
requires 'AnyEvent::IRC::Client';
requires 'AnyEvent::MPRPC';
requires 'JSON';

readme_markdown_from_pod();

author_tests('xt/');

WriteAll;
