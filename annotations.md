@annotation:tour fulfill_a_promise
#Fulfill a Promise
###What is a promise?
A promise is an object that defines a method called "then". The promise object represents a value (or values) that may
be available some time in the future.  

When a promise is resolved, any "success functions" registered  with the "then" method will be called with the newly available data as arguments.  

If a promise is rejected then any "failure functions" registered with the "then" method will be called with the Error as argument.

For now, do not be concerned with exactly HOW this works or what the syntax is. We are about to dive into that in detail

###Setup
To do many of the lessons in this workshop, you will need to install the ["q"](https://npmjs.org/package/q) module. To do this, type the following in your project's directory:

    npm install q --save

This will install a local copy of the "q" module into your directory which you can import into file you have written using:

    var q = require('q');

###Task
- Use the popular "Q" library to create a promise. 
- Pass console.log to the "then" method of your promise.
- Manually resolve that promise using setTimeout with a delay of 300ms and pass it a parameter of "RESOLVED!".

In Q, promises are created using [`Q.defer()`](https://github.com/kriskowal/q/wiki/API-Reference#qdefer)

The defer that is created is not exactly the promise and in order to return the actual promise object itself you must return the "promise" attribute of the newly created defer.

###Boilerplate

    var q = require('q');
    var defer = q.defer(); 
    //defer.promise is the actual promise itself
    //defer.promise.then is the "Q" way of attaching a then handler
    //your solution here 


###Documentation
- [Q in npm](https://npmjs.org/package/q)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour reject_a_promise
#Rejecting a Promise
When a promise is rejected, this is typically (though not always) used to indicate that a value was not successfully obtained by the promise.  Once a promise has been rejected, it can never be resolved (nor rejected again).

Promises implement internal state machines that have strict rules against ever leaving either the resolved or rejected states.

###Task
Use ["q"](https://github.com/kriskowal/q/wiki/API-Reference) again to create a promise. Create a function to print error.message using console.log.  Pass this function as a rejection handler to the "then" method of your promise.

Manually reject that promise using setTimeout with a delay of 300ms and pass it an Error object with parameter "REJECTED!";

###Boilerplate

    var q = require('q');
    var defer = q.defer(); 
  
    //your solution here

###Documentation
- [Q in npm](https://npmjs.org/package/q)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)

@annotation:tour to_reject_or_not_to_reject
#To Reject or not to Reject
###What happens if we reject AND resolve a promise?

The [Promises/A+ spec](http://promises-aplus.github.io/promises-spec/) states that a promise, once fullfilled or rejected, may NOT change states for the rest of its lifetime.  This is an important feature of promises and it is also one of the things that differentiates it from an EventEmitter (and other forms of repeatable callbacks);

Callback-style code usually requires a callback function to be invoked somewhere in the body of the function that it was passed to.  Many, if not most times, that function is intended to be called only once.  However, through errors in logic, problems with syntax, or other simple mistakes it is possible to call your callback multiple times and create vexxing states in your app or insidious bugs.

    /*
      this code is bad, but nontheless common and has the nasty result of calling
      the supplied callback more than once (possibly destroying the earth?)
      it is conventional to return the first invocation of callback but it's 
      easy to overlook!
    */
    var function (user, callback) {
      if (user) {
        callback(null, user); 
      }
      return callback("No user was found", null);
    }

###Task
Let's build a simple script to PROVE to ourselves that promises may only resolve one time and all future attempts to resolve them will simple be ignored.

1. Create a promise using Q.defer
1. Pass console.log as the first AND second argument to your promises "then" method
1. Resolve the promise with a value of "I FIRED"
1. Reject the promise with a value of "I DID NOT FIRE"

If successful, your script should only log "I FIRED" and should NOT log "I DID NOT FIRE".

###Documentation
- [Q in npm](https://npmjs.org/package/q)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour always_async
#Always Async
###Are promises always resolved asynchronously?
The Promises/A+ spec declares that promises MUST fire their resolution/rejection function on the same turn of the event loop that they are created on.  This is very important because it eliminates the possibility of execution order varying and resulting in indeterminate outcomes.

You can expect that the functions passed to the "then" method of a promise will be called on the NEXT turn of the event loop.

###Task
In this lesson, we are going to prove to ourselves that this is the case by writing a script that does the following

1. Create a promise using the "Q" library
1. Pass console.log to the "then" method of our promise
1. Resolve the promise with a parameter "SECOND"
1. Print "FIRST" to the console using console.log

**Do this synchronsouly and NOT in a setTimeout as was the case in previous lessons**

Your script will pass and show you that despite the promise being resolved synchronously, the provided function is not executed until the next turn of the event loop.

Thus, you should see "FIRST", "SECOND"


@annotation:tour values_and_promises
#Values and Promises
###Do I HAVE to return promises?
NO!  Fulfillment handlers may return promises OR values.  Your Promises/A+ library will do the correct thing and wrap your
return value in a promise if need be.  This is awesome because it allows you to intermix values with promises in a chain.

Imagine that you have a a cache of models that may already contain a model you would like to request from the server.  You could check your cache synchronously and return the found value OR send an ajax request to your remote server to fetch it.  

Wrapping this functionality in a promise means that both behaviors can be consumed under a single abstraction: 

    doSomeSetup()
    .then(function () {
      return cache.fetchModel(id) 
        ? cache.fetchModel(id)
        : promisedAjax("users/" + id);
    })
    .then(displayUser)
    .then(null, handleError);

The key thing to understand here is that your handlers will WRAP your return values in promises even if they are obtained synchronously.

Another very important point to understand is that, as discussed before, the returned value will resolve on the NEXT turn of the event loop.

###Task
Construct a promise chain that returns VALUES to prove to yourself that promise handlers will wrap your returned values in promises allowing additional chaining.

1. Construct a promise using Q's defer
1. Construct a function "attachTitle" which prepends "DR. " to its first argument and returns the result.
1. Build a promise chain off the promise we constructed initially that first calls "attachTitle" then calls console.log.
1. Resolve the promise you created with a value of "MANHATTAN".

If your program runs successfully, it should print out "DR. MANHATTAN" which is extremely exciting.  

###Documentation
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour throw_an_error
#Throw an Error
###What happens when an error is thrown?
One of the tremendous strengths of promises is that they handle errors in a manner similar to synchronous code.  Unlike in traditional callback-based code, you do not need to strictly handle all your errors at every step.  

If an error is thrown inside a function, it can be captured.

If an error is thrown inside a function, it will be handled by the next available "rejection" handler.  This allows you to write code that looks remarkably like a "try/catch" block would in synchronous code.

    try {
      doSomethingRisky();
      doAnotherRiskyThing();
    } catch (e) {
      console.log(e);
    }

The equivalent "promisified" code might look like: 

    doSomethingRisky()
    .then(doAnotherRiskyThing)
    .then(null, console.log);

###Task
Let's build exactly the system discussed above. Some invalid JSON will be available on process.argv[2];

1. Build a function called parsePromised that creates a promise, performs JSON.parse in a try/catch block, and resolves or rejects the promise depending on whether an error is thrown. **NOTE** your function should synchronously return the promise!
2. Build a sequence of steps like the ones shown above that catches any thrown errors and logs them to the console.

###Documentation
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour using_qfcall
#Using qfcall
###Using Q's fcall to simplify our code
Wrapping a value or synchronous function call in a promise is a fairly easy pattern to capture in a generic way.

The "Q" library has a function for just this purpose called [fcall](https://github.com/kriskowal/q/wiki/API-Reference#promisefcallargs).

###Task
Use fcall to replace the entire parsePromised function from the previous lesson.

###Documentation
- [fcall](https://github.com/kriskowal/q/wiki/API-Reference#promisefcallargs)


@annotation:tour an_important_rule
#An Important Rule
###There's always a catch....(lol pun)
Promises are designed to emulate synchronous control flows. If any of them throw an exception, the exception will bubble up 
through the stack until it is caught by a catch block or hits the global context where it will be thrown.

In the code below, each expression is evaluated one after the other. If any expression throws an exception, ALL SUBSEQUENT 
EXPRESSIONS WILL NOT BE EXECUTED and the catch block will catch and handle it.

    try {
      doStuff()
      doMoreStuff()
    } catch (err) {
      complainAboutJavascript(err);
    }

With promises, we can achieve a very similar control flow as shown (assume all functions return promises) :

    doStuff()
    .then(doMoreStuff)
    .then(null, complainAboutJavascript);

Maybe we should combine the last two lines since one is a fulfill handler and the other is a rejection handler?  NO!  While this might initially seem sensible consider what would happen if doMoreStuff threw an error.  Since the promise returned from it would be rejected, it would look for the NEXT rejection handler to handle it.  

**Remember:** A promise can NEVER resolve more than once.  

It is, therefore, a best practice to always put a rejection handler at the bottom of your promise chain (much like a catch block).

It is worth pointing out that both the synchronous AND asynchronous code have the same problem.  If the rejection handler itself throws an error you are going to have a bad time.  

Many promise libraries try to ameliorate this problem for you by providing a "done" handler that simple handles any uncaught
errors.  The rule of thumb is this: 

  *If you are NOT returning a value from your promise to a caller, then attach a "done" handler to gaurd against uncaught exceptions".*

An example is shown below:

    doStuff()
    .then(doMoreStuff)
    .then(null, complainAboutJavascript)
    .done();

###Task
We are going to demonstrate this to ourselves by creating a chain of functions that ALL print to the console.  

1. Create a function "throwMyGod" that throws an Error with text "OH NOES"
2. Create a function "iterate" that prints the first argument (an integer) to it and then returns that argument + 1;
3. Create a promise chain that wraps your iterate method using Q's fcall then a series of iterations that attempts to perform iterate 10 times.  
4. Attach console.log as a rejection handler at the bottom of your chain.
5. Insert a call to "throwMyGod" after your 5th call of "iterate"

If you have done this correctly, your code should print 1,2,3,4,5, "[Error: OH NOES]". It's important to notice that the thrown exception was turned into a rejected promise which caused the rejected promise to travel down the promise chain to the first available rejection handler.

###Bonus
Try swapping your rejection handler from console.log to throwMyGod. Your program will now throw an exception in the global context! Ahh! Try to fix this using the approach described above.

###Documentation
- [fcall](https://github.com/kriskowal/q/wiki/API-Reference#promisefcallargs)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour multiple_promises
#Multiple Promises
###Can you do what async does?
When doing asynchronous programming you will often want to perform multiple operations in parallel. In some cases you may wish to delay further processing until a list of async operations have completed.

In synchronous code this is trivial because our operations are executed in the order they are specified:

    var thingOne = getThing(1);
    var thingTwo = getThing(2);

    combine(thingOne, thingTwo);

We would like to build a function such that we can specify a list of asynchronous values we would like to fetch and then use once all are available.

    getAll([fetch(1), fetch(2)])
    .then(function (first, second) {
      console.log(first, second);
    });

###Task
Let's build this function!

1. Construct two promises using Q's defer
1. Construct a function "all" that accepts two promises as arguments. Your function should create an internal promise using Q's defer and return it! 
   - Your function should create a counter variable with initial value of 0.
   - Your function should attach "then" fulfillment handlers to both promises which increment an internal counter and fulfill the function's internal promise with an array containing BOTH values IF the counter reaches 2.
   - You should ALSO attach rejection handlers to both promises which both reject the internal promise!
1. Pass your two promises into your new function and then attach console.log as a fulfillment handler to the promise returned by your function.
1. Attach a function to setTimeout that resolves both of the promises you created and passed to your function with the values "PROMISES" and "FTW" respectively. Set the timeout delay to 200ms.

**TIP:** Don't forget to pass the "promise" attribute of your deferreds!
     
If your function is successful it should print out ["PROMISES", "FTW"] which is just someone's opinion man!

###Bonus
Try using Q's [all](https://github.com/kriskowal/q/wiki/API-Reference#promiseall) method to replace your function.  Note that their implementation expects you to pass it an ARRAY of promises and not individual arguments.

###Super Bonus
Try using Q's [spread](https://github.com/kriskowal/q/wiki/API-Reference#promisespreadonfulfilled-onrejected) method to replace your "then" handler on the promise returned by "all".  Note that spread will return individual arguments which should affect your output slightly!

Q.all, .spread, etc are just some of the many promise utility functions that many promise libraries make available or that you can easily build for yourself.  The composability of promises (do to them being re-ified objects) is a huge upside and you can quickly discover many amazing patterns for building async systems.

###Documentation
- [all](https://github.com/kriskowal/q/wiki/API-Reference#promiseall)
- [spread](https://github.com/kriskowal/q/wiki/API-Reference#promisespreadonfulfilled-onrejected)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour fetch_json
#Fetch JSON
###Let's do something, you know, from "real life"

**Let's fetch JSON over HTTP... YAY!**

Fetching JSON data from a remote machines via AJAX is commonplace on both the server and client.  Promises also happen to map to AJAX particularly well.  Any AJAX request may either succeed or fail and never both.  Promises may fulfill or reject and never both.  

So wow.  Much similarity.  Very promising...

Let's use a new module called [q-io](https://npmjs.org/package/q-io) to take advantage of its ["http.read"](https://github.com/kriskowal/q-io/#readrequest-object-or-url) method which returns a promise for the value of a successful HTTP response body.

Install by typing

    npm install q-io

##Task
Fetch JSON from "http://localhost:1337" and console.log it.

There are several things you will want to know:

1. q-io's http module has a [read](https://github.com/kriskowal/q-io/#readrequest-object-or-url) method which returns a promise for the content of a successful (status 200) http request.
2. Parse the returned JSON and console.log it for much win.

This challenge is a bit tricky but the implementation is relatively straightforward. If you get stuck, refer to the [q-io documentation](https://github.com/kriskowal/q-io/#q-io) for clarification.

###Documentation
- [read](https://github.com/kriskowal/q-io/#readrequest-object-or-url)
- [q-io documentation](https://github.com/kriskowal/q-io/#q-io)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour do_some_work
#Do Some Work
###Let's do several operations against "remote" machines
Sending and fetching data from computers/processes other than your application is an increasingly common task in the world of node.js and the browser.  Many times, you will need to gather data from several sources, perform operations on it, and send some data back out.

###Task
Let's talk to two remote processes over HTTP being run by your friend and mine, "localhost"

    Port 7000: Faux session cache (redis or some such thing) 
    Port 7001: Faux database (mongo, level, postgres etc)

As in the previous lesson, use the "q-io" module to create promises as wrappers for HTTP responses.  HINT: You will probably need more than one promise...

1. Send an HTTP GET request to the session cache on port 7000.  A JSON payload will be returned to you containing a primary key called "id".  
2. Grab that id from the session response and send an HTTP GET request to your database on port 7001 to the url `localhost:70001/<id>`.
3. If successfully done, your database will return a user object. `console.log` it to win many nerd-points.

###Hint
Don't forget that [q-io's read method](https://github.com/kriskowal/q-io/#readpath-options) returns a buffer. You will need to convert it to a string and JSON.parse it to complete this lesson!

###Documentation
- [read](https://github.com/kriskowal/q-io/#readrequest-object-or-url)
- [q-io documentation](https://github.com/kriskowal/q-io/#q-io)
- [Q API Reference](https://github.com/kriskowal/q/wiki/API-Reference)


@annotation:tour more_functional
#More Functional
###Let's tweak/refactor the previous lesson to be more declarative!
Functional programming carries with it some stigmas that can scare many people away. This is unfortunate because you can in fact write clear, elegant code using a small subset of [functional programming](http://en.wikipedia.org/wiki/Functional_programming).  

The previous lesson is an excellent candidate for additional functional refactoring. Here is the previous lesson's solution in case you don't have it:

    var q = require('q')
      , qhttp = require('q-io/http');
    
    qhttp.read("http://localhost:7000/")
    .then(function (id) {
      return qhttp.read("http://localhost:7001/" + id);
    })
    .then(function (json) {
      console.log(JSON.parse(json));
    })
    .then(null, console.error)
    .done();

Let's refactor this function using the popular [lodash](http://lodash.com/docs) library.  Install it with:

    npm install --save lodash

In particular, you may want to use [_.bind](http://lodash.com/docs#bind), [_.compose](http://lodash.com/docs#compose), or others as you see fit.  

The solution will work out of the box since the problem is the same as the previous. Focus on reasoning about how to use function composition to make your promise chain as declarative as possible.  Refer to the provided solution once you have given it some thought and see if you can completely understand it.

###Documentation
- [lodash docs](http://lodash.com/docs)
- [lodash on npm](https://npmjs.org/package/lodash)
- [bind](http://lodash.com/docs#bind)
- [compose](http://lodash.com/docs#compose)













