use v6.c;
class String::Fields:ver<0.0.1>:auth<cpan:ELIZABETH> does Positional does Iterable {
    has Str $.string handles <
      chars chomp chop codes comb contains encode ends-with fc flip gist
      indent index indices Int lc lines match NFC NFD NFKC NFKD Num
      Numeric ord ords parse-base pred raku rindex samecase samemark split
      starts-with Str Stringy subst substr substr-eq substr-rw succ tc
      tclc trans trim trim-leading trim-trailing uc uniparse unival
      univals wordcase words
    >;
    has int @!from;
    has int @!chars;

    method new(*@positions) {
        self.CREATE!SET-SELF(@positions)
    }

    method !SET-SELF(@positions) {
        for @positions {
            if $_ ~~ Pair {
                @!from.push(.key);
                @!chars.push(.value);
            }
            elsif @!from {
                my int $last = @!from.end;
                @!from.push(@!from[$last] + @!chars[$last]);
                @!chars.push($_);
            }
            else {
                @!from.push(0);
                @!chars.push($_)
            }
        }
        self
    }

    method set-string(Str:D $!string --> String::Fields) { self }

    method join(Str(Cool) $separator = "") {
        (^@!from).map( { self.AT-POS($_) } ).join($separator)
    }

    method elems(--> Int:D) { +@!from }
    method AT-POS(Int:D $pos --> Str:D) {
        $!string.substr(@!from[$pos], @!chars[$pos])
    }
    method ASSIGN-POS(Int:D $pos, Str:D $new --> Str:D) {
        die "Assigning to {self.^name} is not supported";
        # $!string.substr-rw(@!from[$pos], @!chars[$pos]) = $new
    }
    method BIND-POS(Int:D $pos, Str:D $new) {
        die "Binding to {self.^name} is not supported";
    }
    method DELETE-POS(Int:D $pos) {
        die "Deleting from {self.^name} is not supported";
    }
    method EXISTS-POS(Int:D $pos --> Bool:D) {
        $pos >= 0 && $pos < @!from
    }

    my class IterateString {
        has String::Fields $.string;
        has int $!elems = $!string.elems;
        has int $!i = -1;

        method pull-one() {
            ++$!i < $!elems
              ?? $!string.AT-POS($!i)
              !! IterationEnd
        }
    }

    method iterator(String::Fields:D:) {
        IterateString.new( :string(self) )
    }
}

proto sub apply-fields(|) is export {*}
multi sub apply-fields(String::Fields:D $sf is rw, String::Fields:D $new) {
    ($sf = $new.set-string($sf.string))<>;   # decont allows iteration
}
multi sub apply-fields(Str:D $string is rw, String::Fields:D $sf) {
    ($string = $sf.set-string($string))<>;   # decont allows iteration
}

=begin pod

=head1 NAME

String::Fields - class for setting fixed size fields in a Str

=head1 SYNOPSIS

=begin code :lang<perl6>

    use String::Fields;

    my $sf := String::Fields.new(2,3,4)
    .say for $sf.set-string("abcdefghijklmnopqrstuvwxyz");
    # ab
    # cde
    # fghi

    my $sf := String::Fields.new(2 => 5, 8, 3);
    my $s = "012345678901234567890";

    $s.&apply-fields($sf);  # or: apply-fields($s,$sf)
    say $s;      # 012345678901234567890
    say $s[0];   # 23456
    say $s[1];   # 78901234
    say $s[2];   # 567

=end code

=head1 DESCRIPTION

String::Fields allows one to specify fixed length fields that can be applied
to a string, effectively turning it into a sequence of strings that can be
individually accessed or iterated over.

When the object is loaded with a string, it can be used as a string in all
the normal ways that a string would.

=head1 METHODS

=head2 new

    my $sf := String::Fields.new(2,3,4)
  
The C<new> method creates a new C<String::Fields> object that contains the
format information of the fields.  It takes any number of parameters to
indicate the position and width of the fields.  If the parameter consists
of just a number, it means the width of a field from where the last field
has ended (or from position 0 for the first parameter).  If the parameter
consists of a C<Pair>, then the key is taken for the offset, and the value
is taken to be the width.

Please note that this B<just> sets the format information.  This allows
the same object to be used for different strings.  Setting the string to
be used, is either done with the C<set-string> method, or by calling the
C<apply-fields> subroutine.

=head2 set-string

    $sf.set-string($string)

The C<set-string> method sets the string to which the format information
should be applied.

=head1 SUBROUTINES

    apply-fields($s,$sf);  # or $s.&apply-fields($sf)

The C<apply-fields> subroutine takes two parameters: a variable with a
string in it, and the C<String::Fields> object that should be applied
to it.  After application, the variable has become a C<String::Fields>
object, but will still act as the ordinary C<Str> it was.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/String-Fields . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: ft=perl6 expandtab sw=4
