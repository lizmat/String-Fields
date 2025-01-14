class String::Fields does Positional does Iterable {
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

    my class IterateString does Iterator {
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
    ($string = $sf.set-string($string))<>;
}
multi sub apply-fields(Str:D $string, String::Fields:D $sf) {
    $sf.set-string($string)<>;
}
multi sub apply-fields(Str:D $string is rw, *@positions) {
    ($string = String::Fields.new(@positions).set-string($string))<>;
}
multi sub apply-fields(Str:D $string, *@positions) {
    String::Fields.new(@positions).set-string($string)<>;
}

# vim: expandtab shiftwidth=4
