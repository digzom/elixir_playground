# Control flow

## Pattern Matching

The `=` operator isn't an assignment, instead, when I wrote `a = 1`, I said variable
`a` was bound to the value 1. The `=` operator is called the *match operator*.

### The match operator

```elixir
iex(1)> person = {"Bob", 25}
```

The left side is called *pattern*. In the right side you have an expression that
evaluates to an elixir term.

### Matching tuples

```elixir
iex(1)> {name, age} = {"Bob", 25}
```

It's useful when you call a function that returns a tuple:

```elixir
iex(4) {date, time} = :calendar.local_time()
iex(5)> {year, month, day} = date
iex(6)> {hour, minute, second} = time
```

### Matching contants

```elixir
iex(1)> 1 = 1
1
```

Constants can help you to compound and decide what how to control what you want to
retrieve:

```elixir
iex(2)> person = {:person, "Bob", 25}
iex(3)> {:person, name, age} = person
{:person, "Bob", 25}
```

If you have different kinds of atoms inside that tuple indicating a "type" (:person,
:animal, :any), with the snipper above you can retrieve the information of only the
type you want.

In the right-side term you expect a three-element tuple, with the first element
having a value of :person.

Suppose that you want to read a configuration file:

```elixir
iex(1)> {:ok, content} = File.read("my_app.config")
```

In this single line of code, three distinct things happen:

1. An attempt to open and read the file my_app.config takes place.
2. If the attempt succeeds, the file contents are extracted to the variable 
   contents.
3. If the attempt fails, an error is raised. This happens because the result of 
   File.read is a tuple in the form {:error, reason}, so the match to {:ok, 
   contents} fails.

***By using constants in patterns, you tighten the match, making sure some part of
the right side has a specific value.***

### Variable in patterns

Whenever a variable name exists in the left-side pattern, it always matches the
corre sponding right-side term. In addition, the variable is bound to the term it
matches.

Use *anonymous variable* (_) to ignore values:

```elixir
iex(1)> {_, time} = :calendar.local_time()
iex(2)> time
{20, 44, 18}
```

You can add a description name:

```elixir
iex(1)> {_date, time} = :calendar.local_time()
```

You can use that variable in a program, but the compiler will emit a warning.

You can nest the patterns. Let's say you only want to retrieve the current hour of
the day:

```elixir
iex(3)> {_, {hour, _, _}} = :calendar.local_time()
```

You can reference a variable multiple times in the same patter:

```elixir
iex(5)> {amount, amount, amount} = {127, 127, 127}
{127, 127, 127}

# it rises and error because the tuple elements aren't identical
iex(6)> {amount, amount, amount} = {127, 127, 1} 
** (MatchError) no match of right hand side value: {127, 127, 1}
```

Sometimes you will need to match against the contents of the variable. For this
purpose, the *pin operator (^) is provided.

```elixir
iex(7)> expected_name = "Bob"

iex(8)> {^expected_name, _} = {"Bob", 25}
{"Bob", 25}
iex(9)> {^expected_name, _} = {"Alice", 30}
** (MatchError) no match of right hand side value: {"Alice", 30}
```

### Matching lists

```elixir
iex(1)> [first, second, third] = [1, 2, 3]
[1, 2, 3]
```

```elixir
iex(6)> [min | _] = Enum.sort([3,2,1])
iex(7)> min
1
```

### Matching maps

To match a map, the following syntax can be used:

```elixir
iex(1)> %{name: name, age: age} = %{name: "Bob", age: 25}
%{age: 25, name: "Bob"}
iex(2)> name
"Bob"
iex(3)> age
25
```

When matching a map, the left-side pattern doesn’t need to contain all the keys from
the right-side term:

```elixir
iex(4)> %{age: age} =
%{name: "Bob", age: 25}
```

### Matching binary strings

```elixir
iex(16)> command = "ping www.example.com"
"ping www.example.com"
iex(17)> "ping " <> url = command
"ping www.example.com"
Matching the string
iex(18)> url
"www.example.com"
```

### Compound matches

```elixir
iex(1)> [_, {name, _}, _] = [{"Bob", 25}, {"Alice", 30}, {"John", 35}]
```

```elixir
iex(4)> a = b = 1 + 3
4
```

Let’s say you want to retrieve the function’s total result (datetime) as well as the
current hour of the day. Here’s the way to do it in a single compound match:

```elixir
iex(6)> date_time = {_, {hour, _, _}} = :calendar.local_time()
```

