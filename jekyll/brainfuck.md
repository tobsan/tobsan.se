---
layout: page
title: Brainfuck interpreter
permalink: /brainfuck
exclude_from_nav: true
---

Get the [full source](/assets/Brainfuck.hs), or continue reading for a better understanding of it.
The source below is slightly changed for formatting reasons.

{% highlight haskell %}
module Main (main) where

import Data.Array.IO
import Data.Array.Unboxed
import Data.Char
import System.Environment (getArgs)
import Control.Monad.State

type BFMonad a = StateT BFState IO a
data BFState = BF {
    pc, ptr :: Int,
    mem     :: IOUArray Int Int,
    program :: UArray Int Char
}

{% endhighlight %}

General imports and the two main data structures, a state monad transformer over IO, and the state
type, which holds the program counter, a pointer, the memory as a mutable array and the program code
as an immutable array.

{% highlight haskell %}

-- Entrypoint
main :: IO ()
main = getArgs >>= \a -> unless (null a) $ readFile (head a) >>= runBF

runBF :: String -> IO ()
runBF pstr = do
    arr <- newArray (0,30000) 0
    evalStateT evalBF (BF 0 0 arr progArr)
  where
    progArr = listArray (0,length pstr) $ pstr ++ "@"

{% endhighlight %}

The main function reads a file (if given on cmdline) and passes it on to `runBF`. `runBF` allocates
an array of 30 000 and runs the program in that array. Note that 30 000 is a sort of arbitrary
number, and since Brainfuck essentially models a [Turing
machine](https://en.wikipedia.org/wiki/Turing_machine), the tape is in theory infinite.

{% highlight haskell %}
evalBF :: BFMonad ()
evalBF = do
    c <- fetch
    unless (c == '@') $ run c >> alterpc (+1) >> evalBF
  where
    run c = case c of
        '>' -> alterptr (+1)
        '<' -> alterptr (subtract 1)
        '+' -> alterptrval (+1)
        '-' -> alterptrval (subtract 1)
        '.' -> getptrval >>= lift . putChar . chr
        ',' -> lift getChar >>= alterptrval . const . ord
        '[' -> while True 
        ']' -> while False
        _   -> return () --Invalid commands are ignored.
{% endhighlight %}

Well, `evalBF` is a fetch-execute loop. There are 8 different commands available. The `@` command is
not as standard as the rest, but it is common for Brainfuck interpreters to see it as an exit
command. See below for the functions that are called above.

{% highlight haskell %}
-- Utility functions

fetch :: BFMonad Char
fetch = liftM2 (!) (gets program) $ gets pc

alterpc :: (Int -> Int) -> BFMonad ()
alterpc f = modify $ \s -> s { pc = f $ pc s }

alterptr :: (Int -> Int) -> BFMonad ()
alterptr f = modify $ \s -> s { ptr = f $ ptr s }

getptrval :: BFMonad Int
getptrval = gets mem >>= \a -> gets ptr >>= lift . readArray a

alterptrval :: (Int -> Int) -> BFMonad ()
alterptrval f = do
    m <- gets mem
    p <- gets ptr 
    getptrval >>= lift . writeArray m p . f

while :: Bool -> BFMonad ()
while b = do
    v <- getptrval
    unless (if b then v /= 0 else v == 0) $ jump 0
  where
    jump :: Int -> BFMonad ()
    jump i = do
        c <- alterpc (if b then (+1) else subtract 1) >> fetch
        case c of
            '[' -> if not b then unless (i==0) $ jump (i-1) 
                            else jump (i+1)
            ']' -> if b     then unless (i==0) $ jump (i-1)
                            else jump (i+1)
            _   -> jump i

{% endhighlight %}
