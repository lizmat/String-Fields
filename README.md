[![Actions Status](https://github.com/lizmat/String-Fields/workflows/test/badge.svg)](https://github.com/lizmat/String-Fields/actions)

NAME
====

String::Fields - class for setting fixed size fields in a Str

SYNOPSIS
========

```perl6
    use String::Fields;

    my $sf := String::Fields.new(2,3,4)
    .say for $sf.set-string("abcdefghijklmnopqrstuvwxyz");
    # ab
    # cde
    # fghi

    my $sf := String::Fields.new(2 => 5, 8, 3);
    my $s = "012345678901234567890";

    $s.&apply-fields($sf);  # or: apply-fields($s,$sf)
    say $s;            # 012345678901234567890
    say $s[0];         # 23456
    say $s[1];         # 78901234
    say $s[2];         # 567
    say $s.join(":");  # 23456:78901234:567

    # one time application
    $s.&apply-fields(2,3,4);  # or: apply-fields($s,2,3,4)

    # using a literal string
    my @fields = "abcdefg".&apply-fields(2,3);  # ["ab","cde"]
```

DESCRIPTION
===========

String::Fields allows one to specify fixed length fields that can be applied to a string, effectively turning it into a sequence of strings that can be individually accessed or iterated over.

When the object is loaded with a string, it can be used as a string in all the normal ways that a string would.

METHODS
=======

new
---

    my $sf := String::Fields.new(2,3,4)

The `new` method creates a new `String::Fields` object that contains the format information of the fields. It takes any number of arguments to indicate the position and width of the fields. If the argument consists of just a number, it means the width of a field from where the last field has ended (or from position 0 for the first argument). If the argument consists of a `Pair`, then the key is taken for the offset, and the value is taken to be the width.

Please note that this **just** sets the format information. This allows the same object to be used for different strings. Setting the string to be used, is either done with the `set-string` method, or by calling the `apply-fields` subroutine.

join
----

    $s.join(":")

Joins all fields together with the given separator.

set-string
----------

    $sf.set-string($string)

The `set-string` method sets the string to which the format information should be applied.

SUBROUTINES
===========

apply-fields
------------

    apply-fields($s,$sf);  # or $s.&apply-fields($sf)

    # one time application
    $s.&apply-fields(2,3,4);  # or: apply-fields($s,2,3,4)

    # using a literal string
    my @fields = "abcdefg".&apply-fields(2,3);  # ["ab","cde"]

If the first argument to the `apply-fields` subroutine is a variable with a string in it, then it will become a `String::Fields` object (but will still act as the original string). If it is a string literal, then the created / applied `String::Fields` object will be returned. The other arguments indicate the fields that should be applie. This can be either be a `String::Fields` object, or it can any number of field specifications, as can be passed to the `new` method.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/String-Fields . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020, 2021 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

