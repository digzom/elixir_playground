# Chapter 5 - Concurrency primitives

Understanding concurrency in BEAM.

## Concurrency in BEAM

To make your system highly available, you have to tackle the following challenges:

- Falt tolerance -- Minimize, isolate and recover from the effects of runtime
  errors.
- Scalability -- Add more hardware resource whithout changing the code
- Distribution -- Run the system on multiple machines as fallbacks

**A BEAM process shouldn't be confused with an OS process. BEAM process is lighter
and *cheaper.**

A server system must handle simultaneous requests from different clients, mantaining
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

Process can comunicate with each other.

*A process can be considered a container of this data -- a place where an immutable
structure is stored and kept alive for a longer time, possibly forever*.

>### Concurrency vs. parallelism
>Concurrency doesn't necessarily imply parallelism. Two concurrent things have
>independent execution contexts, but this doesn't mean that they will run in
>parallel. If you run two CPU-bound concurrent tasks and you only have one CPU core,
>parallel execution doesn't happen.