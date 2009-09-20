#!/bin/sh

echo -- With stdout redirected to run.out --
(scala DickWall && scala OldSchool && scala VassilDichev) > run.out

echo
echo -- With stdout redirected to /dev/null --
(scala DickWall >/dev/null && scala OldSchool >/dev/null && scala VassilDichev >/dev/null)
