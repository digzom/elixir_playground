# Data Abstrations

In this chapter we will deal with building highter-level data structures. Such as Money,
Date, OrderItem, etc.

In Elixir we don't have classes with methods. We have modules with functions.

String and List are modules implemented in pure Elixir, and they have functions to help
the building process.

We have `modifier functions`, with returns data of the same type of the argument. It's
the case of String.upcase/1 or List.insert_at.

Finally, we have `query functions` that returns some piece of information from the data.
Such as String.length or List.first/1. That kind of function expects an instance of the
data abstraction as argument, but returns another type of information.

The base principles of data abstractions in elixir:

- A module is in charge of abstracting some data
- The module's functions usually expect an instance of the data abstration as the fist
  argument
- Modifier functions return a modified version of the abstraction
- Query functions return some other type of data

## Abstracting with modules

MapSet, for example, is a map, but with some features abstracted into functions. It's a
Struct.

### Basic abstraction

Check the folder `todo_list`.

### Composing Abstractions

Check the folder `todo_list`.

The goal is to demonstrate that the code organization isn't that different from an OO
approach. We use different tools to create abstractions - stateless modules and pure
functions instead of classes and methods.

### Abstracting with structs

With `Structs` we can define and enforce some structure.

To se how to define, check the `fraction.ex` file.

A struct may exist only in a module, and a single module can define only one struct.

Access properties of a map with dot is slighly slowly than with patter matching, where
you read all field in a match. In normal situations it shoudn't make much of difference.

**Structs vs maps**

Structs relies on top of maps, but there are some manipulations in maps that can't be
done with structs.

You can't call the `Enum` functions on a structs. You have to specify that the struct
is an enumerable for this work properly. But you can call `Map` functions to deal with
structs.

```elixir
iex(4)> Map.to_list(one_half)
[__struct__: Fraction, a: 1, b: 2]
```

The `__struct__: Fraction` part is automatically included in each struct. It helps
Elixir to distinguish structs from map and performs proper runtime dispatches from it
whitin polymorfic generic code.

A `struct` can't match a plain map.

```elixir
iex(5)> %Fraction{} = %{a: 1, b: 2}
** (MatchError) no match of right hand side value: %{a: 1, b: 2}
```

But a plain map pattern can match a struct:

```elixir
iex(5)> %{a: a, b: b} = %Fraction{a: 1, b: 2}
%Fraction{a: 1, b: 2}
```

This happen because in a match with maps, **all fields on the left hand expression must
exist on the right hand**. So, that works:

```elixir
%Fraction{a: a, b: b} = %{__struct__: Fraction, a: 1, b: 2}
```

**Records**

It is tuples with names. There's not much to say about because that isn't widely used in
elixir. One common using case is to extract records in erlang files.

### Data transparency

Data is always transparent in elixir. Even if you don't want to, the data and the way it
is handled in the abstractions is returned when we use there abstractions.

When we inspect some structs, a special sintax is printed for us to improve redability.
But if we need to know what is whitin an struct abstraction, we can set `struct: false`
as an option in `IO.inspect`:

```elixir
iex(2)> IO.puts(inspect(mapset, structs: false))
%{__struct__: MapSet, map: %{monday: [], tuesday: []}, version: 2}
```

So you can always see the structure of the data. In functional programming, hide things
isn't enforced.

Only complex types are tuples, lists and maps. Any other structure is built on top of
these types.

## Working with hierarchical data

Please, refer to better_todo_list.ex.

## Polymorphism with protocols

Polymorphism is a runtime decision about which code to execute, based on the nature of
the input data. In Elixir we can do this with *protocols*.

The Enum module, for example, is a generic code that works on anything enumerable:

```elixir
Enum.each([1, 2, 3], &IO.inspect/1) # list
Enum.each(1..3, &IO.inspect/1) # range
Enum.each(%{a: 1, b: 2}, &IO.inspect/1) # map
```

The same Enum.each/2 function works for two different types of data. Enum.each doesn't
know nothing about how to walk each structure. It's protocol contract.

### Protocol basics

Protocol is a module in which you declare functions without implementing them. Like
abstract interfaces in OO. The generic logic relies on the protocol, and you can provide
a concrete implementation for different data types.

Ex.:

```elixir
defprotocol String.Chars do # protocol definition
  def to_string(thing) # function declaration
end
```

As you can see, **the function was declared, but not implemented**.

The argument is what will determine the implementation that is called.

To create the protocol to our TodoList, we have to implement the corresponding
protocol:

```elixir
defimpl Collectable, for: TodoList do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(todo_list, :halt), do: :ok
end
```

Now we can implement a list comprehension to deal with our BetterTodoList struct.
Or, if you prefer, use `Enum.into/2`.

```elixir
for entry <- entries, into: TodoList.new(), do: entry
```


Whithout the protocol implementation, we could't to this.

We adapted the BetterTodoList abstraction to any generic code that relies on that
protocol, such as list comprehensions and `Enum.into/2`.


