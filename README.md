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

The `new` method creates a new `String::Fields` object that contains the format information of the fields. It takes any number of parameters to indicate the position and width of the fields. If the parameter consists of just a number, it means the width of a field from where the last field has ended (or from position 0 for the first parameter). If the parameter consists of a `Pair`, then the key is taken for the offset, and the value is taken to be the width.

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

The `apply-fields` subroutine takes two parameters: a variable with a string in it, and the `String::Fields` object that should be applied to it. After application, the variable has become a `String::Fields` object, but will still act as the ordinary `Str` it was.

AUTHOR
======

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/String-Fields . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

