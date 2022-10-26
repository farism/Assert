# Introduction

`Assert` is an assertion library for the Beef programming language, loosely inspired by [Jest](https://jestjs.io/docs/getting-started)

It is an alternative to the Corlib `Test.Assert` function, which comes with some limitations.

The primary motivation for this library is that I wanted slightly better output than `Test.Assert` was providing. By passing in the values individually (rather than the boolen check that `Test.Assert` expects) we can then echo the values back to the user.

In addition to the values being tested, we can use the filepath and line info to read the problem file and show a code snippet of any failing assertions:

```
ERROR: Test failed. 
 >
 > Assert(val1 contains val2)
 >
 > val1: (1, 2, 3)
 > val2: 4
 >
 > d:\Projects\Beef\Assert\src\Assert.bf
 >
 > 284 | 
 > 285 | 	[Test]
 > 286 | 	static void AddTest()
 > 287 | 	{
 > 288 | 		Assert.Eq(2 + 2, 4);
 > 289 >>> 		Assert.Contains(int[](1, 2, 3), 4);
 > 290 | 	}
 > 291 | 
```

# Installing

1. Clone this repo somewhere to your system
2. In the Beef IDE, right-click workspace panel select "Add Existing Project".
3. Find the directory you that was cloned earlier
4. For each project that wiwill `Assert` 

# Usage

```bf
using Assert;

Assert.Eq(1, 1);
```

# Features

There is basic support for numerics, Strings, and IEnumerables.

## Numerics

```bf
Assert.Eq(1, 1);

Assert.Neq(1, 2);

Assert.Gt(2, 1);

Assert.Gte(2, 1);

Assert.Lt(1, 2);

Assert.Lte(1, 2);

Assert.CloseTo(1, 1.000001, 5);  // Close to within N digits (default: 2)
```

## String/StringView

Assert can accept and compare both `String` and `StringView`.

```bf
Assert.Eq(String("hello world"), StringView("hello world")); // Interchangeable

Assert.Neq("hello", "world");

Assert.Contains("hello world", " lo wo ");

Assert.NotContains("hello world", "foobar");

Assert.StartsWith("hello world", "hello");

Assert.EndsWith("hello world", "world");

Assert.Length("hello world", 11);
```


## IEnumerable

Any `IEnumerable` (including `SizedArray`) can be used with `Assert`. 

For `StartsWith`, `EndsWith`, `Contains` and `NotContains`, you can pass either another enumerable, or an individual element as the second parameter. All enumerable comparisons are contiguous.

```bf
Assert.Eq(int[](1, 2, 3), int[](1, 2, 3)); 

Assert.Neq(int[](1, 2, 3), int[](4, 5, 6)); 

Assert.Contains(int[](1, 2, 3), int[](1, 2)); 

Assert.Contains(int[](1, 2, 3), 1); 

Assert.NotContains(int[](1, 2, 3), int[](4, 5, 6)); 

Assert.NotContains(int[](1, 2, 3), 4); 

Assert.StartsWith(int[](1, 2, 3), int[](1, 2)); 

Assert.StartsWith(int[](1, 2, 3), 1); 

Assert.EndsWith(int[](1, 2, 3), int[](2, 3)); 

Assert.EndsWith(int[](1, 2, 3), 3); 

Assert.Length(int[](1, 2, 3, 4, 5), 5);
```