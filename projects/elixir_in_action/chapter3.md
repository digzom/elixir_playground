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

**If and Unless**
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

**Cond**

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

**Case**

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
multiple expressions, verify that the result of each conforms to the desired
pattern, and return the first unexpected result.

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

If one of that terms fail, it will return the internal error message of the
function called.

