The pattern-matching expression consists of two parts: the pattern (left side) and
the term (right side). In a match expression, the attempt to match the term to the 
pattern takes place. 

### Matching with functions

No annotations.

### Multiclause functions

If you provide multiple definitions of the same function with the same arity, it’s
said that the function has multiple clauses.

When you call the function, the runtime goes through each of its clauses, in the
order they’re specified in the source code, and tries to match the provided
arguments.

### Guards

```elixir
defmodule TestNum do
  def test(x) when x < 0 do
    :negative
  end

  def test(0), do: :zero

  def test(x) when x > 0 do
    :positive
  end
end


iex(4)> TestNum.test(:not_a_number) 
:positive 
```

What gives? The explanation lies in the fact that Elixir terms can be compared
with the operators < and >, even if they’re not of the same type. In this case,
the type ordering determines the result: number < atom < reference < fun < port
< pid < tuple < map < list < bitstring (binary)

The set of operators and functions that can be called from guards is very
limited. In particular, you may not call your own functions, and most of the
other functions won’t work:

- Comparison operators (==, !=, ===, !==, >, <, <=, >=)
- Boolean operators (and, or) and negation operators (not, !)
- Arithmetic operators (+, -, *, /)
- Type-check functions from the Kernel module (for example, is_number/1, is_
  atom/1, and so on)

If an error is raised from inside the guard, it won’t be propagated, and the
guard expression will return false. The corresponding clause won’t match, but
some other might.

### Multiclause lambdas

```elixir
iex(3)> test_num =
  fn
    x when is_number(x) and x < 0 ->
      :negative

    0 -> :zero

    x when is_number(x) and x > 0 ->
      :positive
end
```

## Conditionals

### Branching with multiclause functions

## If and Unless

```elixir
if condition do
...
else
...
end

or

if condition, do: something, else: another_thing
```  

If a condition isn't met, and the `else` clause isn't specified, the return value is
the atom nil.

## Cond

If you used cond, the simple max/2 function could look like this:
```elixir
def max(a, b) do
  cond do
    a >= b -> a
    true -> b # equivalent of a default clause
  end
end
```

The `true` pattern ensures that the condition will always be satisfied.

### Case

The case construct is most suitable if you don’t want to define a separate
multiclause function.

### The with special form

Useful when you need to chain a couple of expressions and return the error of the
first expression that fails. Example:

Suppose you need to process registration data submitted by a user. The input is
a map, with keys being strings (“login”, “email”, and “password”). That's the input:

```elixir
%{
  "login" => "alice",
  "email" => "some_email",
  "password" => "password",
  "other_field" => "some_value",
  "some_other_field" => "some_other_value"
}
```

Your task is to normalize this map into a map that contains only the fields login,
email and password.

You can return the following structure:

```elixir
%{login: "alice", email: "some_email", password: "password"}
```

But some required field might not be present in the input map. In this case, you
want to report the error.


You can write helper functions:

```elixir
defp extract_login(%{"login" => login}), do: {:ok, login}
defp extract_login(_), do: {:error, "login missing"}
defp extract_email(%{"email" => email}), do: {:ok, email}
defp extract_email(_), do: {:error, "email missing"}
defp extract_password(%{"password" => password}), do: {:ok, password}
defp extract_password(_), do: {:error, "password missing"}
```

After that, you will write the top-level extract_user/1 function:

```elixir
def extract_user(user) do
  case extract_login(user) do
    {:error, reason} -> {:error, reason}
    {:ok, login} ->
      case extract_email(user) do
        {:error, reason} -> {:error, reason}
        {:ok, email} ->
          case extract_password(user) do
            {:error, reason} -> {:error, reason}
            {:ok, password} ->
              %{login: login, email: email, password: password}
          end
      end
  end
end
```

Quite noisy, huh? The with special form allows you to use pattern matching to chain
multiple expressions, verify that the result of each conforms to the desired pattern, and
return the first unexpected result.

```elixir
with pattern_1 <- expression_1,
     pattern_2 <- expression_2,
     ...
do
  ...
end
```

Ex.:

```elixir
with {:ok, login} <- extract_login(user)
     {:ok, email} <- extract_email(user) do
  %{login: login, email: email}
end
```

If one of that terms fail, it will return the internal error message of the function
called.

In the background, this is a pattern matching: 

```elixir
{:ok, login} = {:ok, "alice"}
{:ok, email} = {:ok, "email"}
%{login: login, email: email}
```

