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

**You can only modify values that already exist in the map. With this feature, maps
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

Elixir provides another sintax to strings, the *sigils*. Ex.:

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

There's a special *heredocs* syntax for better formatting multiline strings:

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

This creates a *character list* which is essentially a list of integers in which each
element in that list represents a character.

```elixir
iex(2)> [65, 66, 67]
'ABC'
```

MN: don't got it.

Just like binary strings, here you have syntax counterparts for various definitions,
such as interpolation (`#{}`), sigil (`~c()`) and unescaped sigil (`~C`) and
*heredocs* (''').

Most of the operations from the `String` module won't work with character lists. In
general, use binary strings.

If a functions works only with character lists (this mostly happens with pure Erang
libraries), you can convert with `String.to_charlist/1`.

To convert a character list to a binary string you can use `List.to_string/1`.

## First-class functions




























