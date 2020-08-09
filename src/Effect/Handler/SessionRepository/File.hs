module Effect.Handler.SessionRepository.File (run) where

import Data.Extensible.Effect
import qualified Effect.Adapter.IO as IO
import Effect.Adapter.SessionRepository (SessionRepository (..))
import qualified Effect.Adapter.SessionRepository as SessionRepository
import Essential hiding (lift)
import Text.Read (readMaybe)

run ::
  forall effs a.
  IO.HasEff effs =>
  Eff (SessionRepository.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. SessionRepository.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret Remove k = do
      IO.lift removeSession
      k ()
    interpret Get k = do
      session <- IO.lift getSession
      k session
    interpret (Store session) k = do
      IO.lift $ storeSession session
      k ()

sessionPath :: FilePath
sessionPath = "session"

removeSession :: IO ()
removeSession = storeSession mempty

storeSession :: SessionRepository.Session -> IO ()
storeSession = writeFile sessionPath . show

getSession :: IO SessionRepository.Session
getSession = do
  sessionUtf8 <- readFile sessionPath
  case readMaybe $ sessionUtf8 of
    Just session -> pure session
    Nothing -> throwString "The session file is corrupted."
