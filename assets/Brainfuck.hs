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

-- Entrypoint
main :: IO ()
main = getArgs >>= \a -> unless (null a) $ readFile (head a) >>= runBF

runBF :: String -> IO ()
runBF pstr = do
    arr <- newArray (0,30000) 0
    evalStateT evalBF (BF 0 0 arr $ listArray (0,length pstr) $ pstr ++ "@")

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
alterptrval f = gets mem >>= \m -> gets ptr 
                         >>= \p -> getptrval >>= lift . writeArray m p . f

while :: Bool -> BFMonad ()
while b = getptrval >>= \v -> unless (if b then v /= 0 else v == 0) $ jump 0
  where
    jump :: Int -> BFMonad ()
    jump i = do
        c <- alterpc (if b then (+1) else subtract 1) >> fetch
        case c of
            '[' -> if not b then unless (i==0) $ jump (i-1) else jump (i+1)
            ']' -> if b     then unless (i==0) $ jump (i-1) else jump (i+1)
            _   -> jump i

