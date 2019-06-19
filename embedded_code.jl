#= Embedded code

Provides syntax cases of macro-embedded code in julia.
=#

using Cxx
using PyCall
using RCall
using Markdown

# Expected: the contents of the strings should look like R code.
R"x <- 3"

R"""
 y <- fit(x, q)
"""

# Expected: the contents should look like markdown. Embedded code blocks
# should look like blocks in their respective languages.
md"""
# This is a header

Here is some markdown text

 - This is a list item
 - This is another item

This should look like a block of julia code:
```julia
x = x + y
```

And this should look like a block of C++:
```c++
auto x = 42;
```
"""

# Expected: the string delimiters should look like strings, and the string
# contents should look like C++
cxx"""
#include <cxx>
"""

# Expected: this should look like an ordinary julia expression
q = 42

# Expected: the macro captures should be highlighted specially
icxx"f(($x));"

icxx"""
  auto x = $y;
  auto z = q($x);
  return x;
"""

str = "the sky is $(g)"

# Expected: should look like javascript inside
js"""
alert("Hello")
"""

# Expected: should look like python inside
py"""
import numpy as np
print 'Hello, world!'
"""

# Expected: should look like an ordinary julia expression
x = 2 + 2