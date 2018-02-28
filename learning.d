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

//aliases are like #define statements in c++
alias fooalias = foo6;

int main(string[] args)
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
  return 0;
}
