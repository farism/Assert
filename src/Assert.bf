using System;
using System.Reflection;
using System.Diagnostics;
using System.Collections;
using Assert.Utils;

namespace Assert;

static class Assert
{
	static let dict = new System.Collections.Dictionary<String, String>() ~ delete _;

	static void Error(String a, String op, String b, String filePath, int line)
	{
		var file = scope $"";
		if (let i = dict.GetValue(filePath))
		{
			file = i;
		} else
		{
			System.IO.File.ReadAllText(filePath, file);
			dict.Add(filePath, file);
		}

		let output = scope $""
			..AppendF("\n")
			..AppendF($" Assert(val1 {op} val2)\n", line, filePath)
			..AppendF("\n")
			..AppendF($" val1: {a}\n")
			..AppendF($" val2: {b}\n")
			..AppendF("\n")
			..AppendF($" {filePath}\n")
			..AppendF("\n");

		var i = 0;
		for (let str in file.Split("\n"))
		{
			i++;
			if (i >= line - 5 && i <= line + 5)
			{
				let arrow = i == line ? ">>>" : "|";
				output.AppendF($" {i} {arrow} {str}\n");
			}
		}

		output.AppendF("\n");

		Internal.[Friend]Test_Error("");
		Internal.[Friend]Test_Write(output);
	}

	static bool ContainsItems<T, U>(T a, T b) where T : concrete, IEnumerable<U>
	{
		for (let i in b)
		{
			var found = false;

			for (let j in a)
			{
				if (j == i)
					found = true;
			}

			if (!found)
				return false;
		}

		return true;
	}

	static bool ContainsItem<T, U>(T a, U b) where T : concrete, IEnumerable<U>
	{
		for (let v in a)
		{
			if (v == b)
				return true;
		}

		return false;
	}



