# Chapter 2 - Part 2

## Maps

I lost that part. So check the book. kkkkk

### Dynamically sized maps

I LOST THAT PART TOO LOL

### Structured Data

Maps are the go-to type for managing key/value data structures of an arbitrary size.
But they’re also frequently used in Elixir to combine a couple of fields into a
single structure.

Example:

```elixir
iex(1)> bob = %{:name => "Bob", :age => 25, :works_at => "Initech"}
```

If keys are atoms, you can write this so it's slightly shorte:

```elixir
iex(1)> bob = %{name: "Bob", age: "25", works_at: "Initech"}
```

To retrieve a field, you can use the [] operator:

```elixir
iex(1)> bob[:name]
"Bob"
iex(2)> bob[:works_at]
"Initech"
iex(3)> bob[:non_existent_field]
nil
```

Atoms, in this case, receive special syntax:

```elixir
iex(5) bob.age
25
```

Yep, just like objects, but what you are accessing is an atom, a key of a map.

With this syntax, if you try to fetch a non existent value, you will get an error:

```elixir
iex(6)> bob.non_existent_field
** (KeyError) key :non_existent_field not found
```

To change a value, you can do this:

```elixir
iex(7)> next_years_bob = %{bob | age: 26}
%{age: 26, name: "Bob", works_at: "Initech"}

iex(8)> %{bob | age: 26, works_at: "Initrode"}
%{age: 26, name: "Bob", works_at: "Initrode"}
```

\*\*You can only modify values that already exist in the map. With this feature, maps
can represent solid structures.

In general, we don't want to add any key to a map. You can do it with `Map.put/3` and
`Map.fecth/2`, but this functions are usually suitable for the cases where maps are
used to manage a dynamically sized key/value structure.

## Binaries and bitstrings

A binary is chunk of bytes.

The following snippet creates a 3-byte binary:

```elixir
iex(1)> <<10, 2, 3>>
<<1, 2, 3>>
```

## Strings

Elixir doesn't have a dedicated string type. Strings are represented by using either
a binary or a list type.

### Binary Strings

```elixir
iex(1)> "This is a string"
"This is a string"
```

The result is a string, but underneath, it's a binary -- a consecutive sequence of
bytes.

Elixir support **embedded string expressions** with #{}. The expression is evaluated
immediately and its string representation is placed at the corresponding location:

```elixir
iex(1)> "1 + 1 = #{1 + 1}"
"1 + 1 = 2"
```

Classical escaping works too: \r \n \\

Also, they don't have to finish in the same line.

Elixir provides another sintax to strings, the _sigils_. Ex.:

```elixir
iex(5)> ~s(This is also a string)
"This is also a string"
```

**Why use that?** When you want a string with quotes. :)

```elixir
iex(6)> ~s("Do... or do not. There is no try." -Master Yoda)
"\"Do... or do not. There is no try.\" -Master Yoda"
```

With the uppercase version, you can include interpolation or escape caracters.

There's a special _heredocs_ syntax for better formatting multiline strings:

```elixir
iex(9)> """
        Heredoc must end on its own line """
        """
"Heredoc must end on its own line \"\"\"\n"
```

In the `String` module resides many helper functions to work with binary strings.

### Character Lists

The alternative way of representing strings is to use single-quote syntax:

```elixir
iex(1)> 'ABC'
'ABC'
```

This creates a _character list_ which is essentially a list of integers in which each
element in that list represents a character.

```elixir
iex(2)> [65, 66, 67]
'ABC'
```

MN: don't got it.

