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
  - It would be nice if we can push a new version of our software without restating any servers.

### Erlang concurrency
Erlang handle with concurrency with its own hands.

1. The BEAM is a single OS process
2. Erlang process is a unit of concurrent execution
3. Scheduler is an OS thread responsible for executing multiple processes
4. BEAM uses multiple schedulers to parallelize the work over available CPU cores

The basic concurrency primitive is called _Erlang process_. That is different of OS process or
threads.

The concurrency system of Erlang promotes some nice features:

### Fault Tolerance
Erlang process are isolated from each other. The crash of one doesn't cause a crash of other
processes.

With that, you can:
- Isolate the effect of an unexpected error
- Have just a local impact
- Do something about it as fast as possible
- Start a new process in place of the broken one

### Scalability
It doesn't need complex synchronization. The process communicate via asynchronous messages.

Moreover, Erlang takes advantage of all available CPU cores.

### Distribution
The communication between process works the same way regardless of whether these processes reside
in the same BEAM instance or two different instances on two separate, remote computers.jk

### Responsiveness
The runtime is specifically tuned to promote the overall responsiveness of the system. I have
mentioned that Erlang takes the execution of multiple processes into its own hands by employing
dedicated schedulers that interchangeably execute many Erlang processes. A scheduler is
preemptive — it gives a small execution window to each process and then pauses it and runs another
process. Because the execution window is small, a single long-running process can’t block the rest
of the system. Furthermore, I/O operations are internally delegated to separate threads, or a
kernel-poll service of the underlying OS is used if available. This means any process that waits
for an I/O operation to finish won’t block the execution of other processes.

About ***garbage collector***: Recall that process are isolated and share no memory, Erlang permit
a per-process garbage collection -> instead of stopping the entire system, each process is
individually collected as needed.

## Server-side systems
Server-side systems are entire systems that, in addition to handling requests, must run various
background jobs and manage some kind of server-wide in-memory state.

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

In distributed server-side systems, Erlang do a great job, because every component in your app can
be an Erlang process. It doesn't matter if the application is in different machines or CPUs.







