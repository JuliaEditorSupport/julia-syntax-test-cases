#= Julia syntax highlighting test.

This file derives from https://gist.github.com/Wilfred/f1aca44c61ed6e1df603
whose author is [@Wilfred](https://github.com/Wilfred). @Wilfred has put it in
the public domain:
  https://gist.github.com/Wilfred/f1aca44c61ed6e1df603#gistcomment-2948526

Changes from the original are governed by the license of the repository in
which this file is found.

This file is designed to test various corner cases of Julia
syntax highlighting.
=#

## Simple function definitions.
# Expected: `function` should be highlighted, as should `foo_bar!`.
function foo_bar!(x,y)
    x + y + 1
end

# Expected: foo_bar!` should be highlighted.
foo_bar!(x,y) = x + y

# Expected: `foo` should be highlighted.
Baz.foo(x) = 1

# Expected: `foo` should be highlighted.
foo(x::(Int,)) = 1

# Expected: `foo` should be highlighted.
foo(x, y=length(x))

## Function definitions in namespaces.
# Expected: `bar` should be highlighted.
function Foo.bar(x, y)
    x + 1
end

## Function definitions with type variables.
# Expected: `elsize` should be highlighted.
elsize(::AbstractArray{T}) where {T} = sizeof(T)

function elsize(::AbstractArray{T}) where T
    sizeof(T)
end

## Nested brackets in function definitions.
# Expected: `cell` should be highlighted.
cell(dims::(Integer...)) = Array(Any, convert((Int...), dims))

# TODO: find an example with a nested type expression.

## Macro usage
# Expected: `@hello_world!` should be highlighted.
@hello_world! foo

## Builtin functions.
# Expected: `throw`, `error` and `super` should not be highlighted. There are
# too many built-in functions for this to be useful.
# https://github.com/JuliaLang/julia/commit/134867c69096fcb52afa5d5a7433892b5127e981
# https://github.com/JuliaLang/julia/pull/7963#issuecomment-52586261
throw(foo)
error("foo", bar, "baz")
super(Int)

## Strings
# Expected: highlight the string.
x = "foo \"bar\" baz"

# Expected: highlight the whole string.
x = "foo
bar"

# Expected: highlight the whole triple-quoted string.
x = """hello "world" foobar"""
y = """foo\\"""
z = """bar\""""

# Expected: highlight `$user`
x = "hello $user"

# Expected: don't highlight `$user`
x = "hello \$user"

# Expected: treat r as part of the string, so `r"a"` is highlighted.
x = r"0.1"

# Expected: treat ismx as part of the string, so `r"a"ismx` is highlighted.
x = r"a"ismx

# Expected: highlight `r"""a "b" c"""`
x = r"""a "b" c"""

# Expected: treat v as part of the string, so `v"0.1"` is highlighted.
x = v"0.1"

# Expected: treat b as part of the string, so `b"a"` is highlighted.
x = b"a"

# Bonus points:
# Expected: highlight the interpolation brackets `$(` and `)`
x = "hello $(user * user)"

# Bonus points:
# Expected: highlight regexp metacharacters `[` and `]`
x = r"[abc]"

# Bonus points:
# Expected: highlight escape sequences `\xff` and `\u2200`
x = b"DATA\xff\u2200"

## Characters
# Expected: highlight the character.
x = 'a'
y = '\u0'
z = '\U10ffff'
a = ' '
b = '"'

# Expected: don't highlight, as ' is an operator here, not a character delimiter.
a = b' + c'

# Bonus points:
# Expected: don't highlight the character
x = 'way too long so not a character'

## Comments
# Expected: highlight `# foo`
# foo

# Expected: highlight `#= foo\n bar =#`
#= foo
bar =#

# Expected: highlight `#= #= =# =#` (comments can nest).
#= #= =# =#

## Type declarations

# Expected highlight `Foo` and `Bar`
mutable struct Foo
    x::Bar
end

# Expected highlight `Foo` and `Bar`
struct Foo
    x::Bar
end

# Expected: highlight `Foo` and `Bar`
abstract type Foo <: Bar

# Expected: don't highlight x or y
x <: y

## Type annotations

# Expected: highlight `FooBar`
f(x::FooBar) = x

# Expected: highlight `Int8`
function foo()
    local x::Int8 = 5
    x
end

# Expected: highlight `T` and `Number`
same_type_numeric(x::T, y::T) where {T <: Number} = true

## Variable delcarations

# Expected: highlight `x` and `y`
global x = "foo, bar = 2", y = 3

# Expected: highlight `x` and `y`
global x = foo(a, b), y = 3

# Expected: highlight `y`
const y = "hello world"

# Expected: highlight `x` and `y`
function foo()
    local x = f(1, 2), y = f(3, 4)
    x + y
end

# Expected: highlight `x` and `y`
let x = f(1, 2), y = f(3, 4)
    x + y
end

## Colons and end

# Expected: highlight `:foo`, `:end` and `:function`
:foo
x = :foo
y = :function
z = :end

# Expected: highlight index `[end]` differently to block delimiter `end`
if foo[end]
end

# Expected: highlight as index `end`
foo[bar:end]

# Expected: don't highlight `:123`
x = :123

# Expected: don't highlight `:baz`
foo[bar:baz]

# Expected: highlight `:baz`
foo[:baz]

# Expected: highlight `:baz`
foo(:baz,:baz)

# Note that `: foo` is currently a valid quoted symbol, this will hopefully
# change in 0.4: https://github.com/JuliaLang/julia/issues/5997

# Expected: highlight `:foo`
[1 :foo]

# Expected: highlight `:end`
[1 :end]

# Expected: don't highlight `:foo`
for x=1:foo
    print(x)
end

## Number highlighting

# Expected: highlight all these as numbers
x = 123
x = 1.1
x = .5
x = -1
x = 0x123abcdef
x = 0o7
x = 0b1011
x = 2.5e-4
x = 2.5E-4
x = 1e+00
x = 2.5f-4
x = 0x.4p-1

# Expected: highlight these as numbers or built-ins
x = Inf
x = NaN

# Expected: highlight `123`
y = 123x

# Debatable: highlight `π` as a number or built-in
# (note that `πx` is a single symbol, not `π * x`)
x = π

# Note that `x.3` is currently equivalent to `.3x` or `.3 * x`, but this
# may change: https://github.com/JuliaLang/julia/issues/6770