# Loops

## Recursion

All that shit about lists.

### Tail function call

We have a *tail call* when the last thing our recursive function is doing is calling
another function.

In Erlang, we have something called *tail call optimization*. In this case, calling a
function doesn't result in the usual *stack push*. What happens is more like a GOTO
statement. You don't allocate additional stack space *before* calling the function,
**which in turn means the tail function call consumes no additional memory**. How is this
possible?

```elixir
def original_fun() do
  ...
  another_fun()
end
```

In the previous snippet, the last thing *original_fun* is doing is calling
*another_fun*. So, in this case, the compiler can safely perform the operation by
jumping to the beginning of *another_fun* without doing additional memory allocation.

When *another_fun* finishes, you return to whatever place original_fun was called.

That's why this is useful in recursive functions. You don't need to branching the
function returns, you just store the result of the functions -- I guess.

The downside of tail-call recursive functions: whereas classical (non-tail) recursion has
a more declarative feel to it, tail recursion usually looks more procedural.

Example of a tail-recursive function:

```elixir
defmodule ListHelper do
  def sum(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []) do
    current_sum
  end

  defp do_sum(current_sum, [head | tail]) do
    new_sum = head + current_sum
    do_sum(new_sum, tail)
  end
end
```

NOTE: Given the properties of tail recursion, you might think it’s always a preferred
approach for doing loops. It’s not that simple. Non-tail recursion often looks more
elegant and concise, and it can in some circumstances yield better performance. When you
write recursion, you should choose the solution that seems like a better fit. If you need
to run an infinite loop, tail recursion is the only way that will work. Otherwise, the
choice amounts to which looks like a more elegant and performant solution.

### Higher-order functions

Is a function that takes one or more functions as its and returns one or more functions.
Ex:

```elixir
iex(1)> Enum.map([1, 2, 3], &(2 * &1))
```

The user extracting example with Enum.filter, the HOC:

```elixir
case Enum.filter(
  ["login", "email", "password"],
  &(not Map.has_key?(user, &1))) do
  [] ->
    ...
  missing_fields ->
    ...
```

### Reduce

The most versatile function from module Enum. You can transform an enumerable into
anything.

Sum all elements of a list:

In javascript, a imperative pattern:

```js
let sum = 0 // initializes the sum 
[1, 2, 3].forEach(element => sum += element) // accumulates the result
```

In a functional language, you can't change the accumulator. How we do?

```elixir
Enum.reduce(enumerable, initial_acc, fn element, acc -> ... end)
```

Practical example:

```elixir
Enum.reduce(
  [1, 2, 3], # initial state
  0, # initial state of the accumulator
  fn element, sum -> sum + element end # it returns the new accumulator value
)
```

The lambda function is called in each iteration step. Its task is to add a bit of
information to the result.

You may recall that **some operators are functions**. So you can invoke an operation with
them like this: &+/2. We can use it with High Order Functions:

```elixir
Enum.reduce([1, 2, 3], 0, &+/2) # 6
```

You can use multiclause lambda functions to control the conditions:

```elixir
# kinda messy
Enum.reduce(
  [1, "not a number", 2, :x, 3],
  0,
  fn
    element, sum when is_number(element) -> sum + element
    _element, sum -> sum
  end
)

# a better approach
defmodule NumHelper do
  def sum_nums(enumerable) do
    Enum.reduce(enumerable, 0, &add_num/2)
  end

  defp add_num(num, sum) when is_number(num), do: sum + num
  defp add_num(_, sum), do: sum
end
```

### Comprehensions

Another construct to iterate and transform enumerables.

The below implementation is used to square each element of a list.

```elixir
for x <- [1, 2, 3] do
  x * x
end
```

It's possible to perform nested iterations over multiple collections. The following
example takes advantage of this feature to calculate a small multiplication table:

```elixir
for x <- [1, 2, 3], y <- [1, 2, 3], do: {x, y, x * y}
[
  {1, 1, 1}, {1, 2, 2}, {1, 3, 3},
  {2, 1, 2}, {2, 2, 4}, {2, 3, 6},
  {3, 1, 3}, {3, 2, 6}, {3, 3, 9}
]
```

Comprehensions can iterate through anything that's enumerable. You can use range to
compute multiplication table for single-digit numbers:

```elixir
for x <- 1..9, y <- 1..9, do: {x, y, x * y}
```

