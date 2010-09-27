#!/usr/bin/dmd -run
/* 
  Hello World in D.

  To compile:

  $ dmd hello.d

  or to optimize:

  $ dmd -O -inline -release hello.d
*/

import std.stdio;

void main(string[] origArgs) {
  writeln("Hello World, Reloaded");

  auto progname = origArgs[0];
  auto args = origArgs[1..origArgs.length]; // Slices are inclusive on the left and exclusive on the right.

  // Type inference + built-in foreach.
  foreach (argI, arg; args) {
    auto cl = new CmdLin(argI, arg);
    writefln("%d%s arg: %s", cl.argnum, cl.suffix, cl.arg);
    // Automatic or explicit memory management
    delete cl;
  }

  // Nested structs and classes.
  struct specs {
    int count, allocated;
  }

  specs lastSpecs;

  // Nested functions can read/mutate captured/outer-scope variables.
  /*specs*/void argspecs(string[] args) {
    lastSpecs = specs(args.length, typeof(args).sizeof);
    foreach (arg; args) {
      lastSpecs.allocated += arg.length * typeof(arg[0]).sizeof;
    }
    //return s;
  }

  writefln("specs.sizeof = %d", specs.sizeof);
  {
    /*auto s1 =*/ argspecs(origArgs);
    writefln("origArgs: numargs = %d, " ~ "allocated = %d", lastSpecs.count, lastSpecs.allocated);
  }
  {
    /*auto s2 =*/ argspecs(args);
    writefln("    args: numargs = %d, " ~ "allocated = %d", lastSpecs.count, lastSpecs.allocated);
  }
}

class CmdLin {
  private int _argI;
  private string _arg;

  public this(int argI, string arg) {
    _argI = argI;
    _arg = arg;
  }

  public int argnum() {
    return _argI + 1;
  }

  public string arg() {
    return _arg;
  }

  public string suffix() {
    string suffix = "th";
    if (_argI >= 20) _argI %= 10;
    switch (_argI % 20) {
      case 0:
        suffix = "st";
        break;
      case 1:
        suffix = "nd";
        break;
      case 2:
        suffix = "rd";
        break;
      default:
    }
    return suffix;
  }
}
