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
> and can be accessed at runtime"*. That means that I can make modifications when the
> program is being read? @pi exists only in compilation time so at runtime the variable
> @pi doesn't exist, just the value, instead?

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

Can be **Integers** or **floats**.

The division operator always returns a float value. To perform integer division, you can
use auto-imported Kernel function `div` and `rem` to get the remainder.

### Atoms

Atoms are literal named constants.

```
:an_atom
:another_atom
```

An atom consists of two parts: the **text** and the **value**.

The atom text is whatever you put after the colon character. At runtime, this text is kept
in the **atom table**.

The value is the data that goes into the variable, and it's merely a reference to the atom
table.

They are best used for **named constants**. Efficient both memory and performance-wise.

- Low memory consuption
- Fast comparisons
- Code still redable

### Aliases

There's another syntax for atom constants. Omit the beginning colon and start with an
uppercase character:

`AnAtom`
`Another.Atom`

At compile time, this *alias* is transformed: `Elixir.AnAtom`, `Elixir.Another.Atom`.

It's no accident that the term *alias* is used for this and the alternative names that we
discussed before. When you write `alias IO, as: MyIO`, for example, you instruct the
compiler to transform `MyIO` into `IO`. The final result emitted in the generated binary is
`Elixir.IO`.

### Atoms as booleans

```elixir
:true === true
:false === false
```

Booleans, in Elixir, are just atoms that has value of true or false.

### Nil and Truthy Values

Nil é o mesmo que null em outras linguagens.

```
nil == :nill
```

Nil and false are *falsy* values. Everything else is *truthy*. 

Sort-circuit operators: ||, &&, !.

### Tuples

Tuples are something like untyped structures, or records, and they're most often used to
group a fixed number of elements together.

```elixir
person = {"Bob", 25}
```

**Extracting an element from the tuple**

```elixir
iex(2)> age = elem(person, 1)
25
```

`Kernel.elem/2` accepts a tuple and the zero-based index of the element.

**Modifying an element from the typle**

```
iex(3)> put_elem(person, 1, 26)
{"Bob", 26}
```

***WHAT? This is mutability!***

Wow, calm down. `put_elem` doesn't modify the tuple. It returns the new version, keeping
the old one intact. Data in Elixir is immutable. Check `person` again.

If you store `put_elem(person)` into `person` variable again, you do the **rebind** and
the older version of the tuple is eligible for garbage collector, since the old location
isn't referenced by any other variable.

### Lists

Lists are used to manage dynamic, variable-sized collections of data.

```
iex(1)> prime_numbers = [2, 3, 5, 7]
[2, 3, 5, 7]
```

It's different of arrays. `Kernel.length`, exempli gratia, need to iterate through the
entire list to calculate its length.

To get an element of a list, you can use `Enum.at/2` function. It takes the enumerable as
first argument and the "index" as second argument.


For direct access, don't use Lists. Intead, use tuples, maps or a higher level data
structure.

Check if a particular element is in a list:

```elixir
iex(4)> 5 in prime_numbers
true
```

Modifying an element at a certain position:

```elixir
iex(6)> List.replace_at(prime_numbers, 0, 11)
```

As was the case with tuples, the modifier doesn't mutate the variable, but returns the
modified version of it. 

You can rebind too:

```elixir
iex(8)> prime_number = List.replace_at(prime_number, 0, 11)
[11, 3, 5, 7]
```

You can insert a new element at the specified position wit the List.insert_at:

```elixir
iex(9)> List.insert_at(prime_number, 3, 13)
[11, 3, 5, 13, 7]
```

You'll recall javascript right now, but you can use a negative value to insert a value at
the last position:

```elixir
iex(10)> List.insert_at(prime_numbers, -1, 13)
[11, 3, 5, 7, 13]
```

You can use negative numbers to iterate back to front.

Remember: **modifying an arbitrary element has a complexity of O(n)**. In particular,
appending to the end is expensive because it always takes *n* steps, *n* being the length
of the list.

Concatenete two lists:

```elixir
iex(11)> [1, 2, 3] ++ [4, 5]
[1, 2, 3, 4, 5]
```

In general, we should avoid append elements to the end of a list. Lists are more efficient
when new elements are pushed to the top, or popped from it.

**Notes about Linked List vs Array**

Arrays: 
- Arrays store elements in contiguous memory locations, enabling fast access
- Since the data is contiguously stored, we just need to access the next memory to get data
- Fixed size, can't change at runtime due to risk of overwriting
- Allocates memory at compile time (if the array is not dynamic)
  - Thats why the size is fixed
