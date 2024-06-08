# Elixir in Action

Here you can find some notes about that book.

# Erlang

Made to be a reliable programming platform

## High availability

Erlang worry about the core concepts to be a high available system:
- Fault tolerance
  - All you want is to keep your system running.
  - Localize the impact of an error as fast as possible
  - Recover
- Scalability
  - A system should be able to handle any possible load.
- Distribution
  - To make a system that never stops, you have to run it in a multiple machines.
- Responsiveness
  - A system have to be reasonable fast and responsive.
  - Occasional load increase shouldn't block the rest of the system
- Live update
  - It would be nice if we can push a new version of our software without restating
    any servers.

### Erlang concurrency

Erlang handle with concurrency with its own hands.

1. The BEAM is a single OS process
2. Erlang process is a unit of concurrent execution
3. Scheduler is an OS thread responsible for executing multiple processes
4. BEAM uses multiple schedulers to parallelize the work over available CPU cores

The basic concurrency primitive is called _Erlang process_. That is different of OS
process or threads.

The concurrency system of Erlang promotes some nice features:

### Fault Tolerance

Erlang process are isolated from each other. The crash of one
doesn't cause a crash of other processes.

With that, you can:
- Isolate the effect of an unexpected error
- Have just a local impact
- Do something about it as fast as possible
- Start a new process in place of the broken one

### Scalability

It doesn't need complex synchronization. The process communicate via
asynchronous messages.

Moreover, Erlang takes advantage of all available CPU cores.

### Distribution

The communication between process works the same way regardless of
whether these processes reside in the same BEAM instance or two different instances
on two separate, remote computers.

### Responsiveness 

The runtime is specifically tuned to promote the overall
responsiveness of the system. I have mentioned that Erlang takes the execution of
multiple processes into its own hands by employing dedicated schedulers that
interchangeably execute many Erlang processes. **A scheduler is preemptive — it gives
a small execution window to each process and then pauses it and runs another
process.** Because the execution window is small, a single long-running process can’t
block the rest of the system. Furthermore, I/O operations are internally delegated to
separate threads, or a kernel-poll service of the underlying OS is used if available.
This means **any process that waits for an I/O operation to finish won’t block the
execution of other processes**.

About **garbage collector**: Recall that process are isolated and share no memory,
Erlang permit a per-process garbage collection -> instead of stopping the entire
system, each process is individually collected as needed.

## Server-side systems

Server-side systems are entire systems that, in addition to
handling requests, must run various background jobs and manage some kind of
server-wide in-memory state.

Attributes of this server-side systems can be:
- HTTP server
- Request processing
- Long-running requests
- Server-wide state
- Persist Data
- Background jobs
- Cache
- Service Crash Recovery

Yep, Erlang can do all of this. 

In distributed server-side systems, Erlang do a great job, because every component in
your app can be an Erlang process. It doesn't matter if the application is in
different machines or CPUs.

## The development platform

Erlang is platform consisting in four distinct parts:
- The language
  - It's a simple, functional language with basic concurrency primitives
  - Source code written in Erlang is compiled into ***bytecode***, that's then
    executed in the BEAM
- The virtual machine
  - The virtual machine parallelizes the concurrent Erlang programms
  - Take care of isolation, distribution and responsiveness
- The framework
  - The OTP framework
    - It's a general propose framework that abstracts away many typical Erlang tasks:
      - Concurrency and distribution patterns
      - Error detection and recovery in concurrent systems
      - Packaging code into libraries
      - Systems deployment
      - Live code updates
- The tools

# Elixir

Is an alternative language for the Erlang VM. Cleaner and more compact.

Compiling the Elixir source code results in a BEAM-compliant bytecode files that can
run in a BEAM instance and can normally cooperate with pure Erlang code. You can use
Erlang libraries from Elixir and vice versa.

Elixir is semantically close to Erlang, but Elixir provides some additional
constructs that make it possible to raddically reduce boilerplate and duplication.

## Code simplification 

