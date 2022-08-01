# Chapter2 - Part 3

## Operators

Just the important parts:

- The division operator **always** returns a float. 

Weak and strict equality is important only when comparing integers to floats:

```elixir
iex(1)> 1 == 1.0
true
iex(2)> 1 === 1.0
false
```

## Macros

A macro consists of Elixir code that can change the semantics of the input code. A
macro is always called at compile time; it receives the parsed representation of the
input Elixir code, and it has the opportunity to return an alternative version of
that code.

```elixir
unless some_expression do
 block_1
else
 block_2
end
```

The snippet above  transform the input code into something like this:

```elixir
if some_expression do
 block_2
else
 block_1
end
```

Whenever I say that something is a macro, the underlying implication is that it runs
at compile time and produces alternative code.

## Understanding the runtime

It's a BEAM instance.

### Modules and functions in the runtime

Start a runtime -> an OS process for the BEAM instance is started and everything
runs inside it.

How does the runtime access the code?

- The VM keeps track of all modules loaded in memory
- When you call a function from a modules, BEAM first checks whether the module is
  loaded
- If it is, the code of the corresponding function is executed
- Otherwise, VM tries to find the compiled module file - the bytecode - on the disk
  and load it and execute the function

**Every compiled module resides in a file.**

### Module names and atoms

When you compile the source containing the Geometry module, the file generated on
the disk is named Elixir.Geometry.beam, regardless of the name of the input source
file. In fact, if multiple modules are defined in a single source file, the
compiler will produce multiple .beam files that correspond to those modules.

In the runtime, module names are aliases, and as I said, aliases are atoms. The 
first time you call the function of a module, BEAM tries to find the corresponding 
file on the disk. The VM looks for the file in the current folder and then in the 
code paths.

In case of `iex code.ex` the BEAM files aren't generated because iex tool performs
an in-memory compilation.

### Pure Erlang Modules

How to call:

```elixir
:code.get_path
```

In Erlang, modules also correspond to atoms. Somewhere on the disk is a file named
code.beam that contains the compiled code of the :code module.

The important thing to remember from this discussion is that at runtime, module
names are atoms. And somewhere on the disk is an xyz.beam file, where xyz is the
expanded form of an alias (such as Elixir.MyModule when the module is named
MyModule).

### Dynamically Calling Functions

Somewhat related to this discussion is the ability to dynamically call functions
at run- time. This can be done with the help of the Kernel.apply/3 function:

```elixir
iex(1)> apply(IO, :puts, ["Dynamic function call."])
Dynamic function call.

```

Kernel.apply/3 receives the module atom, the function atom, and the list of 
arguments passed to the function. Together, these three arguments, often called MFA
(for module, function, arguments), contain all the information needed to call an 
exported (public) function. Kernel.apply/3 can be useful when you need to make a 
runtime decision about which function to call.

### Starting the runtime

That are some ways:

- Interactive shell
  - `iex`

## Running scripts

```shell
$ elixir my_source.ex
```

When you start this, the following actions take place:

1. The BEAM instance is started.
2. The file my_source.ex is compiled in memory, and the resulting modules are
   loaded to the VM. No .beam file is generated on the disk.
3. Whatever code resides outside of a module is interpreted.
4. Once everything is finished, BEAM is stopped.

If you don’t want a BEAM instance to terminate, you can provide the --no-halt
parameter:

```shell
$ elixir --no-halt script.exs
```

### The mix tool

Used to manage projects that are made up of multiple source files (for production
projects is a good thing).

Creating a new `mix` project: 

```shell
$ mix new my_project
```

Inside of project's folder, you can compile the entire project:

```bash
mix compile 
```

The compilation goes through all the files from the lib folder and places the
resulting .beam files in the ebin folder.

**Regardless of how you start the mix project, it ensures that the ebin folder
(where the .beam files are placed) is in the load path so the VM can find your
modules.*




















