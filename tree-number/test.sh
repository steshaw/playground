#!/bin/sh

javac -d . *.java &&
scalac *.scala &&
  scala steshaw.TreeNumber | diff expected - && echo TreeNumber ok &&
  scala steshaw.TreeNumberWithScalaz5StateMonad | diff expected - && echo TreeNumberWithScalaz5StateMonad ok &&
  scala steshaw.TreeNumberWithStateMonad | diff expected - && echo TreeNumberWithStateMonad ok
  java steshaw.TreeNumberInJava | diff expected - && echo TreeNumberInJava ok
