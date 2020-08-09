module Main where

import UserInterface.Cli
import Essential

main :: IO ()
main = runSimpleApp execCommand
