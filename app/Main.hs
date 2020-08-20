module Main where

import Config.App
import Essential
import UserInterface.Cli

main :: IO ()
main = runRIO app execCommand

app :: App
app = App