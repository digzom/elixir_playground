# Chapter 5 - Concurrency primitives

Understanding concurrency in BEAM.

## Concurrency in BEAM

To make your system highly available, you have to tackle the following challenges:

- Fault tolerance -- Minimize, isolate and recover from the effects of runtime
  errors.
- Scalability -- Add more hardware resource without changing the code
- Distribution -- Run the system on multiple machines as fallback

**A BEAM process shouldn't be confused with an OS process. BEAM process is lighter
and cheaper.**

A server system must handle simultaneous requests from different clients, maintaining
shared state (caches, user session data). We have to execute the processing/jobs
simultaneously, thus taking the advantage of all available CPU resources. One job
must not block another pending jobs.

Tasks should be as isolated from each other as possible. We don't want a unhandled
crashed task crashing another an unrelated task or leaving behind an inconsistent
memory state. 

With processes, we can archive:

`scalability`, spawning processes to run in parallel with more hardware. 

`fault-tolerance` when we ensure isolation. With processes we can localize and limit
the impact of unexpected runtime errors.

In BEAM, a process is a concurrent thread of execution. Unlike OS processes or
threads, BEAM processes are handled by VM and uses its own scheduler to manage their
concurrent execution.

The entire BEAM VM is a single OS process that has many child process. Each BEAM
process has its own scheduler to handle its own child process, which can be many of
them. BEAM uses as many schedulers as there are CPU cores available. On a quad-core
machine, four schedulers are used. Each scheduled process gets an execution time
slot; after time is up, the running process is preempted and the next one takes
over.

**With parallelism you can take advantage of all available CPU's on your machine.**

BEAM provides a means to detect a process crash and do something about it.

Process can communicate with each other.

*A process can be considered a container of this data -- a place where an immutable
structure is stored and kept alive for a longer time, possibly forever*.

## Working with processes

### Concurrency vs. parallelism

>Concurrency doesn't necessarily imply parallelism. Two concurrent things have
>independent execution contexts, but this doesn't mean that they will run in
>parallel. If you run two CPU-bound concurrent tasks and you only have one CPU core,
>parallel execution doesn't happen.

Simulating a long-running database query:

```elixir
run_query = 
  fn query_def ->
    Process.sleep(2000)
      "#{query_def} result"
    end
```

If we run this "query" five times it will take 10 seconds to get all the results. This isn't efficient and neither performant nor scalable.

### Creating processes

To create a process we can use spawn/1 function:

```elixir
spawn(fn -> 
  expression_1 
  ...
  expression_2
end)
```

It takes a zero-arity lambda function that will run in the new process. After
process is created, spawn immediately returns, and the caller process's execution
continues. After the lambda is done, the spawned process exits and its memory is released.

We can write a helper lambda that concurrently runs the query:

```elixir
async_query =
  fn query_def ->
    spawn(fn -> IO.puts(run_query.(query_def)) end)
end
``` 

*This code demonstrates an important technique: passing data to the created process.
Notice that async_query takes one argument and binds it to the query_def variable.
This data is then passed to the newly created process via the closure mechanism.
The inner lambda—the one that runs in a separate process—references the variable
query_def from the outer scope. This results in cross-process data passing—the
contents of `query_def` are passed from the main process to the newly created one.*

When the data is passed to another process, the data is deep-copied, because two processes
can't share memory.

Because it is concurrently executed, the processes are completely independent and isolated,
the order of data cannot be guaranteed. 

The caller of the process doesn't have access to the returned data.

To retrieve the result of the concurrent operation to the caller process, we can use
**message-passing** mechanism.

### Message Passing

Sometimes you need the result to do something with the process result data. For example, you
may want a main process that spawns multiple concurrent calculations, and then you want to
handle all the results in the main process.

When a process A wants process B to do something, it sends an asynchronous message to B.
The caller (A) continues with its own execution, and the receiver can pull the message in
at any time and process it in some way. 

The receiver can call the macro `receive` to take one message from the mailbox and process
it.











