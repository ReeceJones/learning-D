import std.stdio;

int foo0(int somenumber)
{
  //just like in c++ parameters are mutable
  somenumber = 5;
  return 1;
}

int foo1(ref int somenumber)
{
  //but unlike in c++ you cannot use & to pass by reference and instead you have to use ref
  somenumber = 100;
  return 2;
}

int foo2(ref int somenumber, lazy void fnCallback)
{
  somenumber = 10000;
  //also unlike c++ you can easily pass functions
  fnCallback();
  return 3;
}

void bar2(int somenumber)
{
  writeln("wow I found the number ", somenumber);
}

int[] foo3(int l, int m)
{
  //interestingly you can initialize dynamic arrays in D using type[]
  int[] dynamicArray;
  dynamicArray.length = m - l + 1;
  for (int i = l; i <= m; i++)
    dynamicArray[i - l] = i;
  return dynamicArray;
}

double foo4(int[] nums)
{
  //something really nice in D is the ability to slice arrays
  //you just use lowerbound index, and then upperbound index
  //it will include the lowerbound, but not the upperbound
  //you can also concatonate arrays with the ~ operator
  int[] sliced = nums[0..3] ~ nums[6..8];
  writeln("sliced & concatonated: ", sliced);
  int avg = 0;
  foreach(int i; sliced)
    avg += i;
  //to cast values in D you have to use cast(type)value
  return (cast(double)avg) / cast(double)sliced.length;
}

string foo5(ref string somestring)
{
  //because strings are arrays of characters you need to use ~= to add to strings
  return somestring ~= " oh hello there";
}

void foo6()
{
  writefln("hello from foo6");
}

//aliases are like #define and typedef statements in c++
alias fooalias = foo6;

//in D you can have auto-deducing templates that do not have to be explicitly defined
void foo7(T)(T bar)
{
  writeln(bar);
}

//you can also have explicitly defined templates to reduce possible errors
template Bar(T)
{
  void foo8(T bar)
  {
    writeln(bar);
  }
}

//like in c++ templates can also be used not just to define types, but also to define values
template Foo(string mode)
{
  void foo9()
  {
    if (mode == "hello")
    {
      writeln("Hello World");
    }
    else if (mode == "template")
    {
      writeln("this is from a template");
    }
  }
}

class FooClass
{
private:
  int x, y;
public:
  this()
  {
    x = 0;
    y = 1;
  }
  void change()
  {
    int tmp = x;
    x = y;
    y = tmp;
  }
  int[] getContents()
  {
    return [x,y];
  }
  //for foo11
  //unfortunately operator overloading in D is a bit wierd
  //the overloads require less writing, but are just wierd
  //to override the == and != operator you have to overload the function
  //opEquals.
  //the general structure for opEquals is checking for same type, checking for null,
  //checking the condition, and then returning this.opEquals and other.opEquals
  override bool opEquals(Object f)
  {
    if (this is f)
      return true;
    if (this is null || f is null)
      return false;
    if (typeid(this) == typeid(f))
      return this.x == (cast(FooClass)f).x && this.y == (cast(FooClass)f).y;
    return this.opEquals(f) && f.opEquals(this);
  }
}


// bool opEquals(FooClass f, FooClass b)
// {
//    return b.x == f.x && b.y == f.y;
// //  return true;
// }

//in D you can easily externally add methods to a class
//parameter just has to be the class, followed by rest of parameters
void foo10(FooClass f, int x, int y)
{
  f.x = x;
  f.y = y;
}

void foo12()
{
    import std.datetime.stopwatch:StopWatch;
    import core.thread: Thread;
    import std.file: write, read;
    StopWatch sw;
    sw.start();
    write("foo.txt", "this is a string");
    sw.stop();
    writeln("wrote foo.txt in ", sw.peek().total!"msecs", "ms");
    sw.reset();
    sw.start();
    string s = cast(string)read("foo.txt");
    sw.stop();
    writeln("foo.txt: ", s);
    writeln("read foo.txt in ", sw.peek().total!"msecs", "ms");
}

//variadic functions in D can be very easy!
void foo13(T...)(T t)
{
  foreach(p; t)
    writeln(p);
}

void foo14()
{
  import core.cpuid: processor;
  import std.digest.sha;
  //in D there are some usefull and not so usefull but cool libraries
  writeln(processor());
  //you can even compute the sha of data
  writeln("sha256 of \"abc\": ", toHexString(sha256Of("abc")));
}

int main(string[] args)
{
  if (args.length > 1)
  {
    if (args[1] == "-f0")
    {
      int somenumber = 0;
      writeln("foo0 return value: ", foo0(somenumber));
      writeln("somenmuber: ", somenumber);
    }
    else if (args[1] == "-f1")
    {
      int somenumber = 0;
      writeln("foo1 return value: ", foo1(somenumber));
      writeln("somenumber: ", somenumber);
    }
    else if (args[1] == "-f2")
    {
      int somenumber = 0;
      writeln("foo2 return value: ", foo2(somenumber, bar2(99)));
      writeln("somenumber: ", somenumber);
    }
      else if (args[1] == "-f3")
    {
      writeln(foo3(1, 5));
    }
    else if (args[1] == "-f4")
    {
      writeln(foo4([1,2,3,4,5,6,7,8,9,0]));
    }
    else if (args[1] == "-f5")
    {
      string s = "this is a string.";
      writeln(foo5(s));
    }
    else if (args[1] == "-f6")
    {
      fooalias();
    }
    else if (args[1] == "-f7")
    {
      foo7("this is a string");
      foo7(5);
    }
    else if (args[1] == "-f8")
    {
      Bar!(string).foo8("hello from foo8");
    }
    else if (args[1] == "-f9")
    {
      Foo!"hello".foo9();
      Foo!"template".foo9();
    }
    else if (args[1] == "-f10")
    {
      //in D unique objects are not pointers. They are similar to objects in java where you use '.'
      //instead of '->' to access the members of the object
      FooClass f = new FooClass();
      writeln(f.getContents());
      //by adding the function to the end of the object name, you are essentially doing foo10(f, 50, 100);
      //which is the same as f.foo10(50, 100);
      f.foo10(50, 100);
      writeln(f.getContents());
    }
    else if (args[1] == "-f11")
    {
      FooClass f = new FooClass();
      FooClass b = new FooClass();
      writeln("foo: ", f.getContents());
      writeln("bar: ", b.getContents());
      writeln(f == b);
      f.foo10(100, 100);
      writeln("foo: ", f.getContents());
      writeln("bar: ", b.getContents());
      writeln(f == b);
      //you can check for nullptrs using is null
      f = null;
      writeln(f is null);
    }
    else if (args[1] == "-f12")
    {
      foo12();
    }
    else if (args[1] == "-f13")
    {
      foo13("this is a string", 2, [1, 10]);
    }
    else if (args[1] == "-f14")
    {
      foo14();
    }
  }
  else
  {
    writeln("use -f0..-f13");
  }
  return 0;
}
