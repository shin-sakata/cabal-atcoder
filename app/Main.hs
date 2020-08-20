module Main where

import Config.App as App
import Essential
import UserInterface.Cli

main :: IO ()
main = do
  runApp execCommand
