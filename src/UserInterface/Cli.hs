module UserInterface.Cli where

import qualified Data.Text.IO as T
import Essential
import Options.Applicative
import UserInterface.Cli.ClearSession (clearSession)
import UserInterface.Cli.Login (login)
import UserInterface.Cli.New (new)

data Command
  = Login
  | New Text
  | ClearSession
  deriving (Show)

parseLogin :: Parser Command
parseLogin = pure Login

parseNew :: Parser Command
parseNew = New <$> argument str (metavar "[CONTEST_NAME]")

-- parseSubmit :: Parser Command
-- parseSubmit = Submit <$> argument str (metavar "[TASK_NAME]")

parseClearSession :: Parser Command
parseClearSession = pure ClearSession

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc

parseCommand :: Parser Command
parseCommand =
  subparser $
    command "login" (parseLogin `withInfo` "Login to AtCoder")
      <> command "new" (parseNew `withInfo` "Create a new project for specified contest")
      -- <> command "submit" (parseSubmit `withInfo` "Submit solution")
      <> command "clear-session" (parseClearSession `withInfo` "Clear session data (cookie store in HTTP client)")

parseInfo :: ParserInfo Command
parseInfo = parseCommand `withInfo` usage

usage :: String
usage = "stack atcoder [--help] [COMMAND]"

execCommand :: RIO env ()
execCommand =
  do
    command <- liftIO $ execParser parseInfo
    run command
  where
    run :: Command -> RIO env ()
    run cmd = case cmd of
      Login -> login
      New contestId -> new contestId
      ClearSession -> clearSession