	public static void Eq<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a != b)
			Error(scope $"{a}", "==", scope $"{b}", fp, ln);
	}

	public static void Eq<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : concrete, IEnumerable<U>
	{
		if (!Equals(a, b))
			Error(scope $"{a}", "==", scope $"{b}", fp, ln);
	}

	public static void Neq<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a == b)
			Error(scope $"{a}", "!=", scope $"{b}", fp, ln);
	}

	public static void Neq<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		if (Equals(a, b))
			Error(scope $"{a}", "!=", scope $"{b}", fp, ln);
	}

	public static void Gt<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a <= b)
			Error(scope $"{a}", ">", scope $"{b}", fp, ln);
	}

	public static void Gte<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a < b)
			Error(scope $"{a}", ">=", scope $"{b}", fp, ln);
	}

	public static void Lt<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a >= b)
			Error(scope $"{a}", "<", scope $"{b}", fp, ln);
	}

	public static void Lte<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : var
	{
		if (a > b)
			Error(scope $"{a}", "<=", scope $"{b}", fp, ln);
	}

	public static void Contains<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : StringView
	{
		if (!a.Contains(b))
			Error(scope $"{a}", "contains", scope $"{b}", fp, ln);
	}

	public static void Contains<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : concrete, IEnumerable<U>
	{
		if (!ContainsItems(a, b))
			Error(scope $"{a}", "contains", scope $"{b}", fp, ln);
	}

	public static void Contains<T, U>(T a, U b, String fp = fp!(), int ln = ln!()) where T : concrete, IEnumerable<U>
	{
		if (!ContainsItem(a, b))
			Error(scope $"{a}", "contains", scope $"{b}", fp, ln);
	}

	public static void NotContains<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : StringView
	{
		if (a.Contains(b))
			Error(scope $"{a}", "not contains", scope $"{b}", fp, ln);
	}

	public static void NotContains<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : concrete, IEnumerable<U>
	{
		if (ContainsItems(a, b))
			Error(scope $"{a}", "not contains", scope $"{b}", fp, ln);
	}

	public static void NotContains<T, U>(T a, U b, String fp = fp!(), int ln = ln!()) where T : concrete, IEnumerable<U>
	{
		if (ContainsItem(a, b))
			Error(scope $"{a}", "not contains", scope $"{b}", fp, ln);
	}

	public static void StartsWith<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : StringView
	{
		if (!a.StartsWith(b))
			Error(scope $"{a}", "starts with", scope $"{b}", fp, ln);
	}

	public static void StartsWith<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		var condition = true;

		let alist = EnumerableToList(a, scope List<U>()),
			blist = EnumerableToList(b, scope List<U>()),
			astr = EnumerableToString(a, scope $""),
			bstr = EnumerableToString(b, scope $"");

		if (alist.Count < blist.Count)
		{
			condition = false;
		} else
		{
			for (let i in ..<blist.Count)
				if (alist[i] != blist[i])
					condition = false;
		}

		if (!condition)
			Error(scope $"{astr}", "starts with", scope $"{bstr}", fp, ln);
	}

	public static void StartsWith<T, U>(T a, U b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		let astr = EnumerableToString(a, scope $"");

		if (EnumerableToList<T, U>(a, scope List<U>())[0] != b)
			Error(scope $"{astr}", "starts with", scope $"{b}", fp, ln);
	}

	public static void EndsWith<T>(T a, T b, String fp = fp!(), int ln = ln!()) where T : StringView
	{
		if (!a.EndsWith(b))
			Error(scope $"{a}", "ends with", scope $"{b}", fp, ln);
	}

	public static void EndsWith<T, U>(T a, T b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		var condition = true;

		let alist = EnumerableToList(a, scope List<U>()),
			blist = EnumerableToList(b, scope List<U>()),
			astr = EnumerableToString(a, scope $""),
			bstr = EnumerableToString(b, scope $"");

		if (alist.Count < blist.Count)
		{
			condition = false;
		} else
		{
			for (let i in ..<blist.Count)
				if (blist[i] != alist[^(blist.Count - i)])
					condition = false;
		}

		if (!condition)
			Error(scope $"{astr}", "ends with", scope $"{bstr}", fp, ln);
	}

	public static void EndsWith<T, U>(T a, U b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		let list = EnumerableToList<T, U>(a, scope List<U>());

		if (list.Count == 0 || list[^1] != b)
			Error(scope $"{EnumerableToString(list, scope $"")}", "ends with", scope $"{b}", fp, ln);
	}

	public static void Length<T>(T a, int b, String fp = fp!(), int ln = ln!()) where T : StringView
	{
		if (a.Length != b)
			Error(scope $"{a}", "has length", scope $"{b}", fp, ln);
	}

	public static void Length<T, U>(T a, int b, String fp = fp!(), int ln = ln!()) where T : IEnumerable<U>
	{
		if (EnumerableToLength(a) != b)
			Error(scope $"{a}", "has length", scope $"{b}", fp, ln);
	}

	public static void CloseTo<T>(T a, T b, int digits = 2, String fp = fp!(), int ln = ln!()) where double : operator T - T
	{
		if (Math.Abs(a - b) >= Math.Pow(10, -digits) / 2)
			Error(scope $"{a}", "close to", scope $"{b}", fp, ln);
	}
}



