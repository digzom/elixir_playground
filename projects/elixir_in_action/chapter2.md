# Chapter 2

- Using the interactive shell
- Working with variables
- Organizing your code
- Understanding the type system
- Working with operators
- Understanding the runtime

This chapter presents the basic building blocks of the language.

## The interactive shell

Just run `iex` on terminal.

Running `iex` starts an instance of the BEAM and then starts an interactive Elixir
Shell inside it.

After you type an expression, it's interpreted and executed. Its return value is then
printed to the screen.

We can use double press in Ctrl+C to exit the interactive shell, but if we want a
more polite way to do it, we can use `System.halt`.

To obtain help, just run the command `h`.

## Working with variables

The variable type is determined by the data it contains at the moment. In Elixir, we
call assignments as *binding*. 

When you assign a value to a variable, the value is bound to that value:
```elixir
iex(1)> name = "Joseph" # Binds variable
"Joseph" # result of the last expression
```

In elixir, all expressions has a result. The result of = operation is whatever is on
the right side.

Variables can end with question mark (?) or exclamation mark (!).

`name?`
`address!`

*Rebinding doesn't mutate the existing memory location*. It reserves memory and
reassigns the symbolic name to the new location.

So, the variables are mutable, **but the data they point to is immutable**.

We don't need to manually release memory, elixir is garbage-collected language.

When a variable goes out of scope, the corresponding memory is eligible for garbage
collection and will be released sometime in the future, when the garbage collector
cleans up the memory.

## Organizing your code

Multiple functions can be further organized into modules.

### Modules

A module is a collection of functions. Every Elixir function must be defined inside a
module.

```
iex(1)> IO.puts("Hello world")         <- Calls the puts function of the IO module
Hello world                            <- Function IO. puts prints to the screen
:ok                                    <- Return value of IO.puts
```

Remember: every expression in elixir returns a value.

To define our own module, we can use `defmodule` and `def` to functions.

To run a module we can copy/paste in shell, but we can tell to iex to interpret the
file while starting:

```shell
$ iex geometry.ex
```

A module must be defined in a single file. A single file may contain multiple module
definitions.

Rules of module name:
- Starts with uppercase letter
- CamelCase style
- Alphanumerics
- Underscores
- Dot

The dot is used to organize modules hierarchically:

```elixir
defmodule Geometry.Rectangle do
...
end

defmodule Geometry.Circle do
...
end
```

### Functions

A functions must **always** be a part of a module.

The ? character is often used to indicate a function that returns either *true* or
*false*.

The character ! at the end of the name indicates a function that may raise a runtime
error.

Both are **conventions**.

> Notice that `def` and `defmodule` aren't keywords. They are *macros*!

If a function has no arguments, we can omit the parentheses:

```elixir
defmodule Program do
  def run do
    ...
  end
end
```

There's no explicit return in Elixir. The return is the last expression.

On the interactive shell we can use *pipeline operators* too.

```elixir
iex(1)> -5 |> abs() |> Integer.to_string() |> IO.puts()
5
```

This code is transformed at compile time into the following:

```elixir
iex(1)> IO.puts(Integer.to_string(abs(-5)))
5
```

Pipeline operator places the result of the previous call as the first argument of the
next call. So:

```
prev(arg1, arg2) |> next(arg3, arg4)
```

Is translated to:

```
next(prev(arg1, arg2), arg3, arg4)
```

### Function Arity

Arity is a fancy name for the number of arguments a function receives.

A function is uniquely identified by:
- Its containing module
- Its name
- Its arity

We can delegate some_function/1 to some_function/2:

```elixir
defmodule Calculator do
  def sum(a), do: sum(a, 0)
  def sum(a, b), do: a + b
end
```

The lower arity function is implemented in terms of a highter-arity one.

**Setting default arguments**:

```elixir
defmodule Calculator do
  def sum(a, b \\ 0), do: a + b
end
```

Default values generate multiple functions of the same name with different arities.

### Function visibility

With `defp` you can define a **private function**. A private function can be called
only inside the module it's defined in.

```elixir
defmodule TestPrivate do
  def double(a) do
    sum(a, a)
  end

  defp sum(a, b) do
    a + b
  end
end
```

### Imports and alias

Calling functions from another module can be cumbersome, because you need to
reference the module name.

We can call the entire module and use its public functions without reference the
module every time we want the function:

```elixir
def module do
  import IO

  def my_function do
    puts "Calling imported function"
  end
end
```

With the *alias* construct, we can reference a module under different name:

```elixir
defmodule MyModule do
  alias IO, as: MyIO

  def my_function do
    MyIO.puts("whatever")
  end
end
```

If you application is divided into a deeper module hierarchy, it can be  cumbersome
to reference modules with full names. Alias can help with this:

```elixir
defmodule MyModule do
  alias Geometry.Rectangle, as: Rectangle

  def my_function do
    Rectangle.area(...)
  end
end
```

We can skip the as options when the alias is the last part of the name of the module
you are calling.

`alias Geometry.Rectangle` will work to.

### Module attributes

> MN: It's not clear to me what are the implications of *"be stored in the generated binary
> and can be accessed at runtime"*. That means that I can make modifications when the program
> is being read? @pi exists only in compilation time so at runtime the variable @pi doesn't
> exist, just the value, instead?

They can be used as compile-time constants and you can register any attribute (wich
can be required in runtime).

```elixir
iex(1)> defmodule Circle do
  @pi 3.14159
  def area(r), do: r * r * @pi
  def circumference(r), do: 2 * r * @pi
end

iex(2)> Circle.area(1)
3.14159
iex(3)> Circle.circumference(1)
6.28318
```

This constant exists only during the compilation of the module, when the references
to it are inlined.

Moreover, an attribute can be *registered*, which means it will be stored in the
generated binary and can be accessed at runtime.

Elixir registers some module attrributes by default:

```elixir
defmodule Circle do
  @moduledoc "Implements basic circle functions"
  @pi 3.14159

  @doc "Computes the area of a circle"
  def area(r), do: r*r*@pi

  @doc "Computes the circumference of a circle"
  def circumference(r), do: 2*r*@pi
end
```

You can access this documentation with `h Circle` in `iex`.

**The point is: registered attributes can be used to attach meta information to a module,
which can then be used by other Elixir (and even Erlang) tools.**

### Type Specifications (typespecs)

This feature allows you to provide type information for your functions, which can later be
analyzed with a static analys tool called `dialyzer`.

> **Dialyzer** is a static analysis tool that identifies software discrepancies, such as
> definite type errors, code that has become dead or unreachable because of programming
> error, and unnecessary tests, in single Erlang modules or entire (sets of) applications.

Typespects provide a way of compensating for the lack of a static type system and better
document functions.

Extend Circle module to include typespecs:

```elixir
defmodule Circle do
  @moduledoc "Implements basic circle functions"
  @pi 3.14159

  @spec area(number) :: number
  def area(r), do: r*r*@pi

  @spec circumference(number) :: number
  def circumference(r), do: 2*r*@pi
end
```

We're saying that both area and circumference receives a number and returns a number.

## Understanding the type system

### Numbers













