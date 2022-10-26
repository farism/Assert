using System;
using System.Reflection;
using System.Diagnostics;
using System.Collections;

namespace Assert.Utils;

static
{
	public static mixin fp()
	{
		Compiler.CallerFilePath
	}

	public static mixin ln()
	{
		Compiler.CallerLineNum
	}

	public static String EnumerableToString<T, U>(T a, String buf) where T : concrete, IEnumerable<U>
	{
		let tmp = scope $"";
		var i = 0;
		for (let v in a)
		{
			if (i > 0)
				tmp.Append(", ");
			tmp.AppendF($"{v}");
			i++;
		}

		if (tmp.Length > 80)
		{
			buf.AppendF($"[{tmp[...40]} .... {tmp[^40...]}]");
		} else
		{
			buf.AppendF($"[{tmp}]");
		}

		return buf;
	}

	public static List<U> EnumerableToList<T, U>(T a, List<U> b) where T : concrete, IEnumerable<U>
	{
		for (let x in a)
			b.Add(x);

		return b;
	}

	public static int EnumerableToLength<T, U>(T a) where T : concrete, IEnumerable<U>
	{
		var i = 0;
		for (let x in a)
			i++;

		return i;
	}

	public static mixin NullCheck<T>(T a, T b)
	{
		if (a == null && b == null)
		{
			return true;
		} else if (a == null || b == null)
		{
			return false;
		}
	}

	public static bool Equals<T, U>(T a, T b) where T : concrete, IEnumerable<U>
	{
		NullCheck!(a, b);

		let alist = EnumerableToList(a, scope List<U>());
		let blist = EnumerableToList(b, scope List<U>());

		if (alist.Count != blist.Count)
			return false;

		for (let i in ..<alist.Count)
			if (alist[i] != blist[i])
				return false;

		return true;
	}
}