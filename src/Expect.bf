using System;
using System.Reflection;
using System.Diagnostics;
using System.Collections;
using Assert.Utils;

namespace Assert.Expect;

public struct Expectation<T>
{
	T target;
	String filePath;
	int line;
	bool not;

	public this(T target, String filePath, int line, bool not = false)
	{
		this.target = target;
		this.filePath = filePath;
		this.line = line;
		this.not = false;
	}

	public Self Not
	{
		get mut
		{
			this.not = not;
			return this;
		}
	}

	public void ToEqual(T other) where T : var
	{
		if (not)
		{
			Assert.Neq(target, other, filePath, line);
		} else
		{
			Assert.Eq(target, other, filePath, line);
		}
	}

	public void ToStartWith(T other) where T : var
	{
		Assert.StartsWith(target, other, filePath, line);
	}

	public void ToEndWith(T other) where T : var
	{
		Assert.EndsWith(target, other, filePath, line);
	}

	public void ToContain(T other) where T : var
	{
		if (not)
		{
			Assert.NotContains(target, other, filePath, line);
		} else
		{
			Assert.Contains(target, other, filePath, line);
		}
	}
}

/*public struct Expectation<T, U> where T : IEnumerable<U>
{
	public struct Assertions<T, U>
	{
		Expectation<T, U> expectation;

		public this(Expectation<T, U> exp)
		{
			this.expectation = exp;
		}

		public void Equal(T other) where T : IEnumerable<U>
		{
		}

		public void Contain(U other) where T : IEnumerable<U>
		{
		}
	}

	T target;
	String filePath;
	int line;

	public this(T target, String filePath, int line)
	{
		this.target = target;
		this.filePath = filePath;
		this.line = line;
	}

	public Assertions<T, U> To
	{
		get
		{
			return Assertions<T, U>(this);
		}
	}
}*/

static
{
	public static Expectation<T> Expect<T>(T a, String fp = fp!(), int ln = ln!())
	{
		return Expectation<T>(a, fp, ln);
	}


	/*public static Expectation<T, U> Expect<T, U>(T a, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		return Expectation<T, U>(a, fp, ln);
	}*/
}

static
{
	[Test]
	static void Expect()
	{
		/*Expect(1).Not.ToEqual(1);
		Expect(int[](1, 2, 3)).Not.ToEqual(int[](1, 2, 4));
		Expect("").Not.ToEqual("");*/
	}

	[Test]
	static void ExpectNot()
	{
	}
}