_"One of the most important benefits of Elixir is its ability
to radically reduce boilerplate and eliminate noise from code, which results in
simpler code that’s easier to write and maintain."_ (pag. 33, 1.2.1)

Writting in Erlang is verbose. The boilerplate code is very present. It's common to
repeat code through modules/files/implementations.

**Macro**: a _macro_ is Elixir code that runs at compile time. Macros take an
internal representation of your source code as input and can create alternative
output.

Elixir _macros_ work on an abstract syntax tree (AST) structure, which makes it
easier to perform nontrivial manipulations of the input code to obtain alternative
output. To simplify all this transformation, Elixir provides helper constructs:

```elixir
defcall sum(a, b) do
  reply(a + b)
end
```
Here, `defcall` isn't a keyword in Elixir. This is a custom macro that translates the
given definition to something like the like this:

```elixir
def sum(server, a, b) do
  GenServer.call(server, {:sum, a, b})
end

def handle_call({:sum, a, b}, _from, state) do
  {:reply, a + b, state}
end
```

Because **macros** are written in Elixir, they're flexible and powerful, making it
possible to extend the language and introduce new constructs that look like an
integral part of the language.

Fun fact: most of Elixir is written in Elixir. Language constructs like if, and
unless, and support for structures are implemented via Elixir macros. Only the
smallest possible core is done in Erlang.

With macros we can extend the language with our own DSL-like constucts.

> Domain-specific Language. Pragmatically, a DSL may be specialized to a
> particular problem domain, a particular problem representation technique, a
> particular solution technique, or other aspects of a domain.

## Composing functions

Both Erlang and Elixir are functional languages. They rely on immutable data and
functions that transform data. 

To avoid staircasing composition, Elixir gives you an elegant way to chain multiple
functions calls together. It's the **pipeline operator**:

```elixir
def process_xl(model, xml) do
  model
  |> update(xml)
  |> process_changes
  |> persist
end
```

The |> takes the result of the previous expression and feeds it to the next one as
the first argument. No need to read from inside out.

It was made with Elixir macro.

You treat functions as data transformations and then combine them in different ways
to gain the desired effect.

### The big picture

**Elixir improvements**
- API for standard libraries is cleaned up
- Concise syntax for working with structured data
- Explicit support for Unicode manipulation
- A Mix tool that simplifies common tasks such as creating applications and
  libraries, manage dependencies, and compiling and testing code.
- A package manager called Hex (http://hex.pm)

## Disadvantages

No technology is a silver bullet.

### Speed

Erlang programs run in BEAM and therefore can't achieve the speed of machine-compiled
languages, such as C and C++. But this isn't accidental.

The goal of the platform is keep performance predictable and within limits. With
Erlang we want stability on our system. The level of performance your Erlang system
achieves on a given machine shouldn't. degrade significantly, meaning there shouldn't
be unexpected system hiccups due to, for example, garbage collector.

After all, long-running BEAM process don't block the rest of the system.

As the load increases, BEAM can use as many hardware resources as possible. If the
hardware capacity isn't enough, the system won't be paralyzed. The scheduler, which
performs frequent context switches that keep the system ticking. And of course, you
can address higher system demand by adding more hardware.

If you need intensive CPU computations, you should probably consider some other
technology.

### Ecosystem

The ecosystem around Erlang and Elixir isn't small, but isn't big as that of some
other languages.

Maybe for some problems that other languages could solve with a good ready-to-use
package will take more time with elixir/erlang. 

## Disadvantages

Yep, even elixir has some.

### Speed

It is note as fast as C or C++, but erlang was created to handle stability. It will use as many hardware as available to complete the tasks and handle requests, but if the hardware isn't enough, you can expect a graceful degradation, having slower requests, but never a crashed system. If you system demands a lot of CPU resources, maybe erlang isn't the best solution for you project.

### Ecosystem

We have a lot of packages and libs, but not much as javascript, java or other mainstream language. But we are growing fast.