static
{
	struct TestStruct
	{
		int a;
		int b;
		public this(int a = 0, int b = 0)
		{
			this.a = a;
			this.b = b;
		}
		public override void ToString(String buffer)
		{
			buffer.AppendF(scope $"(a: {a} b: {b}");
		}
	}






	[Test]
	static void AddTest()
	{
		Assert.Eq(2 + 2, 4);
		Assert.Contains(int[](1, 2, 3), 4);
	}









	[Test]
	static void Neq()
	{
		Assert.Neq(0, 1);
		Assert.Neq('a', 'b');
		Assert.Neq("hello world", "hello worl");
		Assert.Neq(int[](1, 2, 3), int[](1, 2, 4));
		Assert.Neq(scope List<int>() { 1, 2, 3 }, scope List<int>() { 1, 2 });
		Assert.Neq(TestStruct(a: 1), TestStruct());
	}

	[Test]
	static void Gt()
	{
		Assert.Gt(1, 0);
		Assert.Gt(1.1, 1.0);
		Assert.Gt(1.1f, 1.0f);
	}

	[Test]
	static void Gte()
	{
		Assert.Gte(1, 0);
		Assert.Gte(1.1, 1.1);
		Assert.Gte(1.1f, 1.1f);
	}

	[Test]
	static void Lt()
	{
		Assert.Lt(0, 1);
		Assert.Lt(1.0, 1.1);
		Assert.Lt(1.0f, 1.1f);
	}

	[Test]
	static void Lte()
	{
		Assert.Lte(0, 1);
		Assert.Lte(1.0, 1.0);
		Assert.Lte(1.0f, 1.0f);
	}

	[Test]
	static void StartsWith()
	{
		Assert.StartsWith("foobar", "foo");
		Assert.StartsWith(scope List<int>() { 1, 2, 3 }, 1);
		Assert.StartsWith(scope List<int>() { 1, 2, 3 }, scope List<int>() { 1, 2 });
		Assert.StartsWith(scope Queue<int>() { 1, 2, 3 }, 1);
		Assert.StartsWith(scope HashSet<int>() { 1, 2, 3 }, 1);
		Assert.StartsWith(scope LinkedList<int>()..AddLast(1)..AddLast(2)..AddLast(3), 1);
	}

	[Test]
	static void EndsWith()
	{
		Assert.EndsWith("foobar", "bar");
		Assert.EndsWith(scope List<int>() { 1, 2, 3 }, 3);
		Assert.EndsWith(scope List<int>() { 1, 2, 3, 4, 5 }, scope List<int>() { 4, 5 });
		Assert.EndsWith(scope Queue<int>() { 1, 2, 3 }, 3);
		Assert.EndsWith(scope HashSet<int>() { 1, 2, 3 }, 3);
		Assert.EndsWith(scope LinkedList<int>()..AddLast(1)..AddLast(2)..AddLast(3), 3);
	}

	[Test]
	static void Length()
	{
		Assert.Length("hello world", 11);
		Assert.Length(scope List<int>() { 1 }, 1);
		Assert.Length(scope Queue<int>() { 1 }, 1);
		Assert.Length(scope HashSet<int>() { 1 }, 1);
		Assert.Length(scope LinkedList<int>()..AddLast(1), 1);
	}

	[Test]
	static void CloseTo()
	{
		Assert.CloseTo(1, 1 + 0.01f, 1);
		Assert.CloseTo(1f, 1 + 0.000001f, 3);
		Assert.CloseTo(1.0, 1 + 0.000001f, 5);
	}

	[Test]
	static void Contains()
	{
		Assert.Contains("hello world", "lo wo");
		Assert.Contains(int[](1, 2), int[](1, 2));
		Assert.Contains(int[](1), 1);
		Assert.Contains(scope List<int>() { 1 }, scope List<int>() { 1 });
		Assert.Contains(scope List<int>() { 1 }, 1);
		Assert.Contains(scope Queue<int>() { 1 }, scope Queue<int>() { 1 });
		Assert.Contains(scope Queue<int>() { 1 }, 1);
		Assert.Contains(scope LinkedList<int>()..AddLast(1), scope LinkedList<int>()..AddLast(1));
		Assert.Contains(scope LinkedList<int>()..AddLast(1), 1);
		Assert.Contains(scope HashSet<int>()..Add(0), scope HashSet<int>()..Add(0));
		Assert.Contains(scope HashSet<int>()..Add(1), 1);
	}

	[Test]
	static void NotContains()
	{
		Assert.NotContains("hello world", "foo bar");
		Assert.NotContains(int[](1), int[](2));
		Assert.NotContains(int[](1), 2);
		Assert.NotContains(scope List<int>() { 1 }, scope List<int>() { 2 });
		Assert.NotContains(scope List<int>() { 1 }, 2);
		Assert.NotContains(scope Queue<int>() { 1 }, scope Queue<int>() { 2 });
		Assert.NotContains(scope Queue<int>() { 1 }, 2);
		Assert.NotContains(scope LinkedList<int>()..AddLast(1), scope LinkedList<int>()..AddLast(2));
		Assert.NotContains(scope LinkedList<int>()..AddLast(1), 2);
		Assert.NotContains(scope LinkedList<int>()..AddLast(1), scope LinkedList<int>()..AddLast(2));
		Assert.NotContains(scope LinkedList<int>()..AddLast(1), 2);
		Assert.NotContains(scope HashSet<int>()..Add(0), scope HashSet<int>()..Add(1));
		Assert.NotContains(scope HashSet<int>()..Add(1), 2);
	}
}