- Use memory upper limit on the size
- Any element can be accessed with its index
  - Better cache locality due to contiguous memory (can improve performance)
  - Faster to modify an element
  - **To insert an element** (and the array is full), we have to copy the array and make a new
  one with the new data

Linked Lists:
- Less rigid about their storage structure and elements are usually not stored in
  contiguous locations
- Need to be stored with additional tags giving a reference to the next element
- Head points to the second, wich points to the third, with points to the fourth, wich
  ponts to..., wich points to null
- Dynamically sized. Can change at run time since addressess is scattered (each node 
  points to another node)
- Allocates memory at runtime
- For the same number of elements, **use more memory** as a reference to the next node is
  also stored along with the data. However, size flexibility in linked lists use less
  memory overall, bacause it can increase their sizes step-by-step, proportionally.
- All previous memory must be traversed to reach any element
- Faster to delete/insert element in the data
- **To insert an element**, we can just localize the last node and make it next to the new node
- To access an element, we have to to access elements sequentially, starting from the first
  node (isn't possible to do a binary search)
  - Maybe pattern matching in elixir fits well in this cases. When running through the list
  we can return whatever match with the setted choice

![Tabela sobre Arrays](/Screenshot20220525085154.png "Tabela sobre Arrays")

### Recursive list definition

- Lists are **recursive structures**
- Represented by a pair (head, tail)
  - *head* is the first element
  - *tail* "points" to the (head, tail) pair of the remaining elements

Representation:

![Representação de lista](/list_schema.png "Representação de lista")

Special syntax to support recursive list definition:

```elixir
a_list = [head | tail]
```

`head` can be any type of data, whereas `tail` is a list. If `tail` is empty, it's the end
of the entire list.

```elixir
iex(10)> [1 | [2 | [3 | [10 | []]]]]
[1, 2, 3, 10]
```

To get the `head` of the list, you can use the `hd` function. The tail can be obtained by
calling the `tl` function:

```elixir
iex(1)> hd([1, 2, 3, 4])
1
iex(2)> tl([1, 2, 3, 4])
[2, 3, 4]
```

Both operations is O(1), because they amount to reading one or the other value from the
(head, tail) pair.

**NOTE:** Tail doesn't need to be a list. It can be any type. When the tail isn't a list, it's said that the list is *improper* and most of the std list manipulations won't work.

Now we can push a new item to a list with this pattern:

```elixir
iex(1)> a_list = [5, :value, true]
[5, :value, true]

iex(2)> new_list = [:new_element | a_list]
[:new_element, 5, :value, true]
```

Construction of `new_list` is an O(1) operation, and no memory copying occurs -- the tail
of the `new_list` **is** the a_list. We just added a new item that *points* to `a_list`.

### Imutability

In Elixir, the result of a function resides in another memory location. The modification
of the input will result in some data copying, but generally, most of the memory will be
shared between the old and the new version.

**Modifying typles**

A modified tuple is always a complete shallow copy of the old version:

```elixir
a_tuple = {a, b, c}
new_tuple = put_elem(a_tuple, 1, b2)
```

The variable `new_tuple` will contain a shallow copy of `a_tuple`.

Both tuples reference variables `a` and `c`, and whatever is in those variables is shared
(and not duplicated) between both tuples.

In case of rebinding, `a_tuple` will reference another memory location, not the same with
different value. It is **really** imutable. The old location turns available for garbage
collection.

Tuples are always copied, but the copying is shallow (memory level).

**Modifying Lists**

When you modify the *nth* element of a list, the new version will contain shallow copies of
the first *n - 1* elements, followed by the modified element. After that, the tail is
completely shared.

That's why adding elements to the end of a linked list is expensive. To append a new
element at the tail, you have to iterate and copy the entire list.

But, pushing an element to the top of a list doesn't copy anything.

In this case, the new list’s tail is the previous list.

```elixir
iex(2)> [3 | list]
[3, 1, 2, 3, 4]
```

In this example, the [1, 2, 3, 4] part of the new list **is** the previous list. I added 3
to the head, that points to that previous list.

**Benefits**

- Side effect free
- Data consistency

The implicit consequence of immutable data is the ability to hold all versions of a data
structure in the program:

```elixir
def complex_transformation(original_data) do
  original_data
  |> transformation_1 (...)
  |> transformation_2 (...)
end
```

This code starts with original data and passes it through a series of transformations. Each
one is a new, modified version of the input (original data).

If something goes wrong, the function `complex_transformation` can return `original_data`,
because none of the transformations will modify the memory ocupied by original_data.

### Maps
pag 65























