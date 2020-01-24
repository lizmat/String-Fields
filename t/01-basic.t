use v6.c;
use Test;
use String::Fields;

plan 12;

my $sf := String::Fields.new(3,4,5);
isa-ok $sf, String::Fields,
  'Did we get a String::Fields object';

isa-ok $sf.set-string("12345678901234567890"), String::Fields,
  'Did it stay a String::Fields object';

is $sf[0], "123",   'is the first element ok';
is $sf[1], "4567",  'is the second element ok';
is $sf[2], "89012", 'is the third element ok';

is $sf.join, "123456789012", 'did we join the fields';

my @fields;
@fields.push($_) for $sf;
is-deeply @fields, ["123","4567","89012"], 'did we iterate ok';

my $foo = "abcdefghijklmnopqrstuvwxyz";
$foo.&apply-fields($sf);
isa-ok $foo, String::Fields,
  'Did $foo become a String::Fields object';

@fields = ();
@fields.push($_) for $foo<>;
is-deeply @fields, [<abc defg hijkl>], 'did we iterate ok';

$foo.&apply-fields(String::Fields.new(8 => 2, 0 => 3, 4 => 2));
isa-ok $foo, String::Fields,
  'Is $foo still a String::Fields object';

@fields = ();
@fields.push($_) for $foo<>;
is-deeply @fields, [<ij abc ef>], 'did we iterate ok';

ok $foo.starts-with("abcde"), 'check normal Str method';

# vim: ft=perl6 expandtab sw=4