Just like binary strings, here you have syntax counterparts for various definitions,
such as interpolation (`#{}`), sigil (`~c()`) and unescaped sigil (`~C`) and
_heredocs_ (''').

Most of the operations from the `String` module won't work with character lists. In
general, use binary strings.

If a functions works only with character lists (this mostly happens with pure Erlang
libraries), you can convert with `String.to_charlist/1`.

To convert a character list to a binary string you can use `List.to_string/1`.

## First-class functions

In elixir you don't just can calling the functions and storing its return to a
variable. You can call the function definition it self is assigned, and you can the
varieble to call that function.

```elixir
iex(1)> square = fn x ->
  x * x
end
```

The variable `square` now contains an anonymous (or lambda) function, because isn't
bound to a global name.

You can call this function this way:

```elixir
iex(2) square.(5)
25
```

With the dot you know that you are calling a anonymous function, not a named one.

Because functions are stored in a variable, they can be passed as arguments to other
functions. This is used to allow clients to parameterize generic logic. For example:

```elixir
iex(3)> print_element = fn x -> IO.puts(x) end
iex(4)> Enum.each(
  [1, 2, 3],
  print_element
)
1
2
3
:ok
```

You don't even need a variable to pass to the function:

```elixir
iex(5)> Enum.each(
  [1, 2, 3],
  fn x -> IO.puts(x) end
)
```

Notice how the lambda just forwards all arguments to IO.puts. Instead of writing in
that way, you can just write `&IO.puts/1`.

The & operator, also known as the `capture` operator, takes the full function
qualifier - module name, a function name, and an arity - and turns that function
into a lambda that can be assigned to a variable.

```elixir
iex(5)> Enum.each(
  [1, 2, 3],
  &IO.puts/1
)
```

With capture operator you can omit explicit argument naming. You can turn this:

```elixir
iex(7)> lambda = fn x, y, z -> x * y + z end
```

into this:

```elixir
iex(8)> lambda = &(&1 * &2 + &3)
```

### Closures

A closure always captures a specific memory location. Rebinding a variable doesn't
affect the previouly defined lambda that references the same symbolic name:

```elixir
iex(1)> outside_var = 5
iex(2)> lambda = fn -> IO.puts(outside_var) end
iex(3)> outside_var = 6
iex(4)> lambda.()
5
```

It's important to say: since we are referencing the original location (that holds
the number 5), dispite rebinding, that location isn't available for garbage
collecion.

### Other buil-in types

**Reference**

- An almost unique piece of information in a BEAM instance.
- Generated by calling `Kernel.make_ref/0` (or `make_ref`).

**PID**

- **P**rocess **Id**entifier
- Used to, guess what, identify an Erlang process.

**Port identifier**

- Important when using ports. It's a mechanism used in Erlang to talk to the outside
  world.

## Higher-level types

Frequently used: Range, Keyword, MapSet, Date, Time, NaiveDateTime and DateTime.

### Range

A **range** is an abstraction that allows you to represent a range of numbers.

```elixir
iex(1)> range = 1..3
iex(2)> 2 in range
true
iex(3)> -1 in range
false
```

*Ranges* are enumerable, so function from the `Enum` module know how to work with
them. 

*Range*, internally, it's represented as a map that contains range boundaries.


It’s good to be aware that the memory footprint of a range is very small, and
regardless of the size. A million-number range is still just a small map.

### Keyword lists

A list of pairs where the first element is an atom, the second one can be any type.

```elixir
iex(1)> days = [{:monday, 1}, {:tuesday, 2}, {:wednesday, 3}]
```

Elixir sugar syntax:

```elixir
iex(2)> days = [monday: 1, tuesday: 2, wednesday: 3]
```

You can use many handful functions in the `Keyword` module.

```elixir
iex(3)> Keyword.get(days, :mondays)
```

And just as with maps:

```elixir
iex(5)> days[:tuesday]
```

Don’t let that fool you, though. Because you’re dealing with a list, the complexity
of a lookup operation is O(n).

Useful fot allowing clients to pass arbitraty number of optional arguments:

```elixir
iex(6)> IO.inspect([100, 200, 300])
[100, 200, 300]
iex(7)> IO.inspect([100, 200, 300], [width: 3])
[100,
 200,
 300] 
```

This way your clients can pass options via the last argument:

```elixir
def my_fun(arg1, arg2, opts \\ []) do
...
end
```

### MapSet

```elixir
iex(1)> days = MapSet.new([:monday, :tuesday, :wednesday])
#MapSet<[:monday, :tuesday, :wednesday]>
iex(2)> MapSet.member?(days, :monday)
true
iex(3)> MapSet.member?(days, :noday)
false 
iex(4)> days = MapSet.put(days, :thursday)
#MapSet<[:monday, :thursday, :tuesday, :wednesday]>
```

A MapSet is also an enumerable.

### Times and dates

A date can be created with the ~D sigil.

```elixir
iex(1)> date = ~D[2018-01-31]
~D[2018-01-31]
iex(2)> date.year
2018
iex(3)> date.month
1
```

Similarly, you can represent a time with the ~T sigil, by providing hours, minutes, seconds, and microseconds:

```elixir
iex(1)> time = ~T[11:59:12.00007]
iex(2)> time.hour
11
iex(3)> time.minute
59
```

Use the `Date` and `Time` modules to manipulate them.

The DateTime module can be used to work with datetimes in some timezone. Unlike
with other types, no sigil is available. Instead, you can create a datetime by using DateTime functions:
```elixir
iex(4)> datetime = DateTime.from_naive!(naive_datetime, "Etc/UTC")
iex(5)> datetime.year
2018
iex(6)> datetime.hour
11
iex(7)> datetime.time_zone
"Etc/UTC"
```

### IO lists

IO list is a deeply nested structure in which leaf elements are plain bytes (or
binaries, which are again a sequence of bytes). 

```elixir
iex(1)> iolist = [[['H', 'e'], "llo,"], " worl", "d!"]
iex(2)> IO.puts(iolist)
Hello, world!
```



