The result of a comprehension can be anything that's *collectable*. A comprehension
iterates through enumerables, calling the given block for each elemenet and storing the
results in some collectable structure.

```elixir
multiplication_table =
  for x <- [8], y <- 1..9, into: %{} do
      {{x, y}, x * y}
  end
```

The result of the above snippet will be the answer to everything.

The `into` option which specify what to collect. This will return a map which the first
element of the tuple is used as a key that maps to the second element, which is the value.

Another interesting feature of comprehensions is that you can specify filters. The
following example computes nonsymmentrical multiplication_table for numbers x and y.

```elixir
multiplication_table =
  for x <- 1..9, y <- 1..9, x <= y, into: %{} do
    {{x, y}, x * y}
  end
```

`x <= y` is the filter. It's almost like a `when`. If the filter returns true, the block
is colled and the result is collected. Otherwise, the comprehension moves on the next
element.

Iterates through tuples:

```elixir
users = [user: "john", admin: "meg", guest: "barbara"] # yes, it's a tuple
for {type, name} when type != :guest <- users do
  String.upcase(name)
end

["JOHN", "MEG"]
```

### Streams

Streams are a special kind of enumerable that can be useful for doing lazy composable
operations over anything enumerable.

Let's say you have a list of employees, and you need to print each one prefixed by their
position in the list.

```md
1. Alice
2. Bob
3. John
```

Normally, we would do something like that:

```elixir
emp
  |> Enum.with_index()
  |> Enum.each(fn {employeer, position} -> IO.puts("#{position + 1} - #{employeer}") end)
```

And it works. But here we have to much iterations. With streams we can minimize this.

**A stream is a lazy enumerable**.

Using stream to double each element in a list:

```elixir
iex(1)> stream = [1, 2, 3] |> Stream.map(fn x -> 2 * x end)

#the result is a stream:
#Stream<[enum: [1, 2, 3], funs: [#Function<47.108234003/1 in Stream.map/2>]]>
```

Because is a stream, the iteration and the computation (in this case multiplication)
haven't yet happened. Instead, you get the structure that describes that computation.

To make it happen, you have to send the stram to an `Enum` function.

```elixir
iex(5)> Enum.to_list(stream)
[2, 4, 5]
```

`Enum.to_list(stream)` is an *eager operation*. When it starts to iterating through the
input, `Enum.to_list` requests that the input enumerable start producing values.

```elixir
iex(45)> emp |> Stream.with_index() |> Enum.each(fn {employeer, position} -> IO.puts("#{position + 1}. #{employeer}") end)
```

With stream, the output is the same, but values are produced one by one when Enum.to_list
requests another element. This is useful when you need to compose multiple
transformations.
For example, you can use Enum.take/2 to request only one element from the stream:

```elixir
iex(1)> Enum.take(stream, 1)
[2]
```

**Read this again:** because Enum.take/2 iterates only until it collects the desired
number of element, the input stream doubled only one element in the list. The others were
never visited.

The following example takes the input list and prints the square root:

```elixir
[9, -1, "foo", 25, 49]
  |> Stream.filter(&(is_number(&1) and &1 > 0))
  |> Stream.map(&{1, :math.sqrt(&1)})
  |> Stream.with_index()
  |> Enum.each(fn {{input, result}, index} ->
       IO.puts("#{index + 1}. sqrt(#{input}) = #{result}")
     end)
```

Even though you stack multiple transformations, everything is performed in a single pass
when you call Enum.each. If you used Enum functions in every case, you did have to run
multiple iterations over each intermediate list. With large data, this will incur in bad
performance.

**A typical case is when you need to parse each line of a file. Relying on eager Enum
functions means you have to read the entire file into memory and then iterate through
each line. In contrast, using streams makes it possible to read and immediately parse
one line at a time.**

Reading a file and returning only the lines that is larger than 80 characters:

```elixir
def large_lines(path) do
  File.stream!(path)
  |> Stream.map(&String.replace(&1, "\n", "")) 
  |> Enum.filter(&(String.length(&1) > 80))
end
```

In the above example we use `File.stream`, and because of that, no byte from the file
has been read yet at the return.

When `Enum.filter` is called, you really execute the iteration. So you never read the
entire file in memory; instead, you work on each line individually.

**In a nutshell, to make a lazy computation, you need to return a lambda that performs
*the computation.  This makes the computation lazy, because you return its description
*rather than its result. When the computation needs to be materialized, the consumer
*code can call the lambda.**
